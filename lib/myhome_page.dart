import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_apps/device_apps.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:parental_controll_app/ChildProfile.dart';
import 'package:parental_controll_app/parent.dart';
import 'package:parental_controll_app/signin_options.dart';
import 'package:usage_stats/usage_stats.dart';
import 'app_information.dart';
import 'app_usage_details.dart';

class MyHomePage extends StatefulWidget {
  final bool isParent;

  const MyHomePage({super.key, required this.title, required this.isParent});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Location location = Location();

  bool? _serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  List<AppInformation> appInformations = [];
  String? docId;
  Parent? parent;
  UsageInfo? appUsageInfo;
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    parent = Parent('', '', '', '', '', '', [], '');
    await getCurrentUser();
    await getLocationDetails();
    await getAllTheInstalledApps();
    setState(() {
      loading = true;
    });

  }

  getCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;
    print('UID of the parent ${user!.uid}');
    setState(() {
      parent!.userId = user.uid;
      docId = user.uid;
    });
  }

  getAllTheInstalledApps() async {
    appInformations = [];
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
      includeAppIcons: true,
    );
    if (apps.isNotEmpty) {
      for (var element in apps) {
        UsageInfo uInfo = await getUsage(element);
        print('Screen Time ${uInfo.totalTimeInForeground.toString()}');
        AppInformation appInfo = AppInformation(
          element.appName,
          element.packageName,
          uInfo.totalTimeInForeground.toString(),
          uInfo.lastTimeUsed.toString(),
        );
        setState(() {
          appInformations.add(appInfo);
        });
      }
    }

    setState(() {
      parent!.appInformations = appInformations;
    });

    print('lenght of the app information ${appInformations.length}');
    print('DOCID of the parent $docId');

    if (widget.isParent) {
      await updateParentInformation(docId!);
    } else {
      await updateChildInformation(docId!);
    }
  }

  void handleTimeout() {
    setState(() {
      loading = true;
    });
  }

  getLocationDetails() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled!) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled!) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    await location.getLocation().then((value) {
      setState(() {
        _locationData = value;
        parent!.latitude = value.latitude.toString();
        parent!.longitude = value.longitude.toString();
      });
    });
    print(
        'DEVICE LOCATION LAT ${_locationData!.latitude}: LONG ${_locationData!.longitude}');
  }

  updateParentInformation(String docId) async {
    await FirebaseFirestore.instance.collection('Parents').doc(docId).update({
      "latitude": _locationData!.latitude,
      "longitude": _locationData!.longitude,
      'appInformations': appInformations.map((e) => e.toJSON()).toList(),
    });
  }

  updateChildInformation(String docId) async {
    await FirebaseFirestore.instance.collection('Children').doc(docId).update({
      "latitude": _locationData!.latitude,
      "longitude": _locationData!.longitude,
      'appInformations': appInformations.map((e) => e.toJSON()).toList(),
    });
  }

  Future<UsageInfo> getUsage(Application application) async {
    DateTime endDate = DateTime.now();
    DateTime startDate =
        DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);

    // query usage stats
    List<UsageInfo> usageStats =
        await UsageStats.queryUsageStats(startDate, endDate);

    if (usageStats.isNotEmpty) {
      for (var element in usageStats) {
        if (element.packageName == application.packageName) {
          setState(() {
            appUsageInfo = element;
          });
        }
      }
    }
    print('Value inside app usage info ${appUsageInfo!.packageName}');
    // query events
    //List<EventUsageInfo> events = await UsageStats.queryEvents(startDate, endDate);

    // query eventStats API Level 28
    //List<EventInfo> eventStats = await UsageStats.queryEventStats(startDate, endDate);

    // query configurations
    //List<ConfigurationInfo> configurations = await UsageStats.queryConfiguration(startDate, endDate);

    // query aggregated usage statistics
    //Map<String, UsageInfo> queryAndAggregateUsageStats = await UsageStats.queryAndAggregateUsageStats(startDate, endDate);

    // query network usage statistics
    //List<NetworkInfo> networkInfos = await UsageStats.queryNetworkUsageStats(startDate, endDate, networkType: NetworkType.all);
    return appUsageInfo!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () async {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute<Object>(
                  builder: (BuildContext context) => ChildProfile(),
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
                color: Colors.white,
              ))
        ],
      ),
      body: loading == true
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.5,
                    child: FlutterMap(
                      options: MapOptions(
                        center: LatLng(_locationData!.latitude!,
                            _locationData!.longitude!),
                        zoom: 15,
                        maxZoom: 15,
                      ),
                      children: <Widget>[
                        TileLayer(
                          urlTemplate:
                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          subdomains: const ['a', 'b', 'c'],
                        ),
                        MarkerClusterLayerWidget(
                          options: MarkerClusterLayerOptions(
                            maxClusterRadius: 45,
                            size: const Size(40, 40),
                            anchor: AnchorPos.align(AnchorAlign.center),
                            fitBoundsOptions: const FitBoundsOptions(
                              padding: EdgeInsets.all(50),
                              maxZoom: 15,
                            ),
                            markers: [
                              Marker(
                                point: LatLng(_locationData!.latitude!,
                                    _locationData!.longitude!),
                                builder: (context) {
                                  return Container(
                                    child: const Icon(
                                      Icons.location_on,
                                      color: Colors.deepPurple,
                                    ),
                                  );
                                },
                              )
                            ],
                            builder: (context, markers) {
                              return Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blue),
                                child: Center(
                                  child: Text(
                                    markers.length.toString(),
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height * 0.5),
                    child: FutureBuilder(
                        future: DeviceApps.getInstalledApplications(
                          includeSystemApps: true,
                          onlyAppsWithLaunchIntent: true,
                          includeAppIcons: true,
                        ),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Container(
                              decoration: const BoxDecoration(),
                              child: const Text(
                                'We do not have any apps installed',
                              ),
                            );
                          }
                          List<Application> apps =
                              snapshot.data as List<Application>;
                          return Container(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  itemCount: apps.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () async {
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .add({
                                          'appName': apps[index].appName,
                                        });
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return AppUsageDetails(
                                                application: apps[index],
                                              );
                                            },
                                          ),
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.1,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              15,
                                            ),
                                            color: Colors.indigoAccent,
                                          ),
                                          child: Center(
                                            child: ListTile(
                                              leading: Image.memory(
                                                (apps[index]
                                                        as ApplicationWithIcon)
                                                    .icon,
                                              ),
                                              title: SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                                child: Text(
                                                  apps[index].appName,
                                                  style: const TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              trailing: IconButton(
                                                onPressed: () {
                                                  apps[index].openApp();
                                                },
                                                icon: const Icon(
                                                  Icons.open_in_new,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }));
                        }),
                  ),
                ],
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
