import 'package:intl/intl.dart';

import 'basic/typedef_and_enums.dart';

DateFormat _getDateFormat(){

  return DateFormat('HH:mm:ss : dd-MM-yyyy');
}

DateTime getDateFromString(String string){
  if(string==null||string.trim()==''){
    return null;
  }

  return _getDateFormat().parse(string);
}

String getStringFromDate(DateTime dateTime){
  if(dateTime==null){
    return '';
  }else{
    return _getDateFormat().format(dateTime);
  }

}
/////////////////

getTextFromDuration(Duration duration){
  if(duration == Duration.zero){
    return '';
  }
  List<String> durationString= "$duration".split('.');
  return durationString[0];
}

getDateName(DateTime dateTime){
  if(dateTime==null)return "Not set";
  if(dateTime.day==DateTime.now().day&&dateTime.month==DateTime.now().month&&dateTime.year==DateTime.now().year){
    return 'Today';
  }else if(dateTime.day-1==DateTime.now().day&&dateTime.month-1==DateTime.now().month&&dateTime.year-1==DateTime.now().year){
    return 'Tommorow';
  }else if(dateTime.day+1==DateTime.now().day&&dateTime.month+1==DateTime.now().month&&dateTime.year+1==DateTime.now().year){
    return 'Yesterday';
  }else{
    return '${dateTime.day}:${dateTime.month}';
  }
}

getTimeName(DateTime dateTime){
  if(dateTime==null)return "Not set";
  return "${dateTime.hour}:${dateTime.minute}";
}

getDayOfTheWeekStringShort(int dayOfTheWeek){
  switch(dayOfTheWeek){
    case 0 : return 'Mon';
    case 1 : return 'Tue';
    case 2 : return 'Wed';
    case 3 : return 'Thu';
    case 4 : return 'Fri';
    case 5 : return 'Sat';
    case 6 : return 'Sun';
  }
}

String minuteOfDayToHourMinuteString(int minuteOfDay,bool info) {
  return "${(minuteOfDay ~/ 60).toString().padLeft(2, "0")}"
      +(info?"h:":":")+
      "${(minuteOfDay % 60).toString().padLeft(2, "0")}"+(info?"m":"");
}

DateTime onlyDayFormat(DateTime dateTime){
  if(dateTime==null)return null;
  return DateTime(dateTime.year,dateTime.month,dateTime.day);
}


String getDatesNameForAppBarSelector(DateTime dateTime,SelectedView selectedView) {

  switch(selectedView){

    case SelectedView.Day:
      return getDateName(dateTime);
      break;
    case SelectedView.ThreeDay:
      List<String> dts= List.generate(3, (i)=>getDateName(dateTime.add(Duration(days: i))));
      return dts[0] + " - " + dts.last;
      break;
    case SelectedView.Week:
      List<String> dts= List.generate(7, (i)=>getDateName(dateTime.add(Duration(days: i))));
      return dts[0] + " - " + dts.last;
      break;
    case SelectedView.Month:
      List<String> dts= List.generate(30, (i)=>getDateName(dateTime.add(Duration(days: i))));
      return dts[0] + " - " + dts.last;
      break;
    default: return '';
  }

}

daysDifference(DateTime d1,DateTime d2){
  int difference = 0;
  difference+=d1.day-d2.day;
  difference+=(d1.month-d2.month)*30;
  difference+=(d1.year-d2.year)*365;
  return difference;
}

//BULK
List<DateTime> dateTimesFromString(String dates){
  List<String> listdates = dates.split(',');

  List<DateTime> dateTimes = List();

  listdates.forEach((item){
    if(item!=null&&item!=''){
      dateTimes.add(getDateFromString(item));
    }
  });

  return dateTimes;
}

String stringFromDateTimes(List<DateTime> dateTimes){
  String dateTimesString = '';
  if(dateTimes==null)return dateTimesString;
  dateTimes.forEach((item){
    dateTimesString = dateTimesString+ ',${getStringFromDate(item)}';
  });
  return dateTimesString;
}