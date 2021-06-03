import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:saftey_system/homeScreen.dart';

class signUp extends StatelessWidget {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passController = new TextEditingController();
  TextEditingController phoneNumber_1 = new TextEditingController();
  TextEditingController phoneNumber_2 = new TextEditingController();
  late String p_No_1,p_No_2,email,pass;

  getValues(){
    email = emailController.text.toString();
    pass = passController.text.toString();
    p_No_1 = phoneNumber_1.text.toString();
    p_No_2 = phoneNumber_2.text.toString();
  }
  Future registerUser() async {
    var _auth = FirebaseAuth.instance;
    if(emailController.text != null && passController.text != null && phoneNumber_2.text != null && phoneNumber_1 != null){
      try{
        UserCredential user = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
        toast(user);
        return user;
      }
      catch(e){
        Fluttertoast.showToast(msg: e.toString());

      }
    }
    else{
      Fluttertoast.showToast(msg: 'Kinldy Enter All the details');
    }


  }
  toast(UserCredential user){

    if(user != null){
      Fluttertoast.showToast(msg: 'User Registered Successfully');

    }
    else
      Fluttertoast.showToast(msg: 'User is not Registered Successfully');
  }
  saveData() async {
    var  _firebaseFirestore = FirebaseFirestore.instance;
    await _firebaseFirestore.collection('users').doc(FirebaseAuth.instance.currentUser!.uid.toString()).set(
        {
          'UserID' : FirebaseAuth.instance.currentUser!.uid,
          'UserEmail ' : FirebaseAuth.instance.currentUser!.email,
          'E_Number1' : p_No_1,
          'E_Number2' : p_No_2,
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Image(image: AssetImage('images/logo.png') ),
          ),
          backgroundColor: Colors.white,
          title: Text('Sign UP '  , style: TextStyle(color: Colors.black),),
        ),
        body: Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top:20, left: 10,right: 10,),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset('images/logo.png', height: MediaQuery.of(context).size.height * 0.15,),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.06,),
                    Text('Sign UP' , style: TextStyle(fontSize: 22, fontWeight:FontWeight.bold),),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                    TextField(
                      decoration: InputDecoration(
                        fillColor: Colors.grey[100],
                        hintText: 'UserName',
                        hoverColor: Colors.purple[800],
                        prefixIcon: Icon(Icons.admin_panel_settings_outlined),

                      ),
                      controller: emailController,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    TextField(
                      controller: passController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey[100],
                        hintText: 'Password',
                        hoverColor: Colors.purple[800],
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: InkWell(child: Icon(Icons.remove_red_eye),
                        ),
                      ),
                      obscureText: true,
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.001,),
                    MaterialButton(
                      onPressed: () async {
                        await getValues();
                        await registerUser();
                        await saveData();
                        var doc = await FirebaseFirestore.instance.collection('users').doc(FirebaseAuth.instance.currentUser!.uid).get();
                        await Navigator.push(context, MaterialPageRoute(builder: (context) => homeScreen(phoneNumber1: doc['E_Number1'], phoneNumber2: doc['E_Number2'])));
                      },
                      height: MediaQuery.of(context).size.height * 0.04,
                      minWidth: MediaQuery.of(context).size.width *0.9,
                      color: Colors.redAccent,
                      child: Center(
                        child: Text('Sign Up', style: TextStyle(color: Colors.white),),
                      ),
                    )


                  ],
                ),
              ),
            ),
          ),

        ),
      ),
    );
  }
}
