import 'package:calendar_views/calendar_views.dart';
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/dates/gleadingcalendaritem.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'basics/gwidgets/gtext.dart';


class DistivityCalendarWidget extends StatefulWidget {

  final List<DateTime> days;
  final List<TimeStamp> trackedTimestamps;
  final List<TimeStamp> plannedTimestamps;
  final double heightPerMinute;
  final bool forPlanVsTracked;
  final SelectedView selectedView;

  const  DistivityCalendarWidget({Key key,@required this.days,@required this.heightPerMinute,@required this.forPlanVsTracked,
    this.trackedTimestamps, this.plannedTimestamps,@required this.selectedView}) : super(key: key);



  @override
  _DistivityCalendarWidgetState createState() => _DistivityCalendarWidgetState();
}

class _DistivityCalendarWidgetState extends State<DistivityCalendarWidget> {

  @override
  Widget build(BuildContext context) {
    return DayViewEssentials(
      properties: new DayViewProperties(
        days: widget.days,
      ),
      child: Column(
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
              new EventViewComponent(
                getEventsOfDay: (DateTime day) {
                    List<TimeStamp> forDayTimestamps = [];
                    (widget.plannedTimestamps??[]).forEach((element) {
                      if(areDatesOnTheSameDay(element.start, day)){
                        forDayTimestamps.add(element);
                      }
                    });
                    DistivityPageState.listCallback.listen((obj,cud ){
                      if (this.mounted) {
                        setState(() {
                          // Your state change code goes here
                        });
                      }
                    });
                    return List.generate(forDayTimestamps.length, (i){
                      return new StartDurationItem(
                          startMinuteOfDay: forDayTimestamps[i].start.hour
                              *60+forDayTimestamps[i].start.minute,
                          duration: forDayTimestamps[i].durationInMinutes,
                          builder: (context,itemPosition,itemSize,){
                            return new Positioned(
                                top: itemPosition.top+1,
                                left: itemPosition.left,
                                width: itemSize.width,
                                height: itemSize.height-1,
                                child: GestureDetector(
                                  onTap: (){
                                    if(forDayTimestamps[i].tracked){
                                      showEditTimestampsBottomSheet(context,
                                          object: forDayTimestamps[i].getParent(),
                                          indexTimestamp: forDayTimestamps[i].parentIndex);
                                    }else{
                                      showObjectDetailsBottomSheet(
                                          context,
                                          forDayTimestamps[i].getParent(),
                                          day);
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: forDayTimestamps[i].color,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if(widget.selectedView==SelectedView.Day)
                                            GLeadingCalendarItem(
                                                timeStamp: forDayTimestamps[i], day: day,
                                                show: itemSize.height>30,
                                            ),
                                          Flexible(child: GText(forDayTimestamps[i].title,textType: TextType.textTypeNormal,maxLines: 2,sizeMultiplier: widget.heightPerMinute/5,color: getContrastColor(forDayTimestamps[i].color))),
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
                    (widget.trackedTimestamps??[]).forEach((element) {
                      if(areDatesOnTheSameDay(element.start, day)){
                        forDayTimestamps.add(element);
                      }
                    });
                    DistivityPageState.listCallback.listen((obj,cud ){
                      return MyAppState.ss(context);
                    });
                    double padding = (((widget.plannedTimestamps.length!=0&&widget.trackedTimestamps.length!=0)?20:0)~/
                        (SelectedView.values.indexOf(widget.selectedView)+1)).toDouble();
                    return List.generate(forDayTimestamps.length, (i){
                      return new StartDurationItem(
                          startMinuteOfDay: forDayTimestamps[i].start.hour*60+forDayTimestamps[i].start.minute,
                          duration: forDayTimestamps[i].durationInMinutes,
                          builder: (context,itemPosition,itemSize,){
                            return new Positioned(
                                top: itemPosition.top,
                                left: itemPosition.left,
                                width: itemSize.width,
                                height: itemSize.height,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: padding,right: padding
                                  ),
                                  child: GestureDetector(
                                    onTap: (){
                                      if(forDayTimestamps[i].tracked){
                                        showEditTimestampsBottomSheet(context,
                                            object: forDayTimestamps[i].getParent(),
                                            indexTimestamp: forDayTimestamps[i].parentIndex);
                                      }else{
                                        showObjectDetailsBottomSheet(
                                            context,
                                            forDayTimestamps[i].getParent(),
                                            day);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: forDayTimestamps[i].color,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            if(widget.selectedView==SelectedView.Day)
                                              GLeadingCalendarItem(
                                                timeStamp: forDayTimestamps[i], day: day,
                                                show: itemSize.height>30,
                                              ),
                                            Flexible(child: GText(forDayTimestamps[i].title,textType: TextType.textTypeNormal,maxLines: 2,sizeMultiplier: widget.heightPerMinute/5,color: getContrastColor(forDayTimestamps[i].color))),
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
                  StartDurationItem(
                    duration: 120,
                    startMinuteOfDay: getTodayFormated().hour*60+getTodayFormated().minute,
                    builder: (ctx,pos,size){
                      return new Positioned(
                          top: pos.top,
                          left: 20,
                          width: MyApp.dataModel.screenWidth,
                          height: 30,
                          child: Row(
                            children: <Widget>[
                              CircleAvatar(
                                maxRadius: 7,
                                backgroundColor: Colors.white,
                              ),
                              Container(
                                width: MyApp.dataModel.screenWidth-50,
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

