import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';

class GDateTimeEditWidgetForScheduled extends StatelessWidget {


  final Function(Scheduled) onScheduledChange;
  final Scheduled scheduled;
  final bool isStartTime;
  final String text;
  final bool onlyTime;
  final Widget trailing;

  GDateTimeEditWidgetForScheduled({
    @required this. onScheduledChange,
    @required this. scheduled,
    @required this. isStartTime,
    this. text,
    this. onlyTime,
    this. trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Visibility(
                visible: text!="",
                child: Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
                    child: GText(text??(isStartTime?'Starts':'Ends'),maxLines: 3),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: GButton(
                  getTimeName(isStartTime?scheduled.startTime:scheduled.getEndTime()),
                  onPressed: () {
                    showDistivityTimePicker(context,
                        TimeOfDay.fromDateTime(
                            (isStartTime?scheduled.startTime:scheduled.getEndTime()) ?? getTodayFormated()
                        ),
                        onTimeSelected: (time) {
                          if (scheduled.startTime == null) {
                            scheduled.startTime = getTodayFormated();
                          }
                          if(time==null){
                            scheduled.startTime=null;
                          }else{
                            if(isStartTime){
                              scheduled.startTime = DateTime(
                                  scheduled.startTime.year,
                                  scheduled.startTime.month,
                                  scheduled.startTime.day, time.hour,
                                  time.minute,0);
                            }else{
                              scheduled.durationInMinutes = DateTime(
                                  scheduled.getEndTime().year,
                                  scheduled.getEndTime().month,
                                  scheduled.getEndTime().day,
                                  time.hour,
                                  time.minute
                              ).difference(scheduled.startTime).inMinutes;
                            }
                          }
                          onScheduledChange(scheduled);
                        });
                  },
                ),
              ),
              if(!(onlyTime??false))
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: GText('•'),
                ),
              if(!(onlyTime??false))
                GButton(
                  getDateName(isStartTime?scheduled.startTime:scheduled.getEndTime()),
                  onPressed: () {
                    showDistivityDatePicker(
                        context, onDateSelected: (date) {
                      if (scheduled.startTime == null) {
                        scheduled.startTime = getTodayFormated();
                      }
                      if(date==null){
                        scheduled.startTime=null;
                      }else{
                        if(isStartTime){
                          scheduled.startTime = DateTime(
                              date.year, date.month, date.day,
                              scheduled.startTime.hour,
                              scheduled.startTime.minute,0);
                        }else{
                          scheduled.durationInMinutes = DateTime(
                              date.year, date.month, date.day,
                              scheduled.getEndTime().hour, scheduled.getEndTime().minute
                          ).difference(scheduled.startTime).inMinutes;
                        }
                      }
                      onScheduledChange(scheduled);
                    });
                  },
                ),
            ],
          ),
        ),
        if(trailing!=null)
          trailing
      ],
    );
  }
}
