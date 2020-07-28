

import 'dart:io';

import 'package:effectivenezz/data/notifications.dart';
import 'package:effectivenezz/data/web_db.dart';
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

import '../main.dart';
import 'database.dart';
import 'database_helper.dart';
import 'google_drive.dart';
import 'prefs.dart';
import 'package:flutter/services.dart';
import 'package:effectivenezz/ui/pages/welcome_page.dart';
import 'package:effectivenezz/utils/basic/utils.dart';

class DataModel{

  static const platform = const MethodChannel('flutter.native/helper');

  DatabaseHelper databaseHelper;

  double screenWidth=400;

  Prefs prefs;
  DriveHelper driveHelper;
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
    dataModel.screenWidth=MediaQuery.of(context).size.width;
    dataModel.databaseHelper = (kIsWeb?WebDb():await MobileDB.getDatabase(context));
    dataModel.prefs = await Prefs.getInstance();
    print(2);
    dataModel.driveHelper= await DriveHelper.init(context);
    print(3);
    dataModel.scheduleds= await dataModel.databaseHelper.queryAllScheduled();
    dataModel.tasks=await dataModel.databaseHelper.queryAllTasks();
    dataModel.activities = await dataModel.databaseHelper.queryAllActivities();
    dataModel.eCalendars = await dataModel.databaseHelper.queryAllECalendars();
    dataModel.tags=await dataModel.databaseHelper.queryAllTags();
    print(4);
    dataModel.populatePlaying();
    print(5);
    if(!kIsWeb)dataModel.initNotificationsWithCorrectContext(context);
    print(6);

    if(!kIsWeb)dataModel.scheduleEveryDay(context);
    print(7);

    if(!kIsWeb)dataModel.setupDrift();
    print(8);


    return dataModel;
  }

  setupDrift()async{
    if(!kIsWeb){
      if(driveHelper.currentUser!=null){
        platform.invokeMethod('setupDrift',{
          "id":driveHelper.currentUser.id,
          "email":driveHelper.currentUser.email
        });
      }
    }
  }

  launchFeedback(BuildContext context){
    if(driveHelper.currentUser!=null){
      platform.invokeMethod('showConversationActivity',);
    }else{
      launchPage(context,WelcomePage(driveHelper));
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
      if(nextStartTime!=null&&!ids.contains(100000+element.id)){
        dataModel.scheduleNotificationForScheduled(dataModel.notificationHelper,nextStartTime, element);
      }
    });
  }

  scheduleNotificationForScheduled(NotificationHelper notificationHelper,DateTime dateTime,Scheduled scheduled){
    if(dateTime==null)return;
    notificationHelper.scheduleNotification(id: 100000+scheduled.id, title: "Time for ${scheduled.getParent().name}",
        body: "${scheduled.getParent().name} is between ${scheduled.startTime} and "
            "${scheduled.startTime.add(Duration(minutes: scheduled.durationInMins))}", payload: "sch",importance: Importance.Max,
    dateTime: dateTime,permanent: false,color: scheduled.getParent().color);
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
        importance: Importance.Low,
      );
    }
  }

  populatePlaying(){
    print("populatePlaying m");
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
      if(tracked){
        timestamps.addAll(item.getTrackedTimestamps(context,dateTimes));
      }else{
        timestamps.addAll(item.getScheduled(context)[0].getPlanedTimestamps(context,dateTimes,semiOpacity: plannedSemiOpacity));
      }
    });

    activities.forEach((item){
      if(tracked){
        timestamps.addAll(item.getTrackedTimestamps(context,dateTimes));
      }else{
        timestamps.addAll(item.getScheduled(context)[0].getPlanedTimestamps(context,dateTimes,semiOpacity: plannedSemiOpacity));
      }
    });


    return timestamps;
  }

  setPlaying(BuildContext context,dynamic playing,){
    //stop current either of playing
    if(currentPlaying!=null){
      currentPlaying.trackedEnd.add(getTodayFormated());

      if(currentPlaying.id>0){
        if(currentPlaying is Task){
          task(findObjectIndexById(currentPlaying), currentPlaying, context, CUD.Update);
        }else{
          activity(findObjectIndexById(currentPlaying), currentPlaying, context, CUD.Update);
        }
      }

      currentPlaying=null;
    }
    //Start playing
    if(playing!=null) {
      playing.trackedStart.add(getTodayFormated());
      if(playing is Activity){
        activity(findObjectIndexById(playing), playing, context, CUD.Update);
      }else if(playing is Task){
        task(findObjectIndexById(playing), playing, context, CUD.Update);
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
  task(int index,Task event,BuildContext context,CUD cud,{bool withScheduleds,Scheduled addWith})async{
    print("task m");
    if(withScheduleds==null){
      withScheduleds=false;
    }

    switch(cud){
      case CUD.Create:
        tasks.add(event);
        int addedId =await databaseHelper.insertTask(event);
        tasks[tasks.length-1].id=addedId;
        if(addWith!=null){
          addWith.parentId=addedId;
          await scheduled(0, addWith, context, cud);
        }
        DistivityPageState.listCallback.notifyAdd(event);
        break;
      case CUD.Update:
        tasks[index]=event;
        await databaseHelper.updateTask(event);
        if(addWith!=null){
          await scheduled(findObjectIndexById(addWith), addWith, context, cud);
        }
        DistivityPageState.listCallback.notifyUpdated(event);
        break;
      case CUD.Delete:
        tasks.remove(event);
        if(event.id==currentPlaying.id){
          setPlaying(context, null);
        }
        await databaseHelper.deleteTask(event.id);
        if(withScheduleds){
          event.getScheduled(context).forEach((element) async{
            await scheduled(scheduleds.indexOf(element), element, context, cud);
          });
        }
        DistivityPageState.listCallback.notifyRemoved(event);
        break;
    }
    MyAppState.ss(context);
  }

  activity(int index,Activity event,BuildContext context,CUD cud,{bool withScheduleds,Scheduled addWith})async{
    print("activity m");
    if(withScheduleds==null)withScheduleds=false;
    switch(cud){
      case CUD.Create:
        activities.add(event);
        print(1);
        int addedId = await databaseHelper.insertActivity(event);
        print(2);
        activities[activities.length-1].id= addedId;
        print(3);
        if(addWith!=null){
          addWith.parentId=addedId;
          print(4);
          await scheduled(0, addWith, context, cud);
          print(5);
        }
        DistivityPageState.listCallback.notifyAdd(event);
        break;
      case CUD.Update:
        activities[index]=event;
        await databaseHelper.updateActivity(event);
        if(addWith!=null){
          await scheduled(findObjectIndexById(addWith), addWith, context, cud);
        }
        DistivityPageState.listCallback.notifyUpdated(event);
        break;
      case CUD.Delete:
        for(int i = 0 ; i<tasks.length ; i++){
          if(tasks[i].parentId==event.id&&!tasks[i].isParentCalendar){
            task(i, tasks[i], context, CUD.Delete);
          }
        }
        activities.remove(event);
        if(event.id==currentPlaying.id){
          setPlaying(context, null);
        }
        await databaseHelper.deleteActivity(event.id);
        if(withScheduleds){
          event.getScheduled(context).forEach((element) async{
            await scheduled(scheduleds.indexOf(element), element, context, cud);
          });
        }
        DistivityPageState.listCallback.notifyRemoved(event);
        break;
    }
    MyAppState.ss(context);
  }

  eCalendar(int index,ECalendar eCalendar,BuildContext context,CUD cud)async{
    switch(cud){

      case CUD.Create:
        eCalendars.add(eCalendar);
        eCalendars[eCalendars.length-1].id= await databaseHelper.insertECalendar(eCalendar);
        break;
      case CUD.Update:
        eCalendars[index]=eCalendar;
        await databaseHelper.updateECalendar(eCalendar);
        break;
      case CUD.Delete:
        for(int i = 0 ; i<tasks.length ; i++){
          if(tasks[i].parentId==eCalendar.id&&tasks[i].isParentCalendar){
            task(i, tasks[i], context, CUD.Delete);
          }
        }
        for(int i = 0 ; i<activities.length ; i++){
          if(activities[i].parentCalendarId==eCalendar.id){
            activity(i, activities[i], context, CUD.Delete);
          }
        }
        eCalendars.removeAt(index);
        await databaseHelper.deleteECalendar(eCalendar.id);
        break;
    }
    MyAppState.ss(context);
  }

  //SIMPLIFIED CRUD METHODS
  scheduled(int index,Scheduled event,BuildContext context,CUD cud,)async{
    switch(cud){
      case CUD.Create:
        scheduleds.add(event);
        scheduleds[scheduleds.length-1].id=await databaseHelper.insertScheduled(event);
        if(!kIsWeb)scheduleNotificationForScheduled(notificationHelper,event.getNextStartTime(), event);
        break;
      case CUD.Update:
        scheduleds[index]=event;
        await databaseHelper.updateScheduled(event);
        if(!kIsWeb)notificationHelper.cancelNotification(100000+event.id);
        if(!kIsWeb)scheduleNotificationForScheduled(notificationHelper,event.getNextStartTime(), event);
        break;
      case CUD.Delete:
        scheduleds.remove(event);
        await databaseHelper.deleteScheduled(event.id);
        if(!kIsWeb)notificationHelper.cancelNotification(100000+event.id);
        break;
    }
    MyAppState.ss(context);
  }

  //SIMPLIFIED CRUD METHODS
  tag(int index,Tag event,BuildContext context,CUD cud,)async{
    switch(cud){
      case CUD.Create:
        tags.add(event);
        tags[tasks.length-1].id=await databaseHelper.insertTag(event);
        break;
      case CUD.Update:
        tags[index]=event;
        await databaseHelper.updateTag(event);
        break;
      case CUD.Delete:
        tags.remove(event);
        await databaseHelper.deleteTag(event.id);
        break;
    }
    MyAppState.ss(context);
  }


  //FIND METHODS
  Color findParentColor(dynamic task){
    if(task is Task){
      if(task.parentId<0){
        return Colors.white;
      }
      return task.isParentCalendar?findECalendarById(task.parentId).color:findActivityById(task.parentId).color;
    }else if(task is Activity){
      if(task.parentCalendarId<0){
        return Colors.white;
      }
      return findECalendarById(task.parentCalendarId).color;
    }
    return Colors.blueGrey;
  }

  String findParentName(dynamic  task){
    if(task is Task){
      if(task.parentId<0){
        return "No parent";
      }
      return task.isParentCalendar?findECalendarById(task.parentId).name:findActivityById(task.parentId).name;
    }else if(task is Activity){
      if(task.parentCalendarId<0){
        return "No parent";
      }
      return findECalendarById(task.parentCalendarId).name;
    }
    return 'No Parent';
  }

  //FIND BY PARENT
  List<Task> findTasksByCalendar(int calendarId){
    print("findtasksbycalendar m");
    List<Task> toreturn  = [];

    if(calendarId==null){
      calendarId=-1;
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

  List<Activity> findActivitiesByCalendar(int calendarId){
    print("findactivitiesbycalendar m");
    List<Activity> toreturn = [];

    if(calendarId==null){
      calendarId=-1;
    }

    activities.forEach((item){
      if(item.parentCalendarId==calendarId){
        toreturn..add(item);
      }
    });
    return toreturn;
  }


  //FIND BY ID
  Activity findActivityById(int id){
    print("findactivitybyid m");
    Activity activity = Activity(
      color: Colors.white,
      tags: [],
      trackedEnd: [],
      trackedStart: [],
      value: 0,
      name: '',
      valueMultiply: false,
      parentCalendarId: -1,
      id: -1,
    );

    activities.forEach((item){
      if(item.id==id){
        activity=item;
      }
    });

    return activity;

  }

  ECalendar findECalendarById(int id){
    print("findecalendarbyid m");
    ECalendar toreturn = ECalendar(name: 'Nothing', color: Colors.transparent,show: true,parentId: -1,themesEnd: [],themesStart: [],value: 0);
    eCalendars.forEach((item){
      if(item.id==id){
        toreturn=item;
      }
    });
    return toreturn;
  }

  Task findTaskById(int id){
    print("findtaskbyid m");
    Task toreturn = Task(
      color: Colors.white,
      tags: [],
      trackedEnd: [],
      trackedStart: [],
      value: 0,
      name: '',
      parentId: 0,
      checks: [],
      isParentCalendar: false,
      valueMultiply: false,
      id: -1,
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
      activity(findObjectIndexById(currentPlaying), currentPlaying, context, CUD.Update);
    }else if(currentPlaying is Task){
      currentPlaying.trackedStart.last=currentPlaying.trackedStart.last.subtract(Duration(minutes: i));
      task(findObjectIndexById(currentPlaying), currentPlaying, context, CUD.Update);
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