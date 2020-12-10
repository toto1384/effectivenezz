import 'dart:ui';

import 'package:flutter/cupertino.dart';


final String ecalendarId = '_id';
final String ecalendarColor = 'color';
final String ecalendarName = 'name';
final String ecalendarDescription = 'description';
final String ecalendarShow = 'show';
final String ecalendarValue = 'value';
final String ecalendarValueMultiply = 'valueMultiply';

class ECalendar{

  String id;

  Color color;
  String name;
  String description;

  bool show;

  int value;

  ECalendar({this.id,@required this.color,@required this.name,this.description,@required this.show,
    @required this.value,});


  static ECalendar fromMap(Map map){
    return ECalendar(
      color: Color(map[ecalendarColor]),
      name: map[ecalendarName],
      show: map[ecalendarShow]==1,
      id: map[ecalendarId],
      description: map[ecalendarDescription]??'',
      value: map[ecalendarValue],
    );
  }



  Map<String,dynamic> toMap(){
    return {
      ecalendarColor: color.value,
      ecalendarName: name,
      ecalendarShow:show?1:0,
      ecalendarId:id,
      ecalendarDescription:description,
      ecalendarValue:value,
    };
  }


  static ECalendar fromMapBackend(Map map){
    return ECalendar(
      color: Color(int.parse(map[ecalendarColor])),
      name: map[ecalendarName],
      show: map[ecalendarShow],
      id: map[ecalendarId],
      description: map[ecalendarDescription]??'',
      value: map[ecalendarValue],
    );
  }



  Map<String,dynamic> toMapBackend(){
    var map = {
      ecalendarColor: color.value.toString(),
      ecalendarName: name,
      ecalendarShow:show,
      ecalendarValue:value,
      ecalendarDescription:description??"",
    };
    if(id!=null)map[ecalendarId]=id;
    return map;
  }

}