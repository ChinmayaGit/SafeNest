import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:usage_stats/usage_stats.dart';

class AppUsageDetails  extends StatefulWidget {
  final Application application;
  const AppUsageDetails ({super.key, required this.application});

  @override
  State<AppUsageDetails> createState() => _AppUsageDetailsState();
}

class _AppUsageDetailsState extends State<AppUsageDetails> {

  UsageInfo? appUsageInfo;
  getUsage() async {

    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime(endDate.year, endDate.month, endDate.day, 0, 0, 0);


    // query usage stats
    List<UsageInfo> usageStats = await UsageStats.queryUsageStats(startDate, endDate);

    if(usageStats.isNotEmpty){
      for (var element in usageStats) {
        if(element.packageName == widget.application.packageName){
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

  }
  @override
  void initState() {
    super.initState();
    getUsage();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.application.appName,
        ),
      ),
      body: Container(
        child: Column(
         children: [
           const SizedBox(height: 15,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: const BoxDecoration(),
                  width: MediaQuery.of(context).size.width * 0.3,
                  child: const Text(
                    'Screen Time : ',
                    style: TextStyle(
                      color: Colors.lightGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(),
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    '${(int.parse(appUsageInfo!.totalTimeInForeground!) / 1000 / 60).toStringAsFixed(2)} min:sec',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                )
              ],
            ),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Container(
                 decoration: const BoxDecoration(),
                 width: MediaQuery.of(context).size.width * 0.3,
                 child: const Text(
                   'Last Used Time : ',
                   style: TextStyle(
                     color: Colors.lightGreen,
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               ),
               Container(
                   decoration: const BoxDecoration(),
                   width: MediaQuery.of(context).size.width * 0.5,
                   child: Text(
                     DateFormat('dd-MM-yyyy HH:mm:ss').format(DateTime.fromMillisecondsSinceEpoch(int.parse(appUsageInfo!.lastTimeUsed!))),
                     style: const TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.bold,
                     ),
                   )
               )
             ],
           ),
        ],
      ),
    )
    );
  }
}
