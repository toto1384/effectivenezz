



import 'package:effectivenezz/ui/pages/popup_page.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';

final BehaviorSubject<String> selectNotificationSubject =
BehaviorSubject<String>();


class NotificationHelper{

  BuildContext context;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  String channelId= "0";
  String channelName="What's tracking?";
  String channelDescription="Here you will see... Well.... What's tracking";

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
    var initializationSettings = InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    await notificationHelper.flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: notificationHelper.selectNotification);

    notificationHelper._configureSelectNotificationSubject();
    return notificationHelper;
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String payload){
      if(payload=='tracked') {
        launchPage(context,PopupPage());
      }
    });
  }


  void dispose() {
    selectNotificationSubject.close();
  }


  Future selectNotification(String payload) async {
//    if(!firstTime||((await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails()).didNotificationLaunchApp)){
    selectNotificationSubject.add(payload);
//    }else firstTime=false;
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
      autoCancel: false,icon: "effectivenezz_logo",playSound: false,
      importance: importance??Importance.Default, ticker: 'ticker',);
    var iOSPlatformChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        id, title, body, platformChannelSpecifics,
        payload: payload);
  }

  scheduleNotification({@required int id,@required String title,@required String body,@required String payload,
    Color color,Importance importance,bool permanent, @required DateTime dateTime})async{

    if(permanent==null)permanent=false;

    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails(channelId,
      channelName, channelDescription,color: color,indeterminate: permanent,ongoing: permanent,
      autoCancel: !permanent,importance: importance??Importance.Default,
      priority: importance==Importance.Max?Priority.Max:Priority.Default, icon: "effectivenezz_logo",);
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails(presentSound: importance==Importance.Max,presentAlert: importance==Importance.Max,);
    NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        id,
        title,
        body,
        dateTime,
        platformChannelSpecifics);
  }

  dailyNotification({@required int id,@required String title,@required String body,@required String payload})async{
    var time = Time(10, 0, 0);
    var androidPlatformChannelSpecifics =
    AndroidNotificationDetails(channelId,
        channelName, channelDescription);
    var iOSPlatformChannelSpecifics =
    IOSNotificationDetails();
    var platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
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
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.showWeeklyAtDayAndTime(
        id,
        title,
        body,
        Day.Monday,
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