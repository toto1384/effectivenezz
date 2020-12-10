import 'package:calendar_views/calendar_views.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_drawer.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_fab.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_zoom_widget.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/distivity_calendar_widget.dart';
import 'package:effectivenezz/ui/widgets/lists/glist_refresher.dart';
import 'package:effectivenezz/ui/widgets/lists/gsort_by_money_tasks_and_activities.dart';
import 'package:effectivenezz/ui/widgets/specific/distivity_secondary_item.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gapp_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gselected_view_icon_button.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gtab_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/pricing/gpremium_wrapper.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gscaffold.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:sweetsheet/sweetsheet.dart';
import 'package:uuid/uuid.dart';

import '../../main.dart';

class PlanVsTrackedPage extends StatefulWidget {
  @override
  PlanVsTrackedPageState createState() => PlanVsTrackedPageState();
}

class PlanVsTrackedPageState extends DistivityPageState<PlanVsTrackedPage>{

  SelectedView selectedView=SelectedView.Day;
  PlanTracked planTracked = PlanTracked.Plan;
  DateTime selectedDate = getTodayFormated();

  PageController pageController = PageController(
    initialPage: 50,
  );

  ScrollController scrollController = ScrollController(
  );

  int pixelsScrolled = 0;

  GlobalKey positionedKey = GlobalKey();

  double heightPerMinute = 2.0;

  @override
  void initState() {
    selectedView=MyApp.dataModel.backend.prefs.getSelectedView();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      afterFirstLayout();
    });
  }

  SweetSheet sweetSheet = SweetSheet();
  bool isShowing = false;

  void afterFirstLayout() async{
    DistivityPageState.pageChangeCallback.listen((type) {
      if(type==PlanVsTrackedPage)return;
      DistivityCalendarWidget.scheduledCallback.disposeListens();
      if(DistivityCalendarWidget.scheduledCallback.newScheduled!=null){
        closeOverlay();DistivityCalendarWidget.scheduledCallback.notifyUpdated(null);
      }
    });
    if(await MyApp.dataModel.backend.prefs.isFirstTime(this.runtimeType.toString())){
      sweetSheet.show(
          context: context,
          title: GText('Plan',textType: TextType.textTypeTitle,
            color: MyColors.color_black_darker,),
          description: GText('This acts as your calendar. The tasks/activities that you\'ve planned in'
              ' the Track Page will appear here',color: MyColors.color_black_darker,),
          color: MyColors.customSheetColor,
          icon: Icons.calendar_today,
          positive: SweetSheetAction(
            color: Colors.white,
            title: 'GOT IT',
            onPressed: (){
              Navigator.pop(context);
              sweetSheet.show(
                  context: context,
                  title: GText('Schedule',textType: TextType.textTypeTitle,
                    color: MyColors.color_black_darker,),
                  description: GText('Just tap on the calendar to schedule your day. You can either schedule'
                      ' a new task/activity(just as any other calendar) or schedule a existing task/activity('
                      'for example you can schedule multiple work or nap blocks in your day)',
                    color: MyColors.color_black_darker,),
                  color: MyColors.customSheetColor,
                  icon: Icons.calendar_today,
                  positive: SweetSheetAction(
                    color: Colors.white,
                    title: 'GOT IT',
                    onPressed: (){
                      Navigator.pop(context);
                      sweetSheet.show(
                          context: context,
                          title: GText('Double tap to track',textType: TextType.textTypeTitle,
                            color: MyColors.color_black_darker,),
                          description: GText('Oh and if you are lazy to go to the Track Page just double tap'
                              ' on any activity/task to track them',color: MyColors.color_black_darker,),
                          color: MyColors.customSheetColor,
                          icon: Icons.calendar_today,
                          positive: SweetSheetAction(
                            color: Colors.white,
                            title: 'GOT IT',
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          )
                      );
                    },
                  )
              );
            },
          )
      );
    }
    DistivityCalendarWidget.scheduledCallback.listen((s){
      if(mounted){
          if(s!=null){
            if((GScaffoldState.deviceScreenType==DeviceScreenType.desktop)){
              Future.delayed(Duration.zero).then((value) {
                if(!isShowing){
                  isShowing=true;
                  showDistivityDialogAtPosition(context,
                      renderBox: (positionedKey.
                      currentContext.findRenderObject() as RenderBox),
                      stateGetter: (ctx,ss,close){
                        this.close=close;
                        return getSlidingSheet(ss);
                      },selectedView: selectedView);
                }
              });
            }else{
                if(sheetController.state.isHidden){
                  sheetController.show().then((value) {setState(() {});});
                }
            }
          }
      }
    });
  }

  SheetController sheetController = SheetController();

  bool isTasks=false;

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: GScaffold(
        key: scaffoldKey,
        bottomNavigationBar: MyApp.dataModel!=null?(MyApp.dataModel.currentPlaying!=null)?DistivitySecondaryItem():null:null,
        drawer: DistivityDrawer(),
        floatingActionButton: GScaffoldState.deviceScreenType==DeviceScreenType.mobile?GPremiumWrapper(
          upgradeButton: false,
          height: 75,
          width: 75,
          child: DistivityFAB(controllerLogic:(f,b){
            scrollController.addListener(() {
              if(scrollController.position.userScrollDirection == ScrollDirection.reverse){
                b();
              } else {
                if(scrollController.position.userScrollDirection == ScrollDirection.forward){
                  f();
                }
              }
            });
          },isInCalendar: true,),
        ):null,
        floatingActionButtonLocation: kIsWeb?FloatingActionButtonLocation.startFloat:FloatingActionButtonLocation.endFloat,
        appBar: GAppBar(
          'Calendar',
          explicitTitle: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: GIcon(Icons.chevron_left),
                onPressed: (){
                  pageController.jumpToPage(pageController.page.toInt()-1);
                },
              ),
              GestureDetector(
                onTap: () {
                  showDistivityDatePicker(context, onDateSelected: (datetime) {
                    if (datetime != null) {
                      setState(() {
                        selectedDate=datetime;
                      });
                    }
                  });
                },
                child: GText(getDatesNameForAppBarSelector(selectedDate,selectedView),textType: TextType.textTypeSubtitle,)),
              IconButton(
                icon: GIcon(Icons.chevron_right),
                onPressed: (){
                  pageController.jumpToPage(pageController.page.toInt()+1);
                },
              ),
            ],
          ),
          smallSubtitle: false,
          disablePadding: true,
          drawerEnabled: true,
          subtitle: GTabBar(
              items: ["Plan","Tracked","Plan vs Tracked" ,],
              selected: [PlanTracked.values.indexOf(planTracked)],
              variant: 1,
              onSelected: (i,b)async{
                setState(() {
                  if(b)planTracked=PlanTracked.values[i];
                });
                if(i==1){
                  if(await MyApp.dataModel.backend.prefs.isFirstTime('Tracked')){
                    sweetSheet.show(
                      context: context,
                      title: GText('Tracked',textType: TextType.textTypeTitle,color: MyColors.color_black_darker,),
                      description: GText('Here you will see what you\'ve done throughout the day. Start tracking'
                          ' in the track screen or use your notification for quick tracking in a popup.',
                        color: MyColors.color_black_darker,),
                      color: MyColors.customSheetColor,
                      icon: Icons.calendar_view_day,
                      positive: SweetSheetAction(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        title: 'GOT IT',
                      ),
                    );
                  }
                }else if(i==2){
                  if(await MyApp.dataModel.backend.prefs.isFirstTime('PlanVsTracked')){
                    sweetSheet.show(
                        context: context,
                        icon: Icons.compare_arrows,
                        description: GText('Here you can compare what you\'ve planned and what you\'ve tracked',
                          color: MyColors.color_black_darker,),
                        title: GText('Plan Vs Tracked',textType: TextType.textTypeTitle,color: MyColors.color_black_darker,),
                        color: MyColors.customSheetColor,
                        positive: SweetSheetAction(
                          title: 'GOT IT',
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        )
                    );
                  }
                }
              }),
          trailing: GSelectedViewIconButton(selectedView,heightPerMinute,onSelectedView: (s){
            setState(() {
              selectedView=s;
            });
          },onZoomUpdate: (v){
            setState(() {
              heightPerMinute=v;
            });
          },),
        ),
        body: SlidingSheet(
          maxWidth: MediaQuery.of(context).size.height,
          duration: Duration(milliseconds: 100),
          elevation: 0,
          cornerRadius: 16,
          color: MyColors.color_black_darker,
          cornerRadiusOnFullscreen: 0,
          builder: (ctx,state){
            return StatefulBuilder(
              builder: (context, ss) {
                return getSlidingSheet(ss);
              }
            );
          },
          snapSpec: SnapSpec(
            snappings: [.1,0.3, 1.0],initialSnap: 0,
            positioning: SnapPositioning.relativeToAvailableSpace,
          ),
          controller: sheetController,
          body: PageView.builder(itemBuilder: (ctx,ind){
            if(selectedView==SelectedView.Month){
              return MonthView(
                  month: selectedDate,
                  dayOfMonthBuilder: (ctx,day){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(width: 2,color: Colors.white),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: InkWell(
                          onTap: (){
                            showDistivityModalBottomSheet(context, (ctx,ss,c){
                              return DistivityCalendarWidget(day: day.day,
                                heightPerMinute: heightPerMinute,
                                positionedKey: positionedKey,
                                forPlanVsTracked: planTracked,
                                selectedView: SelectedView.Day,);
                            });
                          },
                          child: Center(child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              GText('${day.day.day}',textType: TextType.textTypeSubtitle,),
                              GText('${getMonthOfTheYearStringShort(day.day.month, true)}',)
                            ],
                          )),
                        ),
                      ),
                    );
                  }
              );
            }
            return LayoutBuilder(
              builder: (context, det) {
                return Padding(
                  padding: EdgeInsets.only(bottom: (sheetController.state?.isShown??false?60:0)),
                  child: GListRefresher(
                    child: VerticalZoom(
                      onScaleChange: (d){
                        setState(() {
                          heightPerMinute=(d-30)/(24*60);
                        });
                      },
                      minChildHeight: det.maxHeight,
                      contentHeight: heightPerMinute*24*60+30,
                      child: GPremiumWrapper(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: DistivityCalendarWidget(
                            heightPerMinute: heightPerMinute,
                            positionedKey: positionedKey,
                            day: selectedView==SelectedView.Week?selectedDate.subtract(Duration(days: selectedDate.weekday)):selectedDate,
                            forPlanVsTracked: planTracked,
                            selectedView: selectedView,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
            );

          },physics:kIsWeb?NeverScrollableScrollPhysics():null,controller: pageController,onPageChanged: (page){
            setState(() {
              switch(selectedView){
                case SelectedView.Day:
                  selectedDate=getTodayFormated().add(Duration(days: page-50));
                  break;
                case SelectedView.ThreeDay:
                  selectedDate=getTodayFormated().add(Duration(days: (page-50)*3));
                  break;
                case SelectedView.Week:
                  selectedDate=getTodayFormated().add(Duration(days: (page-50)*7));
                  break;
                case SelectedView.Month:
                  selectedDate=getTodayFormated().add(Duration(days: (page-50)*30));
                  break;
              }
            });
          },),
        )
      ),
    );
  }

  static getTimeStamps(BuildContext context,
      {@required List<DateTime> selectedDateTimes,@required bool planned,@required PlanTracked planTracked}){
    List<TimeStamp> toreturn = [];
    switch(planTracked){

      case PlanTracked.PlanVsTracked:
        if(planned){
          toreturn.addAll( MyApp.dataModel.getTimeStamps(context,dateTimes: selectedDateTimes,tracked: true,plannedSemiOpacity: true));
        }else{
          toreturn.addAll( MyApp.dataModel.getTimeStamps(context,dateTimes: selectedDateTimes,tracked: false,plannedSemiOpacity: true));
        }
        break;
      case PlanTracked.Plan:
        if(planned)toreturn.addAll( MyApp.dataModel.getTimeStamps(context,dateTimes: selectedDateTimes,tracked: false));
        break;
      case PlanTracked.Tracked:
        if(!planned)toreturn.addAll( MyApp.dataModel.getTimeStamps(context,dateTimes: selectedDateTimes,tracked: true));
        break;
    }
    return toreturn;
  }

  Function close;

  closeOverlay(){
    if((GScaffoldState.deviceScreenType==DeviceScreenType.desktop)){
      setState(() {
        if(close!=null)close();
        isShowing=false;
      });
    }else sheetController.hide();
  }

  Widget getSlidingSheet(ss) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: (IconButton(
                  onPressed: (){
                    closeOverlay();DistivityCalendarWidget.scheduledCallback.notifyUpdated(null);
                  },
                  icon: GIcon(Icons.close),
                )),
              ),
              if(GScaffoldState.deviceScreenType!=DeviceScreenType.desktop)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Card(shape: getShape(),child: Container(width: 100,height: 5,),color: MyColors.color_gray_darker,),
                      ),
                      onTap: ()=>sheetController.snapToExtent(sheetController.state.extent==.1?0.3:1),
                    ),
                  ),
                )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GText('Schedule Activity/Task',textType: TextType.textTypeSubtitle,),
                IconButton(icon: GIcon(Icons.search), onPressed: (){
                  Fluttertoast.showToast(msg: 'Will be implemented in a future release');
                }),
              ],
            ),
          ),
          ListTile(
            leading: GIcon(Icons.add),
            onTap: (){
              closeOverlay();
              showAddEditObjectBottomSheet(context, selectedDate: selectedDate,
                  isTask: false, isInCalendar: true,add: true,withNewScheduled: true);
            },
            title: GText('Schedule new Activity'),
          ),
          ListTile(
            leading: GIcon(Icons.add),
            title: GText('Schedule new Task'),
            onTap: (){
              closeOverlay();
              showAddEditObjectBottomSheet(context, selectedDate: selectedDate,
                  isTask: true, isInCalendar: true,add: true,withNewScheduled: true);
            },
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GTabBar(items: ['Activities' , 'Tasks'], selected: [isTasks?1:0],onSelected: (i,b){
              if(b){
                ss((){
                  isTasks=(i==1);
                });
              }
            },),
          ),
          GSortByMoneyTasksAndActivities(
            ScrollController(),selectedDate,
            scrollable: false,whatToShow: isTasks?WhatToShow.Tasks:WhatToShow.Activities,
            areMinimal: true,onSelected: (item)async{
              String id = Uuid().v4();
              if(item is Task){
                await MyApp.dataModel.task(item..schedules.add(id), context, CUD.Update);
              }else{
                await MyApp.dataModel.activity(item..schedules.add(id), context, CUD.Update);
              }
              await MyApp.dataModel.scheduled(DistivityCalendarWidget.
              scheduledCallback.newScheduled..id=id, context, CUD.Create,item.id);
              DistivityCalendarWidget.scheduledCallback.notifyUpdated(null);
              closeOverlay();
            },
          ),
        ]
    );
  }
}
