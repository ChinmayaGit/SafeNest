import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ParentProfile extends StatefulWidget {
   ParentProfile({super.key});

  @override
  State<ParentProfile> createState() => _ParentProfileState();
}

class _ParentProfileState extends State<ParentProfile> {
  DocumentSnapshot<Map<String, dynamic>>? authQuerySnapshot;
bool loading=true;
  @override
  void initState() {
    getAuthData();

  }

   Future<void> getAuthData() async {
      authQuerySnapshot = await FirebaseFirestore.instance
         .collection("Parents")
         .doc(FirebaseAuth.instance.currentUser!.uid)
         .get();
     print(authQuerySnapshot!.data()!["name"]);
     setState(() {
       loading=false;
     });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),body: loading==false?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Text("Name:${authQuerySnapshot!.data()!["name"]}")),
          Text(authQuerySnapshot!.data()!["parentCode"]),
        ],
      ):Center(child: CircularProgressIndicator(),),
    );
  }
}
