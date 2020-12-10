import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';



launchPage(BuildContext context , Widget page,{bool fullScreenDialog}){
  print("launching page ${page.runtimeType}");
  DistivityPageState.pageChangeCallback.notifyUpdated(page.runtimeType);
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
  if(DistivityPageState.customKey.pageName==type.toString())return true;

  return false;
}

formatDouble(double double){
  return NumberFormat("###,###.##").format(double);
}

getGlobalContext(BuildContext context){
  return context.findAncestorStateOfType<DistivityPageState>().context;
}

getRepeatText(RepeatRule repeatRule, String repeatValue){
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

// deleteDb(BuildContext context)async{
//   showYesNoDialog(
//       context,
//       text: "Activities, Tasks, Calendars. EVERYTHING WILL BE DELETED AND THERE IS NO UNDO BUTTON. Are you sure",
//       title: "Delete Everything??",
//       yesString: "DELETE EVERYTHING",
//       noString: "Cancel",
//       onYesPressed: ()async{
//         if(!kIsWeb)MyApp.dataModel.notificationHelper.cancelAllNotifications();
//         MyApp.dataModel.databaseHelper.deleteEveryThing().then((value) {
//           showDistivityDialog(
//               context,
//               actions: [GButton('Restart app', onPressed: (){
//                 MyApp.dataModel=null;
//                 DistivityRestartWidget.restartApp(context);
//               })],
//               title: 'A fresh new start', stateGetter: (ctx,ss)=>Center());
//         });
//   });
// }



Future<http.Response> performApiRequest(RequestType requestType,String url,{Map<String,String> headers,Map data})async{
  if(headers==null)headers={};
  headers['Content-Type']= 'application/json; charset=UTF-8';
  switch(requestType){
    case RequestType.Post:
      var response = await http.post(Uri.encodeFull(url),headers: headers,body: json.encode(data));
      print("${response.statusCode} message ${response.body}");
      if(response.statusCode==200)return response;
      break;
    case RequestType.Update:
      var response = await http.patch(Uri.encodeFull(url),headers: headers,body: json.encode(data));
      print("${response.statusCode} message ${response.body}");
      if(response.statusCode==200)return response;
      break;
    case RequestType.Delete:
      var response = await  http.delete(Uri.encodeFull(url),headers: headers,);
      print("${response.statusCode} message ${response.body}");
      if(response.statusCode==200)return response;
      break;
    case RequestType.Query:
      var response = await http.get(Uri.encodeFull(url),headers: headers);
      print("${response.statusCode} message ${response.body}");
      if(response.statusCode==200)return response;
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

