
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/ui/widgets/distivity_calendar_widget.dart';
import 'package:effectivenezz/ui/widgets/distivity_drawer.dart';
import 'package:effectivenezz/ui/widgets/distivity_zoom_widget.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends DistivityPageState<CalendarPage> {

  SelectedView selectedView=SelectedView.Day;
  DateTime selectedDate = getTodayFormated();

  PageController pageController = PageController(
    initialPage: 50,
  );

  ScrollController scrollController = ScrollController(
  );

  int pixelsScrolled = 0;

  @override
  void initState() {
    selectedView=MyApp.dataModel.prefs.getSelectedView();
    super.initState();
  }
  double heightPerMinute = 2.0;
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: Scaffold(
        key: scaffoldKey,
        drawer: DistivityDrawer(),
        appBar: getAppBar(
          "Calendar",
          smallSubtitle: true,
          subtitle: getSelectedDaysWidgetForAppBar(
              context,
              selectedDate: selectedDate,
              selectedView: selectedView,
              onNewDateSelectedPlusPage: (datetime,pageIndex){
                pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
              }),
          trailing: getSelectedViewIconButton(context, selectedView, (s){
            setState(() {
              selectedView=s;
            });
          }),
          drawerEnabled: true,
          context: context,
        ),
        floatingActionButton: getDistivityFab(selectedDate,(f,b){
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
        return Center(child: getText('Will be implemented in future release'),);
        break;
      default:
        return PageView.builder(itemBuilder: (ctx,ind){
          return SingleChildScrollView(
            controller: scrollController,
            child: DistivityCalendarWidget(
              heightPerMinute: heightPerMinute,
              days: selectedDateTimes,
              forPlanVsTracked: false,
              selectedView: selectedView,
              plannedTimestamps: MyApp.dataModel.getTimeStamps(context,dateTimes: selectedDateTimes),
            ),
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
        },);
        break;
    }
  }
}
