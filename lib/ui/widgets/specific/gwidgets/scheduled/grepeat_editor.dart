import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:flutter/material.dart';

class GRepeatEditor extends StatefulWidget {

  final Scheduled scheduled;
  final Function(Scheduled) onScheduledChange;

  const GRepeatEditor(this.scheduled, this.onScheduledChange,{Key key}) : super(key: key);

  @override
  _GRepeatEditorState createState() => _GRepeatEditorState();
}

class _GRepeatEditorState extends State<GRepeatEditor> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: GText('Repeats'),
        ),
        GButton(
          getRepeatText(widget.scheduled.repeatRule, widget.scheduled.repeatValue),
          variant: 3,
          onPressed: (){
            showRepeatEditBottomSheet(context, onUpdate: (rr,rv,ru){
              setState((){
                widget.scheduled.repeatRule=rr;
                widget.scheduled.repeatValue=rv;
                widget.scheduled.repeatUntil=ru;
                if(widget.scheduled.startTime==null)widget.scheduled.startTime=
                    getTodayFormated();
                widget.onScheduledChange(widget.scheduled);
              });
            }, repeatRule: widget.scheduled.repeatRule,
              repeatValue: widget.scheduled.repeatValue,repeatUntil: widget.scheduled.repeatUntil);
          },
        ),
      ],
    );
  }
}

