
import '../date_n_strings.dart';

bool areDatesOnTheSameDay(DateTime dateTime1, DateTime dateTime2){
  if(dateTime1==null||dateTime2==null)return false;
  if(dateTime1.year==dateTime2.year&&dateTime1.month==dateTime2.month&&dateTime1.day==dateTime2.day){
    return true;
  }else{
    return false;
  }
}

DateTime getTodayFormated(){
  return getDateFromString(getStringFromDate(DateTime.now()));
}

Duration addDurations(Duration d1,Duration d2){
  return Duration(seconds: d1.inSeconds+d2.inSeconds);
}
Duration subtractDurations(Duration d1,Duration d2){
  return Duration(seconds: d1.inSeconds-d2.inSeconds);
}


