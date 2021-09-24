import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:face_net_authentication/pages/utils/prefs.dart';
import 'package:face_net_authentication/pages/editprofiledetails.dart';
import 'package:page_transition/page_transition.dart';
import 'package:face_net_authentication/pages/utils/app_theme.dart';

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
          backgroundColor: AppTheme.mainColorDark,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppTheme.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            'Edit Profile',
            style: TextStyle(
              color: AppTheme.white,
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
          decoration: BoxDecoration(color: AppTheme.mainColorDark),
          padding: EdgeInsets.only(top: 25),
          child: Column(children: [
            Container(
                child: Expanded(
              flex: 3,
              child: ListView(
                children: [
                  Center(
                    child: FutureBuilder(
                      future: getUserImagePath(),
                      builder: (BuildContext context,
                          AsyncSnapshot<String> snapshot) {
                        if (snapshot.hasData) {
                          Widget container = Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
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
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
                ],
              ),
            )),
            Expanded(
              flex: 7,
              child: Container(
                  decoration: new BoxDecoration(
                      color: AppTheme.backgroundColor,
                      borderRadius: new BorderRadius.only(
                        topLeft: const Radius.circular(40.0),
                        topRight: const Radius.circular(40.0),
                      )),
                      padding:EdgeInsets.only(top:25),
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal:20),
                    children: [
                      FutureBuilder(
                        future: getUserName(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            Widget container = buildTextField(
                                "Full Name", snapshot.data, false);
                            return container;
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      SizedBox(height: 10),
                      FutureBuilder(
                        future: getUserEmail(),
                        builder: (BuildContext context,
                            AsyncSnapshot<String> snapshot) {
                          if (snapshot.hasData) {
                            Widget container =
                                buildTextField("Email", snapshot.data, false);
                            return container;
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      ),
                      SizedBox(
                        height: 25,
                        child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color:
                                            Theme.of(context).dividerColor)))),
                      ),
                      buildTextField("Change Password", "", true),
                    ],
                  )),
            )
          ]),
        ));
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Container(
      height: 60,
        child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              decoration: new BoxDecoration(
                  color:  isPasswordTextField ? Color.fromRGBO(190, 150, 150, 1) : AppTheme.subColor,
                  borderRadius: new BorderRadius.circular(50)),
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [
                  Text(labelText,style:TextStyle(color: isPasswordTextField ? Color.fromRGBO(255, 255, 255, 1) : AppTheme.subColorDark)),
                  Spacer(),
                  Text(placeholder,style:TextStyle(color:AppTheme.subColorDark)),
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
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: EditProfileDetail(labelText, isPasswordTextField)),
              );
            }));
  }
}
