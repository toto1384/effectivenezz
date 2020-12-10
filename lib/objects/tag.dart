

import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

final String tagId = "_id";
final String tagName = "name";
final String tagColor = "color";
final String tagShow = "show";


class Tag{

  String id;
  String name;
  Color color;
  bool show;

  Tag({this.id,@required this.name,@required this.color,@required this.show});


  static Tag fromMapBackend(Map map){
    return Tag(
      color: Color(int.parse(map[tagColor])??0xffffff),
      name: map[tagName]??'',
      show: (map[tagShow]??false),
      id: map[tagId]??-1
    );
  }

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
  Map<String,dynamic> toMapBackend(){
    var map = {
      tagColor: color==null?Colors.white.value.toString():color.value.toString(),
      tagName:name,
      tagShow:show,
    };
    if(id!=null)map[tagId]=id;
    return map;
  }


}