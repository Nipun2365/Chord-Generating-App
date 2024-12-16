import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';

import '../profile_page/profile_page.dart';

class WhateNewPage extends StatefulWidget {
  const WhateNewPage({super.key});

  @override
  State<WhateNewPage> createState() => _WhateNewPageState();
}

class _WhateNewPageState extends State<WhateNewPage> {
  List<String> updates = [];

  @override
  void initState() {
    super.initState();
    _fetchUpdatesFromFirestore();
  }

  // Function to fetch updates from Firestore
  Future<void> _fetchUpdatesFromFirestore() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('updates') // The collection where updates are stored
          .orderBy('timestamp', descending: true) // Optional: order by time if available
          .get();

      List<String> newUpdates = [];
      for (var doc in querySnapshot.docs) {
        String update = doc['content']; // Assuming each document has a 'content' field
        newUpdates.add(update);
      }

      setState(() {
        updates = newUpdates; // Update the state with the fetched updates
      });
    } catch (e) {
      print("Error fetching updates: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("What's New"),
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
            updates.isNotEmpty
                ? Expanded(
              child: ListView.builder(
                itemCount: updates.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    elevation: 3,
                    child: ListTile(
                      leading: const Icon(Icons.update, color: Colors.black),
                      title: Text(
                        updates[index],
                        style: const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    ),
                  );
                },
              ),
            )
                : const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center both texts vertically
                  children: [
                    Text(
                      "We will give the updates soon.",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                    SizedBox(height: 30), // Add some space between the texts
                    Text(
                      "You don't have any updates yet.",
                      style: TextStyle(fontSize: 25, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
