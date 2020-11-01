
import 'package:after_layout/after_layout.dart';
import 'package:calendar_views/calendar_views.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_drawer.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_fab.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_zoom_widget.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/basics/rosse_scaffold.dart';
import 'package:effectivenezz/ui/widgets/distivity_calendar_widget.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gapp_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ginfo_icon.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gselected_days_widget_for_app_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gselected_view_icon_button.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gtab_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/pricing/gpremium_wrapper.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gscaffold.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sweetsheet/sweetsheet.dart';

import '../../main.dart';

class PlanVsTrackedPage extends StatefulWidget {
  @override
  _PlanVsTrackedPageState createState() => _PlanVsTrackedPageState();
}

class _PlanVsTrackedPageState extends DistivityPageState<PlanVsTrackedPage> with AfterLayoutMixin{

  SelectedView selectedView=SelectedView.Day;
  PlanTracked planTracked = PlanTracked.Plan;
  DateTime selectedDate = getTodayFormated();

  PageController pageController = PageController(
    initialPage: 50,
  );

  ScrollController scrollController = ScrollController(
  );

  int pixelsScrolled = 0;

  double heightPerMinute = 2.0;

  @override
  void initState() {
    selectedView=MyApp.dataModel.prefs.getSelectedView();
    super.initState();
  }

  SweetSheet sweetSheet = SweetSheet();

  @override
  void afterFirstLayout(BuildContext context) async{
    if(await MyApp.dataModel.prefs.isFirstTime(this.runtimeType.toString())){
      sweetSheet.show(
          context: context,
          title: GText('Plan',textType: TextType.textTypeTitle,
            color: MyColors.color_black_darker,),
          description: GText('This acts as your calendar. The tasks/activities that you\'ve planned in the Track Page'
              ' will appear here',color: MyColors.color_black_darker,),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    List<DateTime> selectedDateTimes =
    (selectedView==SelectedView.Day)?[selectedDate]:
    (selectedView==SelectedView.ThreeDay)?[selectedDate,selectedDate.add(Duration(days: 1)),selectedDate.add(Duration(days: 2))]:
    (selectedView==SelectedView.Week)?List.generate(7, (i)=>selectedDate.add(Duration(days: i))):[];

    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: GScaffold(
        key: scaffoldKey,
        drawer: DistivityDrawer(),
        floatingActionButton: GPremiumWrapper(
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
          }),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        appBar: GAppBar(
          'Calendar',
          smallSubtitle: false,
          disablePadding: true,
          drawerEnabled: true,
          subtitle: GTabBar(
              items: ["Plan","Tracked","Plan vs Tracked" ,],
              selected: [PlanTracked.values.indexOf(planTracked)],
              variant: 2,
              onSelected: (i,b)async{
                setState(() {
                  if(b)planTracked=PlanTracked.values[i];
                });
                if(i==1){
                  if(await MyApp.dataModel.prefs.isFirstTime('Tracked')){
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
                  if(await MyApp.dataModel.prefs.isFirstTime('PlanVsTracked')){
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
        body: selectedView==SelectedView.Month?Center(child: GText('Will be implemented in a future release'),):
        PageView.builder(itemBuilder: (ctx,ind){
          return VerticalZoom(
            onScaleChange: (d){
              setState(() {
                heightPerMinute=d/(24*60);
              });
            },
            contentHeight: heightPerMinute*24*60,
            child: GPremiumWrapper(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: DistivityCalendarWidget(
                  heightPerMinute: heightPerMinute,
                  days: selectedDateTimes,
                  forPlanVsTracked: true,
                  selectedView: selectedView,
                  plannedTimestamps:getTimeStamps(selectedDateTimes,false),
                  trackedTimestamps: getTimeStamps(selectedDateTimes,true),
                ),
              ),
            ),
          );

        },controller: pageController,onPageChanged: (page){
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
              // TODO: Handle this case.
                break;
            }
          });
        },)
      ),
    );
  }

  getTimeStamps(List<DateTime> selectedDateTimes,bool planned){
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
}
