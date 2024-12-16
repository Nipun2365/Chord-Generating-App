import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../profile_page/profile_page.dart';

class RateusPage extends StatefulWidget {
  const RateusPage({super.key});

  @override
  State<RateusPage> createState() => _RateusPageState();
}

class _RateusPageState extends State<RateusPage> {
  int _rating = 0; // Current rating value
  String _comment = ''; // Comment text
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadRating(); // Load the saved rating
  }

  // Load the saved rating from shared preferences
  Future<void> _loadRating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rating = prefs.getInt('user_rating') ?? 0; // Default to 0 if not found
      _comment = prefs.getString('user_comment') ?? ''; // Load saved comment
      _commentController.text = _comment; // Set the comment in the text field
    });
  }

  // Save the rating and comment to Firestore and shared preferences
  Future<void> _saveRating(int rating, String comment) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_rating', rating);
    await prefs.setString('user_comment', comment); // Save the comment

    // Save to Firestore
    await _firestore.collection('ratings').add({
      'rating': rating,
      'comment': comment,
      'timestamp': FieldValue.serverTimestamp(), // Optional: to track when the comment was made
    });
  }

  // Clear the rating and comment from shared preferences after submission
  Future<void> _clearPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_rating'); // Remove saved rating
    await prefs.remove('user_comment'); // Remove saved comment
  }

  // Function to handle star tap
  void _onStarTapped(int index) {
    setState(() {
      _rating = index + 1; // Update rating
    });
  }

  // Function to handle comment change
  void _onCommentChanged(String value) {
    setState(() {
      _comment = value; // Update comment
    });
  }

  // Function to send rating and comment
  void _sendFeedback() {
    // Ensure the rating is within the expected range
    if (_rating < 1 || _rating > 5) {
      // Optionally, show an error message if needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating between 1 and 5.')),
      );
      return; // Exit the method if the rating is invalid
    }

    // Save the rating and comment to Firestore
    _saveRating(_rating, _comment);

    // Clear preferences and reset the state after submission
    _clearPreferences(); // Clear the saved rating and comment
    setState(() {
      _comment = ''; // Clear the comment input
      _rating = 0; // Optionally reset rating after submission
      _commentController.clear(); // Clear the TextField input
    });

    // Print feedback for debugging purposes
    print("Feedback sent: Rating - $_rating, Comment - $_comment");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rate Us"),
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center, // Center stars horizontally
              children: List.generate(5, (index) {
                return IconButton(
                  icon: Icon(
                    index < _rating ? Icons.star : Icons.star_border,
                    color: Colors.yellow,
                    size: 48.0, // Adjust size as needed
                  ),
                  onPressed: () => _onStarTapped(index), // Handle star tap
                );
              }),
            ),
            TextField(
              maxLines: 3, // Allow multiple lines for the comment
              decoration: const InputDecoration(
                labelText: 'Leave a comment',
                labelStyle: TextStyle(color: Colors.white), // Change label text color
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Change border color
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green), // Change focused border color
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue), // Change enabled border color
                ),
              ),
              onChanged: _onCommentChanged, // Handle comment change
              style: const TextStyle(color: Colors.white), // Change input text color
              controller: _commentController, // Use the TextEditingController
            ),
            const SizedBox(height: 20), // Add spacing
            ElevatedButton(
              onPressed: _sendFeedback, // Send feedback
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Button color
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12), // Button padding
              ),
              child: const Text(
                "Send Comment",
                style: TextStyle(color: Colors.black), // Button text style
              ),
            ),

          ],
        ),
      ),
    );
  }
}
