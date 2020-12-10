import 'dart:convert';

import 'package:effectivenezz/data/drive_helper.dart';
import 'package:effectivenezz/data/prefs.dart';
import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/calendar.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/tag.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/pages/quick_start_page.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:flutter/cupertino.dart';

class Backend{

  final String url = "https://api.effectivenezz.com";
  String auth_token;
  GoogleDriveHelper driveHelper;
  Prefs prefs;

  static Future<Backend> initBackend(BuildContext context,)async{
    Backend backend = Backend();
    backend.prefs = await Prefs.getInstance();

    backend.auth_token=await backend.prefs.getAuthToken();

    backend.driveHelper= await GoogleDriveHelper.init(context,backend.prefs);

    return backend;
  }

  Future<String> login({@required String googleId,@required String email})async{
    var response = await performApiRequest(RequestType.Post, "$url/user/login",data: {
      "googleId":googleId,
      "email":email
    });
    prefs.setAuthToken(response.body);
    auth_token=response.body;
    return response.body;
  }

  getHeaders(){
    if(auth_token==null)print('auth token null');
    return {
      "auth-token":auth_token,
    };
  }

  Future<List<Activity>> activity(BuildContext context,RequestType requestType,{Activity activity})async{
    String uri;
    if(requestType==RequestType.Delete||requestType==RequestType.Update){
      uri="$url/activity/${activity.id}";
    }else{
      uri="$url/activity";
    }
    switch(requestType){
      case RequestType.Post:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),data: activity.toMapBackend());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [Activity.fromMapBackend(jsonDecode(res.body))];
        break;
      case RequestType.Update:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),data: activity.toMapBackend());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [];
        break;
      case RequestType.Delete:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),);
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [Activity.fromMapBackend(jsonDecode(res.body))];
        break;
      case RequestType.Query:
        var res =await performApiRequest(requestType, uri,headers: getHeaders());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return jsonDecode(res.body).map<Activity>((element)=>Activity.fromMapBackend(element)).toList();
        break;
    }
    return [];
  }


  Future<List<Task>> task(BuildContext context,RequestType requestType,{Task task})async{
    String uri;
    if(requestType==RequestType.Delete||requestType==RequestType.Update){
      uri="$url/task/${task.id}";
    }else{
      uri="$url/task";
    }
    switch(requestType){
      case RequestType.Post:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),data: task.toMapBackend());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [Task.fromMapBackend(jsonDecode(res.body))];
        break;
      case RequestType.Update:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),data: task.toMapBackend());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [];
        break;
      case RequestType.Delete:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),);
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [Task.fromMapBackend(jsonDecode(res.body))];
        break;
      case RequestType.Query:
        var res =await performApiRequest(requestType, uri,headers: getHeaders());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return jsonDecode(res.body).map<Task>((element)=>Task.fromMapBackend(element)).toList();
        break;
    }
    return [];
  }

  Future<List<ECalendar>> calendar(BuildContext context,RequestType requestType,{ECalendar calendar})async{
    String uri;
    if(requestType==RequestType.Delete||requestType==RequestType.Update){
      uri="$url/calendar/${calendar.id}";
    }else{
      uri= "$url/calendar";
    }
    switch(requestType){
      case RequestType.Post:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),data: calendar.toMapBackend());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [ECalendar.fromMapBackend(jsonDecode(res.body))];
        break;
      case RequestType.Update:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),data: calendar.toMapBackend());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [];
        break;
      case RequestType.Delete:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),);
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [ECalendar.fromMapBackend(jsonDecode(res.body))];
        break;
      case RequestType.Query:
        var res =await performApiRequest(requestType, uri,headers: getHeaders());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return jsonDecode(res.body).map<ECalendar>((element)=>ECalendar.fromMapBackend(element)).toList();
        break;
    }
    return [];
  }

  Future<List<Tag>> tag(BuildContext context,RequestType requestType,{Tag tag})async{
    String uri;
    if(requestType==RequestType.Delete||requestType==RequestType.Update){
      uri="$url/tag/${tag.id}";
    }else{
      uri= "$url/tag";
    }
    switch(requestType){
      case RequestType.Post:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),data: tag.toMapBackend());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [Tag.fromMapBackend(jsonDecode(res.body))];
        break;
      case RequestType.Update:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),data: tag.toMapBackend());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [];
        break;
      case RequestType.Delete:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),);
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [Tag.fromMapBackend(jsonDecode(res.body))];
        break;
      case RequestType.Query:
        var res =await performApiRequest(requestType, uri,headers: getHeaders());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return jsonDecode(res.body).map<Tag>((element)=>Tag.fromMapBackend(element)).toList();
        break;
    }
    return [];
  }


  Future<List<Scheduled>> scheduled(BuildContext context,RequestType requestType,{Scheduled scheduled,String parentId})async{
    String uri;
    if(requestType==RequestType.Delete||requestType==RequestType.Update){
      uri= "$url/scheduled/${scheduled.id}";
    }else if(requestType==RequestType.Query){
      uri= "$url/scheduled/";
    }else if(requestType==RequestType.Post){
      uri= "$url/scheduled/${parentId}";
    }
    switch(requestType){
      case RequestType.Post:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),data: scheduled.toMapBackend());
        if(res==null){
          if(driveHelper.currentUser!=null){
            login(googleId: driveHelper.currentUser.id, email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [Scheduled.fromMapBackend(jsonDecode(res.body))];
        break;
      case RequestType.Update:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),data: scheduled.toMapBackend());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [];
        break;
      case RequestType.Delete:
        var res = await performApiRequest(requestType,uri,headers: getHeaders(),);
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return [Scheduled.fromMapBackend(jsonDecode(res.body))];
        break;
      case RequestType.Query:
        var res =await performApiRequest(requestType, uri,headers: getHeaders());
        if(res==null){
          if(driveHelper.currentUser!=null) {
            login(googleId: driveHelper.currentUser.id,
                email: driveHelper.currentUser.email);
          }
          return [];
        }
        return jsonDecode(res.body).map<Scheduled>((element)=>Scheduled.fromMapBackend(element)).toList();
        break;
    }
    return [];
  }


}