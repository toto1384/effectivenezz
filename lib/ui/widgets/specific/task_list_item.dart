import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
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
  bool isMinimal;

  @override
  void initState() {
    isMinimal=MyApp.dataModel.prefs.getAppMode();
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

    return ListTile(
      onTap: (){
        if(widget.minimal??false){
          widget.onTap();
        }else{
          showObjectDetailsBottomSheet(getGlobalContext(context), widget.task,widget.selectedDate);
        }
      },
      leading: GestureDetector(
        child: getIcon(widget.task.isCheckedOnDate(widget.selectedDate??getTodayFormated())?Icons.check_circle_outline:Icons.radio_button_unchecked,color: widget.task.color,size: 35),
        onTap: (){
          if(widget.task.isCheckedOnDate(widget.selectedDate??getTodayFormated())){
            widget.task.unCheckOnDate(widget.selectedDate??getTodayFormated());
          }else{
            widget.task.checks.add(widget.selectedDate??getTodayFormated());
          }
          MyApp.dataModel.task(MyApp.dataModel.findObjectIndexById(widget.task), widget.task, context, CUD.Update);
        },
      ),
      subtitle: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          getBasicLinedBorder(Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
            child: getText("${formatDouble(widget.task.value.toDouble())}\$/h",textType: TextType.textTypeSubNormal,
              color:  getValueColor(widget.task.value)),
          )),
          Visibility(
            visible: widget.task.description!='',
            child: getBasicLinedBorder(Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
              child: getIcon(Icons.receipt,size: 10),
            )),
          ),
        ],
      ),
      title: getText(widget.task.name),
      onLongPress: ()=>showAddEditObjectBottomSheet(
          context, selectedDate: widget.selectedDate,
          add: false,index: MyApp.dataModel.findObjectIndexById(widget.task),
          object: widget.task,scheduled: widget.task.getScheduled(context)[0],isTask: true
      ),
      trailing: Visibility(
        visible: !(widget.minimal??false),
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: getBasicLinedBorder(GestureDetector(
            onTap: (){
              MyApp.dataModel.setPlaying(context, MyApp.dataModel.taskPlayingId==(widget.task.id)?null:widget.task);
              ifStartTimer();
            },
            child: Padding(
              padding: const EdgeInsets.all(3),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  getIcon(MyApp.dataModel.taskPlayingId==(widget.task.id)?Icons.stop:Icons.play_arrow),
                  getText(isMinimal?getTextFromDuration(widget.task.getTimeLeft(context)):getStringSchedule()),
                ],
              ),
            ),
          )),
        ),
      )
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
    if(isMinimal&&MyApp.dataModel.taskPlayingId==(widget.task.id)){
      _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
        setState(() {
        });
      });
    }else if(_everySecond!=null)_everySecond.cancel();
  }
  Timer _everySecond;
}
