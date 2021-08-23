import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:login_page_day_23/user_profile/profilepage.dart';

Color primaryGreen = Color(0xff416d6d);
List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0, 10))
];

List<Map> categories = [
  {'name': 'Cats', 'iconPath': 'images/cat.png'},
  {'name': 'Dogs', 'iconPath': 'images/dog.png'},
];

List<Map> drawerItems=[
  {
    'icon': FontAwesomeIcons.userAlt,
    'title' : 'Profile',
    'ontap' : HomeView(),
  },
  {
    'icon': FontAwesomeIcons.cogs,
    'title' : 'Setting',
    'ontap' : HomeView(),
  },
  {
    'icon': FontAwesomeIcons.signOutAlt,
    'title' : 'Log out',
    'ontap' : HomeView(),
  },
];