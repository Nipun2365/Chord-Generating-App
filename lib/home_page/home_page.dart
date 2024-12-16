import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../basic_button_page/bottom_bar.dart';

import '../notification_page/notification_page.dart';
import '../profile_page/profile_page.dart';
import '../search_page/search_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentPage = 0;
  final int _totalPages = 4; // Number of items in your carousel
  late Timer _timer;
  final AudioPlayer _audioPlayer = AudioPlayer(); // Create audio player

  String _currentlyPlaying = '';
  PlayerState _playerState = PlayerState.stopped;

  final CollectionReference _songsCollection =
  FirebaseFirestore.instance.collection('songs');
  final CollectionReference _notificationsCollection =
  FirebaseFirestore.instance.collection('notifications'); // New

  List<Map<String, dynamic>> _songs = []; // List to store songs
  List<Map<String, dynamic>> _recentSongs = []; // List to store recent songs
  int _unreadNotificationsCount = 0; // Count of unread notifications

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 0.8);

    // Listen for page changes
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _totalPages - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });

    _fetchSongs(); // Fetch songs once
    _fetchRecentSongs(); // Fetch recent songs
    _fetchUnreadNotificationsCount(); // Fetch unread notifications count
  }

  // Function to fetch unread notifications count
  Future<void> _fetchUnreadNotificationsCount() async {
    try {
      QuerySnapshot snapshot = await _notificationsCollection
          .where('isRead', isEqualTo: false) // Assuming you have a field 'isRead'
          .get();
      setState(() {
        _unreadNotificationsCount = snapshot.docs.length;
      });
    } catch (e) {
      print('Error fetching unread notifications: $e');
    }
  }

  Future<void> _fetchSongs() async {
    try {
      QuerySnapshot snapshot = await _songsCollection.limit(6).get();
      setState(() {
        _songs = snapshot.docs
            .map((songDocument) =>
        songDocument.data()! as Map<String, dynamic>)
            .toList();
      });
    } catch (e) {
      print('Error fetching songs: $e');
    }
  }

  Future<void> _fetchRecentSongs() async {
    try {
      QuerySnapshot snapshot = await _songsCollection
          .orderBy('timestamp', descending: true) // Assuming you have a timestamp field
          .limit(6)
          .get();

      setState(() {
        _recentSongs = snapshot.docs
            .map((songDocument) =>
        songDocument.data()! as Map<String, dynamic>)
            .toList();
      });

      print('Fetched recent songs: $_recentSongs'); // Debugging
    } catch (e) {
      print('Error fetching recent songs: $e');
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    _audioPlayer.dispose(); // Dispose audio player when page is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.person,
            size: 35.0, // Change the size to whatever value you want
          ),
// Profile icon on the left
          onPressed: () async {
            // Navigate to the ProfilePage
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
            );
          },
        ),
        title: const Text(
          'Chordify',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 25.0, // Change the size to your desired value
            fontWeight: FontWeight.bold, // Make the text bold
          ),
        ),
        // Center title
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notification_add,
                  size: 35.0, // Change the size to whatever value you want
                ), // Notification icon on the right
                onPressed: () async {
                  // Navigate to the NotificationsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NotificationsPage()),
                  );
                },
              ),
              if (_unreadNotificationsCount > 0) // Show badge if there are unread notifications
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '$_unreadNotificationsCount', // Show unread count
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),

      body: Column(
        children: [
          const SizedBox(height: 30), // Space after the separator

          // Carousel section
          SizedBox(
            height: 200, // Adjusted height for the carousel
            width: double.infinity,
            child: PageView.builder(
              itemCount: _totalPages,
              itemBuilder: (BuildContext context, int index) {
                String imagePath;

                switch (index) {
                  case 0:
                    imagePath = 'assets/images/m1.jpg';
                    break;
                  case 1:
                    imagePath = 'assets/images/m2.jpg';
                    break;
                  case 2:
                    imagePath = 'assets/images/m3.jpg';
                    break;
                  case 3:
                    imagePath = 'assets/images/m4.jpg';
                    break;
                  default:
                    imagePath = 'assets/images/m5.jpg';
                }
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          imagePath,
                          height: 300, // Adjusted height
                          width: MediaQuery.of(context).size.width - 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                );
              },
              controller: _pageController,
            ),
          ),


          const SizedBox(height: 20),

          // Dots Indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_totalPages, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.green : Colors.grey,
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Our Songs',
                  style: TextStyle(
                      fontSize: 25, fontWeight: FontWeight.bold,
                      color: Colors.white
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BottomNavBar(initialIndex: 1), // Navigate to SearchPage
                      ),
                          (Route<dynamic> route) => false, // This removes all previous routes
                    );
                  },
                  child: const Text(
                    'View All',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Song cover images and play button (first Flexible)
          Flexible(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _songs.reversed.take(6).map((song) {
                  String title = song['title'] ?? 'No Title';
                  String url = song['url'] ?? '';
                  String coverImageUrl = song['coverImageUrl'] ?? '';

                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    width: 120,
                    child: Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              // Change this for roundness
                              child: coverImageUrl.isNotEmpty
                                  ? Image.network(
                                coverImageUrl,
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                                  : Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(12), // Matching the image
                                ),
                                child: const Icon(
                                  Icons.music_note,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                _currentlyPlaying == url &&
                                    _playerState == PlayerState.playing
                                    ? Icons.pause_circle_filled
                                    : Icons.play_circle_filled,
                                size: 32,
                                color: _currentlyPlaying == url &&
                                    _playerState == PlayerState.playing
                                    ? Colors.red
                                    : Colors.yellow,
                              ),
                              onPressed: () {
                                if (_currentlyPlaying == url &&
                                    _playerState == PlayerState.playing) {
                                  _pauseSong();
                                } else {
                                  _playSong(url);
                                }
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          title,
                          style: const TextStyle(color: Colors.green),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),



          const SizedBox(height: 10), // Space between sections

          // Additional song cover images (second Flexible)
          // Additional song cover images (second Flexible)
          // Additional song cover images (second Flexible)
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: _songs.map((song) {
                        String title = song['title'] ?? 'No Title';
                        String url = song['url'] ?? '';
                        String coverImageUrl = song['coverImageUrl'] ?? '';

                        return Container(
                          margin: const EdgeInsets.all(8.0),
                          width: 120,
                          child: Column(
                            children: [
                              Stack(
                                alignment: Alignment.center, // Center play icon
                                children: [
                                  ClipOval(
                                    child: coverImageUrl.isNotEmpty
                                        ? Image.network(
                                      coverImageUrl,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    )
                                        : Container(
                                      width: 100,
                                      height: 100,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        color: Colors.grey,
                                      ),
                                      child: const Icon(
                                        Icons.music_note,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      _currentlyPlaying == url &&
                                          _playerState == PlayerState.playing
                                          ? Icons.pause_circle_filled
                                          : Icons.play_circle_filled,
                                      size: 32,
                                      color: _currentlyPlaying == url &&
                                          _playerState == PlayerState.playing
                                          ? Colors.red
                                          : Colors.purple,
                                    ),
                                    onPressed: () {
                                      if (_currentlyPlaying == url &&
                                          _playerState == PlayerState.playing) {
                                        _pauseSong();
                                      } else {
                                        _playSong(url);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                title,
                                style: const TextStyle(color: Colors.green),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                // Chatbot Icon on the right side
               
              ],
            ),
          ),

          const SizedBox(height: 20), // Space between sections

        ],
      ),
    );
  }

  void _playSong(String url) async {
    await _audioPlayer.play(UrlSource(url));
    setState(() {
      _currentlyPlaying = url;
      _playerState = PlayerState.playing;
    });
  }

  void _pauseSong() async {
    await _audioPlayer.pause();
    setState(() {
      _playerState = PlayerState.paused;
    });
    // Function to upload notification

    }
  }

