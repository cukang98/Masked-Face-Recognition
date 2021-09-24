import 'dart:io';

import 'package:face_net_authentication/pages/db/database.dart';
import 'package:face_net_authentication/pages/models/user.model.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/facenet.service.dart';
import 'package:face_net_authentication/pages/utils/prefs.dart';
import 'package:face_net_authentication/pages/checkinsuccess.dart';
import 'package:page_transition/page_transition.dart';
import 'package:flutter/material.dart';

class AuthActionButton extends StatefulWidget {
  AuthActionButton(this._initializeControllerFuture,
      {Key key,
      @required this.onPressed,
      @required this.isCheckin,
      this.reload,
      this.lt,
      this.lg,
      this.address});
  final Future _initializeControllerFuture;
  final Function onPressed;
  final bool isCheckin;
  final Function reload;
  final double lt;
  final double lg;
  final String address;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  /// service injection
  final FaceNetService _faceNetService = FaceNetService();
  final DataBaseService _dataBaseService = DataBaseService();
  final CameraService _cameraService = CameraService();
  User predictedUser;

  String _predictUser() {
    String userAndPass = _faceNetService.predict();
    return userAndPass ?? null;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          // Ensure that the camera is initialized.
          await widget._initializeControllerFuture;
          // onShot event (takes the image and predict output)
          bool faceDetected = await widget.onPressed();
          String username = await getUserName();
          String email = await getUserEmail();
          if (faceDetected) {
            if (widget.isCheckin) {
              var userAndPass = _predictUser();
              if (userAndPass != null) {
                this.predictedUser = User.fromDB(userAndPass);
                if (predictedUser.user == username) {
                  _dataBaseService.saveLocation(
                      email, widget.lt, widget.lg, widget.address);
                  Navigator.pop(context);
  
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: CheckInSuccess()));
                }
              }
            }
          }
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(35),
          color: Color(0xFFFF6161),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        width: 60,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(Icons.camera_alt, color: Colors.white)],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
