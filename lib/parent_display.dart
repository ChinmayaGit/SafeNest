import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:parental_controll_app/signin_options.dart';

import 'children_display.dart';
import 'myHome_page.dart';
import 'ParentProfile.dart';

class ParentDisplay extends StatefulWidget {
  final bool isParent;

  const ParentDisplay({super.key, required this.isParent});

  @override
  State<ParentDisplay> createState() => _ParentDisplayState();
}

class _ParentDisplayState extends State<ParentDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parent Display'),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute<Object>(
                  builder: (BuildContext context) => ParentProfile(),
                ),
              );
            },
            icon: const Icon(
              Icons.person,
              color: Colors.black,
            ),
          ),
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushNamed(SinginOptions.routeName);
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return const ChildrenDisplay();
                    },
                  ));
                },
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                        color: Colors.blue[100],
                        borderRadius: BorderRadius.circular(
                          15,
                        )),
                    child: const Center(
                        child: Text(
                      'Kids Information',
                      style: TextStyle(fontSize: 30),
                    )),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
