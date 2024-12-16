import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViolinsongDetail extends StatefulWidget {
  final String title;
  final String artist;
  final String url;

  const ViolinsongDetail({
    Key? key,
    required this.title,
    required this.artist,
    required this.url,
  }) : super(key: key);

  @override
  State<ViolinsongDetail> createState() => _ViolinsongDetailState();
}

class _ViolinsongDetailState extends State<ViolinsongDetail> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String _generatedChords = '';

  @override
  void initState() {
    super.initState();
    _generateChords();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _generateChords() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('guitar_chords')
          .doc(widget.title)
          .get();

      if (snapshot.exists && snapshot['guitar'] != null) {
        String storedChords = snapshot['guitar'];

        // Replace <br> with \n for rendering
        String formattedChords = storedChords.replaceAll('<br>', '\n');

        setState(() {
          _generatedChords = formattedChords;
        });
      } else {
        setState(() {
          _generatedChords = 'Chords not available.';
        });
      }
    } catch (e) {
      setState(() {
        _generatedChords = 'Error fetching chords.';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching chords: $e')),
      );
    }
  }

  void _togglePlay() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.setSourceUrl(widget.url);
      await _audioPlayer.resume();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${widget.title}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Artist: ${widget.artist}',
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: _togglePlay,
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: _isPlaying ? Colors.red : Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Generated Chords for Guitar:',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              _generatedChords.isNotEmpty ? _generatedChords : 'Loading chords...',
              style: const TextStyle(
                fontSize: 18,
                color: Colors.yellow,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }
}
