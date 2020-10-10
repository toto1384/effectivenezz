import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/calendar.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/tag.dart';
import 'package:effectivenezz/objects/task.dart';
import 'dart:async';

abstract class DatabaseHelper{


  Future<List<Scheduled>> queryAllScheduled();
  Future<List<Activity>> queryAllActivities();
  Future<List<Task>> queryAllTasks();
  Future<List<ECalendar>> queryAllECalendars();
  Future<List<Tag>> queryAllTags();

  Future<int> insertTask(Task task,{List<Scheduled> scheduleds});
  Future<int> insertActivity(Activity activity,{List<Scheduled> scheduleds});
  Future<int> insertECalendar(ECalendar eCalendar);
  Future<int> insertScheduled(Scheduled scheduled);
  Future<int> insertTag(Tag tag);

  Future<int> updateTask(Task task);
  Future<int> updateActivity(Activity activity);
  Future<int> updateECalendar(ECalendar eCalendar);
  Future<int> updateScheduled(Scheduled scheduled);
  Future<int> updateTag(Tag tag);

  Future<int> deleteTask(int taskId);
  Future<int> deleteActivity(int activityId);
  Future<int> deleteECalendar(int eCalendarId);
  Future<int> deleteScheduled(int scheduledId);
  Future<int> deleteTag(int tagId);

  Future saveFromDriveData(Map<String,List> data);

  Future deleteEveryThing();

}