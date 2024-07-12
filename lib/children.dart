import 'package:parental_controll_app/app_information.dart';

class Children {
  String userId;
  String name;
  String age;
  String mobile;
  String deviceToken;
  String latitude;
  String longitude;
  List<AppInformation> appInformations;
  String parentCode;
  String parentUserId;

  Children(
  this.userId,
  this.name,
  this.age,
  this.mobile,
  this.deviceToken,
  this.latitude,
  this.longitude,
  this.appInformations,
  this.parentCode,
  this.parentUserId,

      );

  Map<String, dynamic> toJSON(){
    return{
      "userId": userId,
      "name": name,
      "age": age,
      "deviceToken": deviceToken,
      "latitude": latitude,
      "longitude": longitude,
      "appInformations": appInformations.map((e) => e.toJSON()).toList(),
       "parentCode" : parentCode,
      "parentUserId" : parentUserId,

    };
  }

  factory Children.fromMap(Map<String, dynamic> data){
    return Children(
        data['userId'] ?? '',
        data['name'] ?? '',
        data['age'] ?? '',
        data['mobile'] ?? '',
        data['deviceToken'] ?? '',
        double.parse(data['latitude'].toString()).toString(),
        double.parse(data['longitude'].toString()).toString(),

        (data['appInformations'] as List<dynamic>).
        map((e) => AppInformation.fromMap(e)).
        toList(),

        data['parentCode'] ?? '',
        data['parentUserId'] ?? ''
    );
  }
}