import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_restart_widget.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';



launchPage(BuildContext context , Widget page,{bool fullScreenDialog}){
  print("launching page ${page.runtimeType}");
  Navigator.push(context, MaterialPageRoute(
    settings: RouteSettings(
      name: page.runtimeType.toString()
    ),
    builder: (context){
      return page;
    }
  ,fullscreenDialog: fullScreenDialog??false));
}

Color getContrastColor(Color color){
  return (color??Colors.white).computeLuminance() > 0.5 ? Colors.black : Colors.white;
}

bool isShowingPage(Type type){
  print("IS SHOWING PAGE ${type.toString()} ${DistivityPageState.customKey.pageName}");
  if(DistivityPageState.customKey.pageName==type.toString())return true;

  return false;
}

formatDouble(double double){
  return NumberFormat("###,###.##").format(double);
}

getGlobalContext(BuildContext context){
  return context.findAncestorStateOfType<DistivityPageState>().context;
}

getRepeatText(RepeatRule repeatRule, int repeatValue){
  switch(repeatRule){

    case RepeatRule.None:
      return 'Doesn\'t repeat';
      break;
    case RepeatRule.EveryXDays:
      return "Every $repeatValue days";
      break;
    case RepeatRule.EveryXWeeks:
      return "Every $repeatValue weeks";
      break;
    case RepeatRule.EveryXMonths:
      return "Every $repeatValue months";
      break;
  }
}

getValueColor(int value){
  if(value<0){
    return Colors.red;
  }
  if(value==0){
    return Colors.deepOrangeAccent;
  }
  if(value>=1000){
    return Colors.green;
  }
  if(value>=100){
    return Colors.tealAccent;
  }
  if(value>0){
    return Colors.amber;
  }
}

customOnBackPressed(BuildContext context){
  showYesNoDialog(context, title: "Do you want to exit the app?", text: "", onYesPressed: (){
    if(Platform.isIOS){
      exit(0);
    }else if(Platform.isAndroid){
      SystemNavigator.pop();
    }
  });
  return false;
}

mailMe(){
  launch("mailto:totoalex62@gmail.com");
}

deleteDb(BuildContext context)async{
  showYesNoDialog(
      context,
      text: "Activities, Tasks, Calendars. EVERYTHING WILL BE DELETED AND THERE IS NO UNDO BUTTON. Are you sure",
      title: "Delete Everything??",
      yesString: "DELETE EVERYTHING",
      noString: "Cancel",
      onYesPressed: ()async{
        if(!kIsWeb)MyApp.dataModel.notificationHelper.cancelAllNotifications();
        MyApp.dataModel.databaseHelper.deleteEveryThing().then((value) {
          showDistivityDialog(
              context,
              actions: [GButton('Restart app', onPressed: (){
                MyApp.dataModel=null;
                DistivityRestartWidget.restartApp(context);
              })],
              title: 'A fresh new start', stateGetter: (ctx,ss)=>Center());
        });
  });
}



Future<http.Response> performApiRequest(RequestType requestType,String url,Map<String,String> headers,{Map data})async{

  switch(requestType){
    case RequestType.Post:
      return http.post(Uri.parse(url),headers: headers,body: utf8.encode(json.encode(data)));
      break;
    case RequestType.Update:
      return http.patch(Uri.parse(url),headers: headers,body: utf8.encode(json.encode(data)));
      break;
    case RequestType.Delete:
      return http.delete(Uri.parse(url),headers: headers,);
      break;
    case RequestType.Query:
      return http.get(Uri.parse(url),headers: headers);
      break;
  }
  return null;
}

RoundedRectangleBorder getShape(
    {bool bottomSheetShape,bool smallRadius, bool webCardShape,bool subtleBorder,Color subtleBorderColor}){

  if(bottomSheetShape==null){
    bottomSheetShape=false;
  }
  if(smallRadius==null){
    smallRadius=true;
  }

  double radius = smallRadius?10:30;

  if(webCardShape==null){
    webCardShape=false;
  }

  if(subtleBorder==null){
    subtleBorder=false;
  }

  if(bottomSheetShape){
    return RoundedRectangleBorder(
        side: subtleBorder?BorderSide(
          width: 1,
          color: subtleBorderColor??Colors.white,
        ):BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        )
    );
  }else if(webCardShape){
    return RoundedRectangleBorder(
      side: subtleBorder?BorderSide(
        width: 1,
        color: Colors.white,
      ):BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
    );
  }else{
    return RoundedRectangleBorder(
        side: subtleBorder?BorderSide(
          width: 1,
          color: Colors.white,
        ):BorderSide(color: Colors.transparent),
        borderRadius: BorderRadius.circular(radius)
    );
  }
}

