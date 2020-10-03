import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/widgets/specific/distivity_animated_list_obj.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class GSortByCalendarListView extends StatelessWidget {

  final DateTime selectedDate;
  final bool areMinimal;
  final Function(dynamic) onSelected;
  final WhatToShow whatToShow;
  final bool scrollable;
  final ScrollController controller;


  GSortByCalendarListView(this. selectedDate,
      {this. areMinimal,
        this. onSelected,
        this. whatToShow,
        this. scrollable,
        this. controller,
      });


  @override
  Widget build(BuildContext context) {
    return DistivityAnimatedListObj(
      whatToShow: (whatToShow??WhatToShow.All),
      isObjectSuitableForHeader: (obj,ind){
        if(obj is Task && (whatToShow??WhatToShow.All)==WhatToShow.Activities)return false;
        if(obj is Activity && (whatToShow??WhatToShow.All)==WhatToShow.Tasks)return false;
        if(obj is Task){
          if(obj.isParentCalendar){
            //isParentCalendar
            if(ind ==MyApp.dataModel.eCalendars.length){
              //last index - no calendar
              //return true if no calendar as parent
              if(obj.parentId==-1)return true;
            }else{
              //return true if matches ids
              if(obj.parentId==MyApp.dataModel.eCalendars[ind].id)return true;
            }
          }else{
            //isnot
            if(ind==MyApp.dataModel.eCalendars.length){
              //last index - no calendar
              return true;
            }
          }
        }else if(obj is Activity){
          if(ind ==MyApp.dataModel.eCalendars.length){
            //last index - no calendar
            //return true if no calendar as parent
            if(obj.parentCalendarId==-1)return true;
          }else{
            //return true if matches ids
            if(obj.parentCalendarId==MyApp.dataModel.eCalendars[ind].id)return true;
          }
        }
        return false;
      },
      headerItemCount: MyApp.dataModel.eCalendars.length+1,
      getHeaderSelectedDate: (ind)=>[getTodayFormated()],
      getHeader: (ctx,ind){
        return Container(
          color: MyColors.color_black_darker,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: CircleAvatar(
                    maxRadius: 5,
                    backgroundColor: ind == MyApp.dataModel.eCalendars.length
                        ? Colors.white
                        : MyApp.dataModel.eCalendars[ind].color,
                  ),
                ),
                getSubtitle(ind == MyApp.dataModel.eCalendars.length
                    ? "No calendar"
                    : MyApp.dataModel.eCalendars[ind].name),
              ],
            ),
          ),
        );
      },
      areMinimal: areMinimal,
      onSelected: onSelected,
      scrollable: scrollable,
      scrollController: controller,
    );
  }
}
