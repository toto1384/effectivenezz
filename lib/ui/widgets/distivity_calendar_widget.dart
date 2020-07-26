
import 'package:calendar_views/calendar_views.dart';
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


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
    return Container(
      child: DayViewEssentials(
        properties: new DayViewProperties(
          days: widget.days,
        ),
        child: DayViewSchedule(
          heightPerMinute: widget.heightPerMinute,
          components: <ScheduleComponent>[
            new TimeIndicationComponent.intervalGenerated(
              generatedTimeIndicatorBuilder:(context,itemPosition,itemSize,minuteOfDay,){
                return new Positioned(
                  top: itemPosition.top,
                  left: itemPosition.left,
                  width: itemSize.width,
                  height: itemSize.height,
                  child: new Container(
                    child: new Center(
                      child: getText(minuteOfDayToHourMinuteString(minuteOfDay,false)),
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
                    color: MyColors.getHelpColor(),
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
                        color: MyColors.getHelpColor(),
                      ),
                    ),
                  );
                }
            ),
            new EventViewComponent(
              getEventsOfDay: (DateTime day) {
                  List<TimeStamp> forDayTimestamps = [];
                  (widget.plannedTimestamps??[]).forEach((element) {
                    if(areDatesOnTheSameDay(element.startTime, day)){
                      forDayTimestamps.add(element);
                    }
                  });
                  DistivityPageState.listCallback.listen((obj,cud ){
                    return MyAppState.ss(context);
                  });
                  return List.generate(forDayTimestamps.length, (i){
                    return new StartDurationItem(
                        startMinuteOfDay: forDayTimestamps[i].startTime.hour*60+forDayTimestamps[i].startTime.minute,
                        duration: forDayTimestamps[i].duration,
                        builder: (context,itemPosition,itemSize,){
                          return new Positioned(
                              top: itemPosition.top+1,
                              left: itemPosition.left,
                              width: itemSize.width,
                              height: itemSize.height-1,
                              child: GestureDetector(
                                onTap: (){
                                  showObjectDetailsBottomSheet(context, forDayTimestamps[i].getParent(),day);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: forDayTimestamps[i].color,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: getText(forDayTimestamps[i].name,textType: TextType.textTypeNormal,maxLines: 2,sizeMultiplier: widget.heightPerMinute/5,color: getContrastColor(forDayTimestamps[i].color)),
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
                    if(areDatesOnTheSameDay(element.startTime, day)){
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
                        startMinuteOfDay: forDayTimestamps[i].startTime.hour*60+forDayTimestamps[i].startTime.minute,
                        duration: forDayTimestamps[i].duration,
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
                                    showObjectDetailsBottomSheet(context, forDayTimestamps[i].getParent(),day);
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: forDayTimestamps[i].color,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Center(
                                      child: getText(forDayTimestamps[i].name,textType: TextType.textTypeNormal,maxLines: 2,sizeMultiplier: widget.heightPerMinute/5,color: getContrastColor(forDayTimestamps[i].color)),
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
      ),
    );
  }
}
