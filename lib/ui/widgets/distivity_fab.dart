

import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:simple_speed_dial/simple_speed_dial.dart';

class DistivityFAB extends StatefulWidget {
  final Function(Function,Function) controllerLogic;

  const DistivityFAB({Key key,@required this.controllerLogic}) : super(key: key);

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
        child: getIcon(Icons.add),
        openBackgroundColor: MyColors.color_gray_darker,
        closedBackgroundColor: MyColors.color_gray_darker,
        speedDialChildren: <SpeedDialChild>[
          SpeedDialChild(
            backgroundColor: MyColors.color_gray_darker,
            label: 'Add Event',
            child: getIcon(Icons.event),
            onPressed: ()=>showAddEditObjectBottomSheet(context, selectedDate: getTodayFormated(), add: true,isTask: false),
          ),
          SpeedDialChild(
            backgroundColor: MyColors.color_gray_darker,
            label: 'Add Task',
            child: getIcon(Icons.event_available),
            onPressed: ()=>showAddEditObjectBottomSheet(context, selectedDate: getTodayFormated(), add: true,isTask: true),
          ),
        ],
      ),
    );
  }
}

