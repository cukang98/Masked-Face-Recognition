import 'package:face_net_authentication/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';

var title;

class EditProfileDetail extends StatefulWidget {
  final String title;
  final bool isPassword;
  EditProfileDetail(this.title, this.isPassword);
  _EditProfileDetailState createState() => _EditProfileDetailState();
}

class _EditProfileDetailState extends State<EditProfileDetail> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _Cpasswordcontroller = TextEditingController();

  Future<void> _passwordsameDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Change Password Failed'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('New password cannot same with current password.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continue'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _successChanged() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Password Changed Successfully'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('You will be required to login again.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Continue'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyHomePage()));
              },
            ),
          ],
        );
      },
    );
  }

  void _changePassword(String currentPassword, String newPassword) async {
    final user = FirebaseAuth.instance.currentUser;
    final cred = EmailAuthProvider.credential(
        email: user.email, password: currentPassword);
    print(currentPassword + newPassword);
    if (currentPassword == newPassword) {
      _passwordsameDialog();
    } else {
      user.reauthenticateWithCredential(cred).then((value) {
        user.updatePassword(newPassword).then((_) {
          _successChanged();
        }).catchError((error) {
          //Error, show something
        });
      }).catchError((err) {
        print(err.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 240, 240, 240),
        appBar: AppBar(
          backgroundColor: Color(0xFFFF6161),
          elevation: 1,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            !widget.isPassword ? 'Edit ' + this.widget.title : widget.title,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25),
              child: IconButton(
                icon: Icon(Icons.check, color: Colors.white),
                onPressed: () {
                  // Unfocus
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  return showDialog(
                      context: context,
                      builder: (currentPassowrdContext) {
                        return AlertDialog(
                          title: Text('Authentication Required'),
                          content: TextField(
                            obscureText: true,
                            controller: _Cpasswordcontroller,
                            textInputAction: TextInputAction.go,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintText: "Enter current password"),
                          ),
                          actions: <Widget>[
                            new TextButton(
                              child: new Text('Submit'),
                              onPressed: () {
                                Navigator.of(currentPassowrdContext).pop();
                                Widget okButton = TextButton(
                                  child: Text("Yes"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    _changePassword(_Cpasswordcontroller.text,
                                        _textController.text);
                                  },
                                );
                                Widget cancelButton = TextButton(
                                  child: Text("No"),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                );
                                AlertDialog alert = AlertDialog(
                                  title: Text("Change Password"),
                                  content: Text(
                                      "Would you like to update your password?"),
                                  actions: [
                                    cancelButton,
                                    okButton,
                                  ],
                                );
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return alert;
                                  },
                                );
                              },
                            )
                          ],
                        );
                      });
                },
              ),
            )
          ],
        ),
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  obscureText: true,
                  onChanged: (text) {
                    setState(() {});
                  },
                  controller: _textController,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      suffixIcon: _textController.text.length > 0
                          ? IconButton(
                              onPressed: () {
                                _textController.clear();
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.grey,
                                size: 18,
                              ))
                          : null),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: _printInfo(widget.title),
              )
            ],
          ),
        ));
  }

  Widget _printInfo(String title) {
    if (widget.isPassword)
      return Text("Minimum of 6 characters",
          style: TextStyle(color: Colors.grey, fontSize: 12));
  }
}
