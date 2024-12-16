import 'package:flutter/material.dart';

import '../basic_button_page/bottom_bar.dart';
import 'guitar_page/guitar_page.dart'; // Import GuitarPage
import 'piano_page/piano_page.dart'; // Import PianoPage
import 'violin_page/violin_page.dart'; // Import ViolinPage
import 'flute_page/flute_page.dart'; // Import FlutePage
import 'tabla_page/tabla_page.dart'; // Import TablaPage
import 'keyboard_page/keyboard_page.dart'; // Import KeyboardPage

class InstrumentPage extends StatelessWidget {
  const InstrumentPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<String> instruments = ['Guitar', 'Piano', 'Violin', 'Flute', 'Tabla', 'Keyboard'];
    final List<String> instrumentImages = [
      'assets/images/guitar.png',
      'assets/images/piono.png',
      'assets/images/violine.png',
      'assets/images/batanalawa.png', // Corrected image name
      'assets/images/tabla.png',
      'assets/images/keyboard.png',
    ];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => BottomNavBar()),
            );
          },
        ),
        title: const Text(
          'Instruments',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: instruments.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      switch (instruments[index]) {
                        case 'Guitar':
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const GuitarPage()));
                          break;
                        case 'Piano':
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const PianoPage()));
                          break;
                        case 'Violin':
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ViolinPage()));
                          break;
                        case 'Flute':
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const FlutePage()));
                          break;
                        case 'Tabla':
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const TablaPage()));
                          break;
                        case 'Keyboard':
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const KeyboardPage()));
                          break;
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blueGrey[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            instrumentImages[index],
                            width: 130,
                            height: 130,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            instruments[index],
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Select Your Instrument.',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Example of InstrumentSongPage where you pass the selected instrument
class InstrumentSongPage extends StatelessWidget {
  final String instrument;

  const InstrumentSongPage({Key? key, required this.instrument}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$instrument Songs'),
      ),
      body: Center(
        child: Text(
          'Songs for $instrument',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
