import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gmax_web_width.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

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

  Color contrastColor = getContrastColor(MyApp.dataModel.currentPlaying.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(7),
          topRight: Radius.circular(7)
        ),
        color: MyApp.dataModel.currentPlaying.color,
      ),
      width: (MyApp.dataModel.screenWidth??400)-100,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Row(
          children: <Widget>[
            if(MyApp.dataModel.currentPlaying is Task)
              IconButton(
                icon: GIcon(MyApp.dataModel.currentPlaying.isCheckedOnDate(getTodayFormated())?Icons.check_circle_outline:Icons.radio_button_unchecked,color:contrastColor),
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
                      child: GText(MyApp.dataModel.currentPlaying.name,color: contrastColor,maxLines: 2),
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
                child:GText("• "+tracked,color: contrastColor,)
                   // + "\n(left: ${getTextFromDuration(currentPlaying.getTimeLeft(context))})"),

              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(icon: GIcon(Icons.stop,color: contrastColor,), onPressed: (){
                  MyApp.dataModel.setPlaying(context, null,);
                }),
                PopupMenuButton(
                  child: GIcon(Icons.more_horiz,color: contrastColor,),
                  shape: getShape(),
                  color: MyColors.getOverFlowColor(),
                  itemBuilder: (ctx){
                    return [
                      PopupMenuItem(
                        child: ListTile(
                          leading: GIcon(Icons.add),
                          title: GText('Add 1 min'),
                          onTap: (){
                            MyApp.dataModel.addMinutesToPlaying(context, 1);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: GIcon(Icons.add),
                          title: GText('Add 5 min'),
                          onTap: (){
                            MyApp.dataModel.addMinutesToPlaying(context, 5);
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child: Divider(),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: GIcon(Icons.add),
                          title: GText('Edit start and end time'),
                          onTap: (){
                            Navigator.pop(context);
                            showEditTimestampsBottomSheet(context, object: MyApp.dataModel.currentPlaying,);
                          },
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: GIcon(Icons.add),
                          title: GText('Swap current ${(MyApp.dataModel.currentPlaying is Task)?"task": "activity"} with task or activity'),
                          onTap: (){
                            Navigator.pop(context);
                            showReplacePlayableBottomSheet(context,MyApp.dataModel.currentPlaying);
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
