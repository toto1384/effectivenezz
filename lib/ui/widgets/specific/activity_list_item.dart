import 'dart:async';
import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/pages/pomodoro_page.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/specific/task_list_item.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class ActivityListItem extends StatefulWidget{

  final DateTime selectedDate;
  final Activity activity;
  final Function onTap;
  final bool minimal;
  final Scheduled context;

  const ActivityListItem({Key key,@required this.selectedDate,@required this.activity,
    this.onTap,this.minimal, this.context}) : super(key: key);

  @override
  _ActivityListItemState createState() => _ActivityListItemState();
}

class _ActivityListItemState extends State<ActivityListItem>{
    List<Task> childs = [];

    bool includeChilds = false;

    @override
    void initState() {
//      if(childs.length==0){
//        childs=MyApp.dataModel.findTaskByActivity(widget.activity.id);
//      }
      super.initState();
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        ifStartTimer();
      });
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              onTap: (){
                if(widget.minimal??false){
                  if(widget.onTap!=null){
                    widget.onTap();
                  }else showObjectDetailsBottomSheet(
                      getGlobalContext(context), widget.activity,widget.selectedDate,
                      isInCalendar: false,sContext: widget.context);
                }else{
                  showObjectDetailsBottomSheet(
                      getGlobalContext(context), widget.activity,widget.selectedDate,
                      isInCalendar: false,sContext: widget.context);
                }
              },
              leading: CircleAvatar(
                maxRadius: 20,
                backgroundColor: widget.activity.color.withOpacity(.3),
                child: GIcon(widget.activity.icon,color: widget.activity.color),
              ),
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Card(child:Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                    child: GText("${formatDouble(widget.activity.value.toDouble())}\$/h",textType: TextType.textTypeSubNormal,
                      color:  getValueColor(widget.activity.value)),
                  ),color: MyColors.color_black_darker),
                  Visibility(
                    visible: childs.length!=0,
                    child: Card(child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                      child: GText("${childs.length} childs",textType: TextType.textTypeSubNormal),
                    ),color: MyColors.color_black_darker),
                  ),
                  Visibility(
                    visible: widget.activity.description!='',
                    child: Card(child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                      child: GIcon(Icons.receipt,size: 10),
                    ),color: MyColors.color_black_darker),
                  ),
                  Visibility(
                    visible: widget.activity.childs.length!=0,
                    child: Card(child:Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GIcon(Icons.check_circle,size: 10),
                          GText(" ${widget.activity.childs.length}",textType: TextType.textTypeSubNormal,)
                        ],
                      ),
                    ),color: MyColors.color_black_darker),
                  ),
                ],
              ),
              title: GText(widget.activity.name),
              onLongPress: ()=>showAddEditObjectBottomSheet(
                  context, selectedDate: widget.selectedDate,isInCalendar: false,
                  add: false, object: widget.activity,isTask: false
              ),
              trailing: Visibility(
                visible: !(widget.minimal??false),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Card(child:InkWell(
                        onLongPress: (){
                          launchPage(context, PomodoroPage(object: widget.activity,));
                        },
                        onTap: (){
                          MyApp.dataModel.setPlaying(context, MyApp.dataModel.isPlaying(widget.activity)?null:widget.activity);
                          ifStartTimer();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(3),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              GIcon(MyApp.dataModel.isPlaying(widget.activity)?Icons.stop:Icons.play_arrow),
                              // GText(getTextFromDuration(widget.activity.getTimeLeft(context))),
                            ],
                          ),
                        ),
                      ),color: MyColors.color_black_darker),
                    ),
                    Visibility(
                      visible: false,
                      child: IconButton(
                        icon: GIcon(includeChilds?Icons.arrow_drop_up:Icons.arrow_drop_down),
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
        ),
      );
    }
    ifStartTimer(){
      if(MyApp.dataModel.isPlaying(widget.activity)){
        _everySecond = Timer.periodic(Duration(seconds: 1), (Timer t) {
          setState(() {
          });
        });
      }else if(_everySecond!=null)_everySecond.cancel();
    }
    Timer _everySecond;
}
