import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:face_net_authentication/pages/utils/prefs.dart';
import 'package:face_net_authentication/pages/editprofiledetails.dart';
import 'package:face_net_authentication/pages/utils/Animation.dart';
import 'package:page_transition/page_transition.dart';

class ProfileDetailPage extends StatefulWidget {
  @override
  _ProfileDetailState createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetailPage> {
  bool showPassword = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          'Edit Profile',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Icon(
              Icons.check,
              color: Colors.white,
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 25),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: FutureBuilder(
                  future: getUserImagePath(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    Widget container = Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(snapshot.data),
                              ))),
                    );

                    return container;
                  },
                ),
              ),
              SizedBox(
                height: 35,
                child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor)))),
              ),
              FutureBuilder(
                future: getUserName(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  Widget container =
                      buildTextField("Full Name", snapshot.data, false);

                  return container;
                },
              ),
              FutureBuilder(
                future: getUserEmail(),
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  Widget container =
                      buildTextField("Email", snapshot.data, false);

                  return container;
                },
              ),
              SizedBox(
                height: 25,
                child: Container(
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color: Theme.of(context).dividerColor)))),
              ),
              buildTextField("Change Password", "", true),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return InkWell(
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Theme.of(context).dividerColor))),
          child: Row(
            children: [
              Text(labelText),
              Spacer(),
              Text(placeholder),
              new Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      size: 15, color: Colors.grey))
            ],
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            PageTransition(type: PageTransitionType.rightToLeft,child: EditProfileDetail(labelText,isPasswordTextField)),
          );
        });
  }
}
