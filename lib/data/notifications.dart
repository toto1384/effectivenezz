import 'package:effectivenezz/ui/pages/popup_page.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart';

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();


class NotificationHelper{

  BuildContext context;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String channelId= "0";
  String channelName="What's tracking?";
  String channelDescription="Here you will see... Well.... What's tracking";

  String channelId1="1";
  String channelName1="Upcoming Events";
  String channelDescription1="Here you will see... Well.... upcoming events";

  bool firstTime= true;

  static Future<NotificationHelper> init(BuildContext context)async{

    NotificationHelper notificationHelper = NotificationHelper();
    notificationHelper.context=context;

    notificationHelper.flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var initializationSettingsAndroid = AndroidInitializationSettings('effectivenezz_logo');
    var initializationSettingsIOS = IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: notificationHelper.onDidReceiveLocalNotification,
    );
    var initializationSettings = InitializationSettings(android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS);
    await notificationHelper.flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: notificationHelper.selectNotification);

    notificationHelper._configureSelectNotificationSubject();
    return notificationHelper;
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload)async{
      if(payload=='tracked') {
        print('launch popup');
        //if(((await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails()).didNotificationLaunchApp)) {
        // if(firstTime){
        //   firstTime=false;
        // }else
          launchPage(context, PopupPage());
        //}
      }
    });
  }


  void dispose() {
    selectNotificationSubject.close();
  }


  Future selectNotification(String payload) async {
    if(payload!=null)selectNotificationSubject.add(payload);
   //}
  }

  requestPermisionsWhenIOS()async{
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  displayNotification({@required int id,@required String title,@required String body,@required String payload,Color color,Importance importance})async{
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId, channelName, channelDescription,color: color,indeterminate: true,ongoing: true,
      autoCancel: false,icon: "effectivenezz_logo",
      importance: Importance.defaultImportance,priority: Priority.defaultPriority);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, platformChannelSpecifics,
        payload: payload);
  }

  scheduleNotification({@required int id,@required String title,@required String body,@required String payload,
    Color color ,@required DateTime dateTime})async{

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId1, channelName1, channelDescription1,color: color,indeterminate: false,ongoing: false,
      autoCancel: true,icon: "effectivenezz_logo",playSound: true,
      importance: Importance.max, ticker: 'ticker',priority: Priority.max);
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(presentSound: true,presentAlert: true,);
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        android:androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        TZDateTime.local(dateTime.year,dateTime.month,dateTime.day,dateTime.hour,dateTime.minute),
        platformChannelSpecifics,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.wallClockTime);
  }

  dailyNotification({@required int id,@required String title,@required String body,@required String payload})async{
    var time = Time(10, 0, 0);
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails(channelId,
        channelName, channelDescription);
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android:androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showDailyAtTime(
        id,
        title,
        body,
        time,
        platformChannelSpecifics);
  }

  weeklyNotification({@required int id,@required String title,@required String body,@required String payload})async{
    var time = Time(10, 0, 0);
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails(channelId,
        channelName, channelDescription);
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        android:androidPlatformChannelSpecifics,iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        id,
        title,
        body,
        Day.monday,
        time,
        platformChannelSpecifics);
  }

  cancelNotification(int id)async{
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  cancelAllNotifications()async{
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    print("Notification received");
  }

}