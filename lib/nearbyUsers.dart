import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:fluttertoast/fluttertoast.dart';
import 'package:saftey_system/signIn.dart';

import 'aboutUS.dart';
import 'emergencyNumbers.dart';

class nearbyUsers extends StatefulWidget {
  late String lat,long;
  nearbyUsers({
    required this.long,
    required this.lat,
});
  @override
  _nearbyUsersState createState() => _nearbyUsersState();
}

class _nearbyUsersState extends State<nearbyUsers> {
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
                  Navigator.push(context, MaterialPageRoute(builder: (context) => aboutUS()));
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
          title: Text('Nearby Users'  , style: TextStyle(color: Colors.black),),
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
                    Text('Nearby Users' , style: TextStyle(fontSize: 22, fontWeight:FontWeight.bold),),
                    SizedBox(height: 20,),
                    Text('Users within 10Km area around you will appear here' , style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection('users').snapshots(),
                    builder: (context , snapshot){
                      if(snapshot.hasData){
                        final List<DocumentSnapshot> documents  = snapshot.data!.docs;
                        return ListView(
                            children: documents.where((element) =>
                              double.parse(element['lat']) - double.parse(widget.lat) <= 0.1 || double.parse(element['lat']) - double.parse(widget.lat) >= -0.1 &&
                                  double.parse(element['long']) - double.parse(widget.long) <= 0.1 || double.parse(element['long']) - double.parse(widget.long) >= -0.1
                            )
                                .map((doc) =>
                                InkWell(
                                  onTap: (){
                                    },
                                  child: Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 5 , right: 5 , bottom: 5, top: 10),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15),
                                              color: Colors.black87,
                                            ),
                                            height: 90,
                                            width: MediaQuery.of(context).size.width,
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 8.0, right: 8),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      CircleAvatar(
                                                        child: ClipOval(
                                                          child: new SizedBox(
                                                            height: 100,
                                                            width: 100,
                                                            child: Image.asset(
                                                              'images/logo.png',
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 20,),
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          SizedBox(height: 5,),
                                                          Text(doc['UserEmail '] , style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
                                                          SizedBox(height: 5),
                                                          Text( 'E1 : ' + doc['E_Number1'] , style: TextStyle(color: Colors.white),),
                                                          Text('E2 : ' + doc['E_Number2'] , style: TextStyle(color: Colors.white),),


                                                        ],
                                                      )
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                        ),
                                      )
                                  ),
                                )).toList()
                        );
                      }
                      else
                        return Center(child: CircularProgressIndicator());
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
