import 'dart:math';
import 'package:calendar_views/calendar_views.dart';
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/list_callback.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/ui/pages/plan_vs_tracked_page.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/dates/gleadingcalendaritem.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:uuid/uuid.dart';
import 'basics/gwidgets/gtext.dart';


class DistivityCalendarWidget extends StatefulWidget {

  static final ScheduledCallback scheduledCallback = ScheduledCallback();

  final DateTime day;
  final double heightPerMinute;
  final PlanTracked forPlanVsTracked;
  final SelectedView selectedView;
  final GlobalKey positionedKey;


  const  DistivityCalendarWidget({Key key,@required this.day,@required this.heightPerMinute,
    @required this.forPlanVsTracked,@required this.selectedView, @required this.positionedKey,
  }) : super(key: key);



  @override
  _DistivityCalendarWidgetState createState() => _DistivityCalendarWidgetState();
}

class _DistivityCalendarWidgetState extends State<DistivityCalendarWidget> {

  List<TimeStamp> trackedTimestamps;
  List<TimeStamp> plannedTimestamps;


  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DistivityCalendarWidget.scheduledCallback.listen((s) {
        if(mounted) setState(() {});
      });
    });
    super.initState();
  }

  bool drag = false;

  @override
  Widget build(BuildContext context) {

    List<DateTime> selectedDateTimes =
    (widget.selectedView==SelectedView.Day)?[widget.day]:
    (widget.selectedView==SelectedView.ThreeDay)?[widget.day,widget.day.add(Duration(days: 1)),widget.day.add(Duration(days: 2))]:
    (widget.selectedView==SelectedView.Week)?List.generate(7, (i)=>widget.day.add(Duration(days: i))):[];

    trackedTimestamps = PlanVsTrackedPageState.
    getTimeStamps(context,planned: false,selectedDateTimes: selectedDateTimes,planTracked: widget.forPlanVsTracked);
    plannedTimestamps = PlanVsTrackedPageState.
    getTimeStamps(context,planned: true,selectedDateTimes: selectedDateTimes,planTracked: widget.forPlanVsTracked);


    return DayViewEssentials(
      properties: new DayViewProperties(
        days: selectedDateTimes,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DayViewDaysHeader(
            headerItemBuilder: (BuildContext context, DateTime day) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  GText(
                    "${areDatesOnTheSameDay(day, getTodayFormated())?"•":""}"
                        "${getDayOfTheWeekStringShort(day.weekday,widget.selectedView!=SelectedView.Week)}",
                    textType: TextType.textTypeNormal,),
                  GText("${day.day}",textType: TextType.textTypeSubNormal,),
                ],
              );
            },
          ),
          DayViewSchedule(
            heightPerMinute: widget.heightPerMinute,
            components: <ScheduleComponent>[
              new TimeIndicationComponent.intervalGenerated(
                generatedTimeIndicatorBuilder:(context,itemPosition,itemSize,minuteOfDay,){
                  return new Positioned(
                    top: itemPosition.top,
                    left: itemPosition.left,
                    width: itemSize.width,
                    height: itemSize.height,
                    child: new Center(
                      child: GText(
                        minuteOfDayToHourMinuteString(minuteOfDay,false),color: MyColors.color_gray_lighter,
                        textType: TextType.textTypeSubNormal,
                      ),
                    ),
                  );
                },
              ),
              new SupportLineComponent.intervalGenerated(
                generatedSupportLineBuilder: (context,itemPosition,itemWidth,minuteOfDay,){
                  return new Positioned(
                    top: itemPosition.top,
                    left: itemPosition.left,
                    width: itemWidth,
                    child: new Container(
                      height: 0.5,
                      color: MyColors.color_gray_lighter,
                    ),
                  );
                },
              ),
              new DaySeparationComponent(
                  generatedDaySeparatorBuilder:(
                      BuildContext context,
                      ItemPosition itemPosition,
                      ItemSize itemSize,
                      int daySeparatorNumber,
                      ) {
                    return new Positioned(
                      top: itemPosition.top,
                      left: itemPosition.left,
                      width: itemSize.width,
                      height: itemSize.height,
                      child: new Center(
                        child: new Container(
                          width: 0.5,
                          color: MyColors.color_gray_lighter,
                        ),
                      ),
                    );
                  }
              ),
              //ON TAP FUNCTIONALITY
              new EventViewComponent(getEventsOfDay: (day){
                return [
                  StartDurationItem(
                      duration: 24*60,
                      startMinuteOfDay: 0,
                      builder: (ctx,pos,size){
                        return new Positioned(
                          top: pos.top,
                          left: pos.left,
                          width: size.width,
                          height: size.height,
                          child: GestureDetector(
                            onTapUp: (details){
                              if(widget.forPlanVsTracked==PlanTracked.Plan)
                               if(DistivityCalendarWidget.scheduledCallback.newScheduled==null){
                                setState(() {
                                  DistivityCalendarWidget.scheduledCallback.newScheduled= Scheduled(
                                    repeatRule: RepeatRule.None,
                                    repeatValue: "0",id: Uuid().v4(),
                                    durationInMinutes: 60,
                                    startTime: DateTime(day.year,day.month,
                                        day.day).add(Duration(minutes: details.localPosition.dy~/widget.heightPerMinute)),
                                  );
                                  DistivityCalendarWidget.scheduledCallback.
                                    notifyUpdated(DistivityCalendarWidget.scheduledCallback.newScheduled);
                                });
                              }
                            },
                            child: Container(color: Colors.transparent,),
                          ),
                        );
                      }
                  ),
                ];
              }),

              new EventViewComponent(
                getEventsOfDay: (DateTime day) {
                    List<TimeStamp> forDayTimestamps = [];
                    (plannedTimestamps??[]).forEach((element) {
                      if(areDatesOnTheSameDay(element.start, day)){
                        forDayTimestamps.add(element);
                      }
                    });
                    DistivityPageState.listCallback.listen((obj,cud ){
                      if (this.mounted) {setState(() {});}
                    });
                    return List.generate(forDayTimestamps.length, (i){
                      return new StartDurationItem(
                          startMinuteOfDay: forDayTimestamps[i].start.hour
                              *60+forDayTimestamps[i].start.minute,
                          duration: forDayTimestamps[i].durationInMinutes,
                          builder: (context,itemPosition,itemSize,){
                            int lastStartMinuteOfTheDay;

                            Scheduled scheduled;
                            if(!forDayTimestamps.first.tracked){
                              if(scheduled==null)scheduled = forDayTimestamps[i].getScheduled();
                              if(lastStartMinuteOfTheDay==null)lastStartMinuteOfTheDay=
                                  scheduled.startTime.hour*60+
                                      scheduled.startTime.minute;
                            }

                            return new Positioned(
                                top: itemPosition.top+1,
                                left: itemPosition.left-5,
                                width: itemSize.width+10,
                                height: itemSize.height-1,
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onDoubleTap: (){
                                      MyApp.dataModel.setPlaying(context, forDayTimestamps[i].parent);
                                    },
                                    onVerticalDragUpdate: forDayTimestamps[i].tracked||!kIsWeb?null:(dragUpdateDetails){
                                      int newDifference =
                                          (dragUpdateDetails.delta.dy~/widget.heightPerMinute)*(kIsWeb?1:4);
                                      if(newDifference==0)return;
                                      setState(() {
                                        int newStartMinuteOfTheDay = lastStartMinuteOfTheDay+newDifference;
                                        if((newStartMinuteOfTheDay>=0)){
                                          scheduled.startTime= DateTime(scheduled.startTime.year, scheduled.startTime.month,
                                              scheduled.startTime.day).add(Duration(minutes: newStartMinuteOfTheDay));
                                        }
                                      });
                                    },
                                    onVerticalDragEnd: forDayTimestamps[i].tracked||!kIsWeb?null:(dragEndDetails){
                                      lastStartMinuteOfTheDay=
                                          scheduled.startTime.minute+
                                              scheduled.startTime.hour*60;
                                      MyApp.dataModel.scheduled(scheduled, context, CUD.Update, forDayTimestamps[i].parent.id);
                                    },
                                    onTap: (){
                                      if(forDayTimestamps[i].tracked){
                                        showEditTimestampsBottomSheet(context,
                                            object: forDayTimestamps[i].parent,
                                            indexTimestamp: forDayTimestamps[i].parentIndex);
                                      }else{
                                        showObjectDetailsBottomSheet(
                                            context,
                                            forDayTimestamps[i].parent,
                                            day,isInCalendar: true,sContext: forDayTimestamps[i].getScheduled());
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: forDayTimestamps[i].color,
                                        borderRadius: BorderRadius.circular(drag?10:5),
                                      ),
                                      child: Stack(
                                        children: [
                                          if((!forDayTimestamps[i].tracked&&Random().nextInt(10)==3)&&itemSize.height>75)
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: GText('Double tap to play',isCentered: true,textType: TextType.textTypeSubNormal,
                                              color: getContrastColor(forDayTimestamps[i].color),),
                                            ),
                                          Center(
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                if(kIsWeb?(widget.selectedView==SelectedView.Day||
                                                    widget.selectedView==SelectedView.ThreeDay):
                                                widget.selectedView== SelectedView.Day)
                                                  GLeadingCalendarItem(
                                                      timeStamp: forDayTimestamps[i], day: day,
                                                      show: itemSize.height>30,
                                                  ),
                                                Flexible(child: GText(forDayTimestamps[i].title,
                                                    textType: TextType.textTypeNormal,maxLines: 2,
                                                    sizeMultiplier: widget.heightPerMinute/5,isCentered:true,
                                                    color: getContrastColor(forDayTimestamps[i].color))),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                            );
                          }
                      );
                    });
                  }
              ),
              new EventViewComponent(
                  getEventsOfDay: (DateTime day) {
                    List<TimeStamp> forDayTimestamps = [];
                    (trackedTimestamps??[]).forEach((element) {
                      if(areDatesOnTheSameDay(element.start, day)){
                        forDayTimestamps.add(element);
                      }
                    });
                    DistivityPageState.listCallback.listen((obj,cud ){
                      if(mounted){setState(() {});}
                    });
                    double padding = (((plannedTimestamps.length!=0&&trackedTimestamps.length!=0)?20:0)~/
                        (SelectedView.values.indexOf(widget.selectedView)+1)).toDouble();
                    return List.generate(forDayTimestamps.length, (i){
                      return new StartDurationItem(
                          startMinuteOfDay: forDayTimestamps[i].start.hour*60+forDayTimestamps[i].start.minute,
                          duration: forDayTimestamps[i].durationInMinutes,
                          builder: (context,itemPosition,itemSize,){
                            int lastStartMinuteOfTheDay;

                            Scheduled scheduled;
                            if(!forDayTimestamps.first.tracked){
                              if(scheduled==null)scheduled = forDayTimestamps[i].getScheduled();
                              if(lastStartMinuteOfTheDay==null)lastStartMinuteOfTheDay=
                                  scheduled.startTime.hour*60+
                                      scheduled.startTime.minute;
                            }


                            return new Positioned(
                                top: itemPosition.top,
                                left: itemPosition.left-5,
                                width: itemSize.width+10,
                                height: itemSize.height,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: padding,right: padding
                                  ),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.click,
                                    child: GestureDetector(
                                      onDoubleTap: (){
                                        MyApp.dataModel.setPlaying(context, forDayTimestamps[i].parent);
                                      },
                                      onVerticalDragUpdate: forDayTimestamps[i].tracked||!kIsWeb?null:(dragUpdateDetails){
                                        int newDifference =
                                            (dragUpdateDetails.delta.dy~/widget.heightPerMinute)*(kIsWeb?1:4);
                                        if(newDifference==0)return;
                                        setState(() {

                                          int newStartMinuteOfTheDay = lastStartMinuteOfTheDay+newDifference;
                                          if((newStartMinuteOfTheDay>=0)){
                                            scheduled.startTime= DateTime(scheduled.startTime.year, scheduled.startTime.month,
                                                scheduled.startTime.day).add(Duration(minutes: newStartMinuteOfTheDay));
                                          }
                                        });
                                      },
                                      onVerticalDragEnd: forDayTimestamps[i].tracked||!kIsWeb?null:(dragEndDetails){
                                        lastStartMinuteOfTheDay=
                                            scheduled.startTime.minute+
                                                scheduled.startTime.hour*60;
                                        MyApp.dataModel.scheduled(scheduled, context, CUD.Update, forDayTimestamps[i].parent.id);
                                      },
                                      onTap: (){
                                        if(forDayTimestamps[i].tracked){
                                          showEditTimestampsBottomSheet(context,
                                              object: forDayTimestamps[i].parent,
                                              indexTimestamp: forDayTimestamps[i].parentIndex);
                                        }else{
                                          showObjectDetailsBottomSheet(
                                              context,
                                              forDayTimestamps[i].parent,
                                              day,isInCalendar: true,sContext: forDayTimestamps[i].getScheduled());
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: forDayTimestamps[i].color,
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: Stack(
                                          children: [
                                            if((!forDayTimestamps[i].tracked&&Random().nextInt(30)==3)&&
                                              itemSize.height>75)
                                              Align(
                                                alignment: Alignment.bottomCenter,
                                                child: GText('Hint: Double tap to play',isCentered: true,
                                                  textType: TextType.textTypeSubMiniscule,
                                                  color: getContrastColor(forDayTimestamps[i].color),),
                                              ),
                                            Center(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if(kIsWeb?(widget.selectedView==SelectedView.Day||
                                                      widget.selectedView==SelectedView.ThreeDay):
                                                      widget.selectedView== SelectedView.Day)
                                                    GLeadingCalendarItem(
                                                      timeStamp: forDayTimestamps[i], day: day,
                                                      show: itemSize.height>30,
                                                    ),
                                                  Flexible(child: GText(forDayTimestamps[i].title,
                                                      textType: TextType.textTypeNormal,maxLines: 2,
                                                      sizeMultiplier: widget.heightPerMinute/5,isCentered:true,
                                                      color: getContrastColor(forDayTimestamps[i].color))),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                            );
                          }
                      );
                    });
                  }
              ),
              new EventViewComponent(getEventsOfDay: (day){
                return [
                  if(DistivityCalendarWidget.scheduledCallback.newScheduled!=null&&
                    areDatesOnTheSameDay(DistivityCalendarWidget.scheduledCallback.newScheduled.startTime,day))
                      StartDurationItem(
                      startMinuteOfDay: DistivityCalendarWidget.scheduledCallback.newScheduled.startTime.hour*
                          60+DistivityCalendarWidget.scheduledCallback.newScheduled.startTime.minute,
                      duration: DistivityCalendarWidget.scheduledCallback.newScheduled.durationInMinutes,
                      builder: (context,itemPosition,itemSize,){
                        int lastStartMinuteOfTheDay;
                        int lastDurationInMinutes;

                        if(lastStartMinuteOfTheDay==null)lastStartMinuteOfTheDay=
                            DistivityCalendarWidget.scheduledCallback.newScheduled.startTime.hour*60+
                                DistivityCalendarWidget.scheduledCallback.newScheduled.startTime.minute;

                        if(lastDurationInMinutes==null)lastDurationInMinutes=
                            DistivityCalendarWidget.scheduledCallback.newScheduled.durationInMinutes;

                        return Positioned(
                          top: itemPosition.top-9,
                          left:itemPosition.left,
                          width: itemSize.width,
                          height: itemSize.height+18,
                          child: Stack(
                            key: widget.positionedKey,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 9),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: DistivityCalendarWidget.scheduledCallback.newScheduled.getColor(),
                                      style: BorderStyle.solid,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.grab,
                                    child: GestureDetector(
                                      onVerticalDragUpdate: (dragUpdateDetails){
                                        int newDifference =
                                            (dragUpdateDetails.delta.dy~/widget.heightPerMinute)*(kIsWeb?1:4);
                                        if(newDifference==0)return;
                                        setState(() {

                                          int newStartMinuteOfTheDay = lastStartMinuteOfTheDay+newDifference;
                                          if((newStartMinuteOfTheDay>=0)&&
                                              (lastDurationInMinutes-newDifference>10)){
                                            DistivityCalendarWidget.scheduledCallback.newScheduled.startTime=
                                                DateTime(DistivityCalendarWidget.scheduledCallback.newScheduled.
                                                startTime.year, DistivityCalendarWidget.scheduledCallback.
                                                newScheduled.startTime.month,DistivityCalendarWidget.
                                                scheduledCallback.newScheduled.startTime.day)
                                                    .add(Duration(minutes: newStartMinuteOfTheDay));
                                          }
                                        });
                                      },
                                      onVerticalDragEnd: (dragEndDetails){
                                        lastStartMinuteOfTheDay=
                                            DistivityCalendarWidget.scheduledCallback.newScheduled.startTime.
                                            minute+DistivityCalendarWidget.scheduledCallback.newScheduled.
                                            startTime.hour*60;
                                        DistivityCalendarWidget.scheduledCallback.notifyUpdated
                                          (DistivityCalendarWidget.scheduledCallback.newScheduled);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                              //edit starttime
                              Padding(
                                padding: EdgeInsets.only(left: widget.selectedView==SelectedView.Week?4:15),
                                child: MouseRegion(
                                  cursor: SystemMouseCursors.grab,
                                  child: GestureDetector(
                                    onVerticalDragUpdate: (dragUpdateDetails){
                                      int newDifference =
                                          (dragUpdateDetails.delta.dy~/widget.heightPerMinute)*(kIsWeb?1:4);
                                      if(newDifference==0)return;
                                      setState(() {

                                        int newStartMinuteOfTheDay = lastStartMinuteOfTheDay+newDifference;
                                        if((newStartMinuteOfTheDay>=0)&&
                                            (lastDurationInMinutes-newDifference>10)){
                                          DistivityCalendarWidget.scheduledCallback.newScheduled.
                                            durationInMinutes=lastDurationInMinutes-newDifference;
                                          DistivityCalendarWidget.scheduledCallback.newScheduled.startTime=
                                              DateTime(DistivityCalendarWidget.scheduledCallback.newScheduled.
                                                startTime.year, DistivityCalendarWidget.scheduledCallback.
                                                  newScheduled.startTime.month,DistivityCalendarWidget.
                                                    scheduledCallback.newScheduled.startTime.day)
                                              .add(Duration(minutes: newStartMinuteOfTheDay));
                                        }
                                      });
                                    },
                                    onVerticalDragEnd: (dragEndDetails){
                                      lastStartMinuteOfTheDay=
                                          DistivityCalendarWidget.scheduledCallback.newScheduled.startTime.
                                            minute+DistivityCalendarWidget.scheduledCallback.newScheduled.
                                              startTime.hour*60;
                                      lastDurationInMinutes=DistivityCalendarWidget.scheduledCallback.
                                        newScheduled.durationInMinutes;
                                      DistivityCalendarWidget.scheduledCallback.notifyUpdated
                                        (DistivityCalendarWidget.scheduledCallback.newScheduled);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Container(
                                        width:18,
                                        height: 18,
                                        decoration: BoxDecoration(
                                          color: DistivityCalendarWidget.scheduledCallback.newScheduled.getColor(),
                                          border: Border.all(color: Colors.white,width: 3),
                                          borderRadius: BorderRadius.circular(100),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              //edit endtime
                              Align(
                                alignment:Alignment.bottomRight,
                                child: Padding(
                                  padding:EdgeInsets.only(right: widget.selectedView==SelectedView.Week?4:15),
                                  child: MouseRegion(
                                    cursor: SystemMouseCursors.grab,
                                    child: GestureDetector(
                                      onVerticalDragUpdate: (dragUpdateDetails){

                                        int newDurationInMinutes =
                                            (dragUpdateDetails.delta.dy~/widget.heightPerMinute)*(kIsWeb?1:4);
                                        if(newDurationInMinutes==0)return;
                                        setState(() {
                                          newDurationInMinutes+=lastDurationInMinutes;
                                          if(newDurationInMinutes>=10&&(newDurationInMinutes)<=24*60){
                                            DistivityCalendarWidget.scheduledCallback.
                                              newScheduled.durationInMinutes=newDurationInMinutes;
                                          }
                                        });
                                      },
                                      onVerticalDragEnd: (dragEndDetails){
                                        lastDurationInMinutes=
                                            DistivityCalendarWidget.scheduledCallback.newScheduled.durationInMinutes;
                                        DistivityCalendarWidget.scheduledCallback.notifyUpdated
                                          (DistivityCalendarWidget.scheduledCallback.newScheduled);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(6.5),
                                        child: Container(
                                          width:18,
                                          height: 18,
                                          decoration: BoxDecoration(
                                            color: DistivityCalendarWidget.scheduledCallback.newScheduled.getColor(),
                                            border: Border.all(color: Colors.white,width: 3),
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                ];
              }),

              new EventViewComponent(getEventsOfDay: (day){
                return [

                  if(areDatesOnTheSameDay(day, getTodayFormated()))StartDurationItem(
                      duration: 120,
                      startMinuteOfDay: getTodayFormated().hour*60+getTodayFormated().minute,
                      builder: (ctx,pos,size){
                        return new Positioned(
                          top: pos.top-16,
                          left: pos.left-10,
                          width: size.width+20,
                          height: 30,
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                maxRadius: 7,
                                backgroundColor: Colors.white,
                              ),
                              Container(
                                width: size.width,
                                height: 3,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      topRight: Radius.circular(10)
                                  ),color: Colors.white,),
                              ),
                            ],
                          ),
                        );
                      }
                  ),
                ];
              }),
            ],
          ),
        ],
      ),
    );
  }
}

