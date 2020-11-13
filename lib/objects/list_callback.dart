

import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';

class ListCallback{
  List<Function(dynamic,CUD)> listens  = [];

  ListCallback();

  listen(Function(dynamic,CUD) function){
    listens.add(function);
  }

  notifyAdd(dynamic object){
    listens.forEach((element) {
      element(object,CUD.Create);
    });
  }

  notifyRemoved(dynamic object){
    listens.forEach((element) {
      element(object,CUD.Delete);
    });
  }

  notifyUpdated(dynamic object){
    listens.forEach((element) {
      element(object,CUD.Update);
    });
  }
}


class ScheduledCallback{
  List<Function(Scheduled)> listens  = [];

  Scheduled newScheduled;

  ScheduledCallback();

  listen(Function(Scheduled) function){
    listens.add(function);
  }

  notifyUpdated(Scheduled object){
    newScheduled=object;
    listens.forEach((element) {
      element(object);
    });
  }
}