import 'package:effectivenezz/objects/timestamp.dart';
import 'package:effectivenezz/ui/widgets/distivity_calendar_widget.dart';
import 'package:effectivenezz/ui/widgets/distivity_fab.dart';
import 'package:effectivenezz/ui/widgets/distivity_zoom_widget.dart';
import 'package:effectivenezz/ui/widgets/rosse_scaffold.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../main.dart';

class PlanVsTrackedPage extends StatefulWidget {
  @override
  _PlanVsTrackedPageState createState() => _PlanVsTrackedPageState();
}

class _PlanVsTrackedPageState extends DistivityPageState<PlanVsTrackedPage>{

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


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: RosseScaffold(
        '',
        scaffoldKey: scaffoldKey,
        scrollController: scrollController,
        fab: DistivityFAB(controllerLogic:(f,b){
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        color: MyColors.color_black,
        expandedHeight: 250,
        trailing: getSelectedViewIconButton(context, selectedView, (s){
          setState(() {
            selectedView=s;
          });
        }),
        appBarWidget: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10,top: 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                 getText('Calendar',textType: TextType.textTypeTitle),
                 getInfoIcon(context, "Here you will get a clear picture of your expectations of yourself, and what you did. "
                     +"The Semi-Transparent blocks are what you've planned, and the Opaque blocks are what you've tracked")
                ],
              ),
            ),
            getTabBar(
                items: ["Plan","Tracked","Plan vs Tracked" ,],
                selected: [PlanTracked.values.indexOf(planTracked)],
                variant: 2,
                onSelected: (i,b){
                  setState(() {
                    if(b)planTracked=PlanTracked.values[i];
                  });
                }),
            getPadding(getSelectedDaysWidgetForAppBar(
                context,
                selectedDate: selectedDate,
                selectedView: selectedView,
                onNewDateSelectedPlusPage: (datetime,pageIndex){
                  pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
                }),horizontal: 15),
          ],
        ),
        body:DistivityZoomWidget(
          onScaleChange: (d){
            double offset=d-heightPerMinute;
            setState(() {
              heightPerMinute=d;
            });
            scrollController.jumpTo(scrollController.position.pixels+offset*500);
          },
          maxScale: 5.0,
          child: getCalendarBody(),
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
        return Center(child: getText('Will be implemented in a future release'),);
        break;
      default:
        return Container(
          width: MediaQuery.of(context).size.width-10,
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
