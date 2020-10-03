import 'dart:io';

import 'package:effectivenezz/data/database_helper.dart';
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/calendar.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/tag.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_restart_widget.dart';
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