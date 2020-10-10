
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';


final String activityId = 'eid';
final String activityName = 'en';
final String activityIcon = 'eic';
final String activityTags = 'eta';
final String activityColor = 'ec';
final String activityTrackedStart = 'ets';
final String activityTrackedEnd = 'ete';
final String activityParentCalendarId = 'ep';
final String activityDescription = 'ede';
final String activityValue = 'ev';
final String activityBlacklistedDates = 'bd';
final String activityValueMultiply = 'evm';



class Activity {

  int id;
  String name;
  Color color;
  IconData icon;
  List<int> tags;

  List<DateTime> trackedStart;
  List<DateTime> trackedEnd;

  int parentCalendarId;
  String description;

  int value;
  bool valueMultiply;

  List<DateTime> blacklistedDates;


  Activity({ this.id, @required this.name,@required this.trackedStart,@required this.trackedEnd,
    @required this.parentCalendarId,this.description,@required this.value,
    this.color,@required this.valueMultiply,this.icon,@required this.tags,this.blacklistedDates});

  List<Scheduled> _scheduled = [];

  List<Scheduled> getScheduled(BuildContext context){
    if(_scheduled.length==0){
      List<Scheduled>  toreturn = [];
      MyApp.dataModel.scheduleds.forEach((element) {
        if((!element.isParentTask)&&(element.parentId==id)){
          toreturn.add(element);
        }
      });
      if(toreturn.length==0){
        Scheduled scheduled = Scheduled(
          durationInMins: 30,
          repeatValue: 0,
          repeatRule: RepeatRule.None,
          isParentTask: false,
          parentId: id,
        );
        MyApp.dataModel.scheduled(0,scheduled,context,CUD.Create);
        toreturn.add(scheduled);
      }
      _scheduled=toreturn;
    }
    return _scheduled;
  }

  insertSchedule({@required DateTime startTime,@required DateTime repeatUntil,@required RepeatRule repeatRule,
    @required int repeatValue,@required int durationInMins}){

    MyApp.dataModel.databaseHelper.insertScheduled(Scheduled(
      isParentTask: false,
      parentId: id,
      durationInMins: durationInMins,
      repeatRule: repeatRule,
      repeatValue: repeatValue,
      startTime: startTime,
      repeatUntil: repeatUntil,
    ));
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
    };
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
    );
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

  List<TimeStamp> getTrackedTimestamps(BuildContext context,List<DateTime> forDates,{bool dontCompleteActives}){
    List<TimeStamp> toreturn = [];

    if(dontCompleteActives==null)dontCompleteActives=false;

    for(int i = 0; i<trackedStart.length;i++){
        List<TimeStamp> splittedPlanedTimestamp = TimeStamp(
          parentId: id,
          isTask: false,
          color: color,
          duration: (((trackedStart.length!=trackedEnd.length)&&(i==(trackedStart.length-1)))?getTodayFormated():trackedEnd[i]).difference(trackedStart[i]).inMinutes,
          startTime: trackedStart[i],
          name: name,
          tracked: true,
          parentIndex: i
        ).splitTimestampForCalendarSupport();

        //if on date
        splittedPlanedTimestamp.forEach((splittedTimestamp){
          if(forDates==null){
            toreturn.add(splittedTimestamp);
          }else{
            forDates.forEach((forDay){
              if(areDatesOnTheSameDay(splittedTimestamp.startTime, forDay)){
                toreturn.add(splittedTimestamp);
              }
            });
          }
        });
    }

    return toreturn;
  }

}
