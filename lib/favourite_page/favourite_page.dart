
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:audioplayers/audioplayers.dart';

import '../search_page/search_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final CollectionReference _songsCollection =
  FirebaseFirestore.instance.collection('songs');
  final AudioPlayer _audioPlayer = AudioPlayer();

  String _currentlyPlaying = '';
  PlayerState _playerState = PlayerState.stopped;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Back arrow icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()), // Navigate to HomePage widget
              );
            }
        ),
        title: const Text('Favorite Songs'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _songsCollection.where('isFavorite', isEqualTo: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Something went wrong'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final List<QueryDocumentSnapshot> favoriteSongs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: favoriteSongs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> song =
              favoriteSongs[index].data()! as Map<String, dynamic>;
              String title = song['title'] ?? 'No Title';
              String artist = song['artist'] ?? 'Unknown Artist';
              String url = song['url'] ?? 'No URL';
              String songId = favoriteSongs[index].id; // Get the document ID

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
                      icon: const Icon(
                        Icons.remove_circle,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        _removeFromFavorites(songId);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
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
      print('Error playing song: $e');
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

  void _removeFromFavorites(String songId) async {
    try {
      await _songsCollection.doc(songId).update({'isFavorite': false});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Song removed from favorites')),
      );
    } catch (e) {
      print('Error removing song from favorites: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to remove song: $e')),
      );
    }
  }
}
