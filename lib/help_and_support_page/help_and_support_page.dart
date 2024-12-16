import 'package:flutter/material.dart';
import '../contacts_page/contacts_page.dart';
import '../report_and_bug_page/report_and_bug_page.dart';


class HelpAndSupportPage extends StatelessWidget {
  const HelpAndSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & Support"),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Navigate back
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Frequently Asked Questions",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // FAQ Section
            ListTile(
              title: const Text("How do I reset my password?", style: TextStyle(color: Colors.white)),
              subtitle: const Text("To reset your password, go to the sign-in page and click on 'Forgot Password'.", style: TextStyle(color: Colors.grey)),
              onTap: () {
                // You can add more detailed navigation or a dialog for more info
              },
            ),
            const Divider(color: Colors.grey),

            ListTile(
              title: const Text("How do I contact support?", style: TextStyle(color: Colors.white)),
              subtitle: const Text("You can contact support via email at nipunkanishka983@gmail.com.", style: TextStyle(color: Colors.grey)),
              onTap: () {
                // You can add more detailed navigation or a dialog for more info
              },
            ),
            const Divider(color: Colors.grey),

            // Additional support options
            const SizedBox(height: 30),
            const Text(
              "Support Options",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 20),

            // Contact Support Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ContactsPage()), // Navigate to ContactPage
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Contact Support", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 20),

            // Report a Bug Button
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReportBugPage()), // Navigate to ContactPage
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text("Report a Bug", style: TextStyle(color: Colors.white)),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.black,
    );
  }

  // Method to report a bug
  void _reportBug() {
    // You can add functionality to navigate to a bug reporting form
    print("Report a bug functionality goes here.");
  }
}
