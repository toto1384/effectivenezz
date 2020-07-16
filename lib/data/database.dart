import 'dart:io';

import 'package:effectivenezz/data/database_helper.dart';
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/calendar.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/tag.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/widgets/distivity_restart_widget.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class MobileDB extends DatabaseHelper{
  
  static final dataBaseName = "CalendarDatabase.db";

  static final taskTable='taskTable';
  static final activityTable = 'activityTable';
  static final calendarTable = 'calendarTable';
  static final scheduledTable = 'scheduledTable';
  static final tagsTable = 'tagsTable';

  static final _databaseVersion = 1;

  Database _database;

  static MobileDB _databaseHelper;

  static Future<MobileDB> getDatabase(BuildContext context)async {
    if(_databaseHelper==null){
      _databaseHelper = MobileDB();
    }
    if (_databaseHelper._database != null) return _databaseHelper;
    _databaseHelper._database = await _databaseHelper._initDatabase(context);
    return _databaseHelper;
  }
  
  _initDatabase(BuildContext context) async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, dataBaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: (db,ver)=>_onCreate(db,ver,context));
  }

  Future saveFromDriveData(Map<String,List> data)async{
    await _database.delete(activityTable);
    await _database.delete(taskTable);
    await _database.delete(tagsTable);
    await _database.delete(calendarTable);
    await _database.delete(scheduledTable);

    data.forEach((key, value) {
      switch(ObjectType.values[int.parse(key)]){

        case ObjectType.Activity:
          value.forEach((element) {
            insertActivity(Activity.fromMap(element));
          });
          break;
        case ObjectType.Task:
          value.forEach((element) {
            insertTask(Task.fromMap(element));
          });
          break;
        case ObjectType.Calendar:
          value.forEach((element) {
            insertECalendar(ECalendar.fromMap(element));
          });
          break;
        case ObjectType.Scheduled:
          value.forEach((element) {
            insertScheduled(Scheduled.fromMap(element));
          });
          break;
        case ObjectType.Tag:
          value.forEach((element) {
            insertTag(Tag.fromMap(element));
          });
          break;
      }
    });
  }

  Future _onCreate(Database db, int version,BuildContext context) async {
    await db.execute('''
          CREATE TABLE $taskTable (
            $taskId INTEGER PRIMARY KEY,
            $taskName TEXT NOT NULL,
            $taskChecks TEXT NOT NULL,
            $taskColor INTEGER NOT NULL,
            $taskTrackedStart TEXT NOT NULL,
            $taskTrackedEnd TEXT NOT NULL,
            $taskParentId INTEGER,
            $taskIsParentCalendar INTEGER NOT NULL,
            $taskDescription TEXT,
            $taskValueMultiply INTEGER NOT NULL,
            $taskValue INTEGER NOT NULL,
            $taskTags TEXT NOT NULL,
            $taskBlacklistedDates TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $activityTable (
            $activityId INTEGER PRIMARY KEY,
            $activityName TEXT NOT NULL,
            $activityColor INTEGER NOT NULL,
            $activityTrackedStart TEXT NOT NULL,
            $activityTrackedEnd TEXT NOT NULL,
            $activityParentCalendarId INTEGER,
            $activityDescription TEXT,
            $activityValue INTEGER NOT NULL,
            $activityValueMultiply INTEGER NOT NULL,
            $activityIcon INTEGER,
            $activityTags TEXT NOT NULL,
            $activityBlacklistedDates TEXT
          )
          ''');
    await db.execute('''
          CREATE TABLE $calendarTable (
            $ecalendarId INTEGER PRIMARY KEY,
            $ecalendarName TEXT NOT NULL,
            $ecalendarColor INTEGER NOT NULL,
            $ecalendarDescription TEXT,
            $ecalendarShow INTEGER NOT NULL,
            $ecalendarParentId INTEGER NOT NULL,
            $ecalendarValue INTEGER NOT NULL,
            $ecalendarThemesStart TEXT NOT NULL,
            $ecalendarThemesEnd TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $scheduledTable (
            $scheduledId INTEGER PRIMARY KEY,
            $scheduledParentId INTEGER NOT NULL,
            $scheduledIsParentTask INTEGER NOT NULL,
            $scheduledStartTime TEXT,
            $scheduledDuration INTEGER,
            $scheduledRepeatRule INTEGER NOT NULL,
            $scheduledRepeatValue INTEGER NOT NULL,
            $scheduledRepeatUntil TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE $tagsTable (
            $tagId INTEGER PRIMARY KEY,
            $tagShow INTEGER NOT NULL,
            $tagColor TEXT NOT NULL,
            $tagName TEXT NOT NULL
          )
          ''');
    showYesNoDialog(
        context,
        title: "Let's make it easier for you",
        text: "I know that this app can feel complicated at times and maybe you don\'t know how to use it at it's full potential."+
            " So we decided to help you to populate the app with some generic activities that you might do.",
        onYesPressed: ()async{


          int habitsId=await insertECalendar(ECalendar(
            value: 10000,
            themesEnd: [],
            color: Colors.green,
            name: "Habits",
            parentId: -1,
            show: true,
            themesStart: [],
          ));
          int learnId = await insertECalendar(ECalendar(
              value: 100000,
              themesStart: [],
              show: true,
              parentId: -1,
              name: "Learn",
              color: Colors.yellow,
              themesEnd: []
          ),);
          int workId = await insertECalendar(ECalendar(
            value: 1000,
            themesStart: [],
            show: true,
            parentId: -1,
            name: "Work",
            color: Colors.red,
            themesEnd: [],
          ),);
          int householdId= await insertECalendar(ECalendar(
            themesEnd: [],
            color: Colors.teal,
            name: "Household",
            parentId: -1,
            show: true,
            themesStart: [],
            value: 100,
          ),);
          int socialMediaId = await insertECalendar(ECalendar(
              value: -100,
              themesStart: [],
              show: false,
              parentId: -1,
              name: "Social media",
              color: Colors.blueGrey,
              themesEnd: []
          ),);

          await insertActivity(Activity(
            name: "Meditate",
            value: 10000,
            parentCalendarId: habitsId,
            tags: [],
            trackedEnd: [],
            trackedStart: [],
            valueMultiply: false,
            icon: Icons.favorite,
            color: Colors.green,
          ),scheduleds: [Scheduled(
            startTime: DateTime(getTodayFormated().year,getTodayFormated().month,getTodayFormated().day,7,),
            repeatRule: RepeatRule.EveryXDays,
            repeatValue: 1,
            durationInMins: 10,
            isParentTask: false,
          )]);
          await insertActivity(Activity(
            name: "Exercise",
            value: 10000,
            parentCalendarId: habitsId,
            tags: [],
            trackedEnd: [],
            trackedStart: [],
            valueMultiply: false,
            icon: Icons.fitness_center,
            color: Colors.green,
          ),scheduleds: [Scheduled(
            startTime: DateTime(getTodayFormated().year,getTodayFormated().month,getTodayFormated().day,17,),
            durationInMins: 50,
            repeatRule: RepeatRule.EveryXDays,
            repeatValue: 2,
            isParentTask: false,
          )]);
          await insertActivity(Activity(
            name: "Increase Traffic",
            value: 10000,
            parentCalendarId: workId,
            tags: [],
            trackedEnd: [],
            trackedStart: [],
            valueMultiply: false,
            color: Colors.red,
            icon: Icons.people,
          ),scheduleds: [Scheduled(
            durationInMins: 120,
            repeatRule: RepeatRule.EveryXDays,
            repeatValue: 3,
            isParentTask: false,
            startTime: DateTime(getTodayFormated().year,getTodayFormated().month,getTodayFormated().day,18,),
          )]);
          await insertActivity(Activity(
            name: "Sales work",
            value: 10000,
            parentCalendarId: workId,
            tags: [],
            trackedEnd: [],
            trackedStart: [],
            valueMultiply: false,
            color: Colors.red,
            icon: Icons.people_outline,
          ),scheduleds: [Scheduled(
            repeatRule: RepeatRule.EveryXDays,
            repeatValue: 1,
            durationInMins: 60,
            startTime: DateTime(getTodayFormated().year,getTodayFormated().month,getTodayFormated().day,10,),
            isParentTask: false
          )]);
          await insertActivity(Activity(
            name: "Design",
            value: 10000,
            parentCalendarId: workId,
            tags: [],
            trackedEnd: [],
            trackedStart: [],
            valueMultiply: false,
            color: Colors.red,
            icon: Icons.brush,
          ),scheduleds: [Scheduled(
            repeatRule: RepeatRule.EveryXDays,
            repeatValue: 1,
            durationInMins: 60,
              startTime: DateTime(getTodayFormated().year,getTodayFormated().month,getTodayFormated().day,9,),
            isParentTask: false
          )]);
          await insertTask(Task(
            name: "Read \"The 4 hour work week\"",
            value: 100000,
            parentId: learnId,
            isParentCalendar: true,
            tags: [],
            color: Colors.yellow,
            trackedEnd: [],
            trackedStart: [],
            isValueMultiply: false,
            checks: []
          ),scheduleds: [Scheduled(
            repeatRule: RepeatRule.EveryXDays,
            repeatValue: 1,
            durationInMins: 60,
            isParentTask: true,
            startTime: DateTime(getTodayFormated().year,getTodayFormated().month,getTodayFormated().day,11,),
          )]);
          await insertActivity(Activity(
            name: "Clean house",
            value: 100,
            parentCalendarId: householdId,
            tags: [],
            trackedEnd: [],
            color: Colors.teal,
            trackedStart: [],
            valueMultiply: false,
            icon: Icons.home,
          ),scheduleds: [Scheduled(
            repeatRule: RepeatRule.EveryXDays,
            repeatValue: 7,
            durationInMins: 120,
            isParentTask: false,
            startTime: DateTime(getTodayFormated().year,getTodayFormated().month,getTodayFormated().day,12,),
          )]);
          await insertTask(Task(
            name: "Wash dishes",
            value: 100,
            parentId: householdId,
            tags: [],
            trackedEnd: [],
            color: Colors.teal,
            trackedStart: [],
            isValueMultiply: false,
            checks: [],
            isParentCalendar: true,
          ),scheduleds: [Scheduled(
            repeatRule: RepeatRule.EveryXDays,
            repeatValue: 1,
            durationInMins: 30,
            isParentTask: true,
            startTime: DateTime(getTodayFormated().year,getTodayFormated().month,getTodayFormated().day,15,),
          )]);
          await insertActivity(Activity(
            name: "Unproductive social media",
            value: -100,
            parentCalendarId: socialMediaId,
            tags: [],
            color: Colors.blueGrey,
            trackedEnd: [],
            trackedStart: [],
            valueMultiply: false,
            icon: Icons.close,
          ),scheduleds: [Scheduled(
            repeatRule: RepeatRule.EveryXDays,
            repeatValue: 1,
            durationInMins: 30,
            startTime: DateTime(getTodayFormated().year,getTodayFormated().month,getTodayFormated().day,21,),
            isParentTask: false
          )]);
          await insertActivity(Activity(
            name: "Semi-Productive social media",
            value: 100,
            parentCalendarId: socialMediaId,
            tags: [],
            trackedEnd: [],
            color: Colors.blueGrey,
            trackedStart: [],
            valueMultiply: false,
            icon: Icons.import_contacts,
          ),scheduleds: [Scheduled(
            repeatRule: RepeatRule.EveryXDays,
            repeatValue: 1,
            durationInMins: 60,
            isParentTask: false,
            startTime: DateTime(getTodayFormated().year,getTodayFormated().month,getTodayFormated().day,20,),
          )]);

          DistivityRestartWidget.restartApp(context);
          MyApp.dataModel=null;
        },yesString: "Let\'s go",noString: "No, don\'t populate");
  }
  

  ///////////ACTIVITY
  Future<int> insertActivity(Activity activity,{List<Scheduled> scheduleds}) async {

    int insertActivityId =  await _database.insert(activityTable, activity.toMap());

    if(scheduleds!=null&&scheduleds.length!=0){
      scheduleds.forEach((element) async {
        element.parentId=insertActivityId;
        await insertScheduled(element);
      });
    }
    return insertActivityId;
  }



  Future<List<Activity>> queryAllActivities() async {
    List<Map> items =  await _database.query(activityTable);
    return List.generate(items.length, (index){
      return Activity.fromMap(items[index]);
    });
  }


  Future<int> updateActivity(Activity activity,{List<Scheduled> scheduleds}) async {
    if(scheduleds!=null&&scheduleds.length!=0){
      scheduleds.forEach((element)async {
        await updateScheduled(element);
      });
    }
    return await _database.update(activityTable, activity.toMap(), where: '$activityId = ?', whereArgs: [activity.id]);
  }

  Future<int> deleteActivity(int id,{List<Scheduled> scheduleds}) async {
    if(scheduleds!=null&&scheduleds.length!=0){
      scheduleds.forEach((element) async{
        await deleteScheduled(element.id);
      });
    }

    return await _database.delete(activityTable, where: '$activityId = ?', whereArgs: [id]);
  }
  ////////////////////////////




  /////////////////TASK
  Future<int> insertTask(Task task,{List<Scheduled> scheduleds}) async {

    int taskId =await _database.insert(taskTable, task.toMap());

    if(scheduleds!=null&&scheduleds.length!=0){
      scheduleds.forEach((element) async{
        element.parentId=taskId;
        await insertScheduled(element);
      });
    }

    return taskId;
  }



  Future<List<Task>> queryAllTasks() async {
    List<Map> items =  await _database.query(taskTable);
    return List.generate(items.length, (index){
      return Task.fromMap(items[index]);
    });
  }


  Future<int> updateTask(Task task,{List<Scheduled> scheduleds}) async {

    if(scheduleds!=null&&scheduleds.length!=0){
      scheduleds.forEach((element)async {
        await updateScheduled(element);
      });
    }

    return await _database.update(taskTable, task.toMap(), where: '$taskId = ?', whereArgs: [task.id]);
  }

  Future<int> deleteTask(int id,{List<Scheduled> scheduleds}) async {

    if(scheduleds!=null&&scheduleds.length!=0){
      scheduleds.forEach((element) async{
        await deleteScheduled(element.id);
      });
    }

    return await _database.delete(taskTable, where: '$taskId = ?', whereArgs: [id]);
  }
  ////////////////////////////





  ////////////////CALENDAR


  Future<int> insertECalendar(ECalendar eCalendar) async {
    return await _database.insert(calendarTable, eCalendar.toMap());
  }



  Future<List<ECalendar>> queryAllECalendars() async {
    List<Map> items =  await _database.query(calendarTable);
    return List.generate(items.length, (index){
      return ECalendar.fromMap(items[index]);
    });
  }


  Future<int> updateECalendar(ECalendar eCalendar) async {
    return await _database.update(calendarTable, eCalendar.toMap(), where: '$ecalendarId = ?', whereArgs: [eCalendar.id]);
  }

  Future<int> deleteECalendar(int id) async {
    return await _database.delete(calendarTable, where: '$ecalendarId = ?', whereArgs: [id]);
  }

  ///////////////////////////




  ////////////////SCHEDULED


  Future<int> insertScheduled(Scheduled scheduled) async {
    return await _database.insert(scheduledTable, scheduled.toMap());
  }



  Future<List<Scheduled>> queryAllScheduled() async {
    List<Map> items =  await _database.query(scheduledTable);
    return List.generate(items.length, (index){
      return Scheduled.fromMap(items[index]);
    });
  }


  Future<int> updateScheduled(Scheduled scheduled) async {
    return await _database.update(scheduledTable, scheduled.toMap(), where: '$scheduledId = ?', whereArgs: [scheduled.id]);
  }

  Future<int> deleteScheduled(int id) async {
    return await _database.delete(scheduledTable, where: '$scheduledId = ?', whereArgs: [id]);
  }

///////////////////////////



  ////////////////TAGS


  Future<int> insertTag(Tag tag) async {
    return await _database.insert(tagsTable, tag.toMap());
  }



  Future<List<Tag>> queryAllTags() async {
    List<Map> items =  await _database.query(tagsTable);
    return List.generate(items.length, (index){
      return Tag.fromMap(items[index]);
    });
  }


  Future<int> updateTag(Tag tag) async {
    return await _database.update(tagsTable, tag.toMap(), where: '$tagId = ?', whereArgs: [tag.id]);
  }

  Future<int> deleteTag(int id) async {
    return await _database.delete(tagsTable, where: '$tagId = ?', whereArgs: [id]);
  }

  @override
  Future deleteEveryThing() async{
    await _database.delete(activityTable);
    await _database.delete(taskTable);
    await _database.delete(tagsTable);
    await _database.delete(calendarTable);
    await _database.delete(scheduledTable);
    return Future.value(null);
  }

///////////////////////////
  
}