import 'package:flutter/material.dart';
import 'package:login_page_day_23/configuration.dart';
import 'package:login_page_day_23/user_profile/profilepage.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(

      decoration: new BoxDecoration(
        image: new DecorationImage(
                fit: BoxFit.cover,
                image: new AssetImage("assets/profilebg.jpg"),
              ),
      ),
      
      padding: EdgeInsets.only(top:50,bottom: 70,left: 0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left:15),
            child:
          Row(
            children: [
              CircleAvatar(radius: 30,backgroundImage: AssetImage('assets/test1.jpg')),
              SizedBox(width: 15,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tin Cu Kang',style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize:20),)
                ],
              )
            ],
          )),
          Container(
            height: MediaQuery.of(context).size.height/3,
            padding: new EdgeInsets.only(right:15,left:15),
            child:
          Column(
            
            mainAxisAlignment: MainAxisAlignment.start,
            children: drawerItems.map((element) => Padding(
              
              padding: const EdgeInsets.only(top:20,bottom: 20,left:10),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => element['ontap']));
              },
                    child:
                    Row(
                      children:[
                  Icon(element['icon'],color: Colors.black54,size: 25,),
                  SizedBox(width: 20,),
                  Text(element['title'],style: TextStyle(color: Colors.black54,fontWeight: FontWeight.bold,fontSize: 20)),
                      ]),)
                  
                ], 

              ),
            )).toList(),
          )),

          Row(
            children: [
            ],
          )


        ],
      ),

    );
  }
}
