import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class emergencyAlerts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firebase = FirebaseFirestore.instance;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Image(image: AssetImage('images/logo.png') ),
          ),
          backgroundColor: Colors.purple[800],
          title: Text('Emergency Alerts'  , style: TextStyle(color: Colors.white),),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: StreamBuilder<QuerySnapshot>(
            stream: _firebase.collection('users').snapshots(),
            builder: (context , snapshot){
              if(snapshot.hasData){
                final List<DocumentSnapshot> documents  = snapshot.data!.docs;
                return ListView(
                    children: documents
                        .map((doc) =>
                        InkWell(
                          onTap: (){
                          },
                          child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10 , right: 10 , bottom: 5, top: 10),
                                child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: doc['status'] == 'Safe' ? Colors.green[700] : Colors.red[700],
                                    ),
                                    height: 100,
                                    width: MediaQuery.of(context).size.width,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(doc['UserEmail '], style: TextStyle(color: Colors.white , fontSize: 12),),
                                              SizedBox(width: 100,),
                                              Text(doc['status'] , style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                            ],
                                          ),
                                          SizedBox(height: 5,),
                                          Row(
                                            children: [
                                              Text(doc['E_Number1'] , style: TextStyle(color: Colors.white),),
                                              SizedBox(width : 20),
                                              Text(doc['E_Number2'] , style: TextStyle(color: Colors.white),),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text('Location:     ' + doc['lat'] + ',' + doc['long'] , style: TextStyle(color: Colors.white),),
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
        ),
      ),
    );
  }
}
