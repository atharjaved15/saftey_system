import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saftey_system/homeScreen.dart';
import 'package:saftey_system/signIn.dart';

class emergencyNumbers extends StatefulWidget {
  @override
  _emergencyNumbersState createState() => _emergencyNumbersState();
}

class _emergencyNumbersState extends State<emergencyNumbers> {
  TextEditingController phoneNumber_1 = new TextEditingController();
  TextEditingController phoneNumber_2 = new TextEditingController();
  late String p_No_1,p_No_2;
  getValues(){
    p_No_1 = phoneNumber_1.text.toString();
    p_No_2 = phoneNumber_2.text.toString();
  }
  Future <void> updateNumbers () async {
    getValues();
    if(phoneNumber_1.text.isNotEmpty &&  phoneNumber_2.text.isNotEmpty){
      await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).update(
          {
            'E_Number1' : p_No_1,
            'E_Number2' : p_No_2,
          }).whenComplete(() => {
            Fluttertoast.showToast(msg: 'Phone Numbers Updated Successfully !'),
      });
    }
  }
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
          title: Text('Update Emergency Numbers'  , style: TextStyle(color: Colors.black),),
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
                    Text('Update Emergency Numbers' , style: TextStyle(fontSize: 22, fontWeight:FontWeight.bold),),
                  ],
                ),
                Container(
                    height: MediaQuery.of(context).size.height * 0.6,
                    child: Column(
                      children: [
                        TextField(
                          controller:  phoneNumber_1,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[100],
                            hintText: 'Emergency Number 1',
                            hoverColor: Colors.purple[800],
                            prefixIcon: Icon(Icons.phone),

                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                        TextField(
                          controller: phoneNumber_2,
                          decoration: InputDecoration(
                            fillColor: Colors.grey[100],
                            hintText: 'Emergency Number 2',
                            hoverColor: Colors.purple[800],
                            prefixIcon: Icon(Icons.phone),

                          ),
                        ),
                      ],
                    )
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.001,),
                MaterialButton(
                  onPressed: () async {
                    await updateNumbers();
                    var doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
                    await  Navigator.push(context, MaterialPageRoute(builder: (context)=> homeScreen(phoneNumber1: doc['E_Number1'], phoneNumber2: doc['E_Number2'])));
                  },
                  height: MediaQuery.of(context).size.height * 0.04,
                  minWidth: MediaQuery.of(context).size.width *0.9,
                  color: Colors.redAccent,
                  child: Center(
                    child: Text('Update Numbers', style: TextStyle(color: Colors.white),),
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
