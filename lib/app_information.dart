
class AppInformation {
  String appName;
  String appPackageName;
  String screenTime;
  String lastTimeUsed;


  AppInformation(this.appName, this.appPackageName, this.screenTime, this.lastTimeUsed);

  Map<String, dynamic> toJSON (){
    return{
      'appName': appName,
      'appPackageName': appPackageName,
      'screenTime': screenTime,
      'lastTimeUsed': lastTimeUsed,
    };
  }

  factory AppInformation.fromMap(Map<String, dynamic> data){
    return AppInformation(
        data['appName'] ?? '',
        data['appPackageName'] ?? '',
        data['screenTime'] ?? '',
        data['lastTimeUsed'] ?? ''
    );
  }
}