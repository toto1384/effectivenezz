import 'dart:ui';

import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/cupertino.dart';


final String ecalendarId = 'i';
final String ecalendarColor = 'co';
final String ecalendarName = 'na';
final String ecalendarDescription = 'd';
final String ecalendarParentId = 'p';
final String ecalendarShow = 's';
final String ecalendarThemesStart = 'ths';
final String ecalendarThemesEnd = 'the';
final String ecalendarValue = 'v';

class ECalendar{

  int id;

  Color color;
  String name;
  String description;

  bool show;
  int parentId;

  int value;
  List<DateTime> themesStart;
  List<DateTime> themesEnd;

  ECalendar({this.id,@required this.color,@required this.name,this.description,@required this.show,@required this.parentId,
    @required this.value,@required this.themesStart,@required this.themesEnd});


  static ECalendar fromMap(Map map){
    return ECalendar(
      color: Color(map[ecalendarColor]),
      name: map[ecalendarName],
      parentId: map[ecalendarParentId],
      show: map[ecalendarShow]==1,
      id: map[ecalendarId],
      description: map[ecalendarDescription]??'',
      themesEnd: dateTimesFromString(map[ecalendarThemesEnd]),
      themesStart: dateTimesFromString(map[ecalendarThemesStart]),
      value: map[ecalendarValue],
    );
  }

  Map<String,dynamic> toMap(){
    return {
      ecalendarColor: color.value,
      ecalendarName: name,
      ecalendarParentId:parentId,
      ecalendarShow:show?1:0,
      ecalendarId:id,
      ecalendarDescription:description,
      ecalendarValue:value,
      ecalendarThemesStart:stringFromDateTimes(themesStart),
      ecalendarThemesEnd:stringFromDateTimes(themesEnd)
    };
  }

}