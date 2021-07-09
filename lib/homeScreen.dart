import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:saftey_system/nearbyUsers.dart';
import 'package:saftey_system/signIn.dart';

import 'aboutUS.dart';
import 'emergencyNumbers.dart';

class homeScreen extends StatelessWidget {
  late String phoneNumber1,phoneNumber2,lat,long;
  homeScreen({
   required this.phoneNumber1,
   required this.phoneNumber2,
});
  void getLocation() async {
     Geolocator.getCurrentPosition(desiredAccuracy:  LocationAccuracy.best).then((value) async =>
     {
       lat = value.latitude.toString(),
       long = value.longitude.toString(),
       await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid.toString()).update({
         'lat' : lat.toString(),
         'long' : long.toString(),
       }),
     });
  }
  void _sendSMS(String message, List<String> recipents) async {
    String _result = await sendSMS(message: message, recipients: recipents)
        .catchError((onError) {
      print(onError);
    });
    print(_result);
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      home: Scaffold(
        drawerEnableOpenDragGesture: true,
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Image(image: AssetImage('images/logo.png') ),
          ),
          backgroundColor: Colors.white,
          title: Text('Home Screen'  , style: TextStyle(color: Colors.black),),
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top:20, left: 10,right: 10,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('images/logo.png', height: MediaQuery.of(context).size.height * 0.15,),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06,),
                    Text('Home Screen' , style: TextStyle(fontSize: 22, fontWeight:FontWeight.bold),),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Emergency Number 1: '),
                            Text(phoneNumber1, style: TextStyle(fontSize: 25),),
                          ],
                        ),
                        SizedBox(height: 10,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text('Emergency Number 2: '),
                            Text(phoneNumber2, style: TextStyle(fontSize: 25),),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                    MaterialButton(
                      onPressed: (){
                        getLocation();
                        _sendSMS('Help me I am in Trouble at location: $lat , $long ', [phoneNumber1,phoneNumber2]);
                      },
                      color: Colors.red,
                      minWidth: MediaQuery.of(context).size.width * 0.3,
                      child: Center(
                        child: Text('Send Alert SMS', style: TextStyle(color: Colors.white),),
                      ),


                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.005,),
                    MaterialButton(
                      onPressed: (){
                        getLocation();
                        _sendSMS('Help me I am in Trouble at location: $lat , $long ', [phoneNumber1,phoneNumber2]);
                      },
                      color: Colors.green,
                      minWidth: MediaQuery.of(context).size.width * 0.3,
                      child: Center(
                        child: Text('I am Safe', style: TextStyle(color: Colors.white),),
                      ),


                    ),
                  ],
                ),
              ),
            ),
          ),

        ),
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
                    Text('Nearby Users'),
                  ],
                ),
                onTap: () async {
                  var doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => nearbyUsers(lat: doc['lat'], long: doc['long'])));
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
      ),
    );
  }
}
