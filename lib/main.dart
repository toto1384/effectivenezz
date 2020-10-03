import 'package:effectivenezz/ui/pages/track_page.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_restart_widget.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'data/provider_models.dart';


void main() {
  runApp(
    DistivityRestartWidget(
      child: MaterialApp(
        title: getTitle(),
          debugShowCheckedModeBanner: false,
          darkTheme: ThemeData(
            fontFamily: 'Montserrat',
            unselectedWidgetColor: Colors.white,
            canvasColor: MyColors.color_black_darker,
            accentColor: Colors.white,
            cursorColor: Colors.white,
            snackBarTheme: SnackBarThemeData(
              shape: getShape(subtleBorder: true),
              backgroundColor: MyColors.color_black,
            ),
            dividerTheme: DividerThemeData(
                endIndent: 20,indent: 20,color: Colors.white,space: 20,thickness: 1.5
            ),
            cardTheme: CardTheme(
              shape: getShape(smallRadius: false),
              elevation: 0,
              color: MyColors.color_black,
            ),
            sliderTheme: SliderThemeData(
              activeTrackColor: MyColors.color_primary,
              inactiveTrackColor: MyColors.color_primary.withOpacity(0.3),
              thumbColor: MyColors.color_primary,
              trackHeight: 8,
              overlayColor: MyColors.color_primary.withOpacity(0.3),
              valueIndicatorColor: MyColors.color_black_darker,
              activeTickMarkColor: Colors.transparent,
              inactiveTickMarkColor: Colors.transparent,
            ),
            primaryColor: Colors.white,
            primaryColorDark: Colors.white,
            scaffoldBackgroundColor: MyColors.color_black_darker,
            iconTheme: IconThemeData(
                color: Colors.white
            ),
            bottomAppBarColor: MyColors.color_black_darker,
            popupMenuTheme: PopupMenuThemeData(
              shape: getShape(),
              color: MyColors.color_black_darker,
            ),
          ),
          themeMode: ThemeMode.dark,
          home: MyApp(),
      )
    ),
  );
}

getTitle(){
  if(MyApp.dataModel!=null){
    if(MyApp.dataModel.currentPlaying!=null){
      return "${MyApp.dataModel.currentPlaying} is Tracked";
    }
  }
  return 'Effectivenezz';
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
    print('ss called');
    final DistivityPageState state =
    context.findAncestorStateOfType<DistivityPageState>();
    if(state!=null){
      state.setState((){});
    }
  }

  Future<DataModel> futureDM ;

  @override
  void initState() {
    super.initState();
    futureDM= DataModel.init(context);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarColor: MyColors.color_black_darker
    ));
    return FutureBuilder(
        future: futureDM,
        builder: (ctx,AsyncSnapshot snap){
          if(snap.hasData){
            if(MyApp.dataModel==null){
              MyApp.dataModel=snap.data;
              MyApp.dataModel.screenWidth=MediaQuery.of(context).size.width;
            }
            return TrackPage();
          }else{
            return Scaffold(body: Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 200,
                      height: 200,
                      child: Image.asset(AssetsPath.icon)),
                ),
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

