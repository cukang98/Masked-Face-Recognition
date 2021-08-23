import 'package:flutter/material.dart';
import 'package:login_page_day_23/dashboard.dart';
import 'package:login_page_day_23/splashscreen.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}
class _HomeViewState extends State<HomeView> {

  PageController _pageController = PageController();
  List<Widget> _screens = [DashBoard(),SplashScreen(),HomeView()];
  int _selectedIndex = 0;
  void _onPageChange(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex){
    _pageController.jumpToPage(selectedIndex);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.green[50],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: 'Check In Now',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_sharp),
            label: 'Profile',
          ),
        ],
        currentIndex: 2,
        onTap:_onItemTapped,
        selectedItemColor: Colors.amber[800],
        
      ),
      
    );
  }
  
}
