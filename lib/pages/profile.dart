import 'dart:io';
import 'dart:convert';
import 'dart:developer';
import 'package:face_net_authentication/pages/utils/animation.dart';
import 'package:face_net_authentication/pages/utils/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
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
import 'package:local_auth/local_auth.dart';

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
    var localAuth = LocalAuthentication();
    bool didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Please authenticate to show account balance',
        useErrorDialogs: false);
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

  Future<dynamic> getCheckInRecord() async {
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

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return SmartRefresher(
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            key: _scaffoldKey,
            backgroundColor: Color.fromRGBO(248, 249, 255, 1),
            drawer: new Drawer(
              // Add a ListView to the drawer. This ensures the user can scroll
              // through the options in the drawer if there isn't enough vertical
              // space to fit everything.
              child: Container(
                  child: Column(children: [
                Expanded(
                    child: ListView(
                  // Important: Remove any padding from the ListView.
                  padding: EdgeInsets.zero,
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Color(0xFF1c92d2), Color(0xFFf2fcfe)],
                            begin: const FractionalOffset(0, 0.5),
                            end: const FractionalOffset(1.5, 0),
                            stops: [0, 5],
                            tileMode: TileMode.clamp),
                      ),
                      currentAccountPicture: new CircleAvatar(
                        radius: 60.0,
                        backgroundImage:
                            FileImage(File(imagePath)), // for Network image
                      ),
                      accountName: Container(
                        child: Text(
                          username,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                      ),
                      accountEmail: Container(
                        child: Text(email, style: TextStyle(fontSize: 13)),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.horizontal(
                          right: Radius.circular(1000),
                        ),
                        // Needed for ripple effect clipping
                        child: Material(
                          type: MaterialType.transparency,
                          child: ColoredBox(
                            color: Colors.transparent,
                            child: ListTile(
                              leading: Icon(
                                Icons.home,
                                color: AppTheme.mainColorDark,
                              ),
                              tileColor: Color.fromRGBO(239, 230, 253, 0.8),
                              title: Text("Home",
                                  style: TextStyle(
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppTheme.mainColorDark,
                                  )),
                              onTap: () {
                                // Update the state of the app
                                // ...
                                // Then close the drawer
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text("Profile",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey,
                          )),
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
                      title: Text("Settings",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey,
                          )),
                      onTap: () {
                        // Update the state of the app
                        // ...
                        // Then close the drawer
                        Navigator.pop(context);
                      },
                    ),
                  ],
                )),
                Divider(),
                Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: ListTile(
                      leading:
                          Icon(Icons.power_settings_new, color: Colors.red),
                      title: Text("Logout",
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red,
                          )),
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
                    ))
              ])),
            ),
            body: SafeArea(
              child: Column(children: [
                Container(
                  decoration: new BoxDecoration(
                      color: AppTheme.mainColorDark,
                      borderRadius: new BorderRadius.only(
                        bottomLeft: const Radius.circular(40.0),
                        bottomRight: const Radius.circular(40.0),
                      )),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: 15, left: 15),
                        margin: EdgeInsets.only(bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                icon: Icon(Icons.menu),
                                color: Colors.white,
                                onPressed: () =>
                                    _scaffoldKey.currentState.openDrawer()),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'Welcome',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      letterSpacing: 0.2,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                  Text(
                                    username,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                      letterSpacing: 0.27,
                                      color: AppTheme.white,
                                    ),
                                  ),
                                ],
                              ),
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
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16, right: 16, top: 8, bottom: 8),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    right: 16, top: 8, bottom: 8),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppTheme.nearlyWhite,
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(38.0),
                                    ),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          offset: const Offset(0, 2),
                                          blurRadius: 8.0),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 16, right: 16, top: 4, bottom: 4),
                                    child: TextField(
                                      onChanged: (String txt) {},
                                      style: const TextStyle(
                                        fontSize: 18,
                                      ),
                                      cursorColor: AppTheme.nearlyWhite,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'London...',
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.nearlyWhite,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(38.0),
                                ),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey.withOpacity(0.4),
                                      offset: const Offset(0, 2),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: const BorderRadius.all(
                                    Radius.circular(32.0),
                                  ),
                                  onTap: () {
                                    // FocusScope.of(context)
                                    //     .requestFocus(FocusNode());
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Icon(Icons.search,
                                        size: 20, color: Color(0xFFFF6161)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  margin:EdgeInsets.only(bottom:5)
                ),
                Expanded(
                  child:Scrollbar(
                    child: FutureBuilder(
                  future: getCheckInRecord(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
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
                          return FadeAnimation(
                              1,
                              Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 3),
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50.0),
                                    ),
                                    elevation: 0,
                                    color: Color.fromRGBO(255, 242, 200, 1),
                                    child: Column(
                                      children: <Widget>[
                                        ListTile(
                                          leading: Icon(Icons.location_city,
                                              size: 40,
                                              color:AppTheme.subColorDark),
                                          title: Text(data[index][0],
                                              style: GoogleFonts.nunito(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: 12,
                                                  color: AppTheme.subColorDark)),
                                          // style: TextStyle(
                                          //   color:Color.fromRGBO(66, 152, 230, 1),
                                          //     fontSize: 11,
                                          //     fontWeight:
                                          //         FontWeight.w700)),
                                          subtitle: Text(data[index][1],
                                              style: TextStyle(fontSize: 10)),
                                        ),
                                      ],
                                    ),
                                  )));
                        },
                      );
                    } else {
                      return Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text("No record found.",
                              style: TextStyle(fontSize: 13)));
                    }
                  },
                ))
              )]),
            ),
            bottomNavigationBar: BottomAppBar(
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: Container(
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
                                  color: Color.fromARGB(170, 108, 96, 225),
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
