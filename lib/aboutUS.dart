import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saftey_system/emergencyNumbers.dart';
import 'package:saftey_system/signIn.dart';

class aboutUS extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        drawer: Drawer(
          elevation: 2,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text('Smart Protection App' , style:  TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                decoration: BoxDecoration(

                  color: Colors.grey[800],
                ),
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.near_me),
                    SizedBox(width: 40,),
                    Text('Home Screen'),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.info),
                    SizedBox(width: 40,),
                    Text('About Us'),
                  ],
                ),
                onTap: () {
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.change_circle_outlined),
                    SizedBox(width: 40,),
                    Text('Update Emergency Numbers'),
                  ],
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => emergencyNumbers()));
                },
              ),
              ListTile(
                title: Row(
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 40,),
                    Text('Log out'),
                  ],
                ),
                onTap: () async{
                  await FirebaseAuth.instance.signOut().whenComplete(() =>
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => signIn())).whenComplete(() => {
                      Fluttertoast.showToast(msg: "You have been Logged Out Successfully!"),
                    }),
                  });
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Image(image: AssetImage('images/logo.png') ),
          ),
          backgroundColor: Colors.white,
          title: Text('About Us'  , style: TextStyle(color: Colors.black),),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('About Us' , style: TextStyle(fontSize: 22, fontWeight:FontWeight.bold),),
                    SizedBox(height: 20,),
                    Text('On this page you may get information about the developers' , style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    children: [
                      Text('Name'),
                      SizedBox(height: 20,),
                      Text('Email'),
                    ],
                  )
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
