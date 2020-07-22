import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class DistivitySecondaryItem extends StatefulWidget {

  @override
  _DistivitySecondaryItemState createState() => _DistivitySecondaryItemState();
}

class _DistivitySecondaryItemState extends State<DistivitySecondaryItem> with AfterLayoutMixin,TickerProviderStateMixin {

  dynamic currentPlaying;

  @override
  void dispose() {
    _everySecond.cancel();
    _everySecond=null;
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(MyApp.dataModel.taskPlayingId!=null){
      currentPlaying=MyApp.dataModel.findTaskById(MyApp.dataModel.taskPlayingId);
    }
    if(MyApp.dataModel.activityPlayingId!=null){
      currentPlaying=MyApp.dataModel.findActivityById(MyApp.dataModel.activityPlayingId);
    }
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7),
          topRight: Radius.circular(7)
        ),
        color: MyColors.color_black,
      ),
      width: MediaQuery.of(context).size.width-100,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
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
            Container(
              constraints: BoxConstraints(maxWidth: 110),
              child: GestureDetector(
                  onTap: (){
                    showReplacePlayableBottomSheet(context,currentPlaying);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(left: ((currentPlaying is Task)?0:20),top: 10,bottom: 10),
                    child: getText(currentPlaying.name,color: currentPlaying.color,maxLines: 2),
                  )
              ),
            ),

            GestureDetector(
              onTap: (){
                showEditTimestampsBottomSheet(context, object: currentPlaying,);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child:getText("• "+tracked)
                   // + "\n(left: ${getTextFromDuration(currentPlaying.getTimeLeft(context))})"),

              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(icon: getIcon(Icons.stop,), onPressed: (){
                  MyApp.dataModel.setPlaying(context, null,);
                }),
                PopupMenuButton(
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
                ),
              ],
            ),
          ],
        ),
      ),
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
