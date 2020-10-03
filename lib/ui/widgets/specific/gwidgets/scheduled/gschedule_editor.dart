import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/scheduled/gduration_widget_for_scheduled.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/scheduled/grepeat_editor.dart';
import 'package:flutter/material.dart';

import 'gdate_time_edit_widget_for_scheduled.dart';

class GScheduleEditor extends StatefulWidget {

  final Scheduled scheduled;
  final Function(Scheduled) onScheduledChange;

  GScheduleEditor(this. scheduled, this. onScheduledChange);

  @override
  _GScheduleEditorState createState() => _GScheduleEditorState();
}

class _GScheduleEditorState extends State<GScheduleEditor> {
  @override
  Widget build(BuildContext context) {
    if(widget.onScheduledChange is Function){
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //starts

          GDateTimeEditWidgetForScheduled( onScheduledChange: widget.onScheduledChange,
              scheduled: widget.scheduled, isStartTime: true),
          (GDurationWidgetForScheduled( scheduled: widget.scheduled,
            onScheduledChange: widget.onScheduledChange,)),
          GRepeatEditor( widget.scheduled, (sc){
            setState((){
              widget.scheduled.repeatRule=sc.repeatRule;
              widget.scheduled.repeatUntil=sc.repeatUntil;
              widget.scheduled.repeatValue=sc.repeatValue;
            });
          }),
        ],
      );
    }else return Container();
  }
}
