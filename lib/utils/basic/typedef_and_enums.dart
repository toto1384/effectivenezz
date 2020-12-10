

import 'package:flutter/material.dart';
import 'package:sliding_sheet/sliding_sheet.dart';

typedef ReturnChild = Widget Function(BuildContext buildContext,Function closeTooltip);

typedef StateGetter = Widget Function( BuildContext buildContext , Function(Function) state);

typedef SheetStateGetter = Widget Function( BuildContext buildContext , Function(Function) state, SheetController sheetController);

typedef StateCloseGetter = Widget Function( BuildContext buildContext , Function(Function) state,Function close);

class TextType{

  final double size;
  final FontWeight fontWeight;
  const TextType(this.size,this.fontWeight);

  static indexOf(TextType textType){
    switch(textType){
      case TextType.textTypeSubMiniscule:return 0;
      case TextType.textTypeSubNormal:return 1;
      case TextType.textTypeNormal:return 2;
      case TextType.textTypeSubtitle:return 3;
      case TextType.textTypeTitle:return 4;
      case TextType.textTypeGigant:return 5;
    }
  }

  static TextType fromIndex(int index){
    switch(index){
      case 0:return TextType.textTypeSubMiniscule;
      case 1:return TextType.textTypeSubNormal;
      case 2:return TextType.textTypeNormal;
      case 3:return TextType.textTypeSubtitle;
      case 4:return TextType.textTypeTitle;
      case 5:return TextType.textTypeGigant;
    }
    return TextType.textTypeNormal;
  }

  static const TextType textTypeTitle =TextType(27,FontWeight.w800);
  static const TextType textTypeSubtitle =TextType(20,FontWeight.w700);
  static const TextType textTypeNormal =TextType(15,FontWeight.w600);
  static const TextType textTypeSubNormal =TextType(12,FontWeight.w400);
  static const TextType textTypeSubMiniscule =TextType(11,FontWeight.w300);
  static const TextType textTypeGigant =TextType(50,FontWeight.w900);

}

enum SelectedView{
  Day,ThreeDay,Week,Month
}

enum ObjectType{
  Activity,Task,Calendar,Scheduled,Tag
}

enum PlanTracked{
  Plan,Tracked,PlanVsTracked,
}

enum WhatToShow{
  Tasks,Activities,All
}

enum FABAction{
  AddTask,
}

enum RepeatRule{
  None,
  EveryXDays,
  EveryXWeeks,
  EveryXMonths,
}

enum RequestType{
  Post,
  Update,
  Delete,
  Query,
}
enum CUD{
  Create,Update,Delete
}



