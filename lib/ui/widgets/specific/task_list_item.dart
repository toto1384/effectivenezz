import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:circular_check_box/circular_check_box.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/pages/pomodoro_page.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gswitchable.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class TaskListItem extends StatefulWidget {
  final Task task;
  final DateTime selectedDate;
  final Function onTap;
  final bool minimal;

  const TaskListItem({Key key,@required this.task,@required this.selectedDate,this.onTap,this.minimal}) : super(key: key);

  @override
  _TaskListItemState createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> with AfterLayoutMixin{

  @override
  void initState() {
    super.initState();
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
            widget.onTap();
          }else{
            showObjectDetailsBottomSheet(getGlobalContext(context), widget.task,widget.selectedDate);
          }
        },
        leading: CircularCheckBox(
          inactiveColor: widget.task.color,
          value: widget.task.isCheckedOnDate(widget.selectedDate??getTodayFormated()),
          onChanged: (C){
            if(!C){
              widget.task.unCheckOnDate(widget.selectedDate??getTodayFormated());
            }else{
              widget.task.checks.add(widget.selectedDate??getTodayFormated());
            }
            MyApp.dataModel.task(MyApp.dataModel.findObjectIndexById(widget.task), widget.task, context, CUD.Update);
          },
          activeColor: widget.task.color,

        ),
        subtitle: Row(
          mainAxisSize: MainAxisSize.min,
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
          ],
        ),
        title: GText(widget.task.name),
        onLongPress: ()=>showAddEditObjectBottomSheet(
            context, selectedDate: widget.selectedDate,
            add: false,index: MyApp.dataModel.findObjectIndexById(widget.task),
            object: widget.task,scheduled: widget.task.getScheduled(context)[0],isTask: true
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
                    GText(getTextFromDuration(widget.task.getTimeLeft(context))),
                  ],
                ),
              ),
            ),color: MyColors.color_black_darker),
          ),
        )
      ),
    );
  }

  getStringSchedule(){
    String schedule = "";

    if(widget.task.getScheduled(context)[0].startTime==null){
      return "Not scheduled";
    }

    if(!areDatesOnTheSameDay(widget.task.getScheduled(context)[0].startTime, getTodayFormated())){
      schedule = schedule+ getDateName(widget.task.getScheduled(context)[0].startTime) + " , ";
    }
    schedule = schedule+ getTimeName(widget.task.getScheduled(context)[0].startTime)+" -- ";

    if(!areDatesOnTheSameDay(widget.task.getScheduled(context)[0].getEndTime(), getTodayFormated())){
      schedule = schedule+ getDateName(widget.task.getScheduled(context)[0].getEndTime())+ " , ";
    }
    schedule = schedule+ getTimeName(widget.task.getScheduled(context)[0].getEndTime());

    return schedule;
  }

  @override
  void afterFirstLayout(BuildContext context) {
    ifStartTimer();
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
