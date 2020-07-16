import 'package:effectivenezz/ui/pages/calendar_page.dart';
import 'package:effectivenezz/ui/pages/set_type_page.dart';
import 'package:effectivenezz/ui/pages/track_page.dart';
import 'package:effectivenezz/ui/widgets/distivity_restart_widget.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/provider_models.dart';


void main() {
  runApp(
    DistivityRestartWidget(
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          darkTheme: getAppDarkTheme(),
          themeMode: ThemeMode.dark,
          home: MyApp(),
      )
    ),
  );
}

class MyApp extends StatefulWidget {
  static DataModel dataModel;
  static bool snapToEnd= true;
  MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {


  static ss(BuildContext context){
    final DistivityPageState state =
    context.findAncestorStateOfType<DistivityPageState>();
    if(state!=null){
      state.setState((){});
    }
  }

  init()async{
    if(MyApp.dataModel==null){
      MyApp.dataModel=await DataModel.init(context);
    }
    return true;
  }

  int progress = 0;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: MyColors.color_black_darker
    ));
    return FutureBuilder(
        future: init(),
        builder: (ctx,AsyncSnapshot snap){
          if(snap.hasData){
            if(MyApp.dataModel.prefs.getAppMode()==null){
              //showpopup
              return SetTypePage();
            }

            return TrackPage();
          }else{
            return Scaffold(body: Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 200,
                    height: 200,
                    child: Image.asset(AssetsPath.icon)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Container(height:10,width: 100,child: LinearProgressIndicator())
                ),
              ],
            ),));
          }
      });
  }
}

