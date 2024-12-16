
import 'package:chordix/singin_and_singup_page/singin_page.dart';
import 'package:chordix/singin_and_singup_page/singup_page.dart';
import 'package:flutter/material.dart';

import '../app_color_and_them_page/app_color.dart';
import '../basic_button_page/basic_button_page.dart';

class SignupOrSigninPage extends StatelessWidget {
  const SignupOrSigninPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/choose_mode_bg.png'), // Add your background image path here
            fit: BoxFit.cover, // This makes the image cover the entire background
          ),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 205,  // Set your desired width here
                      height: 211, // Set your desired height here
                      fit: BoxFit.cover, // Optional: adjust how the image fits in the box
                    ),
                    const SizedBox(
                      height: 55,
                    ),


                  const Text(
                      'Enjoy Listening To Music',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.white, // You might want to change text color for better visibility
                      ),
                    ),
                    const SizedBox(
                      height: 21,
                    ),
                    const Text(
                      'Spotify is a proprietary Swedish audio streaming and media services provider',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: BasicAppButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => SingupPage(),
                                ),
                              );
                            },
                            title: 'Register',
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) => SinginPage(),
                                ),
                              );
                            },
                            child: const Text(
                              'Sign In', // Correct button text
                              style: TextStyle(
                                color: Colors.white, // Customize text color
                                fontSize: 16,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.green, // Button background color
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                      ],
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
