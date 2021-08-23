import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:login_page_day_23/intropage.dart';
import 'package:login_page_day_23/login.dart';
import 'package:login_page_day_23/signup.dart';
import 'package:login_page_day_23/dashboard.dart';
import 'package:login_page_day_23/splashscreen.dart';
import 'package:login_page_day_23/drawerScreen.dart';
import 'package:login_page_day_23/completecheckin.dart';
import 'package:login_page_day_23/getfaceimg.dart';
void main(){
  runApp(MaterialApp(home: FaceImage(),
  theme: ThemeData(
    fontFamily: 'Circular'
  ),
  ));
}


class LogonPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DrawerScreen(),
          DashBoard()

        ],
      ),

    );
  }
}

