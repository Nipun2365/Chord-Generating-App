import 'package:flutter/material.dart';
import '../favourite_page/favourite_page.dart';
import '../home_page/home_page.dart';
import '../instrument_page/instrument_page.dart';
import '../search_page/search_page.dart';

class BottomNavBar extends StatefulWidget {
  final int initialIndex; // Add this line

  BottomNavBar({this.initialIndex = 0}); // Add default value

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  // List of pages to navigate
  final List<Widget> _pages = [
    HomePage(), // Home Page
    SearchPage(), // Search Page
    FavoritesPage(), // Favorites Page
    InstrumentPage(), // Instrument Page
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex; // Set the selected index
  }

  // Function to handle item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Displays the selected page
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.music_note),
            label: 'Instrument',
          ),
        ],
        currentIndex: _selectedIndex, // Reflects the current selection
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        onTap: _onItemTapped, // Updates index on tap
      ),
    );
  }
}
