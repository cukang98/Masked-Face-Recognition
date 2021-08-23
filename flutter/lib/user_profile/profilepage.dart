import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:flutter/material.dart';
import 'package:login_page_day_23/dashboard.dart';
import 'package:login_page_day_23/splashscreen.dart';
import 'package:login_page_day_23/user_profile/card_item.dart';
import 'package:login_page_day_23/user_profile/stack_container.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}
class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            StackContainer(),
            Container(
              padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 21.0,
                  ),
              height: 50, 
              child: Divider(color: Colors.black),
              ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 21.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.account_box,
                          size: 40.0,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Tin",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "First Name",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 21.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.account_box,
                          size: 40.0,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Cu Kang",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "Last Name",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 21.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.person,
                          size: 40.0,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "Male",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "Gender",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 21.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.mail,
                          size: 40.0,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "cukang98@gmail.com",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "Email",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 21.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.vpn_key,
                          size: 40.0,
                          color: Colors.green,
                        ),
                      ),
                      SizedBox(width: 24.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            "******a89",
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            "Password",
                            style: TextStyle(
                              color: Colors.grey[700],
                              fontSize: 12.0,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        
      ),      
    );
  }
  
}
