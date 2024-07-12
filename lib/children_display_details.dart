
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';
import 'package:parental_controll_app/ChildProfile.dart';
import 'package:parental_controll_app/children.dart';

import 'ParentProfile.dart';


class ChildrenDisplayDetails extends StatelessWidget {
  Children data;
  ChildrenDisplayDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${data.name.toUpperCase()} Details'
        ),
        actions: [

        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: FlutterMap(
                options: MapOptions(
                  center: LatLng(
                      double.parse(data.latitude),double.parse(data.longitude),),
                    zoom: 15,
                  maxZoom: 15,
                ),
                children: <Widget>[

                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const['a','b','c'],
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
                          point: LatLng(
                              double.parse(data.latitude),double.parse(data.longitude)),
                          builder: (context) {
                            return Container(child: const Icon(Icons.location_on, color: Colors.deepPurple,),);
                          },)
                      ],
                      builder: (context, markers) {
                        return Container(
                          height: 80, width: 80,
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
              constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height * 0.5),
              child: Container(
                  child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      itemCount: data.appInformations.length ,
                      itemBuilder:(context,index) {
                        Duration screenDuration = Duration(milliseconds: int.parse(data.appInformations[index].screenTime),);
                        return GestureDetector(
                          onTap: () async {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) {
                            //       return AppUsageDetails(application:  data.appInformations.,);
                            //     },
                            //   ),
                            // );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.1,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15,),
                                color: Colors.indigoAccent,
                              ),
                              child: Center(
                                child: ListTile(
                                  title: SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.05,
                                    child: Text(
                                      data.appInformations[index].appName,
                                      style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  subtitle:Text(
                                    'Last used: ${DateFormat('dd-MM-yyyy MM:mm:ss').
                                    format(DateTime.fromMillisecondsSinceEpoch(
                                        int.parse(data.appInformations[index].lastTimeUsed)))}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  trailing: Wrap(
                                    direction: Axis.vertical,
                                    children: [Text(
                                        '${screenDuration.inHours} Hr: ${screenDuration.inMinutes} min: ${screenDuration.inSeconds} sec',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.black
                                        )
                                    ),
                                      const Text(
                                          'Screen Time',
                                          style:  TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black
                                          )
                                      )],
                                  ) ,
                                ),
                              ),
                            ),
                          ),
                        );
                      })
              ),
            ),
          ],
        ),
      ),
    );
  }
}

