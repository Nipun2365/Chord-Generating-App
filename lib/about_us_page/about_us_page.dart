import 'package:flutter/material.dart';
import '../profile_page/profile_page.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("About Us"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // Back arrow icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()), // Navigate to ProfilePage
            );
          },
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "About Chordify",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Change text color to white
              ),
            ),
            SizedBox(height: 20), // Add some spacing
            Text(
              "Chordify is your go-to app for discovering and playing music chords. "
                  "Our goal is to provide a seamless experience for music lovers, offering "
                  "a variety of chords and songs to enhance your musical journey. "
                  "Whether you're a beginner or a professional, Chordify is here to help you "
                  "learn and play your favorite tunes.",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white, // Change text color to white
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Mission",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Change text color to white
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Our mission is to make music more accessible to everyone by providing "
                  "an intuitive platform that simplifies learning and playing music.",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white, // Change text color to white
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Contact Us",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white, // Change text color to white
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Email: nipunkanishka983@gmail.com\nPhone: +94740743369",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white, // Change text color to white
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.black, // Set background color to black
    );
  }
}
