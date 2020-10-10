
import 'dart:ui';

import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/cupertino.dart';

import 'name_value_object.dart';

class TimeStamp{

  int id;
  int parentId;
  String name;
  DateTime startTime;
  int duration;
  Color color;
  bool tracked;
  bool isTask;
  int parentIndex;

  TimeStamp({@required this.duration,
    @required this.isTask,
    @required this.startTime,
    @required this.name,
    @required this.color,
    @required this.tracked,
    @required this.parentId,@required this.parentIndex});

  DateTime getEndTime(){
    if(startTime!=null&&duration!=null)return startTime.add(Duration(minutes: duration));

    return null;
  }

  getParent(){
    print('timestamp get parent');
    return isTask?MyApp.dataModel.findTaskById(parentId):MyApp.dataModel.findActivityById(parentId);
  }

  List<TimeStamp> splitTimestampForCalendarSupport(){
    List<TimeStamp> toreturn = [];
    if(startTime==null)return toreturn;

    int differenceBetweenTracked = onlyDayFormat(getEndTime()??(getTodayFormated().add(Duration(minutes: duration)))).difference(onlyDayFormat(startTime??getTodayFormated())).inDays;

    for(int i = 0;i<differenceBetweenTracked+1;i++){

      //DEFINE THE START AND END FOR THE SPECIFIC DATE( DAYS+I )
      DateTime startToreturn = startTime.add(Duration(days: i));
      if(i!=0){
        startToreturn= DateTime(startToreturn.year,startToreturn.month,startToreturn.day);
      }

      DateTime endToreturn = startTime.add(Duration(days: i));
      if(i!=differenceBetweenTracked){
        endToreturn=DateTime(endToreturn.year,endToreturn.month,endToreturn.day,23,59);
      }else{
        endToreturn=getEndTime();
      }

      toreturn.add(TimeStamp(
        parentId: parentId,
        isTask: isTask,
        name: name,
        tracked: tracked,
        startTime: startToreturn,
        duration: endToreturn==null?null:endToreturn.difference(startToreturn).inMinutes,
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
        if(toreturn[i].name==element.name){
          toreturn[i].value+=element.duration;
          added=true;
        }
      }
      if(added==false)toreturn.add(NameValueObject(element.name,element.duration));
    });

    return toreturn;
  }



}