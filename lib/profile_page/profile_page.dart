import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../about_us_page/about_us_page.dart';
import '../basic_button_page/bottom_bar.dart';
import '../contacts_page/contacts_page.dart';
import '../help_and_support_page/help_and_support_page.dart';
import '../home_page/home_page.dart';
import '../notification_page/notification_page.dart';
import '../rateus_page/rateus_page.dart';
import '../setting_&_privacy_page/setting_&_Privacy_page.dart';
import '../singin_and_singup_page/singin_and_singup_page.dart';
import '../singin_and_singup_page/singup_page.dart';
import '../what_new_page/what_new_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile; // Variable to hold the selected image
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? _email; // Variable to hold the user's email

  @override
  void initState() {
    super.initState();
    _getCurrentUserEmail(); // Retrieve the current user's email
    _loadImage(); // Load the stored image path
  }

  // Function to get the current user's email
  Future<void> _getCurrentUserEmail() async {
    User? user = _auth.currentUser; // Get the current user
    if (user != null) {
      setState(() {
        _email = user.email; // Set the email variable
      });
      print('User email: $_email'); // Debugging log
    } else {
      print('No user is signed in.'); // Debugging log
    }
  }

  // Function to pick and store the image
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); // Open gallery to pick an image
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path); // Update the image file
      });
      _saveImagePath(pickedFile.path); // Save the image path to local storage
    } else {
      print('No image selected.'); // Debugging log
    }
  }

  // Function to save image path in SharedPreferences
  Future<void> _saveImagePath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image_path', path); // Save the path
  }

  // Function to load the stored image path
  Future<void> _loadImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? imagePath = prefs.getString('profile_image_path'); // Retrieve the path
    if (imagePath != null) {
      setState(() {
        _imageFile = File(imagePath); // Set the image file if the path exists
      });
    }
  }

  // Function to handle navigation to each section (replace with actual navigation)
  void _navigateToSection(String section) {
    print('Navigating to $section');
    // You can use Navigator.push to open new pages here for each section
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Page'),
        leading: IconButton(
            icon: const Icon(Icons.arrow_back), // Back arrow icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => BottomNavBar()), // Navigate to HomePage widget
              );
            }
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Profile Section
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage, // Pick image on tap
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _imageFile != null ? FileImage(_imageFile!) : null, // Display the selected image
                    child: _imageFile == null ? const Icon(Icons.person, size: 70) : null, // Default icon if no image
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _email ?? 'No email', // Display email
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white, // Change the email text color
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _pickImage, // Pick image when pressed
                  child: const Text('Change Profile Image'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),

          // Menu Section
          ListTile(
            leading: const Icon(Icons.person_3_outlined, color: Colors.white),
            title: const Text('Add New Account', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SingupPage()), // Navigate to notifications page
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.notification_add, color: Colors.white),
            title: const Text('Notification', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => NotificationsPage()), // Navigate to notifications page
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info_outline, color: Colors.white),
            title: const Text('About Us', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AboutUsPage()), // Navigate to About Us page
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.white),
            title: const Text('Setting & privacy', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SettingsAndPrivacyPage()), // Navigate to Settings page
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.new_releases, color: Colors.white),
            title: const Text('What\'s New', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const WhateNewPage()), // Navigate to What's New page
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.phone, color: Colors.white),
            title: const Text('Contacts Us', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const ContactsPage()), // Navigate to Contacts page
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.star, color: Colors.white),
            title: const Text('Rate Us', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => RateusPage()), // Navigate to Rate Us page
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white),
            title: const Text('LogOut', style: TextStyle(color: Colors.white)),
            onTap: () async {
              await _auth.signOut(); // Sign out the user
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignupOrSigninPage()), // Navigate to sign-in/sign-up page
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.question_mark, color: Colors.white),
            title: const Text('Help & Support', style: TextStyle(color: Colors.white)),
            onTap: () async {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HelpAndSupportPage()), // Navigate to notifications page
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.black, // Set a background color for better contrast
    );
  }
}
