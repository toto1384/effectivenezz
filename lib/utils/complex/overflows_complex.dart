import 'dart:io';

import 'package:circular_check_box/circular_check_box.dart';
import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/calendar.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gswitchable.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext_field.dart';
import 'package:effectivenezz/ui/widgets/lists/gsort_by_calendar_list_view.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/dates/gtracked_intervals_widget.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gempty_view.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ginfo_icon.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gtab_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/scheduled/gschedule_editor.dart';
import 'package:effectivenezz/ui/widgets/specific/task_list_item.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis/drive/v2.dart';

import '../../main.dart';



showAddEditObjectBottomSheet(
    BuildContext context,{dynamic object,int index,bool add,
      @required DateTime selectedDate,Scheduled scheduled,@required bool isTask}){


  if(!isTask){
    if(object==null){
      object=Activity(
        tags: [],
        name: '',
        valueMultiply: false,
        parentCalendarId: -1,
        trackedEnd: [],
        trackedStart: [],
        value: 0,
        icon: Icons.mail,
      );
    }
  }else{
    if(object==null){
      object=Task(
        name: '',
        tags: [],
        valueMultiply: false,
        isParentCalendar: true,
        checks: [],
        parentId: -1,
        trackedEnd: [],
        trackedStart: [],
        value: 0,
      );
    }
  }

  if(scheduled==null){
    scheduled= Scheduled(
      repeatValue: 0,
      repeatRule: RepeatRule.None,
      isParentTask: true,
    );
  }

  if(add==null)add=false;
  TextEditingController nameEditingController = TextEditingController(text: object.name??'');
  TextEditingController descriptionEditingController = TextEditingController(text: object.description??'');


  showDistivityModalBottomSheet(context, (ctx,ss){
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //text field and send
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: GTextField(
                      nameEditingController, hint: 'Name goes here',
                      textInputType: TextInputType.text,variant: 2,textType: TextType.textTypeSubtitle),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(7),
                child: IconButton(
                  icon: GIcon(Icons.send,size: TextType.textTypeSubtitle.size*1.5),
                  onPressed: (){
                    if(scheduled.durationInMinutes<0){
                      Fluttertoast.showToast(
                          msg: "End time can not be sooner than start time",
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.CENTER,
                          timeInSecForIosWeb: 3,
                          backgroundColor: MyColors.color_black,
                          textColor: Colors.white,
                          fontSize: 16.0
                      );
                    }else{
                      object.name = nameEditingController.text;
                      object.description = descriptionEditingController.text;
                      if(object is Task){
                        if(!object.isParentCalendar){
                          Activity newAct =
                            MyApp.dataModel.findActivityById(object.parentId)..childs.add(object);
                          MyApp.dataModel.activities[MyApp.dataModel.findObjectIndexById(newAct)]=newAct;
                        }
                        MyApp.dataModel.task(index, object, context, add?CUD.Create:CUD.Update,addWith: scheduled);
                      }else{
                        MyApp.dataModel.activity(index, object, context, add?CUD.Create:CUD.Update,addWith: scheduled);
                      }
                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
          //set parent
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: ListTile(
              leading: CircleAvatar(
                maxRadius: 15,
                backgroundColor: MyApp.dataModel.findParentColor(object),
              ),
              title: GText(MyApp.dataModel.findParentName(object)),
              onTap: (){
                showSelectParentBottomSheet(context, taskOrActivity: object, onSelected: (i,b){
                  ss((){
                    if(object is Task){
                      if(object.color==null||object.color==(object.isParentCalendar?
                        MyApp.dataModel.findECalendarById(object.parentId).color:MyApp.dataModel.
                        findActivityById(object.parentId).color)){
                        if(b){
                          object.color=MyApp.dataModel.findECalendarById(i).color;
                        }else{
                          object.color=MyApp.dataModel.findActivityById(i).color;
                        }
                      }
                      object.parentId=i;
                      object.isParentCalendar=b;
                      if(object.value==0){
                        if(!b){
                          object.value=MyApp.dataModel.findActivityById(i).value;
                        }
                      }
                    }else if(object is Activity){
                      if(object.color==null||object.color==MyApp.dataModel.
                        findECalendarById(object.parentCalendarId).color){
                        object.color=MyApp.dataModel.findECalendarById(i).color;
                      }
                      object.parentCalendarId=i;
                    }
                  });
                });
              },
            ),
          ),
          //set icon
          if(object is Activity)
            ListTile(
              leading: CircleAvatar(
                child: GIcon(object.icon??Icons.not_interested,color: getContrastColor(object.color??Colors.white),size: 18),
                backgroundColor: object.color??Colors.white,
                maxRadius: 15,
              ),
              onTap: (){
                FlutterIconPicker.showIconPicker(
                    context,
                    title: getSubtitle("Pick Icon"),
                    showTooltips: true,
                    iconPackMode: IconPack.material,
                    backgroundColor: MyColors.color_black,
                    iconColor: Colors.white,
                    closeChild: GButton("Close",onPressed: ()=>Navigator.pop(context))

                ).then((value) => ss((){
                  object.icon=value;
                }));
              },
              title: GText('Set Icon'),
            ),

          Divider(),
          getSubtitle('Schedule'+(object is Task?' task':' activity')),
          GScheduleEditor(scheduled, (sc){
            ss((){
              scheduled=sc;
            });
          }),
          Divider(),
          ExpansionTile(
            title: Padding(
              padding: const EdgeInsets.all(7),
              child: GText('Advanced',textType: TextType.textTypeSubtitle,underline: true),
            ),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10,left: 7),
                child: ListTile(
                  leading: CircleAvatar(
                    maxRadius: 15,
                    backgroundColor: object.color??Colors.white,
                  ),
                  title: GText('Set Color'),
                  onTap: (){
                    showEditColorBottomSheet(context,object.color??MyApp.dataModel.findParentColor(object),(col){
                      ss((){
                        object.color=col;
                      });
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10,left: 7),
                child: ListTile(
                  leading: CircleAvatar(
                    maxRadius: 15,
                    backgroundColor: object.color??Colors.white,
                    child: GIcon(Icons.attach_money,color: getContrastColor(object.color)),
                  ),
                  title: GText('Set value(${formatDouble(object.value.toDouble()??0)}\$/hour)'),
                  onTap: (){
                    showHourValuePopup(context, value: object.value.toDouble(), isMultiply: object.valueMultiply, onSelectedValueAndBool: (v,i){
                      ss((){
                        object.value=v;
                        object.valueMultiply=i;
                      });
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 30,top: 10,right: 20,left: 20),
                child: Center(child: GTextField(descriptionEditingController,textInputType: TextInputType.multiline,hint: 'Description goes here'),),
              ),
            ],
          ),
        ],
      );
  },initialSnapping: .3);
}

showHourValuePopup(BuildContext context,{@required double value,@required bool isMultiply,@required Function(int,bool) onSelectedValueAndBool}){
  value=backwardFigures(value);

  showDistivityDialog(context, actions: [GButton("Set", onPressed: (){
    onSelectedValueAndBool(figures(value??0.0).toInt(),isMultiply);
    Navigator.pop(context);
  })], title: "Set \$/hour", stateGetter: (ctx,ss){

    return Slider(value: value??0.0, onChanged: (v){
      ss((){
        value=v;
      });
    },min: 0,max: 14,divisions: 14,label: "${formatDouble(figures(value??0.0))}\$",);
  });
}

double figures(double figures){
  double result = 10;
  if(figures==7){
    return 0.0;
  }else if(figures<7){
    result=1000000;
    for(int i = 0; i<figures;i++){
      result=result/10;
    }
    return -result;
  }else if(figures>7){
    for(int i = 0; i<figures-8;i++){
      result=result*10;
    }
    return result;
  }
  return result;
}

double backwardFigures(double value){
  double result = 10;
  if(value==0){
    return 7;
  }else if(value<0){
    return 7-value.toString().split(".")[0].split("-").last.length.toDouble();
  }else if(value>0){
    return value.toString().split(".")[0].split("-").last.length.toDouble()+6;
  }
  return result;
}


showReplacePlayableBottomSheet(BuildContext context,dynamic currentPlaying){

  String title = (currentPlaying is Task)?"Replace Task":"Replace Activity";

  Function(dynamic) onSelected = (obj){
    obj.trackedStart.add(currentPlaying.trackedStart.last);

    MyApp.dataModel.currentPlaying=obj;
    if(obj is Task){
      MyApp.dataModel.task(MyApp.dataModel.findObjectIndexById(obj), obj, context, CUD.Update);
    }else if(obj is Activity){
      MyApp.dataModel.activity(MyApp.dataModel.findObjectIndexById(obj), obj, context, CUD.Update);
    }

    (currentPlaying.trackedStart as List<DateTime>).removeLast();

    if(currentPlaying is Task){
      MyApp.dataModel.task(MyApp.dataModel.findObjectIndexById(currentPlaying), currentPlaying, context, CUD.Update);
    }else if(currentPlaying is Activity){
      MyApp.dataModel.activity(MyApp.dataModel.findObjectIndexById(currentPlaying), currentPlaying, context, CUD.Update);
    }

    if(!kIsWeb){
        MyApp.dataModel.notificationHelper.displayNotification(
          id: 0,
          title: obj.name,
          body: "For more info in a popup tap me(beta)",
          payload: "tracked",
          color: obj.color,
        );
    }

    Navigator.pop(context);
  };

  showDistivityModalBottomSheet(context, (ctx,ss){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getSubtitle(title),
            GInfoIcon(
                "By selecting any Task or Activity from this list, they will replace the timestamp from "+
                "${getTimeName((currentPlaying.trackedStart??[getTodayFormated()]).last)} • ${getDateName((currentPlaying.trackedStart??[getTodayFormated()]).last)},"+
                " that is currently occupied by: ${currentPlaying.name}"),
          ],
        ),
        GSortByCalendarListView(
            getTodayFormated(),
            areMinimal: true,
            scrollable: false,
            whatToShow: WhatToShow.All,
            onSelected: (s){
              ss((){
                onSelected(s);
              });
            }
        ),
      ],
    );
  });
}

showObjectDetailsBottomSheet(BuildContext context, dynamic object,DateTime selectedDate){
  bool isActivity = object is Activity;

  showDistivityModalBottomSheet(context, (ctx,ss){
    return Column(
      mainAxisSize: MainAxisSize.min,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if(!isActivity)
                CircularCheckBox(
                  inactiveColor: object.color,
                  value: object.isCheckedOnDate(selectedDate??getTodayFormated()),
                  onChanged: (C){
                    ss(() {
                      if(!C){
                        object.unCheckOnDate(selectedDate??getTodayFormated());
                      }else{
                        object.addCheck(selectedDate??getTodayFormated());
                      }
                    });
                    MyApp.dataModel.task(MyApp.dataModel.findObjectIndexById(object), object, context, CUD.Update);
                  },
                  activeColor: object.color,

                ),
              Flexible(
                child: getSubtitle(object.name,isCentered: false),
              ),
              GButton("Edit", onPressed: (){
                Navigator.pop(context);
                showAddEditObjectBottomSheet(
                    context, selectedDate: selectedDate,
                    object: object,add: false,index: MyApp.dataModel.findObjectIndexById(object),
                    scheduled: object.getScheduled(context)[0],isTask: true);
              })
            ],
          ),
        ),
        if(object.description!="")Divider(),
        if(object.description!="")getSubtitle('Description'),
        if(object.description!="")Padding(
          padding: const EdgeInsets.all(15),
          child: GText(object.description),
        ),
        Divider(),
        ListTile(
          leading: GIcon(Icons.attach_money),
          title: GText("${formatDouble(object.value.toDouble())} \$/hour"),
        ),
        if(object is Task)
          Visibility(
            visible: object.getScheduled(context)[0].repeatValue==1&&object.getScheduled(context)[0].repeatRule==RepeatRule.EveryXDays,
            child: ListTile(
              leading: GIcon(Icons.local_fire_department_rounded),
              title: GText("${object.getStreakNumberForEveryday()} day(s) streak"),
            )
          ),
        Divider(),
        ListTile(
          leading: GIcon(Icons.delete_outline),
          title: GText('Delete task'),
          onTap: (){
            if(isActivity){
              MyApp.dataModel.activity(
                  MyApp.dataModel.findObjectIndexById(object), object, context, CUD.Delete,withScheduleds: true);
            }else{
              MyApp.dataModel.task(
                  MyApp.dataModel.findObjectIndexById(object), object, context, CUD.Delete,withScheduleds: true);
            }
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: GIcon(Icons.av_timer),
          title: GText('See tracking history'),
          onTap: (){
            showDistivityModalBottomSheet(context, (ctx,ss){
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GText("Tracked",textType: TextType.textTypeSubtitle),
                  if(object.trackedStart.length==0)
                    GEmptyView("No timestamps",),
                  GTrackedIntervalsWidget(object)
                ],
              );
            });
          },
        ),
        if(object is Activity)Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            getSubtitle('Sub-tasks'),
          ]+List.generate(object.childs.length, (i){
            return TaskListItem(task: MyApp.dataModel.tasks[MyApp.dataModel.tasks.indexOf(object.childs[i])],
              selectedDate: getTodayFormated(),minimal: true,);
          },)+[ GButton('Add task', onPressed: (){
            showAddEditObjectBottomSheet(
              context,
              selectedDate: getTodayFormated(),
              isTask: true,
              add: true,
              object: Task(
                  name: '',
                  trackedEnd: [],
                  trackedStart: [],
                  parentId: object.id,
                  isParentCalendar: false,
                  value: object.value,
                  checks: [],
                  valueMultiply: false,
                  tags: [],
                  color: object.color
              ),
            );
          })],
        )
//        getSubtitle("Tracked"),
//        if(object.trackedStart.length==0)
//          getEmptyView(context, "No timestamps")
      ]//+getTrackedIntervalsWidget(context,object, object.color),
    );
  });
}

showEditTimestampsBottomSheet(BuildContext context,{@required dynamic object,int indexTimestamp}){
  if(indexTimestamp==null){
    indexTimestamp=object.trackedStart.length-1;
  }

  DateTime startTime = object.trackedStart[indexTimestamp];
  DateTime endTime = indexTimestamp==object.trackedEnd.length?null:object.trackedEnd[indexTimestamp];

  showDistivityModalBottomSheet(context, (ctx,ss){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              getSubtitle("Edit timestamp"),
              GButton("Done", onPressed: (){
                object.trackedStart[indexTimestamp]=startTime??object.trackedStart[indexTimestamp];
                if(object.trackedStart.length==object.trackedEnd.length){
                  //not active
                  if(endTime==null){
                    //now set active
                    if(indexTimestamp==object.trackedStart.length-1){
                      //can set active
                      object.trackedEnd.removeLast();
                      MyApp.dataModel.currentPlaying=object;
                    }else{
                      print("something wrong happened in edit timestamps");
                    }
                  }else{
                    //updated end time
                    object.trackedEnd[indexTimestamp]=endTime;
                  }
                }else{
                  //was previously active
                  if(endTime==null){
                    //nothing changed
                  }else{
                    //new endtime set
                    if(indexTimestamp==object.trackedStart.length-1){
                      //need to add the new timestamp since is at the end
                      object.trackedEnd.add(endTime);
                      MyApp.dataModel.currentPlaying=null;
                    }else{
                      //update with new timestamp
                      object.trackedEnd[indexTimestamp]= (endTime);
                    }
                  }
                }
                object.trackedStart[indexTimestamp]=startTime;
                if(object is Task){
                  MyApp.dataModel.task(MyApp.dataModel.findObjectIndexById(object), object, context, CUD.Update);
                }else if(object is Activity){
                  MyApp.dataModel.activity(MyApp.dataModel.findObjectIndexById(object), object, context, CUD.Update);
                }
                Navigator.pop(context);
              })
            ],
          ),
        ),
        GSwitchable(text: "Not finished yet(Active)", checked: endTime==null, onCheckedChanged: (b){
          ss((){
            if(b){
              endTime=null;
            }else{
              endTime=getTodayFormated();
            }
          });
        }, isCheckboxOrSwitch: true,disabled: indexTimestamp!=object.trackedStart.length-1),

        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: MyApp.dataModel.screenWidth/3,
                      child: Card(
                        shape: getShape(subtleBorder: false,smallRadius: false),
                        color: MyColors.color_black,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                    showDistivityTimePicker(context,TimeOfDay.fromDateTime(startTime??getTodayFormated()) ,
                                        onTimeSelected: (time){
                                      if(startTime==null){
                                        startTime=getTodayFormated();
                                      }
                                      ss((){
                                        if(time==null){
                                        }else startTime = DateTime(startTime.year,startTime.month,startTime.day,time.hour,time.minute);
                                      });
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GText(startTime==null?'No time':'${startTime.hour}:${startTime.minute}'),
                                  ),
                                ),
                                GText('•'),
                                GestureDetector(
                                  onTap: (){
                                    showDistivityDatePicker(context,onDateSelected: (date){
                                      if(startTime==null){
                                        startTime=getTodayFormated();
                                      }
                                      ss((){
                                        if(date==null){
                                        }else startTime = DateTime(
                                            date.year,date.month,date.day,startTime.hour,startTime.minute
                                        );
                                      });
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GText(startTime==null?'No date':'${startTime.day}:${startTime.month}:${startTime.year}'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    GIcon(Icons.chevron_right),
                    endTime==null?GText("Active"):Container(
                      width: MyApp.dataModel.screenWidth/3,
                      child: Card(
                        shape: getShape(subtleBorder: false,smallRadius: false),
                        color: MyColors.color_black,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                GestureDetector(
                                  onTap: (){
                                    showDistivityTimePicker(
                                        context,
                                        TimeOfDay.fromDateTime(endTime??getTodayFormated()) ,
                                        onTimeSelected: (time){
                                          if(startTime==null){
                                            startTime=getTodayFormated();
                                          }
                                          ss((){
                                            if(time==null){
                                            }else endTime = DateTime(
                                                endTime.year,
                                                endTime.month,
                                                endTime.day,
                                                time.hour,
                                                time.minute
                                            );
                                          });
                                        });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GText(startTime==null?'No time':'${endTime.hour}:${endTime.minute}'),
                                  ),
                                ),
                                GText('•'),
                                GestureDetector(
                                  onTap: (){
                                    showDistivityDatePicker(context,onDateSelected: (date){
                                      if(startTime==null){
                                        startTime=getTodayFormated();
                                      }
                                      ss((){
                                        if(date==null){
                                        }else{
                                          endTime = DateTime(
                                              date.year,date.month,date.day,
                                              endTime.hour,endTime.minute
                                          );
                                        }
                                      });
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: GText(startTime==null?'No date':'${endTime.day}:${endTime.month}:${endTime.year}'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: GText("Duration: ${getTextFromDuration((endTime??getTodayFormated()).difference(startTime??getTodayFormated()))} mins"),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GText('Remember to not be so strict with this. We all make mistakes and a '
                  '15-30 minute one will not be reflected in your calendar that much. It doesn\'t matter how'
                  ' much we fail but when we succeed',textType: TextType.textTypeSubNormal,isCentered: true,),
            )
          ],
        ),

      ],
    );
  });
}

showSelectParentBottomSheet(BuildContext context,{@required dynamic taskOrActivity,@required Function(int,bool) onSelected}){

  bool cal=true;

  bool isParentCalendar = (taskOrActivity is Activity)||(taskOrActivity.isParentCalendar==true);
  int parentId=taskOrActivity is Activity?taskOrActivity.parentCalendarId:taskOrActivity.parentId;

  showDistivityModalBottomSheet(context, (ctx,ss){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            getSubtitle('Select parent'),
            Visibility(
              visible: taskOrActivity is Task,
              child: PopupMenuButton(
                itemBuilder: (ctx){
                  return [
                    PopupMenuItem(
                      child: GButton(cal?"Select from Activities":"Select from Calendars", onPressed: (){
                        ss((){
                          cal=!cal;
                        });
                        Navigator.pop(context);
                      }),
                    )
                  ];
                },
                icon: GIcon(Icons.more_vert),

              ),
            ),
          ],
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: cal?MyApp.dataModel.eCalendars.length!=0?List.generate(
              MyApp.dataModel.eCalendars.length,
              (i) => Card(
                color:Colors.transparent,
                elevation: 0,
                shape: getShape(subtleBorder:  (parentId==MyApp.dataModel.eCalendars[i].id)&&(isParentCalendar)),
                child: ListTile(
                  leading: CircleAvatar(
                    maxRadius: 15,
                    backgroundColor: MyApp.dataModel.eCalendars[i].color,
                  ),
                  title: GText(MyApp.dataModel.eCalendars[i].name,),
                  onTap: (){
                    onSelected(MyApp.dataModel.eCalendars[i].id,true);
                    if(taskOrActivity is Task){
                      if(!taskOrActivity.isParentCalendar){
                        for(int j = 0;j<MyApp.dataModel.activities.length;j++){
                          if(MyApp.dataModel.activities[j].id==taskOrActivity.parentId){
                            MyApp.dataModel.activities[j].childs.remove(taskOrActivity);
                          }
                        }
                      }
                    }
                    Navigator.pop(context);
                  },
                ),
              ),
          ):[GEmptyView( "No calendars. Try setting an activity as parent")]:
          MyApp.dataModel.activities.length!=0?List.generate(
              MyApp.dataModel.activities.length,
              (i) => Card(
                color: Colors.transparent,
                elevation: 0,
                shape: getShape(subtleBorder: (parentId==MyApp.dataModel.activities[i].id)&&(!isParentCalendar)),
                child: ListTile(
                  leading: CircleAvatar(
                    maxRadius: 15,
                    backgroundColor: MyApp.dataModel.activities[i].color,
                  ),
                  title: GText(MyApp.dataModel.activities[i].name,),
                  onTap: (){
                    onSelected(MyApp.dataModel.activities[i].id,false);
                    MyApp.dataModel.activities[i].childs.add(taskOrActivity);
                    Navigator.pop(context);
                  },
                ),
              )
          ):[GEmptyView( "No activities. Try setting a calendar as a parent")],
        ),
      ],
    );
  });
}

List<int> daysSelected = [];

showRepeatEditBottomSheet(
    BuildContext context,
    {@required Function(RepeatRule,int) onUpdate,
    @required RepeatRule repeatRule,
    @required int repeatValue}){

  TextEditingController valueEditingController = TextEditingController(text: ((repeatValue??0).toString()));


  showDistivityModalBottomSheet(context, (ctx,ss){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Center(child: GButton('Save', onPressed: (){
          int valueFromTEC = (int.parse(valueEditingController.text))??0;
          if(repeatRule==RepeatRule.EveryXWeeks){
            String toset = valueFromTEC.toString();
            daysSelected.forEach((item){
              toset = toset + item.toString();
            });
            repeatValue=int.parse(toset);
          }else repeatValue=valueFromTEC;
          onUpdate(repeatRule,repeatValue);
          Navigator.pop(context);
        }),),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: GTabBar(
              onSelected: (i,b){
                if(b==true){
                  ss((){
                    repeatRule= RepeatRule.values[i];
                  });
                }
              },
              items: [
                'No repeat',
                'Every x days',
                'Every x weeks',
                'Every x months'
              ],
              selected: [
                RepeatRule.values.indexOf(repeatRule),
              ]
            ),
          ),
        ),
        if(repeatRule==RepeatRule.EveryXDays)
          GTextField(valueEditingController,focus: true,textInputType: TextInputType.number),
        if(repeatRule==RepeatRule.EveryXWeeks||repeatRule==RepeatRule.EveryXMonths)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GText('Will be supported in the future')
//              GTextField(valueEditingController, width: 300),
//              Padding(
//                padding: const EdgeInsets.all(8.0),
//                child: SingleChildScrollView(
//                  child: Row(
//                    mainAxisSize: MainAxisSize.min,
//                    children: List<Widget>.generate(7,(i){
//                      return Padding(
//                        padding: const EdgeInsets.all(8.0),
//                        child: CircleAvatar(
//                          backgroundColor: daysSelected.contains(i)?Colors.white:MyColors.color_black,
//                          child:GestureDetector(
//                            child: GText(getDayOfTheWeekStringShort(i)),
//                            onTap: (){
//                              if(daysSelected.contains(i)){
//                                daysSelected.remove(i);
//                              }else daysSelected.add(i);
//                            },
//                          ),
//                        ),
//                      );
//                    }),
//                  ),
//                ),
//              )
            ],
          ),
      ],
    );
  },hideHandler: true);
}

showAddEditCalendarBottomSheet(BuildContext context,{ECalendar eCalendar,int index,bool add}){
  if(add==null)add=false;

  if(index==null)index=MyApp.dataModel.eCalendars.length;

  if(eCalendar==null)eCalendar=ECalendar(name: '',parentId: -1,show: true,color: Colors.white,
    description: '',value: 0,themesStart: [],themesEnd: []);

  TextEditingController nameEditingController = TextEditingController(text: eCalendar.name);
  TextEditingController descriptionEditingController = TextEditingController(text: eCalendar.description);

  showDistivityModalBottomSheet(context, (ctx,ss){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: GTextField(nameEditingController, hint: 'Name goes here',focus: true,
                  variant: 2,textType: TextType.textTypeSubtitle),
            ),
            IconButton(
              icon: GIcon(Icons.send,size: TextType.textTypeSubtitle.size*1.5),
              onPressed: ()async{
                eCalendar.name=nameEditingController.text;
                eCalendar.description= descriptionEditingController.text;
                await MyApp.dataModel.eCalendar(index, eCalendar, context, add?CUD.Create:CUD.Update);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        ListTile(
          leading: CircleAvatar(
            maxRadius: 15,
            backgroundColor: eCalendar.color??Colors.white,
          ),
          title: GText('Set color'),
          onTap: (){
            showEditColorBottomSheet(context,eCalendar.color,(col){
              ss((){
                eCalendar.color=col;
              });
            });
          },
        ),
        ListTile(
          leading: GIcon(Icons.delete),
          title: GText('Delete calendar'),
          onTap: (){
            if(!add){
              MyApp.dataModel.eCalendar(index, eCalendar, context, CUD.Delete);
            }
            Navigator.pop(context);
          },
        ),
        Divider(),
        Padding(
          padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
          child: Center(
            child: GTextField(descriptionEditingController, textInputType: TextInputType.multiline,hint: 'Description goes here'),
          ),
        )
      ],
    );
  });
}

showSelectViewBottomSheet(BuildContext context,SelectedView selectedView, Function(SelectedView) onSelectedView){
  showDistivityModalBottomSheet(context, (ctx,ss){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        ListTile(
          leading: GIcon(Icons.calendar_view_day),
          title: GText('Day view'),
          onTap: (){
            onSelectedView(SelectedView.Day);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: GIcon(Icons.calendar_today),
          title: GText('3 Day view'),
          onTap: (){
            onSelectedView(SelectedView.ThreeDay);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: GIcon(Icons.calendar_today),
          title: GText('Week view'),
          onTap: (){
            onSelectedView(SelectedView.Week);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: GIcon(Icons.calendar_today),
          title: GText('Month view'),
          onTap: (){
            onSelectedView(SelectedView.Month);
            Navigator.pop(context);
          },
        ),
      ],
    );
  });
}

showAllDriveSavesBottomSheet(BuildContext context)async{
  List<File> files = await MyApp.dataModel.driveHelper.getAllFiles(context);

  showDistivityModalBottomSheet(context, (ctx,ss){
    return files.length==0?GEmptyView("There are no saves on this account. Maybe you logged with the wrong account. If not contact us!"):Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(files.length, (i) => ListTile(
        leading: GIcon(Icons.insert_drive_file),
        onTap: (){
          showYesNoDialog(
              context,
              title: "Restore save from Drive?",
              text: "Keep in mind that the current save WILL BE DELETED FOREVER AND THERE IS NO UNDO BUTTON",
              noString: "Cancel",
              yesString: "Restore save",
              onYesPressed: ()async{
                MyApp.dataModel.driveHelper.downloadAndReplaceFile(context, files[i]);
              });
        },
        title: GText(files[i].originalFilename+getStringFromDate(files[i].createdDate)),
        trailing: IconButton(
          icon: GIcon(Icons.delete_forever),
          onPressed: (){
            showYesNoDialog(context, title: "Delete this save?", text: "This action can not be undone", onYesPressed: ()async {
              await MyApp.dataModel.driveHelper.deleteFile(context, files[i]);
              ss((){
                files.removeAt(i);
              });
            });
          },
        ),
      )),
    );
  });
}