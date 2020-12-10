import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Prefs{

  static Prefs _instance;
  static Future<Prefs> getInstance()async{

    if(_instance==null){
      _instance = Prefs();
    }

    if(_instance.sharedPreferences==null){
      _instance.sharedPreferences= await SharedPreferences.getInstance();
    }

    return _instance;

  }


  SharedPreferences sharedPreferences;

  double getHeightPerMinute(){
    double toreturn =(sharedPreferences.getInt(_PrefsValues.heightPerMinute)??20).toDouble()/10;
    return toreturn;
  }

  setHeightPerMinute(double hpm)async{
    await sharedPreferences.setInt(_PrefsValues.heightPerMinute, (hpm*10).toInt());
  }


  SelectedView getSelectedView(){
    int intSelectedView =sharedPreferences.getInt(_PrefsValues.selectedView)??0;
    return SelectedView.values[intSelectedView];
  }

  setSelectedView(SelectedView selectedView)async{
    await sharedPreferences.setInt(_PrefsValues.selectedView, SelectedView.values.indexOf(selectedView));
  }


  Future<bool> isFirstTime(String page)async{
    bool toreturn =((sharedPreferences.getBool(_PrefsValues.firstTime+page))??true);
    if(toreturn==true){
      await sharedPreferences.setBool(_PrefsValues.firstTime+page, false);
    }
    return toreturn;
  }


  getPromoCode(){
    String intSelectedView =sharedPreferences.getString(_PrefsValues.promoCode)??"";
    return intSelectedView;
  }

  setPromoCode(String selectedView)async{
    await sharedPreferences.setString(_PrefsValues.promoCode, selectedView);
  }


  getAuthToken(){
    String intSelectedView =sharedPreferences.getString(_PrefsValues.authToken)??"";
    return intSelectedView;
  }

  setAuthToken(String authToken)async{
    await sharedPreferences.setString(_PrefsValues.authToken, authToken);
  }


}

class _PrefsValues{
  static final heightPerMinute='hpm';
  static final selectedView = "sv";
  
  static final promoCode ='pc';
  static final authToken ='at';

  static final firstTime="ft";
}