
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';


final String activityId = '_id';
final String activityName = 'name';
final String activityIcon = 'icon';
final String activityTags = 'tags';
final String activityColor = 'color';
final String activityTrackedStart = 'trackedStart';
final String activityTrackedEnd = 'trackedEnd';
final String activityParentCalendarId = 'parentId';
final String activityDescription = 'description';
final String activityValue = 'value';
final String activityBlacklistedDates = 'blacklistedDates';
final String activityValueMultiply = 'valueMultiply';
final String activitySchedules = 'schedules';



class Activity {

  String id;
  String name;
  Color color;
  IconData icon;
  List<String> tags;

  List<DateTime> trackedStart;
  List<DateTime> trackedEnd;
  List<String> schedules;

  String parentCalendarId;
  String description;

  int value;
  bool valueMultiply;

  List<DateTime> blacklistedDates;
  List<Task> childs = [];


  Activity({ this.id, @required this.name,@required this.trackedStart,@required this.trackedEnd,
    @required this.parentCalendarId,this.description,@required this.value,@required this.schedules,
    this.color,@required this.valueMultiply,this.icon,@required this.tags,this.blacklistedDates});


  List<Scheduled> getScheduled(){
    List<Scheduled>  toreturn = [];
    MyApp.dataModel.scheduleds.forEach((element) {
      if(schedules.contains(element.id)){
        toreturn.add(element);
      }
    });
    return toreturn;
  }

  static List<String> tagsFromString(String tags){
    List<String> toreturn = [];
    tags.split(",").forEach((element) {
      if((element!="")){
        toreturn.add((element));
      }
    });
    return toreturn;
  }

  stringFromTags(){
    String toreturn = '';
    tags.forEach((element) {
      toreturn= toreturn+ element.toString()+",";
    });
    return toreturn;
  }


  static List<String> schedulesFromString(String tags){
    List<String> toreturn = [];
    tags.split(",").forEach((element) {
      if((element!="")){
        toreturn.add(element);
      }
    });
    return toreturn;
  }

  stringFromSchedules(){
    String toreturn = '';
    schedules.forEach((element) {
      toreturn= toreturn+ element.toString()+",";
    });
    return toreturn;
  }

  Map<String,dynamic> toMap(){
    return {
      activityValue: value,
      activityValueMultiply: valueMultiply?1:0,
      activityTrackedStart : stringFromDateTimes(trackedStart),
      activityParentCalendarId: parentCalendarId,
      activityName:name,
      activityTrackedEnd:stringFromDateTimes(trackedEnd),
      activityColor: color==null?MyApp.dataModel.findParentColor(this).value:color.value,
      activityDescription: description,
      activityId:id,
      activityIcon:icon!=null?icon.codePoint:null,
      activityTags:stringFromTags(),
      activityBlacklistedDates:stringFromDateTimes(blacklistedDates),
      activitySchedules:stringFromSchedules(),
    };
  }

  Map<String,dynamic> toMapBackend(){
    print(schedules.toString());
    var map= {
      activityValue: value,
      activityValueMultiply: valueMultiply?1:0,
      activityTrackedStart : trackedStart.map((e) => e.millisecondsSinceEpoch).toList(),
      activityParentCalendarId: parentCalendarId,
      activityName:name,
      activityTrackedEnd:trackedEnd.map((e) => e.millisecondsSinceEpoch).toList(),
      activityColor: color==null?MyApp.dataModel.findParentColor(this).value.toString():color.value.toString(),
      activityIcon:icon!=null?icon.codePoint:null,
      activityTags:tags,
      activityBlacklistedDates:(blacklistedDates??[]).map((e) => e.millisecondsSinceEpoch).toList(),
      activitySchedules:schedules,
      activityDescription:description??"",
    };
    if(id!=null)map[activityId]=id;
    return map;
  }

  static Activity fromMap(Map map){
    return Activity(
      value: map[activityValue],
      trackedStart: dateTimesFromString(map[activityTrackedStart]),
      parentCalendarId: map[activityParentCalendarId],
      name: map[activityName],
      trackedEnd: dateTimesFromString(map[activityTrackedEnd]),
      color: Color(map[activityColor]??0xffffff),
      description: map[activityDescription]??'',
      id: map[activityId],
      valueMultiply: map[activityValueMultiply]==1,
      icon: map[activityIcon]==null?null:IconData(map[activityIcon],fontFamily: "MaterialIcons"),
      tags: tagsFromString(map[activityTags]),
      blacklistedDates: dateTimesFromString(map[activityBlacklistedDates]),
      schedules: schedulesFromString(map[activitySchedules])
    );
  }

  static Activity fromMapBackend(Map map){
    return Activity(
        value: map[activityValue],
        trackedStart: map[activityTrackedStart].map((e)=>getDateFromString(e,isUtc: true)).cast<DateTime>().toList(),
        parentCalendarId: map[activityParentCalendarId],
        name: map[activityName],
        trackedEnd: map[activityTrackedEnd].map((e)=>getDateFromString(e,isUtc: true)).cast<DateTime>().toList(),
        color: Color(int.parse(map[activityColor])??0xffffff),
        description: map[activityDescription]??'',
        id: map[activityId],
        valueMultiply: map[activityValueMultiply]==1,
        icon: map[activityIcon]==null?null:IconData(map[activityIcon],fontFamily: "MaterialIcons"),
        tags: (map[activityTags]).cast<String>(),
        blacklistedDates: (map[activityBlacklistedDates]??[]).map((e)=>getDateFromString(e,isUtc: true)).cast<DateTime>().toList(),
        schedules: map[activitySchedules].cast<String>()
    );
  }


  // Duration getTimeLeft(BuildContext context){
  //   if(getScheduled(context)[0].durationInMinutes==0){
  //     return Duration.zero;
  //   }
  //
  //   switch(getScheduled(context)[0].repeatRule){
  //
  //     case RepeatRule.None:
  //       Duration taken = Duration.zero;
  //
  //       for(int i = 0 ; i<trackedStart.length ; i++){
  //         DateTime startTime = trackedStart[i];
  //         DateTime endTime;
  //
  //         if(i+1==trackedStart.length){
  //           //last
  //           if(trackedStart.length!=trackedEnd.length){
  //             //isn't finished
  //             endTime= getTodayFormated();
  //           }else{
  //             endTime = trackedEnd[i];
  //           }
  //         }else{
  //           endTime = trackedEnd[i];
  //         }
  //
  //         taken = addDurations(taken, endTime.difference(startTime));
  //
  //       }
  //
  //       return subtractDurations(Duration(minutes: getScheduled(context)[0].durationInMinutes), taken);
  //       break;
  //     case RepeatRule.EveryXDays:
  //
  //       DateTime nextStartTime = getScheduled(context)[0].getNextStartTime();
  //       DateTime currentStartTime = getScheduled(context)[0].getCurrentStartTime();
  //
  //
  //       Duration tracked = Duration.zero;
  //
  //       for (int i = 0 ; i< trackedStart.length; i++) {
  //         DateTime ts=trackedStart[i];
  //         DateTime te = (((trackedStart.length!=trackedEnd.length)&&(i==(trackedStart.length-1)))?getTodayFormated():trackedEnd[i]);
  //         if(!areDatesOnTheSameDay(ts, te)){
  //
  //           //are not on the same day
  //           List<DateTime> tsl = [];
  //           List<DateTime> tel = [];
  //           for(int i = 0 ; i<daysDifference(te, ts)+1; i++){
  //             if(i==0){
  //               //first
  //               tsl.add(ts);
  //               tel.add(DateTime(ts.year,ts.month,ts.day,23,59));
  //             }else if(i==daysDifference(te, ts)){
  //               //last
  //               tsl.add(DateTime(ts.year,ts.month,ts.day).add(Duration(days: i)));
  //               tel.add(te);
  //             }else{
  //               //middle
  //               tsl.add(DateTime(ts.year,ts.month,ts.day).add(Duration(days: i)));
  //               tel.add(DateTime(ts.year,ts.month,ts.day,23,59).add(Duration(days: i)));
  //             }
  //           }
  //           //now calculate which ts and te match between the dates
  //           for(int i = 0 ; i < tsl.length ; i++){
  //             if(!(tsl[i].isBefore(currentStartTime)&&
  //                 tel[i].isBefore(currentStartTime))){
  //               //is in between
  //               if(tsl[i].isBefore(currentStartTime)){
  //                 tsl[i]=currentStartTime;
  //               }
  //               if(tel[i].isAfter(nextStartTime)){
  //                 tel[i]=nextStartTime;
  //               }
  //               tracked= Duration(milliseconds: tel[i].difference(tsl[i]).inMilliseconds+tracked.inMilliseconds);
  //             }
  //           }
  //         }else{
  //
  //           if(!(ts.isBefore(currentStartTime)&&
  //               te.isBefore(currentStartTime))){
  //             //is in between
  //             if(ts.isBefore(currentStartTime)){
  //               ts=currentStartTime;
  //             }
  //             if(te.isAfter(nextStartTime)){
  //               te=nextStartTime;
  //             }
  //             tracked= Duration(milliseconds: te.difference(ts).inMilliseconds+tracked.inMilliseconds);
  //           }
  //         }
  //       }
  //
  //       return subtractDurations(Duration(minutes: getScheduled(context)[0].durationInMinutes), tracked);
  //     case RepeatRule.EveryXWeeks:
  //       break;
  //     case RepeatRule.EveryXMonths:
  //       break;
  //   }
  //   return Duration.zero;
  // }


  int getMinutesTaken() {
    int minutesTaken = 0;

    for(int i = 0 ; i<trackedStart.length ; i++){
      DateTime startTime = trackedStart[i];
      DateTime endTime;

      if(i+1==trackedStart.length){
        //last
        if(trackedStart.length!=trackedEnd.length){
          //isn't finished
          endTime= getDateFromString(getStringFromDate(DateTime.now()));
        }else{
          endTime = trackedEnd[i];
        }
      }else{
        endTime = trackedEnd[i];
      }

      minutesTaken = minutesTaken + endTime.difference(startTime).inMinutes;

    }

    return minutesTaken;
  }

  List<TimeStamp> getTrackedTimestamps(BuildContext context,List<DateTime> forDates,{bool dontCompleteActives}){
    List<TimeStamp> toreturn = [];

    if(dontCompleteActives==null)dontCompleteActives=false;

    for(int i = 0; i<trackedStart.length;i++){
        List<TimeStamp> splittedPlanedTimestamp = TimeStamp(
          id: "${id}000$i",
          parent: this,
          color: color,
          durationInMinutes: (((trackedStart.length!=trackedEnd.length)&&
              (i==(trackedStart.length-1)))?getTodayFormated():trackedEnd[i]).difference(trackedStart[i]).inMinutes,
          start: trackedStart[i],
          title: name,
          tracked: true,
          parentIndex: i
        ).splitTimestampForCalendarSupport();

        //if on date
        splittedPlanedTimestamp.forEach((splittedTimestamp){
          if(forDates==null){
            toreturn.add(splittedTimestamp);
          }else{
            forDates.forEach((forDay){
              if(areDatesOnTheSameDay(splittedTimestamp.start, forDay)){
                toreturn.add(splittedTimestamp);
              }
            });
          }
        });
    }

    return toreturn;
  }

}
