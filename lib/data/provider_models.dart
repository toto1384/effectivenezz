

import 'dart:io';

import 'package:effectivenezz/data/backend.dart';
import 'package:effectivenezz/data/database_helper.dart';
import 'package:effectivenezz/data/notifications.dart';
import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/calendar.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/tag.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:neat_periodic_task/neat_periodic_task.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import 'database.dart';
import 'package:flutter/services.dart';

class DataModel{

  static const platform = const MethodChannel('flutter.native/helper');

  double screenWidth=400;


  DatabaseHelper databaseHelper;
  Backend backend;
  NotificationHelper notificationHelper;

  dynamic currentPlaying;

  List<Activity> activities =[];
  List<ECalendar> eCalendars = [];
  List<Task> tasks = [];
  List<Scheduled> scheduleds = [];
  List<Tag> tags = [];

  static Future<DataModel> init(BuildContext context)async{
    DataModel dataModel = DataModel();
    print(1);
    if(!kIsWeb)dataModel.databaseHelper=await MobileDB.getDatabase(context);
    print(3);
    dataModel.backend = await Backend.initBackend(context,);
    print(5);
    if(dataModel.backend.auth_token!=null){
      dataModel.scheduleds= await dataModel.backend.scheduled(context,RequestType.Query);
      dataModel.tasks=await dataModel.backend.task(context,RequestType.Query);
      dataModel.activities = await dataModel.backend.activity(context,RequestType.Query);
      dataModel.tasks.forEach((element) {
        if(!element.isParentCalendar){
          dataModel.activities.forEach((act) {
            if(act.id==element.parentId){
              act.childs.add(element);
            }
          });
        }
      });
      dataModel.eCalendars = await dataModel.backend.calendar(context,RequestType.Query);
      dataModel.tags=await dataModel.backend.tag(context,RequestType.Query);
      print(6);
      dataModel.populatePlaying();
      print(7);
      if(!kIsWeb)dataModel.initNotificationsWithCorrectContext(context);

      if(!kIsWeb)dataModel.scheduleEveryDay(context);
    }

    if(!kIsWeb)dataModel.setupDrift();

    print(10);
    return dataModel;
  }

  setupDrift()async{
    if(!kIsWeb){
      if(backend.driveHelper.currentUser!=null){
        platform.invokeMethod('setupDrift',{
          "id":backend.driveHelper.currentUser.id,
          "email":backend.driveHelper.currentUser.email
        });
      }
    }
  }

  launchFeedback(BuildContext context){
    if(backend.driveHelper.currentUser!=null){
      platform.invokeMethod('showConversationActivity',);
    }
  }

  scheduleEveryDay(BuildContext context)async{

    final scheduler = NeatPeriodicTaskScheduler(
      interval: Duration(days: 1),
      name: 'daily_fetch',
      timeout: Duration(seconds: 5),
      task: () async => scheduleNotifications(context,this),
      minCycle: Duration(hours: 1),
    );

    scheduler.start();
    await ProcessSignal.sigterm.watch().first;
    await scheduler.stop();

  }

  findObjectColorByName(String name){
    Color color = Colors.blue;
    activities.forEach((element) {
      if(element.name==name){
        color=element.color;
      }
    });
    tasks.forEach((element) {
      if(element.name==name){
        color=element.color;
      }
    });
    return color;
  }

  static scheduleNotifications(BuildContext context, DataModel dataModel)async{
    if(dataModel==null){
      dataModel=await DataModel.init(context);
    }
    List<PendingNotificationRequest> pendingReq =
      await dataModel.notificationHelper.flutterLocalNotificationsPlugin.pendingNotificationRequests();
    List<int> ids = List.generate(pendingReq.length, (index) => pendingReq[index].id);

    dataModel.scheduleds.forEach((element) {
      DateTime nextStartTime = element.getNextStartTime();
      if(nextStartTime!=null&&!ids.contains(100000+stringIdToInt(element.id))){
        dataModel.scheduleNotificationForScheduled(dataModel.notificationHelper,nextStartTime, element);
      }
    });
  }

  static stringIdToInt(String s){
    return Uuid().parse(s).getRange(0, 5).reduce((value, element) => value+element);
  }

  scheduleNotificationForScheduled(NotificationHelper notificationHelper,DateTime dateTime,Scheduled scheduled){
    if(dateTime==null)return;
    notificationHelper.scheduleNotification(id: 100000+stringIdToInt(scheduled.id), title: "Time for ${scheduled.getParent().name}",
        body: "${scheduled.getParent().name} is between ${scheduled.startTime} and "
            "${scheduled.startTime.add(Duration(minutes: scheduled.durationInMinutes??0))}", payload: "sch",
    dateTime: dateTime,color: scheduled.getParent().color);
  }


  initNotificationsWithCorrectContext(BuildContext context)async{
    notificationHelper= await NotificationHelper.init(context);
    notificationHelper.cancelNotification(0);
    if(currentPlaying!=null){
      notificationHelper.displayNotification(
        id: 0,
        title:"'"+ currentPlaying.name+"' is tracked",
        body: "For more info in a popup tap me",
        payload: "tracked",
        color: currentPlaying.color,
        importance: Importance.low,
      );
    }
  }

  populatePlaying(){
    print("populatePlaying m");
    currentPlaying=null;
    tasks.forEach((element) {
      if(element.trackedEnd.length<element.trackedStart.length){
        currentPlaying=element;
      }
    });
    activities.forEach((element) {
      if(element.trackedEnd.length<element.trackedStart.length){
        currentPlaying=element;
      }
    });
  }


  //UNIVERSAL WAY OF POPULATING THE CALENDAR
  List<TimeStamp> getTimeStamps(BuildContext context,{@required List<DateTime> dateTimes,bool tracked,bool plannedSemiOpacity}) {
    print("getTimeStamps m");
    if(plannedSemiOpacity==null)plannedSemiOpacity=false;
    if(tracked==null){
      tracked=false;
    }

    final timestamps = <TimeStamp>[];

    tasks.forEach((item){
      if(item.isParentCalendar){
        if(findECalendarById(item.parentId).show){
          if(tracked){
            timestamps.addAll(item.getTrackedTimestamps(context,dateTimes));
          }else{
            item.getScheduled().forEach((element) {
              timestamps.addAll(element.getPlanedTimestamps(context,dateTimes,semiOpacity: plannedSemiOpacity));
            });
          }
        }
      }
    });

    activities.forEach((item){
      if(findECalendarById(item.parentCalendarId).show){
        if(tracked){
          timestamps.addAll(item.getTrackedTimestamps(context,dateTimes));
        }else{
          item.getScheduled().forEach((element) {
            timestamps.addAll(element.getPlanedTimestamps(context,dateTimes,semiOpacity: plannedSemiOpacity));
          });
        }
      }
    });


    return timestamps;
  }

  setPlaying(BuildContext context,dynamic playing,){
    //stop current either of playing
    if(currentPlaying!=null){
      currentPlaying.trackedEnd.add(getTodayFormated());

      if(currentPlaying.id!="-1"){
        if(currentPlaying is Task){
          task(currentPlaying, context, CUD.Update);
        }else{
          activity(currentPlaying, context, CUD.Update);
        }
      }

      currentPlaying=null;
    }
    //Start playing
    if(playing!=null) {
      playing.trackedStart.add(getTodayFormated());
      if(playing is Activity){
        activity(playing, context, CUD.Update);
      }else if(playing is Task){
        task( playing, context, CUD.Update);
      }
    }


    currentPlaying=playing;
    //notifications
    if(!kIsWeb){
      if(playing==null){
        notificationHelper.cancelNotification(0);
      }else{
        notificationHelper.displayNotification(
          id: 0,
          title: playing.name,
          body: "For more info in a popup tap me",
          payload: "tracked",
          color: playing.color,
        );
      }
    }
    MyAppState.ss(context);
  }


  isEmpty(){
    if(tasks.length==0&&activities.length==0)return true;
    return false;
  }


  //SIMPLIFIED CRUD METHODS
  task(Task event,BuildContext context,CUD cud,{bool withScheduleds,})async{
    print("task m");
    if(withScheduleds==null){
      withScheduleds=false;
    }

    switch(cud){
      case CUD.Create:
        event.id = (await backend.task(context,RequestType.Post,task: event)).first.id;
        tasks.add(event);
        DistivityPageState.listCallback.notifyAdd(event);
        if(!kIsWeb)await databaseHelper.insertTask(event);
        break;
      case CUD.Update:
        tasks[findObjectIndexById(event)]=event;
        DistivityPageState.listCallback.notifyUpdated(event);
        if(!kIsWeb)await databaseHelper.updateTask(event);
        await backend.task(context,RequestType.Update,task: event,);
        break;
      case CUD.Delete:
        if(!event.isParentCalendar){
          for(int i = 0 ; i<activities.length;i++){
            if(activities[i].id==event.parentId){
              activities[i].childs.remove(event);
            }
          }
        }
        if(currentPlaying!=null){
          if(event.id==currentPlaying.id){
            setPlaying(context, null);
          }
        }
        tasks.remove(event);
        DistivityPageState.listCallback.notifyRemoved(event);
        if(!kIsWeb)await databaseHelper.deleteTask(event.id);
        if(withScheduleds){
          event.getScheduled().forEach((element) async{
            await scheduled(element, context, cud,event.id);
          });
        }
        await backend.task(context,RequestType.Delete,task: event);
        break;
    }
    MyAppState.ss(context);
  }

  activity(Activity event,BuildContext context,CUD cud,{bool withScheduleds,})async{
    print("activity m");
    if(withScheduleds==null)withScheduleds=false;
    switch(cud){
      case CUD.Create:
        event.id = (await backend.activity(context,RequestType.Post,activity: event)).first.id;
        activities.add(event);
        DistivityPageState.listCallback.notifyAdd(event);
        if(!kIsWeb)await databaseHelper.insertActivity(event);
        break;
      case CUD.Update:
        activities[findObjectIndexById(event)]=event;
        DistivityPageState.listCallback.notifyUpdated(event);
        if(!kIsWeb)await databaseHelper.updateActivity(event);
        await backend.activity(context,RequestType.Update,activity: event,);
        break;
      case CUD.Delete:
        for(int i = 0 ; i<tasks.length ; i++){
          if(tasks[i].parentId==event.id&&!tasks[i].isParentCalendar){
            task(tasks[i], context, CUD.Delete);
          }
        }
        activities.remove(event);
        if(currentPlaying!=null){
          if(event.id==currentPlaying.id){
            setPlaying(context, null);
          }
        }
        DistivityPageState.listCallback.notifyRemoved(event);
        if(!kIsWeb)await databaseHelper.deleteActivity(event.id);
        if(withScheduleds){
          event.getScheduled().forEach((element) async{
            await scheduled(element, context, cud,event.id);
          });
        }
        await backend.activity(context,RequestType.Delete,activity: event);
        break;
    }
    MyAppState.ss(context);
  }

  eCalendar(int index,ECalendar eCalendar,BuildContext context,CUD cud)async{
    switch(cud){

      case CUD.Create:
        eCalendar.id = (await backend.calendar(context,RequestType.Post,calendar: eCalendar)).first.id;
        eCalendars.add(eCalendar);
        DistivityPageState.listCallback.notifyAdd(null);
        if(!kIsWeb)await databaseHelper.insertECalendar(eCalendar);
        break;
      case CUD.Update:
        eCalendars[index]=eCalendar;
        DistivityPageState.listCallback.notifyUpdated(null);
        if(!kIsWeb)await databaseHelper.updateECalendar(eCalendar);
        await backend.calendar(context,RequestType.Update,calendar: eCalendar,);
        break;
      case CUD.Delete:
        for(int i = 0 ; i<tasks.length ; i++){
          if(tasks[i].parentId==eCalendar.id&&tasks[i].isParentCalendar){
            task(tasks[i], context, CUD.Delete);
          }
        }
        for(int i = 0 ; i<activities.length ; i++){
          if(activities[i].parentCalendarId==eCalendar.id){
            activity(activities[i], context, CUD.Delete);
          }
        }
        eCalendars.removeAt(index);
        DistivityPageState.listCallback.notifyRemoved(null);
        if(!kIsWeb)await databaseHelper.deleteECalendar(eCalendar.id);
        await backend.calendar(context,RequestType.Delete,calendar: eCalendar);
        break;
    }
  }

  //SIMPLIFIED CRUD METHODS
  scheduled(Scheduled event,BuildContext context,CUD cud,String parentId)async{
    switch(cud){
      case CUD.Create:
        event.id = (await backend.scheduled(context,RequestType.Post,scheduled: event,parentId: parentId)).first.id;
        scheduleds.add(event);
        if(!kIsWeb)await databaseHelper.insertScheduled(event);
        if(!kIsWeb)scheduleNotificationForScheduled(notificationHelper,
            event.getNextStartTime(), event);
        break;
      case CUD.Update:
        scheduleds[findObjectIndexById(event)]=event;
        if(!kIsWeb)await databaseHelper.updateScheduled(event);
        if(!kIsWeb)notificationHelper.cancelNotification(100000+stringIdToInt(event.id));
        if(!kIsWeb)scheduleNotificationForScheduled(notificationHelper,
            event.getNextStartTime(), event);
        await backend.scheduled(context,RequestType.Update,scheduled: event,);
        break;
      case CUD.Delete:
        scheduleds.remove(event);
        if(!kIsWeb)await databaseHelper.deleteScheduled(event.id);
        if(!kIsWeb)notificationHelper.cancelNotification(100000+stringIdToInt(event.id));
        await backend.scheduled(context,RequestType.Delete,scheduled: event);
        break;
    }
    DistivityPageState.listCallback.notifyUpdated(null);
    MyAppState.ss(context);
  }

  //SIMPLIFIED CRUD METHODS
  tag(Tag event,BuildContext context,CUD cud,)async{
    switch(cud){
      case CUD.Create:
        event.id = (await backend.tag(context,RequestType.Post,tag: event)).first.id;
        tags.add(event);
        if(!kIsWeb)await databaseHelper.insertTag(event);
        break;
      case CUD.Update:
        tags[findObjectIndexById(event)]=event;
        if(!kIsWeb)await databaseHelper.updateTag(event);
        await backend.tag(context,RequestType.Update,tag: event,);
        break;
      case CUD.Delete:
        tags.remove(event);
        if(!kIsWeb)await databaseHelper.deleteTag(event.id);
        await backend.tag(context,RequestType.Delete,tag: event);
        break;
    }
    MyAppState.ss(context);
  }


  //FIND METHODS
  Color findParentColor(dynamic task){
    if(task is Task){
      if(task.parentId=="-1"){
        return Colors.white;
      }
      return task.isParentCalendar?findECalendarById(task.parentId).color:findActivityById(task.parentId).color;
    }else if(task is Activity){
      if(task.parentCalendarId=="-1"){
        return Colors.white;
      }
      return findECalendarById(task.parentCalendarId).color;
    }
    return Colors.blueGrey;
  }

  String findParentName(dynamic  task){
    if(task is Task){
      if(task.parentId=="-1"){
        return "No parent";
      }
      return task.isParentCalendar?findECalendarById(task.parentId).name:findActivityById(task.parentId).name;
    }else if(task is Activity){
      if(task.parentCalendarId=="-1"){
        return "No parent";
      }
      return findECalendarById(task.parentCalendarId).name;
    }
    return 'No Parent';
  }

  //FIND BY PARENT
  List<Task> findTasksByCalendar(String calendarId){
    print("findtasksbycalendar m");
    List<Task> toreturn  = [];

    if(calendarId==null){
      calendarId="-1";
    }

    tasks.forEach((item){
      if(calendarId==-1){
        if(item.isParentCalendar==false){
          toreturn.add(item);
        }else if(item.parentId==-1){
          toreturn.add(item);
        }
      }else if(item.parentId==calendarId&&item.isParentCalendar){
        toreturn.add(item);
      }
    });

    return toreturn;

  }

  List<Activity> findActivitiesByCalendar(String calendarId){
    print("findactivitiesbycalendar m");
    List<Activity> toreturn = [];

    if(calendarId==null){
      calendarId="-1";
    }

    activities.forEach((item){
      if(item.parentCalendarId==calendarId){
        toreturn..add(item);
      }
    });
    return toreturn;
  }


  //FIND BY ID
  Activity findActivityById(String id){
    print("findactivitybyid m");
    Activity activity = Activity(
      color: Colors.white,
      tags: [],
      trackedEnd: [],
      trackedStart: [],
      value: 0,
      name: 'No activity',
      valueMultiply: false,
      parentCalendarId: "-1",
      id: "-1",schedules: []
    );

    activities.forEach((item){
      if(item.id==id){
        activity=item;
      }
    });

    return activity;

  }

  ECalendar findECalendarById(String id){
    print("findecalendarbyid m");
    ECalendar toreturn = ECalendar(name: 'Nothing', color: Colors.transparent,show: true, value: 0);
    eCalendars.forEach((item){
      if(item.id==id){
        toreturn=item;
      }
    });
    return toreturn;
  }

  Task findTaskById(String id){
    print("findtaskbyid m");
    Task toreturn = Task(
      color: Colors.white,
      tags: [],
      trackedEnd: [],
      trackedStart: [],
      value: 0,
      name: '',
      parentId: "-1",
      checks: [],
      isParentCalendar: false,
      valueMultiply: false,
      id: "-1",
      schedules: []
    );
    tasks.forEach((item){
      if(item.id==id){
        toreturn= item;
      }
    });
    return toreturn;
  }

  int findObjectIndexById(dynamic object){
    List objects = (object is Task)?tasks:(object is Activity)?activities:(object is ECalendar)?eCalendars:(object is Tag)?tags:scheduleds;
    int toreturn = -1;
    for(int i = 0; i<objects.length;i++){
      if(objects[i].id==object.id){
        toreturn=i;
      }
    }
    return toreturn;
  }

  void addMinutesToPlaying(BuildContext context, int i) {
    if(currentPlaying==null){

    }else if(currentPlaying is Activity){
      //activity is playing
      currentPlaying.trackedStart.last=currentPlaying.trackedStart.last.subtract(Duration(minutes: i));
      activity(currentPlaying, context, CUD.Update);
    }else if(currentPlaying is Task){
      currentPlaying.trackedStart.last=currentPlaying.trackedStart.last.subtract(Duration(minutes: i));
      task(currentPlaying, context, CUD.Update);
    }
  }

  isPlaying(dynamic object){
    if(currentPlaying==null)return false;
    if(currentPlaying.id==object.id)return true;
    return false;
  }

  Map<String,List<Map>> toDriveData(){
    Map<String,List<Map>> driveData = Map();

    driveData[0.toString()] = activities.map((e) => Map.from(e.toMap())).toList();
    driveData[1.toString()] = tasks.map((e) => Map.from(e.toMap())).toList();
    driveData[2.toString()] = (eCalendars.map((e) => e.toMap())).toList();
    driveData[3.toString()] = scheduleds.map((e) => e.toMap()).toList();
    driveData[4.toString()] = tags.map((e) => e.toMap()).toList();

    return driveData;
  }

  saveFromDriveData(Map<String,List<Map>> data){
    activities=data[0.toString()].map((e) => Activity.fromMap(e));
    tasks=data["1"].map((e) => Task.fromMap(e));
    eCalendars=data["2"].map((e) => ECalendar.fromMap(e));
    scheduleds=data["3"].map((e) => Scheduled.fromMap(e));
    tags=data["4"].map((e) => Tag.fromMap(e));
  }

}