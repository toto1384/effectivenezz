import 'package:effectivenezz/objects/date_value_object.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/stats/line_chart.dart';
import 'package:effectivenezz/ui/widgets/stats/pie_chart.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:effectivenezz/utils/stats_utils.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

class GMetricWidget extends StatelessWidget {

  final Metric metric;
  final StatPeriod statPeriod;
  final DateTime dateTime;
  final Size big;

  GMetricWidget(this. metric, this. statPeriod,this. dateTime,this. big);

  @override
  Widget build(BuildContext context) {
    switch(metric){

      case Metric.focus:
        switch(statPeriod){

          case StatPeriod.day:
            List<TimeStamp> tracked =
            MyApp.dataModel.getTimeStamps(context, dateTimes: calculateSelectedDates(statPeriod, dateTime),tracked: true);

            double averageFocusMinutes = 0;
            tracked.forEach((element) {averageFocusMinutes=averageFocusMinutes+element.durationInMinutes;});
            if(averageFocusMinutes!=0)averageFocusMinutes=averageFocusMinutes/tracked.length;

            return GText("${minuteOfDayToHourMinuteString(averageFocusMinutes.toInt(),true)}",textType: getTextTypeFromSize(big));
            break;
          case StatPeriod.week:
          case StatPeriod.month:
            List<DateValueObject> data = [];
            calculateSelectedDates(statPeriod, dateTime).forEach((DateTime element) {
              List<TimeStamp> tracked =
              MyApp.dataModel.getTimeStamps(context, dateTimes: [element],tracked: true);

              double averageFocusMinutes = 0;
              tracked.forEach((element) {averageFocusMinutes+=element.durationInMinutes;});
              if(averageFocusMinutes!=0)averageFocusMinutes=averageFocusMinutes/tracked.length;

              data.add(DateValueObject(element,averageFocusMinutes.toInt()));
            });

            return LineChart(data: data,width: getLineChartSizeFromSize(context, big),);
            break;
        }

        break;
      case Metric.hour_value:


        switch(statPeriod){

          case StatPeriod.day:
            List<TimeStamp> tracked =
            MyApp.dataModel.getTimeStamps(context, dateTimes: calculateSelectedDates(statPeriod, dateTime),tracked: true);

            double averageHourValue = 0;
            int minutesTracked=0;

            tracked.forEach((element) {
              averageHourValue+=element.parent.value;
              minutesTracked+=element.durationInMinutes;
            });
            if(averageHourValue!=0)averageHourValue=averageHourValue/minutesTracked;

            return GText(formatDouble(averageHourValue)+'\$',textType: getTextTypeFromSize(big));
            break;
          case StatPeriod.week:
          case StatPeriod.month:
            List<DateValueObject> data = [];
            calculateSelectedDates(statPeriod, dateTime).forEach((element) {
              List<TimeStamp> tracked =
              MyApp.dataModel.getTimeStamps(context, dateTimes: [element],tracked: true);

              double averageHourValue = 0;
              int minutesTracked=0;

              tracked.forEach((element) {
                averageHourValue+=element.parent.value;
                minutesTracked+=element.durationInMinutes;
              });
              if(averageHourValue!=0)averageHourValue=averageHourValue/minutesTracked;

              data.add(DateValueObject(element,averageHourValue.toInt()));
            });
            return LineChart(data: data,width:  getLineChartSizeFromSize(context, big),);
            break;
        }

        break;
      case Metric.tracked_today:

        List<TimeStamp> tracked =
        MyApp.dataModel.getTimeStamps(context, dateTimes: calculateSelectedDates(statPeriod, dateTime),tracked: true);

        return PieChart(
          size: getPieChartSizeFromSize(big),
          data: TimeStamp.totalMinutesPerTrackable(tracked),
        );

        break;
    }
    return Center();
  }
}
