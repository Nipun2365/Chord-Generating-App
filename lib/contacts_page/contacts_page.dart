import 'package:flutter/material.dart';

import '../profile_page/profile_page.dart';


class ContactsPage extends StatelessWidget {
  const ContactsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us'),
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

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                "Contact Information",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white), // Title color
              ),
            ),
            const SizedBox(height: 40),
            ListTile(
              leading: const Icon(Icons.whatshot, color: Colors.green),
              title: const Text(
                'WhatsApp',
                style: TextStyle(color: Colors.white), // Change text color for WhatsApp
              ),
              subtitle: const Text(
                '+94740743369', // Replace with your WhatsApp number
                style: TextStyle(color: Colors.grey), // Change subtitle color for WhatsApp
              ),
              onTap: () {
                // Add functionality to open WhatsApp if needed
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.email, color: Colors.red),
              title: const Text(
                'Email',
                style: TextStyle(color: Colors.white), // Change text color for Email
              ),
              subtitle: const Text(
                'nipunkanishka983@gmail.com', // Replace with your email
                style: TextStyle(color: Colors.grey), // Change subtitle color for Email
              ),
              onTap: () {
                // Add functionality to open email app if needed
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.tiktok, color: Colors.white),
              title: const Text(
                'TikTok',
                style: TextStyle(color: Colors.white), // Change text color for TikTok
              ),
              subtitle: const Text(
                '@nipunkaniska983', // Replace with your TikTok username
                style: TextStyle(color: Colors.grey), // Change subtitle color for TikTok
              ),
              onTap: () {
                // Add functionality to open TikTok profile if needed
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.flag, color: Colors.blueAccent),
              title: const Text(
                'Twitter',
                style: TextStyle(color: Colors.white), // Change text color for Twitter
              ),
              subtitle: const Text(
                '@nipunkanishka', // Replace with your Twitter username
                style: TextStyle(color: Colors.grey), // Change subtitle color for Twitter
              ),
              onTap: () {
                // Add functionality to open Twitter profile if needed
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.video_camera_back, color: Colors.purple),
              title: const Text(
                'Viber',
                style: TextStyle(color: Colors.white), // Change text color for Email
              ),
              subtitle: const Text(
                '+94740743369', // Replace with your email
                style: TextStyle(color: Colors.grey), // Change subtitle color for Email
              ),
              onTap: () {
                // Add functionality to open email app if needed
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.facebook, color: Colors.blue),
              title: const Text(
                'Faceboook',
                style: TextStyle(color: Colors.white), // Change text color for Email
              ),
              subtitle: const Text(
                'nipunkanishka', // Replace with your email
                style: TextStyle(color: Colors.grey), // Change subtitle color for Email
              ),
              onTap: () {
                // Add functionality to open email app if needed
              },
            ),
          ],
        ),
      ),
    );
  }
}
