import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_page_day_23/configuration.dart';
import 'package:carousel_slider/carousel_slider.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: MediaQuery.of(context).size.height,
      transform: Matrix4.translationValues(xOffset, yOffset, 0)
        ..scale(scaleFactor)
        ..rotateY(isDrawerOpen ? -0.5 : 0),
      duration: Duration(milliseconds: 250),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.7),
              spreadRadius: 15,
              blurRadius: 10,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
          borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 40)),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )),
              height: 30,
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.only(bottom: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isDrawerOpen
                      ? IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            setState(() {
                              xOffset = 0;
                              yOffset = 0;
                              scaleFactor = 1;
                              isDrawerOpen = false;
                            });
                          },
                        )
                      : IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () {
                            setState(() {
                              xOffset = 230;
                              yOffset = 150;
                              scaleFactor = 0.6;
                              isDrawerOpen = true;
                            });
                          }),
                  Column(
                    children: [
                      Text(
                        'Welcome, Tin Cu Kang',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      )
                    ],
                  ),
                  CircleAvatar(
                      radius: 23,
                      backgroundImage: AssetImage('assets/test1.jpg')),
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
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Text("Records",
                    style:
                        TextStyle(fontSize: 35, fontWeight: FontWeight.w700))),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.search),
                  Text('Search Records'),
                  Text(''),
                ],
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.location_city, size: 50),
                        title:
                            Text('Jalan Kemuliaan 26, Taman Universiti 81300'),
                        subtitle: Text('15/12/2020 15:38'),
                      ),
                    ],
                  ),
                )),
                
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.location_city, size: 50),
                        title:
                            Text('21, Jalan Kemuliaan 12, Taman Sutera 81300'),
                        subtitle: Text('11/12/2020 11:37'),
                      ),
                    ],
                  ),
                )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.location_city, size: 50),
                        title: Text('Sutera Mall, Taman Sutera Utama, 81300'),
                        subtitle: Text('12/8/2020 08:08'),
                      ),
                    ],
                  ),
                )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.location_city, size: 50),
                        title: Text('Aeon Mall, Taman Bukit Indah, 81300'),
                        subtitle: Text('21/7/2020 18:08'),
                      ),
                    ],
                  ),
                )),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                child: Card(
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.location_city, size: 50),
                        title: Text('Aeon Mall, Taman Bukit Indah, 81300'),
                        subtitle: Text('21/7/2020 18:08'),
                      ),
                    ],
                  ),
                ))
                ],
              )
            ),
          ],
        ),
      ),

    );
  }
}
