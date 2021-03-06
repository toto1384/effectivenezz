import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';
import '../main.dart';


final String taskId= "_id";
final String taskName= "name";
final String taskChecks= "checks";
final String taskTags= "tags";
final String taskColor= "color";

final String taskTrackedStart= "trackedStart";
final String taskTrackedEnd= "trackedEnd";

final String taskParentId= "parentId";
final String taskIsParentCalendar= "isParentCalendar";
final String taskDescription= "description";
final String taskValue= "value";
final String taskValueMultiply= "valueMultiply";

final String taskBlacklistedDates= "blacklistedDates";
final String taskSchedules = 'schedules';


class Task{

  String id;
  String name;
  List<DateTime> checks;

  List<String> schedules;
  Color color;
  List<String> tags;

  List<DateTime> trackedStart;
  List<DateTime> trackedEnd;

  String parentId;
  bool isParentCalendar;
  String description;
  int value;
  bool valueMultiply;

  List<DateTime> blackListedDates;


  Task({this.id, @required this.name,@required this.trackedEnd,@required this.trackedStart,
    this.parentId,this.description,@required this.isParentCalendar,@required this.schedules,
    @required this.value, this.color,@required this.checks,@required this.valueMultiply,
    @required this.tags,this.blackListedDates});


  addCheck(DateTime dateTime){
    checks.add(dateTime);
  }
  
  static List<String> tagsFromString(String tags){
    List<String> toreturn = [];
    tags.split(",").forEach((element) {
      if((element!="")){
        toreturn.add(element);
      }
    });
    return toreturn;
  }

  String stringFromTags(){
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

  String stringFromSchedules(){
    String toreturn = '';
    schedules.forEach((element) {
      toreturn= toreturn+ element.toString()+",";
    });
    return toreturn;
  }

  int getStreakNumberForEveryday(){
    int streak = 0;
    while(isCheckedOnDate(getTodayFormated().subtract(Duration(days: streak+1)))){
      streak++;
    }
    if(isCheckedOnDate(getTodayFormated())){
      streak++;
    }
    return streak;
  }


  bool isCheckedOnDate(DateTime dateTime){
    if(checks.length==0){
      return false;
    }else{
      bool checked = false;
      checks.forEach((item){
        if(areDatesOnTheSameDay(item, dateTime)){
          checked=true;
        }
      });
      return checked;
    }
  }


  unCheckOnDate(DateTime dateTime){
    for(int i = 0; i<checks.length; i++){
      if(checks[i].year==dateTime.year&&checks[i].month==dateTime.month&&checks[i].day==dateTime.day){
        checks.removeAt(i);
        return;
      }
    }
  }

  Map<String,dynamic> toMap(){
    return {
      taskValue: value,
      taskTrackedStart : stringFromDateTimes(trackedStart),
      taskParentId: parentId,
      taskName:name,
      taskChecks:stringFromDateTimes(checks),
      taskTrackedEnd:stringFromDateTimes(trackedEnd),
      taskColor: color==null?MyApp.dataModel.findParentColor(this).value:color.value,
      taskDescription: description,
      taskId:id,
      taskIsParentCalendar: isParentCalendar?1:0,
      taskValueMultiply: valueMultiply?1:0,
      taskTags: stringFromTags(),taskSchedules:stringFromSchedules(),
      taskBlacklistedDates:stringFromDateTimes(blackListedDates),
    };
  }

  Map<String,dynamic> toMapBackend(){
    var map = {
      taskValue: value,
      taskTrackedStart : trackedStart.map((e) => e.millisecondsSinceEpoch).toList(),
      taskParentId: parentId,
      taskName:name,
      taskChecks:checks.map((e) => e.millisecondsSinceEpoch).toList(),
      taskTrackedEnd:trackedEnd.map((e) => e.millisecondsSinceEpoch).toList(),
      taskColor: color==null?MyApp.dataModel.findParentColor(this).value.toString():color.value.toString(),
      taskIsParentCalendar: isParentCalendar,
      taskValueMultiply: valueMultiply?1:0,
      taskTags: tags,taskSchedules:schedules,
      taskBlacklistedDates:(blackListedDates??[]).map((e) => e.millisecondsSinceEpoch).toList(),
      taskDescription:description??""
    };
    if(id!=null)map[taskId]=id;
    return map;
  }

  static Task fromMap(Map map){
    return Task(
      value: map[taskValue],
      trackedStart: dateTimesFromString(map[taskTrackedStart]),
      parentId: map[taskParentId],
      name: map[taskName],
      checks: dateTimesFromString(map[taskChecks]),
      trackedEnd: dateTimesFromString(map[taskTrackedEnd]),
      color: Color(map[taskColor]??0xffffff),
      description: map[taskDescription]??'',
      id: map[taskId],schedules: schedulesFromString(map[taskSchedules]),
      isParentCalendar: map[taskIsParentCalendar]==1,
      valueMultiply: map[taskValueMultiply]==1,
      tags: tagsFromString(map[taskTags]),
      blackListedDates: dateTimesFromString(map[taskBlacklistedDates]),
    );
  }

  static Task fromMapBackend(Map map){
    return Task(
      value: map[taskValue],
      trackedStart:map[taskTrackedStart].map((e)=>getDateFromString(e,isUtc: true)).cast<DateTime>().toList(),
      parentId: map[taskParentId],
      name: map[taskName],
      checks: map[taskChecks].map((e)=>getDateFromString(e,isUtc: true)).cast<DateTime>().toList(),
      trackedEnd: map[taskTrackedEnd].map((e)=>getDateFromString(e,isUtc: true)).cast<DateTime>().toList(),
      color: Color(int.parse(map[taskColor])??0xffffff),
      description: map[taskDescription]??'',
      id: map[taskId],schedules: map[taskSchedules].cast<String>(),
      isParentCalendar: map[taskIsParentCalendar],
      valueMultiply: map[taskValueMultiply]==1,
      tags: map[taskTags].cast<String>(),
      blackListedDates: map[taskBlacklistedDates].map((e)=>getDateFromString(e,isUtc: true)).cast<DateTime>().toList(),
    );
  }

  List<Scheduled> getScheduled(){
    List<Scheduled>  toreturn = [];
    MyApp.dataModel.scheduleds.forEach((element) {
      if(schedules.contains(element.id)){
        toreturn.add(element);
      }
    });
    return toreturn;
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
  //             endTime= getDateFromString(getStringFromDate(DateTime.now()));
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
  //       return Duration(minutes: subtractDurations(Duration(minutes:
  //         getScheduled(context)[0].durationInMinutes), taken).inMinutes);
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
  //           if(!(ts.isBefore(currentStartTime)&&te.isBefore(currentStartTime))){
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
  //       return Duration(minutes: subtractDurations(Duration(minutes:
  //         getScheduled(context)[0].durationInMinutes), tracked).inMinutes);
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

  List<TimeStamp> getTrackedTimestamps(BuildContext context,List<DateTime> forDates){
    List<TimeStamp> toreturn = [];

//    if(trackedEnd.length!=trackedStart.length){
//      trackedEnd.add(getTodayFormated());
//    }

    for(int i = 0; i<trackedStart.length;i++){
      List<TimeStamp> splittedPlanedTimestamp = TimeStamp(
        id: id,
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
        forDates.forEach((forDay){
          if(areDatesOnTheSameDay(splittedTimestamp.start, forDay)){
            toreturn.add(splittedTimestamp);
          }
        });
      });
    }



    return toreturn;
  }



}
