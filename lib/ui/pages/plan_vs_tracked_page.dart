
import 'package:after_layout/after_layout.dart';
import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_fab.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_zoom_widget.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/basics/rosse_scaffold.dart';
import 'package:effectivenezz/ui/widgets/distivity_calendar_widget.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ginfo_icon.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gselected_days_widget_for_app_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gselected_view_icon_button.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gtab_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/pricing/gpremium_wrapper.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
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
    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: RosseScaffold(
          '',
          scaffoldKey: scaffoldKey,
          scrollController: scrollController,
          fab: GPremiumWrapper(
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
          color: MyColors.color_black,
//        expandedHeight: 250,
          trailing: GSelectedViewIconButton(selectedView, (s){
            setState(() {
              selectedView=s;
            });
          }),
          appBarWidget: Column(
            key: GlobalKey(),
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 10,top: 10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                   GText('Calendar',textType: TextType.textTypeTitle),
                   GInfoIcon("Here you will get a clear picture of your expectations of yourself, and what you did. "
                       +"The Semi-Transparent blocks are what you've planned, and the Opaque blocks are what you've tracked")
                  ],
                ),
              ),
              GTabBar(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                child: (GSelectedDaysWidgetForAppBar(
                    selectedDate: selectedDate,
                    selectedView: selectedView,
                    onNewDateSelectedPlusPage: (datetime,pageIndex){
                      pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                    })),
              ),
            ],
          ),
          body: Container(
            height: heightPerMinute*60*24+100,
            child: DistivityZoomWidget(
              onScaleChange: (d){
                double offset=d-heightPerMinute;
                setState(() {
                  heightPerMinute=d;
                });
                scrollController.jumpTo(scrollController.position.pixels+offset*500);
              },
              maxScale: 5.0,
              child: GPremiumWrapper(
                child: getCalendarBody(),
              ),
            ),
          ),

        ),
    );
  }

  getCalendarBody(){

    List<DateTime> selectedDateTimes =
    (selectedView==SelectedView.Day)?[selectedDate]:
    (selectedView==SelectedView.ThreeDay)?[selectedDate,selectedDate.add(Duration(days: 1)),selectedDate.add(Duration(days: 2))]:
    (selectedView==SelectedView.Week)?List.generate(7, (i)=>selectedDate.add(Duration(days: i))):[];

    switch(selectedView){
      case SelectedView.Month:
        return Center(child: GText('Will be implemented in a future release'),);
        break;
      default:
        return Container(
          width: MyApp.dataModel.screenWidth-10,
          height: heightPerMinute*60*24+100,
          child: PageView.builder(itemBuilder: (ctx,ind){
            return DistivityCalendarWidget(
              heightPerMinute: heightPerMinute,
              days: selectedDateTimes,
              forPlanVsTracked: true,
              selectedView: selectedView,
              plannedTimestamps:getTimeStamps(selectedDateTimes,false),
              trackedTimestamps: getTimeStamps(selectedDateTimes,true),
            );

          },controller: pageController,onPageChanged: (page){
            setState(() {
              switch(selectedView){
                case SelectedView.Day:
                  selectedDate=getDateFromString(getStringFromDate(DateTime.now())).add(Duration(days: page-50));
                  break;
                case SelectedView.ThreeDay:
                  selectedDate=getDateFromString(getStringFromDate(DateTime.now())).add(Duration(days: (page-50)*3));
                  break;
                case SelectedView.Week:
                  selectedDate=getDateFromString(getStringFromDate(DateTime.now())).add(Duration(days: (page-50)*7));
                  break;
                case SelectedView.Month:
                // TODO: Handle this case.
                  break;
              }
            });
          },),
        );
        break;
    }
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
