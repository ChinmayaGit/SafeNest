import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'children.dart';
import 'children_display_details.dart';

class ChildrenDisplay extends StatefulWidget {
  const ChildrenDisplay({super.key});

  @override
  State<ChildrenDisplay> createState() => _ChildrenDisplayState();
}

class _ChildrenDisplayState extends State<ChildrenDisplay> {
  String? parentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;
    print('UID of the parent ${user!.uid}');
    setState(() {
      parentUserId = user.uid;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KIDS INFORMATION'),
      ),
      body: Container(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Children')
                  .where('parentUserId', isEqualTo: parentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data!.docs;
                  return snapshot.data!.docs.isNotEmpty
                      ? ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Children child = Children.fromMap(
                              snapshot.data!.docs[index].data());
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) {
                              return ChildrenDisplayDetails(data:  child );
                            },
                          ));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height:
                            MediaQuery.of(context).size.height * 0.2,
                            width:
                            MediaQuery.of(context).size.width * 0.6,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.green[200],
                            ),
                            child: Center(
                              child: Text(
                                '${snapshot.data!.docs[index]['name']}',
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                      : const Center(
                    child: Text('NO KIDS CONNECTED'),
                  );
                }
                return const Center(
                  child: Text('NO KIDS CONNECTED'),
                );
              })),
    );
  }
}
