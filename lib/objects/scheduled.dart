
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


final String scheduledId= "sid";
final String scheduledParentId= "spid";
final String scheduledIsParentTask= "sispat";
final String scheduledStartTime= "sstt";
final String scheduledDuration= "sdur";
final String scheduledRepeatRule= "srr";
final String scheduledRepeatValue= "srv";
final String scheduledRepeatUntil= "sru";

class Scheduled{


  int id;
  int parentId;
  bool isParentTask;
  DateTime startTime;
  int durationInMinutes;
  RepeatRule repeatRule;
  int repeatValue;
  DateTime repeatUntil;


  Scheduled({@required this.parentId,@required this.isParentTask,
    this.startTime,this.durationInMinutes,@required this.repeatRule,@required this.repeatValue,this.repeatUntil,this.id});


  DateTime getEndTime(){
    if(startTime==null)return null;
    return (startTime.add(Duration(minutes: durationInMinutes??0)));
  }

  static Scheduled fromMap(Map map){
    Scheduled scheduled =  Scheduled(
      startTime: getDateFromString(map[scheduledStartTime]),
      repeatValue: map[scheduledRepeatValue],
      repeatRule: getRepeatRuleInt(map[scheduledRepeatRule]??0),
      durationInMinutes: map[scheduledDuration],
      parentId: map[scheduledParentId],
      isParentTask: map[scheduledIsParentTask]==1,
      repeatUntil: getDateFromString(map[scheduledRepeatUntil]),
      id: map[scheduledId],
    );
    return scheduled;
  }

  Map<String,dynamic> toMap(){
    if(repeatRule!=RepeatRule.None&&startTime==null){
      repeatRule=RepeatRule.None;
      Fluttertoast.showToast(msg: 'Because there was no start or end time, the repeat rule was set to none');
    }
    return {
      scheduledId:id,
      scheduledParentId: parentId,
      scheduledIsParentTask:isParentTask?1:0,
      scheduledStartTime:getStringFromDate(startTime),
      scheduledDuration:durationInMinutes,
      scheduledRepeatValue: repeatValue,
      scheduledRepeatUntil: getStringFromDate(repeatUntil),
      scheduledRepeatRule: getIntRepeatRule(),
    };
  }


  String getRepeatText(){
    switch(repeatRule){

      case RepeatRule.EveryXDays:
        return 'Repeats every $repeatValue day(s)';
        break;
      case RepeatRule.EveryXWeeks:
        return 'Repeats every ${repeatValue.toString()[0]} week(s) on ${repeatValue.toString().length-1} days of the week';
        break;
      case RepeatRule.EveryXMonths:
        return 'Repeats every $repeatValue month(s)';
        break;
      case RepeatRule.None:
        return 'Does not repeat';
        break;
    }
    return '';
  }

  int getIntRepeatRule(){
    switch(repeatRule){

      case RepeatRule.EveryXDays:
        return 1;
        break;
      case RepeatRule.EveryXWeeks:
        return 2;
        break;
      case RepeatRule.EveryXMonths:
        return 3;
        break;
      case RepeatRule.None:
        return 0;
        break;
    }
    print("Repeat rule int scheduled");
    return 0;
  }

  static RepeatRule getRepeatRuleInt(int repeatRule){
    switch(repeatRule){
      case 0 : return RepeatRule.None;
      case 1 : return RepeatRule.EveryXDays;
      case 2 : return RepeatRule.EveryXWeeks;
      case 3 : return RepeatRule.EveryXMonths;
      default: return RepeatRule.None;
    }
  }


  bool isOnDates(BuildContext context,List<DateTime> forDays){
    print("isondates m");

    bool isOnDates = false;

    if(startTime==null){
      forDays.forEach((element) {
        if(element==null){
          isOnDates=true;
        }
      });
      return isOnDates;
    }

    forDays.remove(null);
    if(forDays.length==0)return false;

    if(repeatRule==RepeatRule.None){
      forDays.forEach((element) {
        if(areDatesOnTheSameDay(element, startTime)){
          isOnDates=true;
        }
      });
      return isOnDates;
    }

    TimeStamp wholeTimeStamp=TimeStamp(
      id: id,
      parentId: parentId,
      color: getParent().color,
      isTask: isParentTask,
      durationInMinutes: durationInMinutes,
      start: startTime,
      title: getParent().name,
      tracked: true,
      parentIndex: 0
    );

    DateTime lastStartTime;

    //while not the first time and the end date is before the days
    while(lastStartTime==null||((DateTime(lastStartTime.year,lastStartTime.month,lastStartTime.day)).isBefore(forDays.last))){

      //if it is not first time then add to the start time the repeat value and the endtime-starttime difference for the purpose
      //of incrementing the date according to the repeat rule
      if(lastStartTime!=null){
        wholeTimeStamp.start=wholeTimeStamp.start.add
          (Duration(days: repeatValue+Duration(minutes: durationInMinutes).inDays));
      }

      //form timestamp then split it
      List<TimeStamp> splittedPlanedTimestamp = wholeTimeStamp.splitTimestampForCalendarSupport();

      //if on date
      splittedPlanedTimestamp.forEach((splittedTimestamp){
        forDays.forEach((forDay){
          if(areDatesOnTheSameDay(splittedTimestamp.start, forDay)){
            isOnDates=true;
          }
        });
      });

      lastStartTime=splittedPlanedTimestamp.last.start;

    }
    return isOnDates;
  }

  List<TimeStamp> getPlanedTimestamps(BuildContext context,List<DateTime> forDays,{bool semiOpacity}){
    if(semiOpacity==null)semiOpacity=false;
    print("getplannedtimestamps m");
    //sort days
//    forDays.sort((a,b) {
//      var adate = a['expiry'] //before -> var adate = a.expiry;
//      var bdate = b['expiry'] //before -> var bdate = b.expiry;
//      return b.compareTo(a); //to get the order other way just switch `adate & bdate`
//    });
    if(durationInMinutes==null||startTime==null)return [];

    List<TimeStamp> toreturn = [];

    switch(repeatRule){
      case RepeatRule.EveryXDays:

        TimeStamp wholeTimeStamp=TimeStamp(
          id: id,
          parentId: parentId,
          isTask: isParentTask,
          color: semiOpacity?getParent().color.withOpacity(.3):getParent().color,
          durationInMinutes: durationInMinutes,
          start: startTime,
          title: getParent().name,
          tracked: false,
          parentIndex: 0
        );

        DateTime lastStartTime;
        //while not the first time and the end date is before the days
        while(lastStartTime==null||DateTime(lastStartTime.year,lastStartTime.month,lastStartTime.day).isBefore(forDays.last)){

          //if it is not first time then add to the start time the repeat value and the endtime-starttime difference for the purpose
          //of incrementing the date according to the repeat rule
          if(lastStartTime!=null){
            wholeTimeStamp.start=wholeTimeStamp.start.add
              (Duration(days: repeatValue+Duration(minutes: durationInMinutes).inDays));
          }

          //form timestamp then split it
          List<TimeStamp> splittedPlanedTimestamp = wholeTimeStamp.splitTimestampForCalendarSupport();

          //if on date
          splittedPlanedTimestamp.forEach((splittedTimestamp){
            forDays.forEach((forDay){
              if(areDatesOnTheSameDay(splittedTimestamp.start, forDay)){
                toreturn.add(splittedTimestamp);
              }
            });
          });

          lastStartTime=splittedPlanedTimestamp.last.start;

        }
        break;
      case RepeatRule.EveryXWeeks:
      // TODO: Handle this case.
        break;
      case RepeatRule.EveryXMonths:
      // TODO: Handle this case.
        break;
      case RepeatRule.None:
      //form timestamp then split it
        List<TimeStamp> splittedPlanedTimestamp =[];
        if(startTime!=null){
          splittedPlanedTimestamp= TimeStamp(
            id: id,
            parentId: parentId,
            isTask: isParentTask,
            color: semiOpacity?getParent().color.withOpacity(.4):getParent().color,
            durationInMinutes: durationInMinutes,
            start: startTime,
            title: getParent().name,
            tracked: false,
            parentIndex: 0
          ).splitTimestampForCalendarSupport();
        }

        //if on date
        splittedPlanedTimestamp.forEach((splittedTimestamp){
          forDays.forEach((forDay){
            if(areDatesOnTheSameDay(splittedTimestamp.start, forDay)){
              toreturn.add(splittedTimestamp);
            }
          });
        });
        break;
    }
    return toreturn;
  }
  getParent(){
    if(isParentTask==null||parentId==null)return null;
    return isParentTask?MyApp.dataModel.findTaskById(parentId):MyApp.dataModel.findActivityById(parentId);

  }



  DateTime getNextStartTime(){
    if(startTime==null)return null;
    switch(repeatRule){

      case RepeatRule.None:
        return startTime.difference(getTodayFormated()).inDays>=0?startTime:null;
        break;
      case RepeatRule.EveryXDays:
        TimeStamp wholeTimeStamp=TimeStamp(
          id: id,
          parentId: parentId,
          isTask: isParentTask,
          color: Colors.white,
          durationInMinutes: durationInMinutes,
          start: startTime,
          title: getParent().name,
          tracked: false,
          parentIndex: 0
        );

        DateTime lastStartTime;
        //while not the first time and the end date is before the days
        while(lastStartTime==null||DateTime(lastStartTime.year,lastStartTime.month,lastStartTime.day).isBefore(getTodayFormated())){

          //if it is not first time then add to the start time the repeat value and the endtime-starttime difference for the purpose
          //of incrementing the date according to the repeat rule
          if(lastStartTime!=null){
            wholeTimeStamp.start=wholeTimeStamp.start.
              add(Duration(days: repeatValue+Duration(minutes: durationInMinutes).inDays));
          }

          //form timestamp then split it
          List<TimeStamp> splittedPlanedTimestamp = wholeTimeStamp.splitTimestampForCalendarSupport();

          lastStartTime=splittedPlanedTimestamp.last.start;

        }
        return wholeTimeStamp.start;
        break;
      case RepeatRule.EveryXWeeks:
        // TODO: Handle this case.
        break;
      case RepeatRule.EveryXMonths:
        // TODO: Handle this case.
        break;
    }
    return null;
  }


  DateTime getCurrentStartTime(){
    if(startTime==null)return null;
    switch(repeatRule){

      case RepeatRule.None:
        startTime.difference(getTodayFormated()).inDays>=0?startTime:null;
        break;
      case RepeatRule.EveryXDays:
        TimeStamp wholeTimeStamp=TimeStamp(
          id: id,
          parentId: parentId,
          isTask: isParentTask,
          color: Colors.white,
          durationInMinutes: durationInMinutes,
          start: startTime,
          title: getParent().name,
          tracked: false,
          parentIndex: 0
        );

        DateTime lastStartTime;
        //while not the first time and the end date is before the days
        while(lastStartTime==null||DateTime(lastStartTime.year,lastStartTime.month,lastStartTime.day).isBefore(getTodayFormated())){

          //if it is not first time then add to the start time the repeat value and the endtime-starttime difference for the purpose
          //of incrementing the date according to the repeat rule
          if(lastStartTime!=null){
            wholeTimeStamp.start=
                wholeTimeStamp.start.
                add(Duration(days: repeatValue+Duration(minutes: durationInMinutes).inDays));
          }

          //form timestamp then split it
          List<TimeStamp> splittedPlanedTimestamp = wholeTimeStamp.splitTimestampForCalendarSupport();

          lastStartTime=splittedPlanedTimestamp.last.start;

        }
        return wholeTimeStamp.start.subtract(Duration(days: repeatValue+
            Duration(minutes: durationInMinutes).inDays));
        break;
      case RepeatRule.EveryXWeeks:
      // TODO: Handle this case.
        break;
      case RepeatRule.EveryXMonths:
      // TODO: Handle this case.
        break;
    }
    return null;
  }




  int getStartMinuteOfTheDay(DateTime forThisDate){
    return (startTime.hour * 60) + startTime.minute;
  }

  isOverdue() {
    if(startTime==null)return false;
    return getEndTime().isBefore(getTodayFormated());
  }

  getColor() {
    final parent = getParent();
    if(parent==null){
      return Colors.red;
    }else return parent.color;
  }

}