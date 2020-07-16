import 'dart:io';
import 'package:effectivenezz/data/database.dart';
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/ui/widgets/distivity_restart_widget.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';



launchPage(BuildContext context , Widget page){
  print("launching page ${page.runtimeType}");
  Navigator.push(context, MaterialPageRoute(
    builder: (context){
      return page;
    }
  ),);
}
bool isShowingPage(BuildContext context,Type type){
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
      return '';
      break;
    case RepeatRule.EveryXDays:
      return "(${repeatValue}d)";
      break;
    case RepeatRule.EveryXWeeks:
      return "(${repeatValue}w)";
      break;
    case RepeatRule.EveryXMonths:
      return "(${repeatValue}m)";
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
        MyApp.dataModel.databaseHelper.deleteEveryThing().then((value) {
          showDistivityDialog(
              context,
              actions: [getButton('Restart app', onPressed: (){
                MyApp.dataModel=null;
                DistivityRestartWidget.restartApp(context);
              })],
              title: 'A fresh new start', stateGetter: (ctx,ss)=>Center());
        });
  });
}



Future<HttpClientResponse>performApiRequest(RequestType requestType,String url,Map<String,String> headers)async{
  HttpClient httpClient = new HttpClient();

  HttpClientRequest request ;

  switch(requestType){

    case RequestType.Post:
      request = await httpClient.postUrl(Uri.parse(url));
      break;
    case RequestType.Update:
      request = await httpClient.patchUrl(Uri.parse(url));
      break;
    case RequestType.Delete:
      request = await httpClient.deleteUrl(Uri.parse(url));
      break;
    case RequestType.Query:
      request = await httpClient.getUrl(Uri.parse(url));
      break;
  }

  headers.forEach((k,v){
    request.headers.set(k, v);
  });

  return await request.close();
}

