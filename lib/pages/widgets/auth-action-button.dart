import 'dart:io';

import 'package:face_net_authentication/pages/db/database.dart';
import 'package:face_net_authentication/pages/models/user.model.dart';
import 'package:face_net_authentication/pages/profile.dart';
import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:face_net_authentication/services/camera.service.dart';
import 'package:face_net_authentication/services/facenet.service.dart';
import 'package:face_net_authentication/services/auth.dart';
import 'package:face_net_authentication/pages/utils/prefs.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../home.dart';
import 'app_text_field.dart';

class AuthActionButton extends StatefulWidget {
  AuthActionButton(this._initializeControllerFuture,
      {Key key, @required this.onPressed, @required this.isLogin, this.reload});
  final Future _initializeControllerFuture;
  final Function onPressed;
  final bool isLogin;
  final Function reload;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  /// service injection
  final FaceNetService _faceNetService = FaceNetService();
  final DataBaseService _dataBaseService = DataBaseService();
  final CameraService _cameraService = CameraService();
  final TextEditingController _userTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _emailTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _emailController = TextEditingController();
  User predictedUser;
  void _resetPassword(email) async {
    firebase_auth.FirebaseAuth _auth = firebase_auth.FirebaseAuth.instance;
    await _auth
        .sendPasswordResetEmail(email: email)
        .then((value) {})
        .catchError((err) {
      print(err);
    });
  }

  Future _signUp(context) async {
    /// gets predicted data from facenet service (user face detected)
    List predictedData = _faceNetService.predictedData;
    String email = _emailTextEditingController.text;
    String user = _userTextEditingController.text;
    String password = _passwordTextEditingController.text;

    /// resets the face stored in the face net sevice
    this._faceNetService.setPredictedData(null);

    try {
      final auth = new Auth();
      await auth.registerUser(
        email,
        password,
        user,
      );
      await _dataBaseService.saveData(user, password, predictedData);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text(e),
          );
        },
      );
    }
  }

  Future _signIn(context) async {
    String password = _passwordTextEditingController.text;
    final auth = new Auth();
    String _token;

    try {
      _token = await auth.signInWithEmail(_emailTextEditingController.text,
          _passwordTextEditingController.text);
    } catch (e) {
      FocusScope.of(context).requestFocus(new FocusNode());
    }
    if (_token != null) {
      print(_emailTextEditingController.text +
          _passwordTextEditingController.text);
      setUserEmail(this._emailTextEditingController.text);
      setUserName(this.predictedUser.user);
      setUserImagePath(_cameraService.imagePath);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Profile(
                    this._emailTextEditingController.text,
                    this.predictedUser.user,
                    imagePath: _cameraService.imagePath,
                  )));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Wrong password!'),
          );
        },
      );
    }
  }

  Future _predictUser() async {
    String userAndPass = await _faceNetService.predict();
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

          if (faceDetected) {
            if (widget.isLogin) {
              var userAndPass = "";
              // _predictUser().then((value) {
              //   userAndPass = value;
              //   this.predictedUser = User.fromDB(userAndPass);
              // });
            }
            PersistentBottomSheetController bottomSheetController =
                Scaffold.of(context)
                    .showBottomSheet((context) => signSheet(context));

            bottomSheetController.closed.whenComplete(() => widget.reload());
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

  signSheet(context) {
    return Container(
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FutureBuilder(
                  future: _predictUser(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Container(
                              child: Text(
                                'Plese Wait ...',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ]);
                    } else {
                      this.predictedUser = User.fromDB(snapshot.data);
                      return snapshot.hasData
                          ? Column(children: [
                            widget.isLogin?
                              Container(
                                child: Text(
                                  'Welcome back, ' + predictedUser.user + '.',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ):Container(),
                              Container(
                                child: Column(
                                  children: [
                                    !widget.isLogin
                                        ? AppTextField(
                                            controller:
                                                _userTextEditingController,
                                            labelText: "Full Name",
                                          )
                                        : Container(),
                                    SizedBox(height: 10),
                                    widget.isLogin && predictedUser == null
                                        ? Container()
                                        : AppTextField(
                                            controller:
                                                _emailTextEditingController,
                                            labelText: "Email",
                                          ),
                                    SizedBox(height: 10),
                                    widget.isLogin && predictedUser == null
                                        ? Container()
                                        : AppTextField(
                                            controller:
                                                _passwordTextEditingController,
                                            labelText: "Password",
                                            isPassword: true,
                                          ),
                                    Divider(),
                                    !widget.isLogin
                                        ? Container()
                                        : InkWell(
                                            onTap: () {
                                              return showDialog(
                                                  context: context,
                                                  builder:
                                                      (currentPassowrdContext) {
                                                    return AlertDialog(
                                                      title: Text(
                                                          'Reset Password'),
                                                      content: TextField(
                                                        controller:
                                                            _emailController,
                                                        textInputAction:
                                                            TextInputAction.go,
                                                        keyboardType: TextInputType
                                                            .numberWithOptions(),
                                                        decoration: InputDecoration(
                                                            hintText:
                                                                "Enter email address"),
                                                      ),
                                                      actions: <Widget>[
                                                        new TextButton(
                                                          child: new Text(
                                                              'Submit'),
                                                          onPressed: () {
                                                            _resetPassword(
                                                                _emailController
                                                                    .text);
                                                            Navigator.of(
                                                                    currentPassowrdContext)
                                                                .pop();
                                                            Widget okButton =
                                                                TextButton(
                                                              child: Text("OK"),
                                                              onPressed: () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                            );
                                                            AlertDialog alert =
                                                                AlertDialog(
                                                              title: Text(
                                                                  "Password Reset Link Sent"),
                                                              content: Text(
                                                                  "An password reset link has been sent to your email."),
                                                              actions: [
                                                                okButton
                                                              ],
                                                            );
                                                            showDialog(
                                                              context: context,
                                                              builder:
                                                                  (BuildContext
                                                                      context) {
                                                                return alert;
                                                              },
                                                            );
                                                          },
                                                        )
                                                      ],
                                                    );
                                                  });
                                            },
                                            child: Text(
                                                "Forgot Password? Click Me",
                                                style: TextStyle(
                                                    color: Colors.red))),
                                    SizedBox(height: 10),
                                    widget.isLogin && predictedUser != null
                                        ? AppButton(
                                            text: 'Login',
                                            onPressed: () async {
                                              _signIn(context);
                                            },
                                            color: Color(0xFFFF6161),
                                            icon: Icon(
                                              Icons.login,
                                              color: Colors.white,
                                            ),
                                          )
                                        : !widget.isLogin
                                            ? AppButton(
                                                text: 'Sign Up',
                                                onPressed: () async {
                                                  await _signUp(context);
                                                },
                                                color: Color(0xFFFF6161),
                                                icon: Icon(
                                                  Icons.person_add,
                                                  color: Colors.white,
                                                ),
                                              )
                                            : Container(),
                                  ],
                                ),
                              )
                            ])
                          : Container(
                              child: Text(
                              'Please try again',
                              style: TextStyle(fontSize: 20),
                            ));
                    }
                  })
             
        ],
      ),
    );
  }
}
