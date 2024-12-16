
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';
import '../basic_button_page/bottom_bar.dart';
import '../favourite_page/favourite_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final CollectionReference _songsCollection =
  FirebaseFirestore.instance.collection('songs');
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _searchController = TextEditingController(); // Controller for search query

  String _searchQuery = '';
  String _currentlyPlaying = '';
  PlayerState _playerState = PlayerState.stopped;

  @override
  void dispose() {
    _audioPlayer.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomNavBar()), // Navigate to BottomNavBar
            );
          },
        ),
        title: const Text('Search Songs'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FavoritesPage()), // Navigate to FavoritesPage
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white), // Text color in search bar
              decoration: InputDecoration(
                filled: true, // Enable background color for the search bar
                fillColor: Colors.black, // Background color of search bar
                labelText: 'Search Songs',
                labelStyle: const TextStyle(color: Colors.white), // Label text color
                prefixIcon: const Icon(Icons.search, color: Colors.white), // Search icon color
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white), // Border color when enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.white), // Border color when focused
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.trim(); // Update the search query
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _songsCollection.snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final List<QueryDocumentSnapshot> songs = snapshot.data!.docs;

                // Filter songs based on search query
                final List<QueryDocumentSnapshot> filteredSongs = songs.where((songDoc) {
                  Map<String, dynamic> song = songDoc.data()! as Map<String, dynamic>;
                  String title = song['title']?.toLowerCase() ?? '';
                  String artist = song['artist']?.toLowerCase() ?? '';
                  return title.contains(_searchQuery.toLowerCase()) ||
                      artist.contains(_searchQuery.toLowerCase());
                }).toList();
                if (filteredSongs.isEmpty) {
                  return const Center(
                    child: Text(
                      'No songs found matching your search',
                      style: TextStyle(color: Colors.white), // Change the text color here
                    ),
                  );
                }


                return ListView.builder(
                  itemCount: filteredSongs.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> song =
                    filteredSongs[index].data()! as Map<String, dynamic>;
                    String title = song['title'] ?? 'No Title';
                    String artist = song['artist'] ?? 'Unknown Artist';
                    String url = song['url'] ?? 'No URL';
                    bool isFavorite = song['isFavorite'] ?? false;

                    return ListTile(
                      title: Text(
                        title,
                        style: const TextStyle(color: Colors.green),
                      ),
                      subtitle: Text(
                        artist,
                        style: const TextStyle(color: Colors.white),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              _currentlyPlaying == url && _playerState == PlayerState.playing
                                  ? Icons.pause
                                  : Icons.play_arrow,
                              color: _currentlyPlaying == url && _playerState == PlayerState.playing
                                  ? Colors.red
                                  : Colors.green,
                            ),
                            onPressed: () {
                              if (_currentlyPlaying == url && _playerState == PlayerState.playing) {
                                _pauseSong();
                              } else {
                                _playSong(url);
                              }
                            },
                          ),
                          IconButton(
                            icon: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              _toggleFavorite(filteredSongs[index].id, !isFavorite);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _playSong(String url) async {
    try {
      await _audioPlayer.setSourceUrl(url);
      await _audioPlayer.resume();
      setState(() {
        _currentlyPlaying = url;
        _playerState = PlayerState.playing;
      });

      _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
        setState(() {
          _playerState = state;
        });
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to play song: $e')),
      );
    }
  }

  void _pauseSong() async {
    await _audioPlayer.pause();
    setState(() {
      _playerState = PlayerState.paused;
    });
  }

  void _toggleFavorite(String songId, bool isFavorite) async {
    try {
      await _songsCollection.doc(songId).update({'isFavorite': isFavorite});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(isFavorite ? 'Added to favorites' : 'Removed from favorites')),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update favorite status: $e')),
      );
    }
  }
}
