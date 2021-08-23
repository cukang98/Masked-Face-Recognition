import 'package:flutter/material.dart';
import 'package:login_page_day_23/dashboard.dart';
class TopBar extends StatelessWidget {
  const TopBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            onPressed: () {Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DashBoard()));},
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.menu, color: Colors.white),
          ),
        ],
      ),
    );
  }
}