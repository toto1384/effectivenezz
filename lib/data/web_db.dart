//
//
import 'package:effectivenezz/data/database_helper.dart'; import 'package:effectivenezz/objects/activity.dart'; import 'package:effectivenezz/objects/calendar.dart'; import 'package:effectivenezz/objects/scheduled.dart'; import 'package:effectivenezz/objects/tag.dart'; import 'package:effectivenezz/objects/task.dart'; class WebDb extends DatabaseHelper{@override Future<int> deleteActivity(int activityId) {throw UnimplementedError();}@override Future<int> deleteECalendar(int actiendarId) {throw UnimplementedError();}@override Future<int> deleteScheduled(int actiduledId) {throw UnimplementedError();}@override Future<int> deleteTag(int actid) {throw UnimplementedError();}@override Future<int> deleteTask(int actiId) {throw UnimplementedError();}@override Future<int> insertActivity(Activity activity) {throw UnimplementedError();}@override Future<int> insertECalendar(ECalendar actiendar) {throw UnimplementedError();}@override Future<int> insertScheduled(Scheduled actiduled) {throw UnimplementedError();}@override Future<int> insertTag(Tag acti) {throw UnimplementedError();}@override Future<int> insertTask(Task  acti) {throw UnimplementedError();}@override Future<List<Activity>> queryAllActivities() {throw UnimplementedError();}@override Future<List<ECalendar>> queryAllECalendars() {throw UnimplementedError();}@override Future<List<Scheduled>> queryAllScheduled() {throw UnimplementedError();}@override Future<List<Tag>> queryAllTags() {throw UnimplementedError();}@override Future<List<Task>> queryAllTasks() {throw UnimplementedError();}@override Future saveFromDriveData(Map data) {throw UnimplementedError();}@override Future<int> updateActivity(Activity activity) {throw UnimplementedError();}@override Future<int> updateECalendar(ECalendar actiendar) {throw UnimplementedError();}@override Future<int> updateScheduled(Scheduled actiduled) {throw UnimplementedError();}@override Future<int> updateTag(Tag acti) {throw UnimplementedError();}@override Future<int> updateTask(Task  acti) {throw UnimplementedError();}@override Future deleteEveryThing(){throw UnimplementedError();}}
//
//
// import 'dart:html';
// import 'dart:convert';
//
// import 'package:effectivenezz/data/database_helper.dart';
// import 'package:effectivenezz/objects/activity.dart';
// import 'package:effectivenezz/objects/calendar.dart';
// import 'package:effectivenezz/objects/scheduled.dart';
// import 'package:effectivenezz/objects/tag.dart';
// import 'package:effectivenezz/objects/task.dart';
// import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
//
//
// class WebDb extends DatabaseHelper{
//   final Storage _localStorage = window.localStorage;
//
//   Future saveFromDriveData(Map<String,List> data) async{
//     print(data.toString());
//     data.forEach((key, value) {
//       _localStorage[key]=jsonEncode(data[key]);
//     });
//   }
//
//   @override
//   Future<int> deleteActivity(int activityId) async{
//     List<Activity> activities = await queryAllActivities();
//     var todelete ;
//     var index;
//     activities.forEach((element) {
//       if(element.id==activityId)todelete=element;
//     });
//     index=activities.indexOf(todelete);
//     activities.remove(todelete);
//     _localStorage[ObjectType.values.indexOf(ObjectType.Activity).toString()] = jsonEncode(activities.map((e) => e.toMap()).toList());
//     return index;
//   }
//
//   @override
//   Future<int> deleteECalendar(int actiendarId) async{
//     List<ECalendar> ecalendars = await queryAllECalendars();
//     var todelete ;
//     var index;
//     ecalendars.forEach((element) {
//       if(element.id==actiendarId)todelete=element;
//     });
//     index=ecalendars.indexOf(todelete);
//     ecalendars.remove(todelete);
//     _localStorage[ObjectType.values.indexOf(ObjectType.Calendar).toString()] = jsonEncode(ecalendars.map((e) => e.toMap()).toList());
//     return index;
//   }
//
//   @override
//   Future<int> deleteScheduled(int actiduledId) async{
//     List<Scheduled> scheduleds = await queryAllScheduled();
//     var todelete ;
//     var index;
//     scheduleds.forEach((element) {
//       if(element.id==actiduledId)todelete=element;
//     });
//     index=scheduleds.indexOf(todelete);
//     scheduleds.remove(todelete);
//     _localStorage[ObjectType.values.indexOf(ObjectType.Scheduled).toString()] = jsonEncode(scheduleds.map((e) => e.toMap()).toList());
//     return index;
//   }
//
//   @override
//   Future<int> deleteTag(int actid) async{
//     List<Tag> tags = await queryAllTags();
//     var todelete ;
//     var index;
//     tags.forEach((element) {
//       if(element.id==actid)todelete=element;
//     });
//     index=tags.indexOf(todelete);
//     tags.remove(todelete);
//     _localStorage[ObjectType.values.indexOf(ObjectType.Tag).toString()] = jsonEncode(tags.map((e) => e.toMap()).toList());
//     return index;
//   }
//
//   @override
//   Future<int> deleteTask(int actiId) async{
//     List<Task> tasks = await queryAllTasks();
//     var todelete ;
//     var index;
//     tasks.forEach((element) {
//       if(element.id==actiId)todelete=element;
//     });
//     index=tasks.indexOf(todelete);
//     tasks.remove(todelete);
//     _localStorage[ObjectType.values.indexOf(ObjectType.Task).toString()] = jsonEncode(tasks.map((e) => e.toMap()).toList());
//     return index;
//   }
//
//   @override
//   Future<int> insertActivity(Activity activity) async{
//     List<Activity> activities = await queryAllActivities();
//     if(activities.length==0){
//       activity.id=0;
//     }else activity.id=activities.last.id+1;
//     activities.add(activity);
//     _localStorage[ObjectType.values.indexOf(ObjectType.Activity).toString()] = jsonEncode(activities.map((e) => e.toMap()).toList());
//     return activity.id;
//   }
//
//   @override
//   Future<int> insertECalendar(ECalendar actiendar) async{
//     List<ECalendar> ecalendars = await queryAllECalendars();
//     if(ecalendars.length==0){
//       actiendar.id=0;
//     }else actiendar.id=ecalendars.last.id+1;
//     ecalendars.add(actiendar);
//     _localStorage[ObjectType.values.indexOf(ObjectType.Calendar).toString()] = jsonEncode(ecalendars.map((e) => e.toMap()).toList());
//     return actiendar.id;
//   }
//
//   @override
//   Future<int> insertScheduled(Scheduled actiduled)async {
//     List<Scheduled> scheduled = await queryAllScheduled();
//     if(scheduled.length==0){
//       actiduled.id=0;
//     }else actiduled.id=scheduled.last.id+1;
//     scheduled.add(actiduled);
//     _localStorage[ObjectType.values.indexOf(ObjectType.Scheduled).toString()] = jsonEncode(scheduled.map((e) => e.toMap()).toList());
//     return actiduled.id;
//   }
//
//   @override
//   Future<int> insertTag(Tag acti )async{
//     List<Tag> tags = await queryAllTags();
//     if(tags.length==0){
//       acti.id=0;
//     }else acti.id=tags.last.id+1;
//     tags.add(acti);
//     _localStorage[ObjectType.values.indexOf(ObjectType.Tag).toString()] = jsonEncode(tags.map((e) => e.toMap()).toList());
//     return acti.id;
//   }
//
//   @override
//   Future<int> insertTask(Task  acti) async{
//     List<Task> tasks = await queryAllTasks();
//     if(tasks.length==0){
//       acti.id=0;
//     }else acti.id=tasks.last.id+1;
//     tasks.add(acti);
//     _localStorage[ObjectType.values.indexOf(ObjectType.Task).toString()] = jsonEncode(tasks.map((e) => e.toMap()).toList());
//     return acti.id;
//   }
//
//   @override
//   Future<List<Activity>> queryAllActivities()async{
//     String val = _localStorage[ObjectType.values.indexOf(ObjectType.Activity).toString()];
//     if(val==null||val=='')return [];
//     return (jsonDecode(val) as List).map((e) => Activity.fromMap(e)).toList();
//   }
//
//   @override
//   Future<List<ECalendar>> queryAllECalendars()async {
//     String val = _localStorage[ObjectType.values.indexOf(ObjectType.Calendar).toString()];
//     if(val==null||val=='')return [];
//     return (jsonDecode(val) as List).map((e) => ECalendar.fromMap(e)).toList();
//   }
//
//   @override
//   Future<List<Scheduled>> queryAllScheduled()async{
//     String val = _localStorage[ObjectType.values.indexOf(ObjectType.Scheduled).toString()];
//     if(val==null||val=='')return [];
//     List data = jsonDecode(val);
//     return data.map((e) {return Scheduled.fromMap(e);}).toList();
//   }
//
//   @override
//   Future<List<Tag>> queryAllTags()async{
//     String val = _localStorage[ObjectType.values.indexOf(ObjectType.Tag).toString()];
//     if(val==null||val=='')return [];
//     return (jsonDecode(val) as List).map((e) => Tag.fromMap(e)).toList();
//   }
//
//   @override
//   Future<List<Task>> queryAllTasks()async{
//     String val = _localStorage[ObjectType.values.indexOf(ObjectType.Task).toString()];
//     if(val==null||val=='')return [];
//     return (jsonDecode(val) as List).map((e) => Task.fromMap(e)).toList();
//   }
//
//   @override
//   Future<int> updateActivity(Activity activity) async{
//     List<Activity> activities = await queryAllActivities();
//     activities[findObjectIndexById(activity, activities)]=activity;
//     _localStorage[ObjectType.values.indexOf(ObjectType.Activity).toString()] = jsonEncode(activities.map((e) => e.toMap()).toList());
//     return 0;
//   }
//
//   @override
//   Future<int> updateECalendar(ECalendar actiendar) async{
//     List<ECalendar> ecalendars = await queryAllECalendars();
//     ecalendars[findObjectIndexById(actiendar, ecalendars)]=actiendar;
//     _localStorage[ObjectType.values.indexOf(ObjectType.Calendar).toString()] = jsonEncode(ecalendars.map((e) => e.toMap()).toList());
//     return 0;
//   }
//
//   @override
//   Future<int> updateScheduled(Scheduled actiduled) async{
//     List<Scheduled> scheduleds = await queryAllScheduled();
//     scheduleds[findObjectIndexById(actiduled, scheduleds)]=actiduled;
//     _localStorage[ObjectType.values.indexOf(ObjectType.Scheduled).toString()] = jsonEncode(scheduleds.map((e) => e.toMap()).toList());
//     return 0;
//   }
//
//   @override
//   Future<int> updateTag(Tag acti) async{
//     List<Tag> tags = await queryAllTags();
//     tags[findObjectIndexById(acti, tags)]=acti;
//     _localStorage[ObjectType.values.indexOf(ObjectType.Tag).toString()] = jsonEncode(tags.map((e) => e.toMap()).toList());
//     return 0;
//   }
//
//   @override
//   Future<int> updateTask(Task  acti) async{
//     List<Task> tags = await queryAllTasks();
//     tags[findObjectIndexById(acti, tags)]=acti;
//     _localStorage[ObjectType.values.indexOf(ObjectType.Task).toString()] = jsonEncode(tags.map((e) => e.toMap()).toList());
//     return 0;
//   }
//
//   @override
//   Future deleteEveryThing() {
//     List.generate(ObjectType.values.length, (index) {
//        _localStorage.remove(index.toString());
//     });
//     return Future.value(null);
//   }
//
//   int findObjectIndexById(dynamic object,List list){
//     int toreturn = -1;
//     for(int i = 0; i<list.length;i++){
//       if(list[i].id==object.id){
//         toreturn=i;
//       }
//     }
//     return toreturn;
//   }
// }