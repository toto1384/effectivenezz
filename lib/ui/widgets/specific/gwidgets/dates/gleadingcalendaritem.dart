import 'package:circular_check_box/circular_check_box.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../main.dart';

class GLeadingCalendarItem extends StatefulWidget {
  final TimeStamp timeStamp;
  final DateTime day;
  final bool show;

  const GLeadingCalendarItem({Key key,@required this.timeStamp,@required this.day,@required this.show}) :
        super(key: key);
  @override
  _GLeadingCalendarItemState createState() => _GLeadingCalendarItemState();
}

class _GLeadingCalendarItemState extends State<GLeadingCalendarItem> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
     visible: widget.show,
     child: (widget.timeStamp.parent is Task)?CircularCheckBox(
       inactiveColor: getContrastColor(widget.timeStamp.color),
      value: widget.timeStamp.parent.isCheckedOnDate(widget.day),
      onChanged: (C){
        if(!C){
          widget.timeStamp.parent.
          unCheckOnDate(widget.day);
        }else{
          widget.timeStamp.parent.addCheck(widget.day);
        }
        MyApp.dataModel.task(widget.timeStamp.parent, context, CUD.Update);
      },
      checkColor: widget.timeStamp.color,
      activeColor: getContrastColor(widget.timeStamp.color),
    ):Container(width: 0,height: 0,));
    // GIcon(widget.timeStamp.getParent().icon,
    //   color: getContrastColor(widget.timeStamp.color),);
  }
}
