import 'package:parental_controll_app/app_information.dart';

class Parent{
  String userId;
  String name;
  String age;
  String deviceToken;
  String latitude;
  String longitude;
  List<AppInformation> appInformations;
  String parentCode;

  Parent(
      this.userId,
      this.name,
      this.age,
      this.deviceToken,
      this.latitude,
      this.longitude,
      this.appInformations,
      this.parentCode,
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
    };
  }

}