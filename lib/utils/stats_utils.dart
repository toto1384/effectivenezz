
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
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

enum Size{
  Small,Medium,Large
}

TextType getTextTypeFromSize(Size size){
  switch(size){

    case Size.Small:
      return TextType.textTypeNormal;
      break;
    case Size.Medium:
      return TextType.textTypeSubtitle;
      break;
    case Size.Large:
      return TextType.textTypeTitle;
      break;
  }
  return TextType.textTypeNormal;
}

getLineChartSizeFromSize(BuildContext context , Size size){
  switch(size){

    case Size.Small:
      return MyApp.dataModel.screenWidth/10;
      break;
    case Size.Medium:
      return MyApp.dataModel.screenWidth/5;
      break;
    case Size.Large:
      return null;
      break;
  }
}

double getPieChartSizeFromSize(Size size){
  switch(size){
    
    case Size.Small:
      return 100;
      break;
    case Size.Medium:
      return 250;
      break;
    case Size.Large:
      return 400;
      break;
  }
  return 0;
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