import 'dart:async';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/pages/pomodoro_page.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class TaskListItem extends StatefulWidget {
  final Task task;
  final DateTime selectedDate;
  final Function onTap;
  final bool minimal;
  final Scheduled context;

  const TaskListItem({Key key,@required this.task,
    @required this.selectedDate,this.onTap,this.minimal,this.context}) : super(key: key);

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {ifStartTimer();});
  }

  @override
  void dispose() {
    if(_everySecond!=null)_everySecond.cancel();
    _everySecond=null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      color: MyColors.color_black,
      shape: getShape(),
      child: ListTile(
        onTap: (){
          if(widget.minimal??false){
            if(widget.onTap!=null){
              widget.onTap();
            }else showObjectDetailsBottomSheet(
                getGlobalContext(context), widget.task,widget.selectedDate,
                isInCalendar: false,sContext: widget.context);
          }else{
            showObjectDetailsBottomSheet(
                getGlobalContext(context), widget.task,widget.selectedDate,
                isInCalendar: false,sContext: widget.context);
          }
        },
        leading: CircularCheckBox(
          inactiveColor: widget.task.color,
          value: widget.task.isCheckedOnDate(widget.selectedDate??getTodayFormated()),
          onChanged: (C){
            setState(() {
              if(!C){
                widget.task.unCheckOnDate(widget.selectedDate??getTodayFormated());
              }else{
                widget.task.addCheck(widget.selectedDate??getTodayFormated());
              }
            });
            MyApp.dataModel.task(widget.task, context, CUD.Update);
          },
          activeColor: widget.task.color,

        ),
        subtitle: Wrap(
          direction: Axis.horizontal,

          children: <Widget>[
            Card(child:Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
              child: GText("${formatDouble(widget.task.value.toDouble())}\$/h",textType: TextType.textTypeSubNormal,
                color:  getValueColor(widget.task.value)),
            ),color: MyColors.color_black_darker),
            Visibility(
              visible: widget.task.description!='',
              child: Card(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                child: GIcon(Icons.receipt,size: 10),
              ),color: MyColors.color_black_darker),
            ),
            Visibility(
              visible: widget.task.getScheduled().length!=0&&widget.task.getScheduled()[0].repeatValue==1&&widget.task.getScheduled()[0].repeatRule==RepeatRule.EveryXDays,
              child: Card(child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GIcon(Icons.local_fire_department_rounded,size: 10),
                    GText(' ${widget.task.getStreakNumberForEveryday()} day(s) streak',textType: TextType.textTypeSubNormal,)
                  ],
                ),
              ),color: MyColors.color_black_darker),
            ),
          ],
        ),
        title: GText(widget.task.name),
        onLongPress: ()=>showAddEditObjectBottomSheet(
            context, selectedDate: widget.selectedDate,isInCalendar: false,
            add: false, object: widget.task,isTask: true
        ),
        trailing: Visibility(
          visible: !(widget.minimal??false),
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Card(
             child:GestureDetector(
              onLongPress: (){
                launchPage(context, PomodoroPage(object: widget.task,));
              },
              onTap: (){
                MyApp.dataModel.setPlaying(context, MyApp.dataModel.currentPlaying==(widget.task)?null:widget.task);
                ifStartTimer();
              },
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    GIcon(MyApp.dataModel.currentPlaying==(widget.task)?Icons.stop:Icons.play_arrow),
                  ],
                ),
              ),
            ),color: MyColors.color_black_darker),
          ),
        )
      ),
    );
  }

  ifStartTimer(){
    if(MyApp.dataModel.currentPlaying==(widget.task)){
      _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
        setState(() {
        });
      });
    }else if(_everySecond!=null)_everySecond.cancel();
  }
  Timer _everySecond;
}
