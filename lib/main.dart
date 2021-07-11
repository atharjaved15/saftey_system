import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:saftey_system/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('email');
  if(email==null){
    runApp(Splash());
  }
  else{
    var doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: homeScreen(phoneNumber1: doc['E_Number1'], phoneNumber2: doc['E_Number2']),
    ) );
  }

}
