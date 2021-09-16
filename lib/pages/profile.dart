import 'dart:io';

import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:face_net_authentication/pages/profile_detail.dart';
import 'package:face_net_authentication/pages/checkin.dart';
import 'package:flutter/material.dart';

import 'package:carousel_slider/carousel_slider.dart';

class Profile extends StatelessWidget {
  const Profile(this.email, this.username, {Key key, this.imagePath})
      : super(key: key);
  final String email;
  final String username;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: Color.fromRGBO(240, 240, 240, 1),
        drawer: new Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                decoration: BoxDecoration(
                  image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: AssetImage('assets/drawerbackground.jpg')),
                ),
                currentAccountPicture: new CircleAvatar(
                  radius: 60.0,
                  backgroundColor: const Color(0xFF778899),
                  backgroundImage:
                      FileImage(File(imagePath)), // for Network image
                ),
                accountName: Container(
                  child: Text(username),
                ),
                accountEmail: Container(
                  child: Text(email),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Home"),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.account_circle),
                title: Text("Profile"),
                onTap: () {
                  // Update the state of the app
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileDetailPage()),
                  );
                  // Then close the drawer
                  
                },
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.power_settings_new),
                title: Text("Logout"),
                onTap: () {
                  // Update the state of the app
                  // ...
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            child: Column(
              children: [
                Container(
                  color: Color(0xFFFF6161),
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  margin: EdgeInsets.only(bottom: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(Icons.menu),
                          color: Colors.white,
                          onPressed: () =>
                              _scaffoldKey.currentState.openDrawer()),
                      Column(
                        children: [
                          Text(
                            'Welcome, ' + username,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Container(
                              child: SizedBox(
                            width: 45,
                          ))
                        ],
                      )
                    ],
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                      height: 180.0,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.fastOutSlowIn,
                      enableInfiniteScroll: true,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8),
                  items: [
                    Container(
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage('assets/c1.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage('assets/c2.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          image: AssetImage('assets/c3.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
                Divider(),
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Text("Records",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700))),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.search),
                      Text('Search Records'),
                      Text(''),
                    ],
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.33,
                    child: ListView(
                      children: <Widget>[
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  const ListTile(
                                    leading:
                                        Icon(Icons.location_city, size: 40),
                                    title: Text(
                                        'Jalan Kemuliaan 26, Taman Universiti 81300',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700)),
                                    subtitle: Text('15/12/2020 15:38',
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  const ListTile(
                                    leading:
                                        Icon(Icons.location_city, size: 40),
                                    title: Text(
                                        '21, Jalan Kemuliaan 12, Taman Sutera 81300',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700)),
                                    subtitle: Text('11/12/2020 11:37',
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  const ListTile(
                                    leading:
                                        Icon(Icons.location_city, size: 40),
                                    title: Text(
                                        'Sutera Mall, Taman Sutera Utama, 81300',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700)),
                                    subtitle: Text('12/8/2020 08:08',
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  const ListTile(
                                    leading:
                                        Icon(Icons.location_city, size: 40),
                                    title: Text(
                                        'Aeon Mall, Taman Bukit Indah, 81300',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700)),
                                    subtitle: Text('21/7/2020 18:08',
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                ],
                              ),
                            )),
                        Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 0),
                            child: Card(
                              child: Column(
                                children: <Widget>[
                                  const ListTile(
                                    leading:
                                        Icon(Icons.location_city, size: 50),
                                    title: Text(
                                        'Aeon Mall, Taman Bukit Indah, 81300',
                                        style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700)),
                                    subtitle: Text('21/7/2020 18:08',
                                        style: TextStyle(fontSize: 10)),
                                  ),
                                ],
                              ),
                            ))
                      ],
                    )),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 70,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {},
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            AppButton(
                              text: "Check In",
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => CheckIn()),
                                );
                              },
                              icon: Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              color: Color(0xFFFF6161),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ));
  }
}
