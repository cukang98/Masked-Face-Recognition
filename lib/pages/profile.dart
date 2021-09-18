import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:face_net_authentication/pages/utils/animation.dart';
import 'package:http/http.dart' as http;
import 'package:face_net_authentication/pages/widgets/app_button.dart';
import 'package:face_net_authentication/pages/utils/requestassistant.dart';
import 'package:face_net_authentication/pages/profile_detail.dart';
import 'package:face_net_authentication/pages/checkin.dart';
import 'package:face_net_authentication/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:page_transition/page_transition.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Profile extends StatefulWidget {
  const Profile(this.email, this.username, {Key key, this.imagePath})
      : super(key: key);
  final String email;
  final String username;
  final String imagePath;
  @override
  ProfileState createState() => ProfileState(email, username, imagePath);
}

class ProfileState extends State<Profile> {
  RequestAssistant requestAssistant = RequestAssistant();
  final databaseRef = FirebaseDatabase.instance.reference();
  final String email;
  final String username;
  final String imagePath;

  ProfileState(this.email, this.username, this.imagePath);
  @override
  void initState() {
    super.initState();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    setState(() {});
    await Future.delayed(Duration(milliseconds: 1000));

    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  Future <dynamic> getCheckInRecord() async {
    String emailBase64 = base64.encode(utf8.encode(email));
    http.Response response = await http.get(Uri.parse(
        "https://final-year-project-9e674.firebaseio.com/$emailBase64/.json"));
    try {
      if (response.statusCode == 200) {
        String jsonData = response.body;
        Map<String, dynamic> decodedData = jsonDecode(jsonData);
        return decodedData;
      } else
        return "failed";
    } catch (exp) {
      return exp.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    return SmartRefresher(
        controller: _refreshController,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Scaffold(
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
                      CoolAlert.show(
                          context: context,
                          type: CoolAlertType.confirm,
                          text: 'Do you want to logout',
                          confirmBtnText: 'Yes',
                          cancelBtnText: 'No',
                          confirmBtnColor: Colors.green,
                          onConfirmBtnTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyHomePage()),
                            );
                          });
                      //Navigator.pop(context);
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                          autoPlayAnimationDuration:
                              Duration(milliseconds: 800),
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        child: Text("Records",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700))),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      margin:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                        child: FutureBuilder(
                          future: getCheckInRecord(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if(snapshot.hasData){
                              List data = [];
                            snapshot.data.forEach((key, values) {
                              data.add([
                                values['address'],
                                values['date'],
                                values['lt'],
                                values['ld']
                              ]);
                            });
                            data = new List.from(data.reversed);
                            return ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                
                                return FadeAnimation(1,Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 15, vertical: 0),
                                    child: Card(
                                      child: Column(
                                        children: <Widget>[
                                          ListTile(
                                            leading: Icon(Icons.location_city,
                                                size: 40),
                                            title: Text(data[index][0],
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    fontWeight:
                                                        FontWeight.w700)),
                                            subtitle: Text(data[index][1],
                                                style: TextStyle(fontSize: 10)),
                                          ),
                                        ],
                                      ),
                                    )));
                              },
                            );
                            }else{
                              return Container();
                            }
                          },
                        ))
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
                                        PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: CheckIn(),
                                        ));
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
            )));
  }
}
