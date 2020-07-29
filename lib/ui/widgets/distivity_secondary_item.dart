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

class _DistivitySecondaryItemState extends State<DistivitySecondaryItem> with AfterLayoutMixin,TickerProviderStateMixin {

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7),
          topRight: Radius.circular(7)
        ),
        color: MyColors.color_black_darker,
      ),
      width: (MyApp.dataModel.screenWidth??400)-100,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            if(MyApp.dataModel.currentPlaying is Task)
              IconButton(
                icon: getIcon(MyApp.dataModel.currentPlaying.isCheckedOnDate(getTodayFormated())?Icons.check_circle_outline:Icons.radio_button_unchecked,color: MyApp.dataModel.currentPlaying.color),
                onPressed: (){
                  if(MyApp.dataModel.currentPlaying.isCheckedOnDate(getTodayFormated())){
                    MyApp.dataModel.currentPlaying.unCheckOnDate(getTodayFormated());
                  }else{
                    MyApp.dataModel.currentPlaying.checks.add(getTodayFormated());
                  }
                  MyApp.dataModel.task(MyApp.dataModel.findObjectIndexById(MyApp.dataModel.currentPlaying), MyApp.dataModel.currentPlaying, context, CUD.Update);
                },
              ),
            Flexible(
              child: Container(
                constraints: BoxConstraints(maxWidth: 110),
                child: GestureDetector(
                    onTap: (){
                      showReplacePlayableBottomSheet(context,MyApp.dataModel.currentPlaying);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: ((MyApp.dataModel.currentPlaying is Task)?0:20),top: 10,bottom: 10),
                      child: getText(MyApp.dataModel.currentPlaying.name,color: MyApp.dataModel.currentPlaying.color,maxLines: 2),
                    )
                ),
              ),
            ),

            GestureDetector(
              onTap: (){
                showEditTimestampsBottomSheet(context, object: MyApp.dataModel.currentPlaying,);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 10),
                child:getText("• "+tracked)
                   // + "\n(left: ${getTextFromDuration(currentPlaying.getTimeLeft(context))})"),

              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
        tracked = getTextFromDuration(getTodayFormated().difference(MyApp.dataModel.currentPlaying.trackedStart.last));
      });
    });
  }
}
