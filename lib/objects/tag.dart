

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final String tagId = "tid";
final String tagName = "tna";
final String tagColor = "tco";
final String tagShow = "tsh";


class Tag{

  int id;
  String name;
  Color color;
  bool show;

  Tag({this.id,@required this.name,@required this.color,@required this.show});


  static Tag fromMap(Map map){
    return Tag(
      color: Color(map[tagColor]??0xffffff),
      name: map[tagName]??'',
      show: (map[tagShow]??0)==1,
      id: map[tagId]??-1
    );
  }

  Map<String,dynamic> toMap(){
    return {
      tagColor: color==null?Colors.white.value:color.value,
      tagId:id,
      tagName:name,
      tagShow:show?1:0,
    };
  }

}