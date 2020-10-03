import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/ui/pages/track_page.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/lists/gsort_by_money_tasks_and_activities.dart';
import 'package:effectivenezz/ui/widgets/specific/distivity_secondary_item.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
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
              child: Container(
                constraints: BoxConstraints(maxWidth: MyApp.dataModel.screenWidth-50),
                child: GestureDetector(
                  onTap: (){},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 15,bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            getSubtitle("Record new entry"),
                            GButton('Open app',variant: 2,onPressed: (){
                              launchPage(context, TrackPage());
                            },),
                          ],
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2,),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: SingleChildScrollView(
                            child:GSortByMoneyTasksAndActivities(
                              ScrollController(),
                              getTodayFormated(),areMinimal: true,onSelected: (e){
                                MyApp.dataModel.setPlaying(context, e);
                                MinimizeApp.minimizeApp();
                                Navigator.pop(context);
                                launchPage(context, TrackPage());
                              },scrollable: false
                            ),
                          ),
                        ),
                      ),
                      if(MyApp.dataModel.currentPlaying!=null)
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: DistivitySecondaryItem(),
                        ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GText(
                          "Remember: don't be so strict with yourself",
                          textType: TextType.textTypeSubNormal,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
