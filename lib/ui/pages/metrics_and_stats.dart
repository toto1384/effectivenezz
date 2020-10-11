import 'package:after_layout/after_layout.dart';
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/ui/pages/metric_page.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_drawer.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/basics/rosse_scaffold.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gmetric_widget.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gselected_days_widget_for_app_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/pricing/gpremium_wrapper.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gmax_web_width.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gscaffold.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:effectivenezz/utils/stats_utils.dart';
import 'package:flutter/material.dart';
import 'package:sweetsheet/sweetsheet.dart';

class MetricsAndStatsPage extends StatefulWidget {
  @override
  _MetricsAndStatsPageState createState() => _MetricsAndStatsPageState();
}

class _MetricsAndStatsPageState extends DistivityPageState<MetricsAndStatsPage> with AfterLayoutMixin{

  DateTime selectedDate = getTodayFormated();


  @override
  void afterFirstLayout(BuildContext context) async{
    if(await MyApp.dataModel.prefs.isFirstTime(this.runtimeType.toString())){
      SweetSheet sweetSheet = SweetSheet();
      sweetSheet.show(
          context: context,
          description: GText('Here are your metrics and stats. Organized in today, weekly, and monthly views. '
              'Start tracking to see those metrics fill up'
              'Tap on each metric to expand it,',color: MyColors.color_black_darker,),
          color: MyColors.customSheetColor,
          icon: Icons.pie_chart_outlined,
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
        child:GScaffold(
          key: scaffoldKey,
          drawer: DistivityDrawer(),
          body: RosseSilver(
            'Metrics and Stats',
            body: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                  child: GSelectedDaysWidgetForAppBar(
                      selectedDate: selectedDate, selectedView: SelectedView.Day, onNewDateSelectedPlusPage: (date,i){
                        setState(() {
                          selectedDate=date;
                        });
                      }),
                ),
                getSubtitle('Weekly(${getDatesNameForAppBarSelector(selectedDate,SelectedView.Week)})'),
              ]+
                  List.generate(Metric.values.length, (index) => GPremiumWrapper(
                    upgradeButton: true,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Card(
                          color: MyColors.color_black_darker,
                            child:Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    getSubtitle(getMetricName(Metric.values[index])),
                                    GMetricWidget( Metric.values[index], StatPeriod.week, selectedDate,Size.Large),
                                  ],
                                ),
                              ),
                            ),shape: getShape(smallRadius: true),
                        ),
                      ),
                    ),
                  ))+[getSubtitle('Monthly(${getDatesNameForAppBarSelector(selectedDate,SelectedView.Month)})')]+
                  List.generate(Metric.values.length, (index) => GPremiumWrapper(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                        child: Card(
                          color: MyColors.color_black_darker,
                            child:Container(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    getSubtitle(getMetricName(Metric.values[index])),
                                    GMetricWidget( Metric.values[index], StatPeriod.month, selectedDate,Size.Large),
                                  ],
                                ),
                              ),
                            ),shape: getShape(smallRadius: true),
                        ),
                      ),
                    ),
                  )),
            ),
            appBarWidget: Column(
              key: GlobalKey(),
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: GText('${getDatesNameForAppBarSelector(selectedDate, SelectedView.Day)}\'s metrics',textType: TextType.textTypeSubtitle),
                    ),
//                IconButton(
//                  icon: getIcon(Icons.arrow_forward_ios),
//                  onPressed: (){
//                    launchPage(context, TodaySMetricsPage());
//                  },
//                ),
                  ],
                ),
                Container(
                  width: MyApp.dataModel.screenWidth-30,
                  height: 150,
                  child: ListView.builder(itemCount: Metric.values.length,itemBuilder: (ctx,ind){
                    return GPremiumWrapper(
                      child: GestureDetector(
                        onTap: (){
                          launchPage(context, MetricPage(metric: Metric.values[ind],));
                        },
                        child: Card(
                          child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 125,
                            height: 125,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GText(getMetricName(Metric.values[ind]),textType: TextType.textTypeSubtitle,isCentered: true),
                                Center(child: GMetricWidget( Metric.values[ind], StatPeriod.day, selectedDate,Size.Small)),
                              ],
                            ),
                          ),
                        ),shape: getShape(smallRadius: true),color: MyColors.color_black),
                      ),
                    );
                  },scrollDirection: Axis.horizontal,),
                ),
              ],
            ),
            color: MyColors.color_black,
            backEnabled: false,
            //expandedHeight: 300,
          ),
        )
    );
  }
}