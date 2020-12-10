
import 'dart:ui';

import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/cupertino.dart';
import 'name_value_object.dart';

class TimeStamp {

  String id;
  dynamic parent;
  String title;
  DateTime start;
  int durationInMinutes;
  Color color;
  bool tracked;
  int parentIndex;

  TimeStamp({@required this.durationInMinutes,
    @required this.start,
    @required this.title,
    @required this.color,
    @required this.tracked,
    @required this.parent,@required this.parentIndex,@required this.id});

  DateTime getEndTime(){
    if(start!=null)return start.add(Duration(minutes: durationInMinutes));

    return null;
  }

  getScheduled(){
    Scheduled scheduled;
    MyApp.dataModel.scheduleds.forEach((element) {
      if(element.id==id){
        scheduled=element;
      }
    });
    return scheduled;
  }

  List<TimeStamp> splitTimestampForCalendarSupport(){
    List<TimeStamp> toreturn = [];
    if(start==null)return toreturn;

    int differenceBetweenTracked = onlyDayFormat(getEndTime()??(getTodayFormated().
      add(Duration(minutes: durationInMinutes)))).
      difference(onlyDayFormat(start??getTodayFormated())).inDays;

    for(int i = 0;i<differenceBetweenTracked+1;i++){

      //DEFINE THE START AND END FOR THE SPECIFIC DATE( DAYS+I )
      DateTime startToreturn = start.add(Duration(days: i));
      if(i!=0){
        startToreturn= DateTime(
            startToreturn.year,
            startToreturn.month,
            startToreturn.day,0,0,0);
      }

      DateTime endToreturn = start.add( Duration(days: i));
      if(i!=differenceBetweenTracked){
        endToreturn=DateTime(endToreturn.year,endToreturn.month,endToreturn.day,23,59,0);
      }else{
        endToreturn=getEndTime();
      }

      toreturn.add(TimeStamp(
        id: id,
        parent: parent,
        title: title,
        tracked: tracked,
        start: startToreturn,
        durationInMinutes: endToreturn==null?null:endToreturn.difference(startToreturn).inMinutes,
        color: color,
        parentIndex: parentIndex
      ));
    }
    return toreturn;
  }


  static List<NameValueObject> totalMinutesPerTrackable(List<TimeStamp> timestamps){
    List<NameValueObject> toreturn= [];

    timestamps.forEach((element) {
      bool added = false;
      for(int i = 0 ; i< toreturn.length; i++){
        if(toreturn[i].name==element.title){
          toreturn[i].value+=element.durationInMinutes;
          added=true;
        }
      }
      if(added==false)toreturn.add(NameValueObject(element.title,element.durationInMinutes));
    });

    return toreturn;
  }



}