import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';


class GDurationWidgetForScheduled extends StatefulWidget {

  final Scheduled scheduled;
  final Function(Scheduled) onScheduledChange;

  GDurationWidgetForScheduled({
    @required this. scheduled,
    @required this. onScheduledChange,
  });

  @override
  _GDurationWidgetForScheduledState createState() => _GDurationWidgetForScheduledState();
}

class _GDurationWidgetForScheduledState extends State<GDurationWidgetForScheduled> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: GText('Duration'),
        ),
        GButton(
          widget.scheduled.durationInMinutes == null
              ? "Set duration"
              : "${minuteOfDayToHourMinuteString(widget.scheduled.durationInMinutes,true)}",
          variant: 3,
          onPressed: () {
            showPickDurationBottomSheet(context, (d) {
              setState(() {
                widget.scheduled.durationInMinutes = (d??Duration.zero).inMinutes;
                widget.onScheduledChange(widget.scheduled);
              });
            });
          },
        ),
        Flexible(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Visibility(
                visible: widget.scheduled.startTime!=null,
                child: GText("(Ends on ${getStringFromDate(widget.scheduled.getEndTime())})")),
          ),
        )
      ],
    );
  }
}

