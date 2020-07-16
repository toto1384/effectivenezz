import 'dart:io';

import 'package:effectivenezz/data/database.dart';
import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/calendar.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:path/path.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';

import '../../main.dart';



showAddEditTaskBottomSheet(BuildContext context,{Task task,int index,bool add,@required DateTime selectedDate,Scheduled scheduled}){

  if(task==null){
    task=Task(
      name: '',
      tags: [],
      isValueMultiply: false,
      isParentCalendar: true,
      checks: [],
      parentId: -1,
      trackedEnd: [],
      trackedStart: [],
      value: 0,
    );
  }

  if(scheduled==null){
    scheduled= Scheduled(
      repeatValue: 0,
      repeatRule: RepeatRule.None,
      isParentTask: true,
      durationInMins: 30
    );
  }

  if(add==null)add=false;
  TextEditingController nameEditingController = TextEditingController(text: task.name??'');
  TextEditingController descriptionEditingController = TextEditingController(text: task.description??'');


  showDistivityModalBottomSheet(context, (ctx,ss){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: getIcon(task.isCheckedOnDate(selectedDate)?Icons.check_circle_outline:Icons.radio_button_unchecked),
                    onPressed: (){
                      if(task.isCheckedOnDate(selectedDate)){
                        task.unCheckOnDate(selectedDate);
                      }else{
                        task.checks.add(selectedDate);
                      }
                      if(add){ss((){});}else{
                        MyApp.dataModel.task(MyApp.dataModel.tasks.indexOf(task), task, context, CUD.Update);
                      }
                    },
                  ),
                  getPadding(getTextField(nameEditingController, width: 200,hint: 'Name goes here',textInputType: TextInputType.text,variant: 2)),
                ],
              ),
              IconButton(
                icon: getIcon(Icons.send),
                onPressed: (){
                  if(scheduled.durationInMins<0){
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
                    task.name = nameEditingController.text;
                    task.description = descriptionEditingController.text;
                    MyApp.dataModel.task(index, task, context, add?CUD.Create:CUD.Update,addWith: scheduled);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
        getDivider(),
        scheduledEditor(context, scheduled, (sc){
          ss((){
            scheduled=sc;
          });
        }),
        getDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            repeatEditor(context, scheduled, (sc){
              ss((){
                scheduled=sc;
              });
            }),
            IconButton(
              icon: getIcon(Icons.colorize,color: task.color),
              onPressed: (){
                showEditColorBottomSheet(context,task.color??MyApp.dataModel.findParentColor(task),(col){
                  ss((){
                    task.color=col;
                  });
                });
              },
            ),
            getButton("${formatDouble(task.value.toDouble()??0)}\$/hour", onPressed: (){
              showHourValuePopup(context, value: task.value.toDouble(), isMultiply: task.isValueMultiply, onSelectedValueAndBool: (v,i){
                ss((){
                  task.value=v;
                  task.isValueMultiply=i;
                });
              });
            }),
          ],
        ),

        ListTile(
          leading: CircleAvatar(
            maxRadius: 15,
            backgroundColor: MyApp.dataModel.findParentColor(task),
          ),
          title: getText(MyApp.dataModel.findParentName(task)),
          onTap: (){
            showSelectParentBottomSheet(context, taskOrActivity: task, onSelected: (i,b){
              ss((){
                if(task.color==null||task.color==(task.isParentCalendar?MyApp.dataModel.findECalendarById(task.parentId).color:MyApp.dataModel.findActivityById(task.parentId).color)){
                  if(b){
                    task.color=MyApp.dataModel.findECalendarById(i).color;
                  }else{
                    task.color=MyApp.dataModel.findActivityById(i).color;
                  }
                }
                task.parentId=i;
                task.isParentCalendar=b;
                if(task.value==0){
                  if(!b){
                    task.value=MyApp.dataModel.findActivityById(i).value;
                  }
                }
              });
            });
          },
        ),
        Divider(color: MyColors.getHelpColor(),),
        Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Center(child: getTextField(descriptionEditingController, width: MediaQuery.of(context).size.width.toInt()-50,textInputType: TextInputType.multiline,hint: 'Description goes here'),),
        )


      ],
    );
  });
}

showHourValuePopup(BuildContext context,{@required double value,@required bool isMultiply,@required Function(int,bool) onSelectedValueAndBool}){
  value=backwardFigures(value);

  showDistivityDialog(context, actions: [getButton("Set", onPressed: (){
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
    MyApp.dataModel.activityPlayingId=null;
    MyApp.dataModel.taskPlayingId=null;

    obj.trackedStart.add(currentPlaying.trackedStart.last);

    if(obj is Task){
      MyApp.dataModel.taskPlayingId=obj.id;
      MyApp.dataModel.task(MyApp.dataModel.findObjectIndexById(obj), obj, context, CUD.Update);
    }else if(obj is Activity){
      MyApp.dataModel.activityPlayingId=obj.id;
      MyApp.dataModel.activity(MyApp.dataModel.findObjectIndexById(obj), obj, context, CUD.Update);
    }

    (currentPlaying.trackedStart as List<DateTime>).removeLast();

    if(currentPlaying is Task){
      MyApp.dataModel.task(MyApp.dataModel.findObjectIndexById(currentPlaying), currentPlaying, context, CUD.Update);
    }else if(currentPlaying is Activity){
      MyApp.dataModel.activity(MyApp.dataModel.findObjectIndexById(currentPlaying), currentPlaying, context, CUD.Update);
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
            getText(title,textType: TextType.textTypeSubtitle),
            getInfoIcon(
                context, "By selecting any Task or Activity from this list, they will replace the timestamp from "+
                "${getTimeName((currentPlaying.trackedStart??[getTodayFormated()]).last)} • ${getDateName((currentPlaying.trackedStart??[getTodayFormated()]).last)},"+
                " that is currently occupied by: ${currentPlaying.name}"),
          ],
        ),
        getSortByCalendarListView(
            context,
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

showTaskDetailsBottomSheet(BuildContext context, Task task){


  showDistivityModalBottomSheet(context, (ctx,ss){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(width: MediaQuery.of(context).size.width/1.65,child: getText(task.name,textType: TextType.textTypeSubtitle,)),
              getButton("Edit", onPressed: (){
                Navigator.pop(context);
                showAddEditTaskBottomSheet(context, selectedDate: getTodayFormated(),task: task,add: false,index: MyApp.dataModel.findObjectIndexById(task),scheduled: task.getScheduled(context)[0]);
              })
            ],
          ),
        ),
        getText(task.description),
        getDivider(),
        getText("${formatDouble(task.value.toDouble())} \$/hour"),
        ListTile(
          leading: getIcon(Icons.delete_outline),
          title: getText('Delete task'),
          onTap: (){
            MyApp.dataModel.task(MyApp.dataModel.findObjectIndexById(task), task, context, CUD.Delete,withScheduleds: true);
            Navigator.pop(context);
          },
        ),
        getText("Tracked",textType: TextType.textTypeSubtitle),
        if(task.trackedStart.length==0)
          getEmptyView(context, "No timestamps")
      ]+getTrackedIntervalsWidget(context,task, task.color),
    );
  });
}

showActivityDetailsBottomSheet(BuildContext context,Activity activity){

  showDistivityModalBottomSheet(context, (ctx,ss){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              getText(activity.name,textType: TextType.textTypeSubtitle),
              getButton("Edit", onPressed: (){
                Navigator.pop(context);
                showAddEditActivityBottomSheet(context, selectedDate: getTodayFormated(),activity: activity,add: false,index: MyApp.dataModel.findObjectIndexById(activity),scheduled: activity.getScheduled(context)[0]);
              })
            ],
          ),
        ),
        getText(activity.description),
        getDivider(),
        getText("${formatDouble(activity.value.toDouble())} \$/hour"),
        ListTile(
          leading: getIcon(Icons.delete_outline),
          title: getText('Delete activity'),
          onTap: (){
            MyApp.dataModel.activity(MyApp.dataModel.activities.indexOf(MyApp.dataModel.findActivityById(activity.id)), activity, context, CUD.Delete,withScheduleds: true);
            Navigator.pop(context);
          },
        ),
        getText("Tracked",textType: TextType.textTypeSubtitle),
        if(activity.trackedStart.length==0)
          getEmptyView(context, "No timestamps")
      ]+getTrackedIntervalsWidget(context,activity, activity.color),
    );
  });
}


showEditTimestampsBottomSheet(BuildContext context, {@required dynamic object,int indexTimestamp}){
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
              getText("Edit timestamp",textType: TextType.textTypeSubtitle),
              getButton("Done", onPressed: (){
                object.trackedStart[indexTimestamp]=startTime;
                if(object.trackedStart.length==object.trackedEnd.length){
                  //not active
                  if(endTime==null){
                    //now set active
                    if(indexTimestamp==object.trackedStart.length-1){
                      //can set active
                      object.trackedEnd.removeLast();
                      if(object is Task){
                        MyApp.dataModel.activityPlayingId=null;
                        MyApp.dataModel.taskPlayingId=object.id;
                      }else if(object is Activity){
                        MyApp.dataModel.activityPlayingId=object.id;
                        MyApp.dataModel.taskPlayingId=null;
                      }
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
                      MyApp.dataModel.taskPlayingId=null;
                      MyApp.dataModel.activityPlayingId=null;
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
        getSwitchable(text: "Not finished yet(Active)", checked: endTime==null, onCheckedChanged: (b){
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
                      width: MediaQuery.of(context).size.width/3,
                      child: Card(
                        shape: getShape(subtleBorder: true,smallRadius: false),
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
                                          startTime=null;
                                        }else startTime = DateTime(startTime.year,startTime.month,startTime.day,time.hour,time.minute);
                                      });
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: getText(startTime==null?'No time':'${startTime.hour}:${startTime.minute}'),
                                  ),
                                ),
                                getText('•'),
                                GestureDetector(
                                  onTap: (){
                                    showDistivityDatePicker(context,onDateSelected: (date){
                                      if(startTime==null){
                                        startTime=getTodayFormated();
                                      }
                                      ss((){
                                        if(date==null){
                                          startTime=null;
                                        }else startTime = DateTime(
                                            date.year,date.month,date.day,startTime.hour,startTime.minute
                                        );
                                      });
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: getText(startTime==null?'No date':'${startTime.day}:${startTime.month}:${startTime.year}'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    getIcon(Icons.chevron_right),
                    endTime==null?getText("Active"):Container(
                      width: MediaQuery.of(context).size.width/3,
                      child: Card(
                        shape: getShape(subtleBorder: true,smallRadius: false),
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
                                              endTime=null;
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
                                    child: getText(startTime==null?'No time':'${endTime.hour}:${endTime.minute}'),
                                  ),
                                ),
                                getText('•'),
                                GestureDetector(
                                  onTap: (){
                                    showDistivityDatePicker(context,onDateSelected: (date){
                                      if(startTime==null){
                                        startTime=getTodayFormated();
                                      }
                                      ss((){
                                        if(date==null){
                                          endTime=null;
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
                                    child: getText(startTime==null?'No date':'${endTime.day}:${endTime.month}:${endTime.year}'),
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
              padding: const EdgeInsets.all(8.0),
              child: getText("Duration: ${getTextFromDuration((endTime??getTodayFormated()).difference(startTime??getTodayFormated()))} mins"),
            ),
          ],
        ),

      ],
    );
  });
}

showAddEditActivityBottomSheet(BuildContext context,{Activity activity,int index,bool add,@required DateTime selectedDate,Scheduled scheduled}){

  if(activity==null){
    activity=Activity(
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
  if(scheduled==null){
    scheduled=Scheduled(
      isParentTask: false,
      repeatRule: RepeatRule.None,
      repeatValue: 1,
      durationInMins: 30
    );
  }


  if(add==null)add=false;

  TextEditingController nameEditingController = TextEditingController(text: activity.name??'');
  TextEditingController descriptionEditingController = TextEditingController(text: activity.description??'');


  showDistivityModalBottomSheet(context, (ctx,ss){
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              IconButton(
                icon: getIcon(activity.icon??Icons.not_interested),
                onPressed: (){
                  FlutterIconPicker.showIconPicker(
                    context,
                    title: getText("Pick Icon",textType: TextType.textTypeSubtitle),
                    showTooltips: true,
                    iconPackMode: IconPack.material,
                    backgroundColor: MyColors.color_black,
                    iconColor: Colors.white,
                    closeChild: getButton("Close",onPressed: ()=>Navigator.pop(context))

                  ).then((value) => ss((){
                    activity.icon=value;
                  }));
                },
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  getPadding(getTextField(nameEditingController, width: 200,focus: false,hint: 'Name goes here',textInputType: TextInputType.text,variant: 2)),
                ],
              ),
              IconButton(
                icon: getIcon(Icons.send),
                onPressed: (){
                  if(scheduled.durationInMins<0){
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
                    activity.name = nameEditingController.text;
                    activity.description = descriptionEditingController.text;
                    MyApp.dataModel.activity(index, activity, context, add?CUD.Create:CUD.Update,addWith: scheduled);
                    Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
        ),
        getDivider(),
        scheduledEditor(context, scheduled, (sc){
          ss((){
            scheduled=sc;
          });
        }),
        getDivider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            repeatEditor(context, scheduled, (sc){
              ss((){
                scheduled=sc;
              });
            }),
            IconButton(
              icon: getIcon(Icons.colorize,color: activity.color),
              onPressed: (){
                showEditColorBottomSheet(context,activity.color??MyApp.dataModel.findECalendarById(activity.parentCalendarId).color,(col){
                  ss((){
                    activity.color=col;
                  });
                });
              },
            ),
            getButton("${formatDouble(activity.value.toDouble()??0)}\$/hour", onPressed: (){
              showHourValuePopup(context, value: activity.value.toDouble(), isMultiply: activity.valueMultiply, onSelectedValueAndBool: (v,i){
                ss((){
                  activity.value=v;
                  activity.valueMultiply=i;
                });
              });
            }),
          ],
        ),
        ListTile(
          leading: CircleAvatar(
            maxRadius: 15,
            backgroundColor: MyApp.dataModel.findECalendarById(activity.parentCalendarId).color,
          ),
          title: getText(MyApp.dataModel.findECalendarById(activity.parentCalendarId).name),
          onTap: (){
            showSelectParentBottomSheet(context, taskOrActivity: activity, onSelected: (i,b){
              ss((){
                if(activity.color==null||activity.color==MyApp.dataModel.findECalendarById(activity.parentCalendarId).color){
                  activity.color=MyApp.dataModel.findECalendarById(i).color;
                }
                activity.parentCalendarId=i;
              });
            });
          },
        ),
        Divider(color: MyColors.getHelpColor(),),
        Padding(
          padding: const EdgeInsets.only(bottom: 25),
          child: Center(child: getTextField(descriptionEditingController, width: MediaQuery.of(context).size.width.toInt()-50,textInputType: TextInputType.multiline,hint: 'Description goes here'),),
        )


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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: getText('Select parent',textType: TextType.textTypeSubtitle),
            ),
            Visibility(
              visible: taskOrActivity is Task,
              child: PopupMenuButton(
                itemBuilder: (ctx){
                  return [
                    PopupMenuItem(
                      child: getButton(cal?"Select from Activities":"Select from Calendars", onPressed: (){
                        ss((){
                          cal=!cal;
                        });
                        Navigator.pop(context);
                      }),
                    )
                  ];
                },
                icon: getIcon(Icons.more_vert),

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
                  title: getText(MyApp.dataModel.eCalendars[i].name,),
                  onTap: (){
                    onSelected(MyApp.dataModel.eCalendars[i].id,true);
                    Navigator.pop(context);
                  },
                ),
              ),
          ):[getEmptyView(context, "No calendars. Try setting an activity as parent")]:
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
                  title: getText(MyApp.dataModel.activities[i].name,),
                  onTap: (){
                    onSelected(MyApp.dataModel.activities[i].id,false);
                    Navigator.pop(context);
                  },
                ),
              )
          ):[getEmptyView(context, "No activities. Try setting a calendar as a parent")],
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
        Center(child: getButton('Save', onPressed: (){
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
            child: getTabBar(
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
          getTextField(valueEditingController, width: 300,focus: true,textInputType: TextInputType.number),
        if(repeatRule==RepeatRule.EveryXWeeks||repeatRule==RepeatRule.EveryXMonths)
          Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getText('Will be supported in the future')
//              getTextField(valueEditingController, width: 300),
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
//                            child: getText(getDayOfTheWeekStringShort(i)),
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

  if(eCalendar==null)eCalendar=ECalendar(name: '',parentId: -1,show: true,color: Colors.transparent,
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
            getPadding(getTextField(nameEditingController, width: 300,hint: 'Name goes here',focus: true,variant: 2),),
            IconButton(
              icon: getIcon(Icons.send),
              onPressed: (){
                eCalendar.name=nameEditingController.text;
                eCalendar.description= descriptionEditingController.text;
                MyApp.dataModel.eCalendar(index, eCalendar, context, add?CUD.Create:CUD.Update);
                Navigator.pop(context);
              },
            ),
          ],
        ),
        ListTile(
          leading: CircleAvatar(
            maxRadius: 15,
            backgroundColor: eCalendar.color,
          ),
          title: getText('Set color'),
          onTap: (){
            showEditColorBottomSheet(context,eCalendar.color,(col){
              ss((){
                eCalendar.color=col;
              });
            });
          },
        ),
        ListTile(
          leading: getIcon(Icons.delete),
          title: getText('Delete calendar'),
          onTap: (){
            if(!add){
              MyApp.dataModel.eCalendar(index, eCalendar, context, CUD.Delete);
            }
            Navigator.pop(context);
          },
        ),
        getDivider(),
        Padding(
          padding: const EdgeInsets.only(bottom: 15,left: 10,right: 10),
          child: Center(
            child: getTextField(descriptionEditingController, width: MediaQuery.of(context).size.width.toInt()-40,textInputType: TextInputType.multiline,hint: 'Description goes here'),
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
          leading: getIcon(Icons.calendar_view_day),
          title: getText('Day view'),
          onTap: (){
            onSelectedView(SelectedView.Day);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: getIcon(Icons.calendar_today),
          title: getText('3 Day view'),
          onTap: (){
            onSelectedView(SelectedView.ThreeDay);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: getIcon(Icons.calendar_today),
          title: getText('Week view'),
          onTap: (){
            onSelectedView(SelectedView.Week);
            Navigator.pop(context);
          },
        ),
        ListTile(
          leading: getIcon(Icons.calendar_today),
          title: getText('Month view'),
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
    return files.length==0?getEmptyView(context, "There are no saves on this account. Maybe you logged with the wrong account. If not contact us!"):Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(files.length, (i) => ListTile(
        leading: getIcon(Icons.insert_drive_file),
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
        title: getText(files[i].originalFilename+getStringFromDate(files[i].createdDate)),
        trailing: IconButton(
          icon: getIcon(Icons.delete_forever),
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