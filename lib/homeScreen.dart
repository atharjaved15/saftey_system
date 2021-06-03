import 'package:flutter/material.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:geolocator/geolocator.dart';

class homeScreen extends StatelessWidget {
  late String phoneNumber1,phoneNumber2,lat,long;
  homeScreen({
   required this.phoneNumber1,
   required this.phoneNumber2,
});
  void getLocation(){
     Geolocator.getCurrentPosition(desiredAccuracy:  LocationAccuracy.best).then((value) =>
     {
       lat = value.latitude.toString(),
       long = value.longitude.toString(),
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
