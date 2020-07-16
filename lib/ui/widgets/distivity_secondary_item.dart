import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class DistivitySecondaryItem extends StatefulWidget {
  @override
  _DistivitySecondaryItemState createState() => _DistivitySecondaryItemState();
}

class _DistivitySecondaryItemState extends State<DistivitySecondaryItem> with AfterLayoutMixin {

  dynamic currentPlaying;

  @override
  void dispose() {
    _everySecond.cancel();
    _everySecond=null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(MyApp.dataModel.taskPlayingId!=null){
      currentPlaying=MyApp.dataModel.findTaskById(MyApp.dataModel.taskPlayingId);
    }
    if(MyApp.dataModel.activityPlayingId!=null){
      currentPlaying=MyApp.dataModel.findActivityById(MyApp.dataModel.activityPlayingId);
    }
//      return getText(tracked);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Card(
          color: Colors.transparent,
          shape: getShape(subtleBorder: true),
          elevation: 0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Padding(
                  padding: const EdgeInsets.only(top: 8,right: 8),
                  child: PopupMenuButton(
                    child: getIcon(Icons.more_horiz),
                    shape: getShape(),
                    color: MyColors.getOverFlowColor(),
                    itemBuilder: (ctx){
                      return [
                        PopupMenuItem(
                          child: ListTile(
                            leading: getIcon(Icons.add),
                            title: getText('Add 1 min'),
                            onTap: (){
                              MyApp.dataModel.addMinutesToPlaying(context, 1);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                        PopupMenuItem(
                          child: ListTile(
                            leading: getIcon(Icons.add),
                            title: getText('Add 5 min'),
                            onTap: (){
                              MyApp.dataModel.addMinutesToPlaying(context, 5);
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ];
                    },
                  )
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if(currentPlaying is Task)
                          IconButton(
                            icon: getIcon(currentPlaying.isCheckedOnDate(getTodayFormated())?Icons.check_circle_outline:Icons.radio_button_unchecked,color: currentPlaying.color),
                            onPressed: (){
                              if(currentPlaying.isCheckedOnDate(getTodayFormated())){
                                currentPlaying.unCheckOnDate(getTodayFormated());
                              }else{
                                currentPlaying.checks.add(getTodayFormated());
                              }
                              MyApp.dataModel.task(MyApp.dataModel.findObjectIndexById(currentPlaying), currentPlaying, context, CUD.Update);
                            },
                          ),
                        GestureDetector(
                            onTap: (){
                              showReplacePlayableBottomSheet(context,currentPlaying);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: getText(currentPlaying.name,color: currentPlaying.color),
                            )
                        ),

                        GestureDetector(
                          onTap: (){
                            showEditTimestampsBottomSheet(context, object: currentPlaying,);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child:getText(tracked),

                          ),
                        ),
                        IconButton(icon: getIcon(Icons.stop,), onPressed: (){
                          MyApp.dataModel.setPlaying(context, null,);
                        }),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getText("Time left: ${getTextFromDuration(currentPlaying.getTimeLeft(context))}",),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Timer _everySecond;
  String tracked="0:00:00";

  @override
  void afterFirstLayout(BuildContext context) {
    _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        tracked = getTextFromDuration(getTodayFormated().difference(currentPlaying.trackedStart.last));
      });
    });
  }
}
