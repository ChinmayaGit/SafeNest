import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:parental_controll_app/myHome_page.dart';

class ChildProfile extends StatefulWidget {
  ChildProfile({super.key});

  @override
  State<ChildProfile> createState() => _ChildProfileState();
}

class _ChildProfileState extends State<ChildProfile> {
  DocumentSnapshot<Map<String, dynamic>>? authQuerySnapshot;
  bool loading = true;

  @override
  void initState() {
    getAuthData();
  }

  Future<void> getAuthData() async {
    authQuerySnapshot = await FirebaseFirestore.instance
        .collection("Children")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading == false
          ? Column(

              children: [
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: GestureDetector(
                        onTap: (){
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute<Object>(
                              builder: (BuildContext context) => MyHomePage(title: "Scree", isParent: false),
                            ),
                          );
                        },
                        child: Container(child: Icon(Icons.arrow_back_ios_new)))),
                    Expanded(
                        flex: 5,
                        child: Center(child: Text("Profile"))),

                    Expanded(
                        flex: 1,
                        child: Container())
                  ],
                ),

                Text(authQuerySnapshot!.data()!["name"]),
                Text(authQuerySnapshot!.data()!["parentCode"]),
              ],
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
