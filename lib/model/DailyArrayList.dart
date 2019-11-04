import 'package:daily_app/model/daily.dart';

class DailyArrayList {
  List<Daily> dailyList;

  DailyArrayList({this.dailyList});

  factory DailyArrayList.fromJson(Map<dynamic,dynamic> json) {
    return DailyArrayList(
      dailyList: parsedaily(json)
    );
  }

  static List<Daily> parsedaily(Map<dynamic,dynamic> json) {

  }
}