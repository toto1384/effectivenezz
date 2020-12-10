import 'package:intl/intl.dart';

import 'basic/typedef_and_enums.dart';

DateFormat _getDateFormat(){
  return DateFormat('yyyy-MM-dd HH:mm:sss.SSS');
}

DateTime getDateFromString(String string,{bool isUtc = false}){
  if(string==null||string.trim()==''){
    return null;
  }
  string= string.replaceAll("Z", "").replaceAll("T", " ");

  DateTime dateTime = _getDateFormat().parse(string,isUtc);
  if(dateTime.isUtc)dateTime=dateTime.toLocal();

  return dateTime;
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
    return '${dateTime.day} ${getMonthOfTheYearStringShort(dateTime.month, true)}';
  }
}

getTimeName(DateTime dateTime){
  if(dateTime==null)return "Not set";
  return "${dateTime.hour}:${dateTime.minute}";
}

getDayOfTheWeekStringShort(int dayOfTheWeek,bool big){
  switch(dayOfTheWeek-1){
    case 0 : return big?'Mon':"M";
    case 1 : return big?'Tue':"T";
    case 2 : return big?'Wed':"W";
    case 3 : return big?'Thu':"T";
    case 4 : return big?'Fri':"F";
    case 5 : return big?'Sat':"S";
    case 6 : return big?'Sun':"S";
  }
}

getMonthOfTheYearStringShort(int dayOfTheWeek,bool big){
  switch(dayOfTheWeek){
    case 1 : return big?'Jan':"J";
    case 2 : return big?'Feb':"F";
    case 3 : return big?'Mar':"M";
    case 4 : return big?'Apr':"A";
    case 5 : return big?'May':"M";
    case 6 : return big?'Jun':"J";
    case 7 : return big?'Jul':"J";
    case 8 : return big?'Aug':"A";
    case 9 : return big?'Sep':"S";
    case 10 : return big?'Oct':"O";
    case 11 : return big?'Nov':"N";
    case 12 : return big?'Dec':"D";
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
      return "Week ${weekNumber(dateTime)}";
      break;
    case SelectedView.Month:
      return getMonthOfTheYearStringShort(dateTime.month, true);
      break;
    default: return '';
  }

}

int weekNumber(DateTime date) {
  int dayOfYear = int.parse(DateFormat("D").format(date));
  return ((dayOfYear - date.weekday + 10) / 7).floor();
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