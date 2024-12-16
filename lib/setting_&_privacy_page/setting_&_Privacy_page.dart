import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import '../profile_page/profile_page.dart';
import '../singin_and_singup_page/singin_and_singup_page.dart';

class SettingsAndPrivacyPage extends StatefulWidget {
  const SettingsAndPrivacyPage({Key? key}) : super(key: key);

  @override
  _SettingsAndPrivacyPageState createState() => _SettingsAndPrivacyPageState();
}

class _SettingsAndPrivacyPageState extends State<SettingsAndPrivacyPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Firebase Auth instance

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings & Privacy"),
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
            const SizedBox(height: 80),
            const Text(
              "Settings",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),

            const Divider(color: Colors.grey), // Divider

            // Privacy Policy Section
            const Text(
              "Privacy",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 10),
            ListTile(
              title: const Text("Privacy Policy", style: TextStyle(color: Colors.white)),
              onTap: () {
                _showPrivacyPolicy(context); // Show privacy policy dialog
              },
            ),

            const SizedBox(height: 20), // Add spacing

            // Log Out Button
            ElevatedButton(
              onPressed: () {
                _logOut(); // Handle logout
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button color
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button padding
              ),
              child: const Text("Log Out", style: TextStyle(color: Colors.white)), // Button text
            ),

            const SizedBox(height: 20), // Add spacing

            // Delete Account Button
            ElevatedButton(
              onPressed: () {
                _confirmDeleteAccount(); // Handle account deletion
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red, // Button color
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button padding
              ),
              child: const Text("Delete Account", style: TextStyle(color: Colors.white)), // Button text
            ),

            const SizedBox(height: 20), // Add spacing
          ],
        ),
      ),
      backgroundColor: Colors.black, // Set background color to black
    );
  }

  // Method to show privacy policy
  void _showPrivacyPolicy(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Privacy Policy", style: TextStyle(color: Colors.white)),
          content: const Text(
            "Your privacy policy content goes here. This is where you explain how user data is collected, used, and protected.",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Close", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
          backgroundColor: Colors.black, // Set dialog background color to black
        );
      },
    );
  }

  // Method to log out the user
  void _logOut() async {
    await _auth.signOut(); // Log out the user
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const SignupOrSigninPage()), // Navigate to sign-in/sign-up page
    );
  }

  // Method to confirm account deletion
  void _confirmDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Account", style: TextStyle(color: Colors.white)),
          content: const Text(
            "Are you sure you want to delete your account? This action cannot be undone.",
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel", style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text("Delete", style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _deleteAccount(); // Proceed with account deletion
              },
            ),
          ],
          backgroundColor: Colors.black, // Set dialog background color to black
        );
      },
    );
  }

  // Method to delete the user account
  void _deleteAccount() async {
    User? user = _auth.currentUser; // Get the current user
    if (user != null) {
      try {
        await user.delete(); // Delete the user account
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const SignupOrSigninPage()), // Navigate to sign-in/sign-up page
        );
      } catch (e) {
        print('Error during account deletion: $e'); // Handle errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting account: $e')),
        );
      }
    }
  }
}
