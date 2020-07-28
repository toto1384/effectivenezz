import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';

import '../main.dart';


final String taskId= "ti";
final String taskName= "tn";
final String taskChecks= "tc";
final String taskTags= "tta";
final String taskColor= "tco";

final String taskTrackedStart= "tts";
final String taskTrackedEnd= "tte";

final String taskParentId= "tp";
final String taskIsParentCalendar= "tis";
final String taskDescription= "tde";
final String taskValue= "tv";
final String taskValueMultiply= "tva";

final String taskBlacklistedDates= "tbd";


class Task{

  int id;
  String name;
  List<DateTime> checks;

  Color color;
  List<int> tags;

  List<DateTime> trackedStart;
  List<DateTime> trackedEnd;

  int parentId;
  bool isParentCalendar;
  String description;
  int value;
  bool valueMultiply;

  List<DateTime> blackListedDates;


  Task({this.id, @required this.name,@required this.trackedEnd,@required this.trackedStart,
    @required this.parentId,this.description,@required this.isParentCalendar,
    @required this.value, this.color,@required this.checks,@required this.valueMultiply,
    @required this.tags,this.blackListedDates}){
  }


  static List<int> tagsFromString(String tags){
    List<int> toreturn = [];
    tags.split(",").forEach((element) {
      if((element!="")){
        toreturn.add(int.parse(element));
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


  isCheckedOnDate(DateTime dateTime){
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
      taskColor: color==null?Colors.white.value:color.value,
      taskDescription: description,
      taskId:id,
      taskIsParentCalendar: isParentCalendar?1:0,
      taskValueMultiply: valueMultiply?1:0,
      taskTags: stringFromTags(),
      taskBlacklistedDates:stringFromDateTimes(blackListedDates),
    };
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
      id: map[taskId],
      isParentCalendar: map[taskIsParentCalendar]==1,
      valueMultiply: map[taskValueMultiply]==1,
      tags: tagsFromString(map[taskTags]),
      blackListedDates: dateTimesFromString(map[taskBlacklistedDates]),
    );
  }

  List<Scheduled> _scheduled=[];

  List<Scheduled> getScheduled(BuildContext context){
    if(_scheduled.length==0){
      List<Scheduled>  toreturn = [];
      MyApp.dataModel.scheduleds.forEach((element) {
        if((element.isParentTask)&&(element.parentId==id)){
          toreturn.add(element);
        }
      });
      if(toreturn.length==0){
        Scheduled scheduled = Scheduled(
          durationInMins: 0,
          repeatValue: 0,
          repeatRule: RepeatRule.None,
          isParentTask: true,
          parentId: id,
        );
        MyApp.dataModel.scheduled(0,scheduled,context,CUD.Create);
        toreturn.add(scheduled);
      }
      _scheduled=toreturn;
    }
    return _scheduled;
  }

  Duration getTimeLeft(BuildContext context){
    if(getScheduled(context)[0].durationInMins==0){
      return Duration.zero;
    }

    switch(getScheduled(context)[0].repeatRule){

      case RepeatRule.None:
        Duration taken = Duration.zero;

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

          taken = addDurations(taken, endTime.difference(startTime));

        }

        return subtractDurations(Duration(minutes: getScheduled(context)[0].durationInMins), taken);
        break;
      case RepeatRule.EveryXDays:

        DateTime nextStartTime = getScheduled(context)[0].getNextStartTime();
        DateTime currentStartTime = getScheduled(context)[0].getCurrentStartTime();


        Duration tracked = Duration.zero;

        for (int i = 0 ; i< trackedStart.length; i++) {
          DateTime ts=trackedStart[i];
          DateTime te = (((trackedStart.length!=trackedEnd.length)&&(i==(trackedStart.length-1)))?getTodayFormated():trackedEnd[i]);
          if(!areDatesOnTheSameDay(ts, te)){

            //are not on the same day
            List<DateTime> tsl = [];
            List<DateTime> tel = [];
            for(int i = 0 ; i<daysDifference(te, ts)+1; i++){
              if(i==0){
                //first
                tsl.add(ts);
                tel.add(DateTime(ts.year,ts.month,ts.day,23,59));
              }else if(i==daysDifference(te, ts)){
                //last
                tsl.add(DateTime(ts.year,ts.month,ts.day).add(Duration(days: i)));
                tel.add(te);
              }else{
                //middle
                tsl.add(DateTime(ts.year,ts.month,ts.day).add(Duration(days: i)));
                tel.add(DateTime(ts.year,ts.month,ts.day,23,59).add(Duration(days: i)));
              }
            }
            //now calculate which ts and te match between the dates
            for(int i = 0 ; i < tsl.length ; i++){
              if(!(tsl[i].isBefore(currentStartTime)&&tel[i].isBefore(currentStartTime))){
                //is in between
                if(tsl[i].isBefore(currentStartTime)){
                  tsl[i]=currentStartTime;
                }
                if(tel[i].isAfter(nextStartTime)){
                  tel[i]=nextStartTime;
                }
                tracked= Duration(milliseconds: tel[i].difference(tsl[i]).inMilliseconds+tracked.inMilliseconds);
              }
            }
          }else{

            if(!(ts.isBefore(currentStartTime)&&te.isBefore(currentStartTime))){
              //is in between
              if(ts.isBefore(currentStartTime)){
                ts=currentStartTime;
              }
              if(te.isAfter(nextStartTime)){
                te=nextStartTime;
              }
              tracked= Duration(milliseconds: te.difference(ts).inMilliseconds+tracked.inMilliseconds);
            }
          }
        }

        return subtractDurations(Duration(minutes: getScheduled(context)[0].durationInMins), tracked);
      case RepeatRule.EveryXWeeks:
      // TODO: Handle this case.
        break;
      case RepeatRule.EveryXMonths:
      // TODO: Handle this case.
        break;
    }
    return Duration.zero;
  }


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
        parentId: id,
        isTask: true,
        color: color,
        duration: (((trackedStart.length!=trackedEnd.length)&&(i==(trackedStart.length-1)))?getTodayFormated():trackedEnd[i]).difference(trackedStart[i]).inMinutes,
        startTime: trackedStart[i],
        name: name,
        tracked: true,
      ).splitTimestampForCalendarSupport();

      //if on date
      splittedPlanedTimestamp.forEach((splittedTimestamp){
        forDates.forEach((forDay){
          if(areDatesOnTheSameDay(splittedTimestamp.startTime, forDay)){
            toreturn.add(splittedTimestamp);
          }
        });
      });
    }



    return toreturn;
  }



}
