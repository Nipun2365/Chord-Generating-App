import 'package:flutter/material.dart';
import '../basic_button_page/basic_button_page.dart';
import '../singin_and_singup_page/singin_and_singup_page.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(
            padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 40),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/images/intro_bg.png'),
              ),
            ),
          ),

          // Overlay with opacity
          Container(
            color: Colors.black.withOpacity(0.15),
          ),

          // Page content with padding
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 70, horizontal: 50),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  // App logo using Image.asset for PNG images
                  child: Image.asset(
                    'assets/images/logo.png',  // Add your logo image path here
                    width: 100,
                    height: 80,
                  ),
                ),
                const Spacer(),

                // Title text
                const Text(
                  'Enjoy Listening To Music',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 21),

                // Description text
                const Text(
                  'This functionality simplifies music creation and learning for users, '
                      'enabling them to seamlessly explore and play chords for their favorite songs across multiple instruments.',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFAAAAAA),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),

                // Get Started button with green color
                BasicAppButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) => const SignupOrSigninPage(),
                      ),
                    );
                  },
                  title: 'Get Started',

                  color: Colors.blue, // Setting the button color to green
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
