import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/ui/pages/track_page.dart';
import 'package:effectivenezz/ui/widgets/distivity_secondary_item.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:minimize_app/minimize_app.dart';

class PopupPage extends StatefulWidget {
  @override
  _PopupPageState createState() => _PopupPageState();
}

class _PopupPageState extends DistivityPageState<PopupPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (){
        MinimizeApp.minimizeApp();
        Navigator.pop(context);
        launchPage(context, TrackPage());
        return Future.delayed(Duration.zero).then((value) => false);
      },
      child: GestureDetector(
        onTap: (){
          MinimizeApp.minimizeApp();
          Navigator.pop(context);
          launchPage(context, TrackPage());
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Card(
              elevation: 20,
              shape: getShape(),
              color: MyColors.color_black_darker,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: getText("Record new entry",textType: TextType.textTypeSubtitle),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2,maxWidth: MediaQuery.of(context).size.width-100),
                      child: SingleChildScrollView(
                        child: getSortByCalendarListView(context, getTodayFormated(),areMinimal: true,onSelected: (e){
                              MyApp.dataModel.setPlaying(context, e);
                              MinimizeApp.minimizeApp();
                              Navigator.pop(context);
                          launchPage(context, TrackPage());
                        },scrollable: false),
                      ),
                    ),
                  ),
                  if(MyApp.dataModel.activityPlayingId!=null||MyApp.dataModel.taskPlayingId!=null)
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: DistivitySecondaryItem(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
