
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sweetsheet/sweetsheet.dart';




class MyColors{
  static const Color color_primary = Color(0xffffffff);

  static const Color color_black = Color(0xff161A2B);
  static const Color color_black_darker = Color(0xff0E0F1E);


  static const Color color_gray_darker = Color(0xff2d3344);
  static const Color color_gray_lighter = Color(0xff5F6377);

  static const Color color_yellow = Color(0xffF0A500);
  static const Color color_yellow_darker = Color(0xffCF7500);

  static getHelpColor(){
    return color_yellow;
  }

  static getIconTextGray(){
    return color_gray_lighter;
  }

  static getGrayBackground(){
    return color_gray_darker;
  }

  static getOverFlowColor(){
    return MyColors.color_black;
  }

  static getBackgroundColor(){
    return MyColors.color_black;
  }

  static getIconTextColor(){
    return Colors.white;
  }

  static CustomSheetColor customSheetColor = CustomSheetColor(
      main: MyColors.color_yellow,
      accent: MyColors.color_yellow_darker,
      icon: MyColors.color_black_darker,
  );

}

class AssetsPath{
  static var checkboxAnimation = "assets/checkbox.flr";
  static var tick = 'assets/sounds/tick.mp3';
  static var emptyView = 'assets/empty_illustration.svg';
  static var r8020 = 'assets/time_doctor/80_20.svg';
  static var rParkinsonLaw = 'assets/time_doctor/parkinson_law.svg';
  static var theArtOfNotDoing = 'assets/time_doctor/the_art_of_not_doing.svg';
  static var typeA = 'assets/set_type/type_a.svg';
  static var typeB = 'assets/set_type/type_b.svg';
  static var icon= 'assets/logo.png';
  static var doctorIllustration=  "assets/welcome/doctor_illustration.png";
  static var metricIllustration =  "assets/welcome/metric_illustration.png";
  static var planningIllustration =  "assets/welcome/planning_illustration.png";
  static var timeIllustration =  "assets/welcome/time_illustration.png";


}