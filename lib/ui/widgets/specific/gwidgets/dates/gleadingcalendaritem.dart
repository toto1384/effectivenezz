import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../main.dart';

class GLeadingCalendarItem extends StatefulWidget {
  final TimeStamp timeStamp;
  final DateTime day;

  const GLeadingCalendarItem({Key key,@required this.timeStamp,@required this.day}) : super(key: key);
  @override
  _GLeadingCalendarItemState createState() => _GLeadingCalendarItemState();
}

class _GLeadingCalendarItemState extends State<GLeadingCalendarItem> {
  @override
  Widget build(BuildContext context) {
    return widget.timeStamp.isTask?Checkbox(
      value: widget.timeStamp.getParent().isCheckedOnDate(widget.day),
      onChanged: (C){
        if(!C){
          widget.timeStamp.getParent().
          unCheckOnDate(widget.day);
        }else{
          widget.timeStamp.getParent().checks.add(widget.day);
        }
        MyApp.dataModel.task(widget.timeStamp.parentId,
            widget.timeStamp.getParent(), context, CUD.Update);
      },
      activeColor: getContrastColor(widget.timeStamp.color),
    ):GIcon(widget.timeStamp.getParent().icon,
      color: getContrastColor(widget.timeStamp.color),);
  }
}
