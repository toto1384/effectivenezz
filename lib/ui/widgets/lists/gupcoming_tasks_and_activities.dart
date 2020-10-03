import 'package:effectivenezz/ui/widgets/specific/distivity_animated_list_obj.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';


class GUpcomingTasksAndActivities extends StatelessWidget {


  final ScrollController controller;

  GUpcomingTasksAndActivities(this. controller);

  @override
  Widget build(BuildContext context) {
    return DistivityAnimatedListObj(
      scrollController: controller,
      getHeader: (ctx,ind){
        DateTime listDate = ind==7?null:getTodayFormated().add(Duration(days: ind));
        return Container(
          child: Row(
            children: <Widget>[
              getSubtitle(ind == 7 ? "No date" : getDateName(listDate)),
            ],
          ), color: MyColors.color_black_darker,
        );
      },
      getHeaderSelectedDate: (ind){
        return [ind==7?null:getTodayFormated().add(Duration(days: ind))];
      },
      headerItemCount: 8,
      isObjectSuitableForHeader: (item, ind){
        DateTime listDate = ind==7?null:getTodayFormated().add(Duration(days: ind));
        if (item.getScheduled(context)[0].isOnDates(context, [listDate])) {
          return true;
        }return false;
      },
      whatToShow: WhatToShow.All,
      areMinimal: false,
    );
  }
}
