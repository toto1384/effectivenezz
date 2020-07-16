

import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/widgets/distivity_animated_list.dart';
import 'package:effectivenezz/ui/widgets/specific/task_list_item.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:flutter/material.dart';
import 'package:sticky_headers/sticky_headers/widget.dart';

import '../../../main.dart';
import 'activity_list_item.dart';


typedef GetHeaderSelectedDate = List<DateTime> Function(int indexHeader);

class DistivityAnimatedListObj extends StatefulWidget {

  final bool areMinimal;
  final Function(dynamic) onSelected;
  final WhatToShow whatToShow;
  final ScrollController scrollController;
  final int headerItemCount;
  final OnUpdate isObjectSuitableForHeader;
  final IndexedWidgetBuilder getHeader;
  final GetHeaderSelectedDate getHeaderSelectedDate;
  final bool scrollable;

  const DistivityAnimatedListObj(
      {Key key, this.areMinimal, this.onSelected,@required this.whatToShow, this.scrollController,@required this.headerItemCount,
        @required this.isObjectSuitableForHeader,@required this.getHeader,@required this.getHeaderSelectedDate, this.scrollable}) : super(key: key);



  @override
  _DistivityAnimatedListObjState createState() => _DistivityAnimatedListObjState();
}

class _DistivityAnimatedListObjState extends State<DistivityAnimatedListObj> {
  @override
  Widget build(BuildContext context) {

    bool visible = false;
    switch (widget.whatToShow) {
      case WhatToShow.Tasks:
        visible = MyApp.dataModel.tasks.length != 0;
        break;
      case WhatToShow.Activities:
        visible = MyApp.dataModel.activities.length != 0;
        break;
      case WhatToShow.All:
        visible = MyApp.dataModel.tasks.length != 0 ||
            MyApp.dataModel.activities.length != 0;
        break;
    }


    return !visible ? getEmptyView(
        context, "No upcoming tasks and activities") : (widget.scrollable??true)?
    ListView.builder(itemCount: widget.headerItemCount, itemBuilder:(ctx, ind)=>logik(ind),controller: widget.scrollController,)
        :Column(children: List.generate(widget.headerItemCount, logik),);
  }

  Widget logik(ind){
    List<Task> tasks = [];
    List<Activity> activities = [];

    if(tasks.length==0&&(widget.whatToShow==WhatToShow.All||widget.whatToShow==WhatToShow.Tasks))
      MyApp.dataModel.tasks.forEach((item) {
        if(widget.isObjectSuitableForHeader(item,ind)){
          tasks.add(item);
        }
      }
      );
    if(activities.length==0&&(widget.whatToShow==WhatToShow.All||widget.whatToShow==WhatToShow.Activities))
      MyApp.dataModel.activities.forEach((item) {
        if(widget.isObjectSuitableForHeader(item,ind)){
          activities.add(item);
        }
      }
      );
    bool visible = tasks.length+activities.length != 0;
    return Visibility(
      visible: visible,
      child: StickyHeader(
        header: widget.getHeader(context,ind),
        content: StatefulBuilder(
            builder: (context, ss) {
              return DistivityAnimatedList(
                onUpdate: (obj,index) {
                  bool shouldBigUpdate= false;

//                  if(index>=0){
//                    dynamic oldObject = ((obj is Task)?tasks:activities)[((obj is Task)?tasks:activities).indexOf(obj)];
//
//                    if(obj.getScheduled(context)[0].startTime!=oldObject.getScheduled(context)[0].startTime)shouldBigUpdate= true;
//                    if(obj.getScheduled(context)[0].repeatValue!=oldObject.getScheduled(context)[0].repeatValue)shouldBigUpdate= true;
//                    if(obj.getScheduled(context)[0].repeatRule!=oldObject.getScheduled(context)[0].repeatRule)shouldBigUpdate= true;
//                  }
                  ss((){
                    if (index >= 0) ((obj is Task)?tasks:activities)[(obj is Task)?index-activities.length:index] = obj;
                  });
                  return shouldBigUpdate;
                },
                isObjectSuitableForList: (obj)=>widget.isObjectSuitableForHeader(obj,ind),
                onAdd: (obj) {
                  if (!widget.isObjectSuitableForHeader(obj,ind)) {
                    return -1;
                  }
                  int index = (obj is Task)?(tasks.length + activities.length):(activities.length);
                  ((obj is Task)?tasks : activities).add(obj);
                  return index;
                },
                getObjectIndexInTheList: (obj){
                  int index = -1;
                  if(obj is Activity){
                    for(int i = 0 ;i < activities.length; i ++){
                      if(obj.id==activities[i].id){
                        index=i;
                      }
                    }
                  }else{
                    for(int i = 0 ;i < tasks.length; i ++){
                      if(obj.id==tasks[i].id){
                        index=i+activities.length;
                      }
                    }
                  }
                  return index;
                },
                onRemove: (obj,index) {
                  if (index != -1) ((obj is Task)?tasks:activities).remove(obj);
                  if(tasks.length+activities.length==0){
                    MyAppState.ss(context);
                  }
                },
                animatedListRemovedItemBuilder: (removedObject, d) {
                  return FadeTransition(
                      opacity: d,
                      child: Builder(builder: (ctx) {
                        if (removedObject is Activity) {
                          return ActivityListItem(
                            selectedDate: widget.getHeaderSelectedDate(ind)[0], activity: removedObject,
                            minimal: widget.areMinimal??false,onTap: () {
                            if (widget.onSelected != null) widget.onSelected(activities[ind]);
                          },
                          );
                        } else {
                          return TaskListItem(
                              selectedDate: widget.getHeaderSelectedDate(ind)[0], task: removedObject,
                              minimal: widget.areMinimal??false,onTap: () {
                                if (widget.onSelected != null) widget.onSelected(
                                    tasks[ind - activities.length]);
                              },
                          );
                        }
                      })
                  );
                },
                scrollPhysics: NeverScrollableScrollPhysics(),
                initialItemCount: tasks.length + activities.length,
                animatedListItemBuilder: (ctx, inde, anim) {
                  if (inde < activities.length) {
                    return FadeTransition(
                        opacity: anim, child: ActivityListItem(
                      selectedDate: widget.getHeaderSelectedDate(ind)[0], activity: activities[inde],
                      minimal: widget.areMinimal??false,onTap: () {
                        if (widget.onSelected != null) widget.onSelected(activities[inde]);
                      },
                    )
                    );
                  } else {
                    return FadeTransition(opacity: anim, child: TaskListItem(
                        selectedDate: widget.getHeaderSelectedDate(ind)[0],
                        task: tasks[inde - activities.length],minimal: widget.areMinimal??false,onTap: () {
                          if (widget.onSelected != null) widget.onSelected(
                              tasks[inde - activities.length]);
                        },
                    )
                    );
                  }
                },

              );
            }
        ),
      ),
    );
  }
}
