
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/date_value_object.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/ui/widgets/stats/line_chart.dart';
import 'package:effectivenezz/ui/widgets/stats/pie_chart.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/cupertino.dart';

enum Metric{
  focus,
  tracked_today,
  hour_value
}

enum StatPeriod{
  day,
  week,
  month
}


getMetricName(Metric metric){
  switch(metric){

    case Metric.focus:
      return 'Focus(avg.)';
      break;
    case Metric.tracked_today:
      return 'Tracked';
      break;
    case Metric.hour_value:
      return 'Hour value(avg.)';
      break;
  }
}

Widget getMetricWidget(BuildContext context,Metric metric, StatPeriod statPeriod,DateTime dateTime,bool big){
  switch(metric){

    case Metric.focus:
      switch(statPeriod){

        case StatPeriod.day:
          List<TimeStamp> tracked =
            MyApp.dataModel.getTimeStamps(context, dateTimes: calculateSelectedDates(statPeriod, dateTime),tracked: true);

          double averageFocusMinutes = 0;
          tracked.forEach((element) {averageFocusMinutes=averageFocusMinutes+element.duration;});
          if(averageFocusMinutes!=0)averageFocusMinutes=averageFocusMinutes/tracked.length;

          return getText("${minuteOfDayToHourMinuteString(averageFocusMinutes.toInt(),true)}",textType: big?TextType.textTypeGigant:TextType.textTypeSubtitle);
          break;
        case StatPeriod.week:
        case StatPeriod.month:
          List<DateValueObject> data = [];
          calculateSelectedDates(statPeriod, dateTime).forEach((DateTime element) {
            List<TimeStamp> tracked =
              MyApp.dataModel.getTimeStamps(context, dateTimes: [element],tracked: true);

            double averageFocusMinutes = 0;
            tracked.forEach((element) {averageFocusMinutes+=element.duration;});
            if(averageFocusMinutes!=0)averageFocusMinutes=averageFocusMinutes/tracked.length;

            data.add(DateValueObject(element,averageFocusMinutes.toInt()));
          });

          return LineChart(data: data,width: !big?MediaQuery.of(context).size.width/10:null,);
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
            averageHourValue+=element.getParent().value;
            minutesTracked+=element.duration;
          });
          if(averageHourValue!=0)averageHourValue=averageHourValue/minutesTracked;

          return getText(formatDouble(averageHourValue)+'\$',textType: big?TextType.textTypeGigant:TextType.textTypeSubtitle);
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
              averageHourValue+=element.getParent().value;
              minutesTracked+=element.duration;
            });
            if(averageHourValue!=0)averageHourValue=averageHourValue/minutesTracked;

            data.add(DateValueObject(element,averageHourValue.toInt()));
          });
          return LineChart(data: data,width: !big?MediaQuery.of(context).size.width/10:null,);
          break;
      }

      break;
    case Metric.tracked_today:

      List<TimeStamp> tracked =
      MyApp.dataModel.getTimeStamps(context, dateTimes: calculateSelectedDates(statPeriod, dateTime),tracked: true);

      return PieChart(
        size: big?400:100,
        data: TimeStamp.totalMinutesPerTrackable(tracked),
      );

      break;
  }
  return Center();
}

List<DateTime> calculateSelectedDates(StatPeriod statPeriod, DateTime dateTime){
  int listCount = 0 ;

  switch(statPeriod){

    case StatPeriod.day:
      listCount=1;
      break;
    case StatPeriod.week:
      listCount=7;
      break;
    case StatPeriod.month:
      listCount=30;
      break;
  }

  return List.generate(listCount, (index) => dateTime.add(Duration(days: index-(listCount-1))));
}