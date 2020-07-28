import 'package:demoji/demoji.dart';
import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/pages/quick_start_page.dart';
import 'package:effectivenezz/ui/widgets/platform_svg.dart';
import 'package:effectivenezz/ui/widgets/specific/distivity_animated_list_obj.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../main.dart';
import '../date_n_strings.dart';
import 'overflows_complex.dart';

getDateWidget(BuildContext context,
    {@required DateTime selectedDate, @required Function(
        DateTime) onDateSelected}) {
  GestureDetector(
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        getIcon(Icons.chevron_left, size: 16),
        getText(getDateName(selectedDate),),
        getIcon(Icons.chevron_right, size: 16)
      ],
    ),
    onTap: () {
      showDistivityDatePicker(context, onDateSelected: (datetime) {
        if (datetime != null) {
          onDateSelected(datetime);
        }
      });
    },
  );
}

Widget getInfoIcon(BuildContext context, String message, {String name}) {
  GlobalKey key = GlobalKey();
  return GestureDetector(
    onTap: () {
      RenderBox box = key.currentContext.findRenderObject();
      Offset position = box.localToGlobal(Offset(0, 50));
      showMenu(context: context,
          position: RelativeRect.fromLTRB(
              position.dx, position.dy, position.dx, 0),
          items: [
            PopupMenuItem(
              child: getText(message),
            ),
          ],
          shape: getShape(subtleBorder: false),
          color: MyColors.color_gray_darker);
    },
    child: Padding(
      key: key,
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          getIcon(Icons.info_outline, color: MyColors.getHelpColor(), size: 20),
          Visibility(
              visible: name != null,
              child: getText(name, color: MyColors.getHelpColor(),
                  textType: TextType.textTypeSubNormal)
          )
        ],
      ),
    ),
  );
}

getWelcomePresentation(BuildContext context, int currentPage,
    {@required List<String> assetPaths, @required List<
        String> texts, @required Function(int) onPageChanged}) {
  PageController pageController = PageController(initialPage: currentPage);

  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          height: 450,
          child: PageView(
            onPageChanged: onPageChanged,
            children: List<Widget>.generate(assetPaths.length, (index) =>
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        assetPaths[index], width: 300, height: 300,),
                    ),
                    getSubtitle(texts[index],),
                  ],
                )),
            controller: pageController,
          ),
        ),
      ),
      Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List<Widget>.generate(assetPaths.length, (index) =>
            Padding(
              padding: const EdgeInsets.all(5),
              child: CircleAvatar(
                backgroundColor: index == currentPage ? MyColors
                    .color_gray_darker : MyColors.color_gray_lighter,
                radius: 5,),
            )),
      ),

    ],
  );
}

Center getEmptyView(BuildContext context, String text,{bool beginButton}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.only(bottom: 100),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
                constraints: BoxConstraints(maxWidth: MyApp.dataModel.screenWidth - 50, maxHeight: MyApp.dataModel.screenWidth - 50),
                child: PlatformSvg.asset(AssetsPath.emptyView)
            ),
            getSubtitle(text),
            getPadding(getButton(
              'Quick start',
              onPressed: (){
                launchPage(context, QuickStartPage());
              }
            ),vertical:15),
          ],
        ),
      ),
    ),
  );
}

List<Widget> getTrackedIntervalsWidget(BuildContext context,dynamic object, Color color,) {
  return List.generate(object.trackedStart.length, (ind) {
    bool show = (object.trackedEnd.length != 0) && (object.trackedEnd.length > ind);

    return GestureDetector(
      onTap: (){
        showEditTimestampsBottomSheet(context, object: object,indexTimestamp: ind);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: <Widget>[
            Center(child: getIcon(Icons.chevron_right),),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Visibility(
                  visible: object.trackedStart.length != 0,
                  child: Card(
                    color: Colors.transparent,
                    shape: getShape(subtleBorder: true),
                    elevation: 0,
                    child: getPadding(getText(
                        getStringFromDate(object.trackedStart[ind]), color: color)),
                  ),
                ),
                Card(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: getShape(subtleBorder: true),
                  child: getPadding(getText(
                      show ? getStringFromDate(object.trackedEnd[ind]) : 'Active',
                      color: color)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  });
}

List<Widget> getCalendarsListForDrawer(BuildContext buildContext) {
  return List<Widget>.generate(MyApp.dataModel.eCalendars.length, (i) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: MyApp.dataModel.eCalendars[i].color,
          maxRadius: 15,
        ),
        //IconButton(
//          icon: getIcon(MyApp.dataModel.eCalendars[i].show
//              ? Icons.check_circle_outline
//              : Icons.radio_button_unchecked,
//              color: MyApp.dataModel.eCalendars[i].color),
//          onPressed: () {
//            ECalendar eCalendar = MyApp.dataModel.eCalendars[i];
//            eCalendar.show = !eCalendar.show;
//            MyApp.dataModel.eCalendar(i, eCalendar, buildContext, CUD.Update);
//          },
//        ),
        title: getText(MyApp.dataModel.eCalendars[i].name,
            color: MyApp.dataModel.eCalendars[i].color),
      ),
    );
  });
}

getYoutubePlayer(String vId) {
  ClipRRect(
    borderRadius: BorderRadius.circular(10),
    child: YoutubePlayer(
      controller: YoutubePlayerController(
          initialVideoId: 'qh9czFNGDBc',
          flags: YoutubePlayerFlags(
            autoPlay: false,
          )
      ),
      showVideoProgressIndicator: true,
    ),
  );
}

Widget getAppBar(String title,
    {bool backEnabled,
      bool centered,
      BuildContext context,
      bool drawerEnabled,
      Widget trailing,
      Widget subtitle,
      bool smallSubtitle,
      String tooltip,
      GlobalKey key,
    }) {
  if (centered == null) {
    centered = false;
  }

  if (smallSubtitle == null) {
    smallSubtitle = true;
  }

  if (drawerEnabled == null) {
    drawerEnabled = false;
  }
  if (backEnabled == null) {
    backEnabled = false;
  }
  return PreferredSize(
    key: key,
    preferredSize: Size(MyApp.dataModel.screenWidth, smallSubtitle ? 100 : 150),
    child: getPadding(Align(
      alignment: centered ? Alignment.bottomCenter : Alignment.bottomLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            brightness: Brightness.dark,
            leading: drawerEnabled?IconButton(
              icon: getIcon(Icons.menu,),
              onPressed: () {
                DistivityPageState.customKey.openDrawer();
              },
            ):backEnabled?IconButton(
              icon: getIcon(Icons.chevron_left), onPressed: () {
              Navigator.pop(context);
            },):Container(),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(child: getText(title, textType: TextType.textTypeTitle,)),
                    Visibility(child: getInfoIcon(context, tooltip),
                      visible: tooltip != null,),
                  ],
                ),
                if(subtitle != null && smallSubtitle)
                  subtitle
              ],
            ),
          ),
          if(!smallSubtitle && subtitle != null)
            subtitle
        ],
      ),
    ), horizontal: 10, vertical: 0),
  );
}

getEmojiSlider(double value, Function(double) onChanged,double size){
  if(size==null||size<=0)size=100;
  return StatefulBuilder(
    builder: (ctx,ss){
      return Container(
        width: size,
        height: 100,
        child:  FlutterSlider(
          values: [0,1,2,3,4],
          min: 0,
          max:4,
          onDragCompleted: (ind,low,high){
            onChanged(value);
          },
          trackBar: FlutterSliderTrackBar(
            activeTrackBarHeight: 10,
            inactiveTrackBarHeight: 10,
            activeTrackBar: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            inactiveTrackBar: BoxDecoration(
              color: MyColors.color_gray_lighter,
              borderRadius: BorderRadius.circular(15)
            )
          ),

          onDragging: (ind,low,high){
            ss((){
              value=low.toDouble();
            });
          },
          decoration: BoxDecoration(color: Colors.transparent),
//          fixedValues: [
//            FlutterSliderFixedValue(value: 0,percent: 0),
//            FlutterSliderFixedValue(value: 1,percent: 25),
//            FlutterSliderFixedValue(value: 2,percent: 50),
//            FlutterSliderFixedValue(value: 3,percent: 75),
//            FlutterSliderFixedValue(value: 4,percent: 100)
//          ],
//          lockHandlers: true,
          tooltip: FlutterSliderTooltip(
            alwaysShowTooltip: false,
            custom: (val)=>Center(),
          ),
          handlerHeight: TextType.textTypeGigant.size+15,
          handlerWidth: TextType.textTypeGigant.size+15,

          handler: FlutterSliderHandler(
            decoration: BoxDecoration(color: Colors.transparent),
            child: getText(getEmojiVal(value.toInt()),textType: TextType.textTypeGigant)
          ),
        ),
      );
    },
  );
}

getEmojiVal(int value){
  switch(value){
    case 0:return Demoji.angry;break;
    case 1:return Demoji.worried;break;
    case 2:return Demoji.slightly_frowning_face	;break;
    case 3:return Demoji.grinning	;break;
    case 4:return Demoji.smiling_face_with_three_hearts	;break;
  }
}

getTabBar({@required List<String> items, @required List<
    int> selected, Function(int, bool) onSelected,int variant}) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(items.length, (index) {
        bool isSelected = selected.contains(index);
        return getPadding(
          getButton(
            items[index],
            variant: (variant??1)==1?isSelected ? 1 : 2:isSelected ? 2 : 1,
            onPressed: () {
              onSelected(index, !isSelected);
            },
          ),
        );
      }),
    ),
  );
}

upcomingTasksAndActivities(BuildContext context, ScrollController controller,
    DateTime selectedDate,) {

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

bool showing = false;

sortByMoneyTasksAndActivities(BuildContext context, ScrollController controller,
    DateTime selectedDate,) {

  return StatefulBuilder(
    builder: (context, ss) {
      return DistivityAnimatedListObj(
        getHeader: (ctx,ind){
          return Container(
            child: Row(
              children: <Widget>[
                getSubtitle("\$${formatDouble(figures(15-ind.toDouble()))}"),
              ],
            ), color: MyColors.color_black_darker,
          );
        },
        additionalButton: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: getButton(showing?'Hide low value entries':'Show low value entries', onPressed: (){
                if(showing==true){
                  ss((){
                    showing=false;
                  });
                  return;
                }
                showDistivityDialog(context, actions: [
                  getButton('Show', onPressed: (){
                    ss((){
                      showing=!showing;
                    });
                    Navigator.pop(context);
                  },variant: 2),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: getButton('Return to excellence', onPressed: ()=>Navigator.pop(context)),
                  ),
                ], title: 'Show low value entries?', stateGetter: (ctx,ss){
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      getText('Below 0\$ activities will only make you feel good and will not make you happy. Time for yourself'
                        ' should be about your relatives, journaling, reading, exercising and meditation. These will actually make '
                        'you happy. \n Watch this video, it explains this concept better'),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId: 'u_zMDLQgFrM',
                            flags: YoutubePlayerFlags(
                              autoPlay: false
                            )
                          ),

                        ),
                      ),
                    ],
                  );
                });
              }),
            ),
          ),
        ),
        getHeaderSelectedDate: (ind){
          return [selectedDate];
        },
        headerItemCount: showing?15:9,
        isObjectSuitableForHeader: (item, ind){
          if(item.value == figures(15.0-ind.toDouble()).toInt()){
            return true;
          }return false;
        },
        whatToShow: WhatToShow.All,
        areMinimal: false,
        scrollController: controller,
      );
    }
  );
}

repeatEditor(BuildContext context,Scheduled scheduled, Function(Scheduled) onScheduledChange,Function ss){
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: getText('Repeats'),
      ),
      getButton(
        getRepeatText(scheduled.repeatRule, scheduled.repeatValue),
        onPressed: (){
          showRepeatEditBottomSheet(context, onUpdate: (rr,rv){
            ss((){
              scheduled.repeatRule=rr;
              scheduled.repeatValue=rv;
              if(scheduled.startTime==null)scheduled.startTime=getTodayFormated();
              onScheduledChange(scheduled);
            });
          }, repeatRule: scheduled.repeatRule, repeatValue: scheduled.repeatValue);
        },
      ),
    ],
  );
}

getDurationWidgetForScheduled(BuildContext context,{
  @required Scheduled scheduled,
  @required Function(Scheduled) onScheduledChange,
  @required Function ss
}){
  
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: getText('Duration'),
      ),
      getButton(
        scheduled.durationInMins == null
            ? "Set duration"
            : "${minuteOfDayToHourMinuteString(scheduled.durationInMins,true)}",
        onPressed: () {
          showPickDurationBottomSheet(context, (d) {
            ss(() {
              scheduled.durationInMins = (d??Duration.zero).inMinutes;
              onScheduledChange(scheduled);
            });
          });
        },
      ),
      Flexible(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Visibility(
            visible: scheduled.startTime!=null,
              child: getText("(Ends on ${getStringFromDate(scheduled.getEndTime())})")),
        ),
      )
    ],
  );
}


getDateTimeEditWidgetForScheduled(BuildContext context,{
  @required Function(Scheduled) onScheduledChange,
  @required Scheduled scheduled,
  @required bool isStartTime,
  String text,
}){
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Flexible(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
          child: getText(text??(isStartTime?'Starts':'Ends'),maxLines: 3),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: getButton(
          getTimeName(isStartTime?scheduled.startTime:scheduled.getEndTime()),
          onPressed: () {
            showDistivityTimePicker(context,
                TimeOfDay.fromDateTime(
                    (isStartTime?scheduled.startTime:scheduled.getEndTime()) ?? getTodayFormated()
                ),
                onTimeSelected: (time) {
                  if (scheduled.startTime == null) {
                    scheduled.startTime = getTodayFormated();
                  }
                  if(time==null){
                    scheduled.startTime=null;
                  }else{
                    if(isStartTime){
                      scheduled.startTime = DateTime(
                          scheduled.startTime.year,
                          scheduled.startTime.month,
                          scheduled.startTime.day, time.hour,
                          time.minute);
                    }else{
                      scheduled.durationInMins = DateTime(
                          scheduled.getEndTime().year,
                          scheduled.getEndTime().month,
                          scheduled.getEndTime().day,
                          time.hour,
                          time.minute
                      ).difference(scheduled.startTime).inMinutes;
                    }
                  }
                  onScheduledChange(scheduled);
                });
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(15),
        child: getText('•'),
      ),
      getButton(
        getDateName(isStartTime?scheduled.startTime:scheduled.getEndTime()),
        onPressed: () {
          showDistivityDatePicker(
              context, onDateSelected: (date) {
            if (scheduled.startTime == null) {
              scheduled.startTime = getTodayFormated();
            }
            if(date==null){
              scheduled.startTime=null;
            }else{
              if(isStartTime){
                scheduled.startTime = DateTime(
                    date.year, date.month, date.day,
                    scheduled.startTime.hour,
                    scheduled.startTime.minute);
              }else{
                scheduled.durationInMins = DateTime(
                    date.year, date.month, date.day,
                    scheduled.getEndTime().hour, scheduled.getEndTime().minute
                ).difference(scheduled.startTime).inMinutes;
              }
            }
            onScheduledChange(scheduled);
          });
        },
      ),
    ],
  );
}

scheduledEditor(BuildContext context,Scheduled scheduled, Function(Scheduled) onScheduledChange) {
  if(onScheduledChange is Function){
    return StatefulBuilder(
      builder: (ctx,ss){
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            //starts
            getDateTimeEditWidgetForScheduled(context, onScheduledChange: onScheduledChange,
                scheduled: scheduled, isStartTime: true),
            getPadding(getDurationWidgetForScheduled(context, scheduled: scheduled,
                onScheduledChange: onScheduledChange, ss: ss),horizontal: 0),
            repeatEditor(context, scheduled, (sc){
              ss((){
                scheduled=sc;
              });
            },ss),
          ],
        );
      },
    );
  }
}


getSortByCalendarListView(BuildContext context,
    DateTime selectedDate,
    {bool areMinimal,
      Function(dynamic) onSelected,
      WhatToShow whatToShow,
      bool scrollable,
      ScrollController controller,
    }) {

  if(whatToShow==null){
    whatToShow=WhatToShow.All;
  }

  return DistivityAnimatedListObj(
    whatToShow: whatToShow,
    isObjectSuitableForHeader: (obj,ind){
      if(obj is Task && whatToShow==WhatToShow.Activities)return false;
      if(obj is Activity && whatToShow==WhatToShow.Tasks)return false;
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

Widget getSelectedDaysWidgetForAppBar(BuildContext context,
    {@required DateTime selectedDate,
      @required SelectedView selectedView,
      @required Function(DateTime, int) onNewDateSelectedPlusPage}) {
  return GestureDetector(
    child: getText(getDatesNameForAppBarSelector(selectedDate, selectedView)),
    onTap: () {
      showDistivityDatePicker(context, onDateSelected: (datetime) {
        if (datetime != null) {
          int differenceFromNow = datetime
              .difference(getTodayFormated())
              .inDays;

          int differenceFromNowFormatted = 0;
          switch (selectedView) {
            case SelectedView.Day:
              differenceFromNowFormatted = differenceFromNow;
              break;
            case SelectedView.ThreeDay:
              if (differenceFromNow == 2) differenceFromNow = 3;

              if (differenceFromNow < 3) {
                //less than 3
                if (differenceFromNow > -3) {
                  //greater than -3
                  differenceFromNowFormatted = differenceFromNow > 0 ? 0 : -1;
                  break;
                }
              }
              differenceFromNowFormatted = (differenceFromNow ~/ 3).toInt();
              break;
            case SelectedView.Week:
              if (differenceFromNow == 6) differenceFromNow = 7;
              if (differenceFromNow < 7) {
                //less than 7
                if (differenceFromNow > -7) {
                  //greater than -7
                  differenceFromNowFormatted = differenceFromNow > 0 ? 0 : -1;
                  break;
                }
              }
              differenceFromNowFormatted = (differenceFromNow ~/ 7).toInt();
              break;
            case SelectedView.Month:
              if (differenceFromNow == 29) differenceFromNow = 30;
              if (differenceFromNow < 30) {
                //less than 30
                if (differenceFromNow > -30) {
                  //greater than -30
                  differenceFromNowFormatted = differenceFromNow > 0 ? 0 : -1;
                  break;
                }
              }
              differenceFromNowFormatted = (differenceFromNow ~/ 30).toInt();
              break;
          }

          onNewDateSelectedPlusPage(datetime, differenceFromNowFormatted + 50);
        }
      });
    },
  );
}

getSelectedViewIconButton(BuildContext context, SelectedView selectedView,
    Function(SelectedView) onSelectedView) {
  IconData iconData;
  switch (selectedView) {
    case SelectedView.Day:
      iconData = Icons.calendar_view_day;
      break;
    case SelectedView.ThreeDay:
      iconData = Icons.today;
      break;
    case SelectedView.Week:
      iconData = Icons.calendar_today;
      break;
    case SelectedView.Month:
      iconData = Icons.grid_on;
      break;
  }

  return IconButton(
    icon: getIcon(iconData),
    onPressed: () {
      showDistivityModalBottomSheet(context, (ctx, ss) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: getIcon(Icons.calendar_view_day),
              title: getText('Day view'),
              onTap: () {
                onSelectedView(SelectedView.Day);
                MyApp.dataModel.prefs.setSelectedView(SelectedView.Day);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: getIcon(Icons.calendar_today),
              title: getText('3 Day view'),
              onTap: () {
                onSelectedView(SelectedView.ThreeDay);
                MyApp.dataModel.prefs.setSelectedView(SelectedView.ThreeDay);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: getIcon(Icons.today),
              title: getText('Week view'),
              onTap: () {
                onSelectedView(SelectedView.Week);
                MyApp.dataModel.prefs.setSelectedView(SelectedView.Week);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: getIcon(Icons.grid_on),
              title: getText('Month view'),
              onTap: () {
                onSelectedView(SelectedView.Month);
                MyApp.dataModel.prefs.setSelectedView(SelectedView.Month);
                Navigator.pop(context);
              },
            ),
          ],
        );
      });
    },
  );
}