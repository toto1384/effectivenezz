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

  Future<String> insertTask(Task task,);
  Future<String> insertActivity(Activity activity,);
  Future<String> insertECalendar(ECalendar eCalendar);
  Future<String> insertScheduled(Scheduled scheduled);
  Future<String> insertTag(Tag tag);

  Future<int> updateTask(Task task);
  Future<int> updateActivity(Activity activity);
  Future<int> updateECalendar(ECalendar eCalendar);
  Future<int> updateScheduled(Scheduled scheduled);
  Future<int> updateTag(Tag tag);

  Future<int> deleteTask(String taskId);
  Future<int> deleteActivity(String activityId);
  Future<int> deleteECalendar(String eCalendarId);
  Future<int> deleteScheduled(String scheduledId);
  Future<int> deleteTag(String tagId);

  Future saveFromDriveData(Map<String,List> data);

  Future deleteEveryThing();

}