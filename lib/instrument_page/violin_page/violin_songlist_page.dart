
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../keyboard_page/keyboardsong_detail.dart';


class ViolinSonglistPage extends StatelessWidget {
  final List<Map<String, String>> songs = [
    {'title': 'Lovely', 'artist': 'Billie Eilish', 'url': '<lovely_song_url>'},
    {'title': 'Numba-Ha', 'artist': 'Unknown Artist', 'url': '<numba_ha_song_url>'},
    {'title': 'One Kiss', 'artist': 'Calvin Harris,Dua Lipa', 'url': '<numba_ha_song_url>'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Song List'),
      ),
      body: ListView.builder(
        itemCount: songs.length,
        itemBuilder: (context, index) {
          final song = songs[index];
          return ListTile(
            title: Text(song['title']!),
            subtitle: Text(song['artist']!),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => KeyboardsongDetail(
                    title: song['title']!,
                    artist: song['artist']!,
                    url: song['url']!,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Future<void> addChordsToFirestore(String songTitle, String guitarChords) async {
  try {
    // Example chord with <br>
    String formattedChords = guitarChords.replaceAll('\n', '<br>');

    await FirebaseFirestore.instance.collection('guitar_chords').doc(songTitle).set({
      'guitar': formattedChords,
    });
    print("Chords added successfully for $songTitle.");
  } catch (e) {
    print("Error adding chords: $e");
  }
}

// Example usage
void main() {
  addChordsToFirestore('Lovely', '[Verse 1] <br>C <br>Thought I found a way<br>Em');
  addChordsToFirestore('Numba-Ha', '[Chorus] <br>Em <br>Bm <br>C <br>D');
}
