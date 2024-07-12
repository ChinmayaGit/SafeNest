//import 'dart:html';
//import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:parental_controll_app/myHome_page.dart';
import 'package:parental_controll_app/parent_display.dart';

//import 'package:flutter_map/flutter_map.dart';
//import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
//import 'package:latlong2/latlong.dart';
//import 'package:location/location.dart';
//import 'package:parental_controll_app/app_usage_details.dart';
import 'package:parental_controll_app/signin_options.dart';
import 'package:usage_stats/usage_stats.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermissions();
  }

  requestPermissions() async {
    // grant usage permission - opens Usage Settings
    await UsageStats.grantUsagePermission();

    // check if permission is granted
    bool isPermission = UsageStats.checkUsagePermission() as bool;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.email?[0] == "0") {
                return const ParentDisplay(isParent: false);
              } else {
                return const MyHomePage(
                  title: 'Screen Control',
                  isParent: false,
                );
              }
            }
            return const SinginOptions();
          }),
      routes: {
        SinginOptions.routeName: (context) {
          return const SinginOptions();
        }
      },
    );
  }
}
