import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

import 'gwidgets/gicon.dart';

class DistivityFAB extends StatefulWidget {
  final Function(Function,Function) controllerLogic;
  final bool isInCalendar;

  const DistivityFAB({Key key,@required this.controllerLogic,@required this.isInCalendar}) : super(key: key);

  @override
  _DistivityFABState createState() => _DistivityFABState();
}

class _DistivityFABState extends State<DistivityFAB> with TickerProviderStateMixin{

  bool extended = false;

  AnimationController animation ;
  AnimationController _hideFabAnimation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this,duration: Duration(milliseconds: 200));
    _hideFabAnimation = AnimationController(vsync: this, duration: Duration(milliseconds: 200),value: 1);
    if(widget.controllerLogic!=null)widget.controllerLogic(()=>_hideFabAnimation.forward(),()=>_hideFabAnimation.reverse());
  }

  @override
  void dispose() {
    animation.dispose();
    _hideFabAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _hideFabAnimation,
      child: SpeedDial(
        controller: animation,
        child: GIcon(Icons.add,color: MyColors.color_black_darker,),
        openBackgroundColor: MyColors.color_yellow,
        closedBackgroundColor: MyColors.color_yellow,
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            backgroundColor: MyColors.color_yellow,
            label: 'Add Event',
            child: GIcon(Icons.event,color: MyColors.color_black_darker,),
            onPressed: ()=>showAddEditObjectBottomSheet(context, isInCalendar: widget.isInCalendar,
                selectedDate: getTodayFormated(), add: true,isTask: false),
          ),
          SpeedDialChild(
            backgroundColor: MyColors.color_yellow,
            label: 'Add Task',
            child: GIcon(Icons.event_available,color: MyColors.color_black_darker,),
            onPressed: ()=>showAddEditObjectBottomSheet(context,isInCalendar: widget.isInCalendar,
                selectedDate: getTodayFormated(), add: true,isTask: true),
          ),
        ],
      ),
    );
  }
}

