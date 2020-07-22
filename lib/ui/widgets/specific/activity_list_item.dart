import 'dart:async';

import 'package:after_layout/after_layout.dart';
import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/widgets/specific/task_list_item.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class ActivityListItem extends StatefulWidget{

  final DateTime selectedDate;
  final Activity activity;
  final Function onTap;
  final bool minimal;

  const ActivityListItem({Key key,@required this.selectedDate,@required this.activity,this.onTap,this.minimal}) : super(key: key);

  @override
  _ActivityListItemState createState() => _ActivityListItemState();
}

class _ActivityListItemState extends State<ActivityListItem> with AfterLayoutMixin{
    bool isMinimal;
    List<Task> childs = [];

    bool includeChilds = false;

    @override
    void initState() {
      isMinimal=MyApp.dataModel.prefs.getAppMode();
//      if(childs.length==0){
//        childs=MyApp.dataModel.findTaskByActivity(widget.activity.id);
//      }
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

      return Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            onTap: (){
              if(widget.minimal??false){
                widget.onTap();
              }else{
                showObjectDetailsBottomSheet(getGlobalContext(context), widget.activity,widget.selectedDate);
              }
            },
            leading: CircleAvatar(
              maxRadius: 20,
              backgroundColor: widget.activity.color,
              child: getIcon(widget.activity.icon),
            ),
            subtitle: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                getBasicLinedBorder(Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                  child: getText("${formatDouble(widget.activity.value.toDouble())}\$/h",textType: TextType.textTypeSubNormal,
                    color:  getValueColor(widget.activity.value)),
                )),
                Visibility(
                  visible: childs.length!=0,
                  child: getBasicLinedBorder(Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                    child: getText("${childs.length} childs",textType: TextType.textTypeSubNormal),
                  )),
                ),
                Visibility(
                  visible: widget.activity.description!='',
                  child: getBasicLinedBorder(Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                    child: getIcon(Icons.receipt,size: 10),
                  )),
                ),
              ],
            ),
            title: getText(widget.activity.name),
            onLongPress: ()=>showAddEditObjectBottomSheet(
                context, selectedDate: widget.selectedDate,
                add: false,index: MyApp.dataModel.findObjectIndexById(widget.activity),
                object: widget.activity,scheduled: widget.activity.getScheduled(context)[0],isTask: false
            ),
            trailing: Visibility(
              visible: !(widget.minimal??false),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: getBasicLinedBorder(GestureDetector(
                      onTap: (){
                        MyApp.dataModel.setPlaying(context, MyApp.dataModel.activityPlayingId==widget.activity.id?null:widget.activity);
                        ifStartTimer();
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            getIcon(MyApp.dataModel.activityPlayingId==widget.activity.id?Icons.stop:Icons.play_arrow),
                            getText(isMinimal?getTextFromDuration(widget.activity.getTimeLeft(context)):getStringSchedule()),
                          ],
                        ),
                      ),
                    )),
                  ),
                  Visibility(
                    visible: false,
                    child: IconButton(
                      icon: getIcon(includeChilds?Icons.arrow_drop_up:Icons.arrow_drop_down),
                      onPressed: (){
                        setState(() {
                          includeChilds=!includeChilds;
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ),
          if(includeChilds)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(childs.length, (index){
                  return TaskListItem(
                    selectedDate: widget.selectedDate,
                    task: childs[index],
                  );
                }),
              ),
            ),
        ],
      );
    }

    getStringSchedule(){
      String schedule = "";

      if(widget.activity.getScheduled(context)[0].startTime==null){
        return "Not scheduled";
      }

      if(!areDatesOnTheSameDay(widget.activity.getScheduled(context)[0].startTime, getTodayFormated())){
        schedule = schedule+ getDateName(widget.activity.getScheduled(context)[0].startTime) + " , ";
      }
      schedule = schedule+ getTimeName(widget.activity.getScheduled(context)[0].startTime)+" -- ";

      if(!areDatesOnTheSameDay(widget.activity.getScheduled(context)[0].getEndTime(), getTodayFormated())){
        schedule = schedule+ getDateName(widget.activity.getScheduled(context)[0].getEndTime())+ " , ";
      }
      schedule = schedule+ getTimeName(widget.activity.getScheduled(context)[0].getEndTime());

      return schedule;
    }

    @override
    void afterFirstLayout(BuildContext context) {
      ifStartTimer();
    }
    ifStartTimer(){
      if(isMinimal&&MyApp.dataModel.activityPlayingId==(widget.activity.id)){
        _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
          setState(() {
          });
        });
      }else if(_everySecond!=null)_everySecond.cancel();
    }
    Timer _everySecond;
}
