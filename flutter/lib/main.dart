import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'intropage.dart';
import 'login.dart';
import 'signup.dart';
import 'dashboard.dart';
import 'splashscreen.dart';
import 'drawerScreen.dart';
import 'completecheckin.dart';
import 'getfaceimg.dart';
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

