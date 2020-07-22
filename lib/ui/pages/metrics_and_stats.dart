import 'package:effectivenezz/ui/pages/metric_page.dart';
import 'package:effectivenezz/ui/widgets/rosse_scaffold.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:effectivenezz/utils/stats_utils.dart';
import 'package:flutter/material.dart';

class MetricsAndStatsPage extends StatefulWidget {
  @override
  _MetricsAndStatsPageState createState() => _MetricsAndStatsPageState();
}

class _MetricsAndStatsPageState extends DistivityPageState<MetricsAndStatsPage> {

  DateTime selectedDate = getTodayFormated();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()=>customOnBackPressed(context),
        child:RosseScaffold(
          'Metrics and Stats',
          scaffoldKey: scaffoldKey,
          body: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                child: getSelectedDaysWidgetForAppBar(context,
                    selectedDate: selectedDate, selectedView: SelectedView.Day, onNewDateSelectedPlusPage: (date,i){
                      setState(() {
                        selectedDate=date;
                      });
                    }),
              ),
              getPadding(getText('This week',textType: TextType.textTypeTitle,underline: true),horizontal: 20)
            ]+
                List.generate(Metric.values.length, (index) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: getBasicLinedBorder(
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              getText(getMetricName(Metric.values[index]),textType: TextType.textTypeSubtitle),
                              getMetricWidget(context, Metric.values[index], StatPeriod.week, selectedDate,true),
                            ],
                          ),
                        ),
                      ),smallRadius: true
                  ),
                ))+[getPadding(getText('This month',textType: TextType.textTypeTitle,underline: true),horizontal: 20)]+
                List.generate(Metric.values.length, (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                  child: getBasicLinedBorder(
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              getText(getMetricName(Metric.values[index]),textType: TextType.textTypeSubtitle),
                              getMetricWidget(context, Metric.values[index], StatPeriod.month, selectedDate,true),
                            ],
                          ),
                        ),
                      ),smallRadius: true
                  ),
                )),
          ),
          appBarWidget: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    getPadding(getText('Today\'s metrics',textType: TextType.textTypeSubtitle),horizontal: 20),
//                IconButton(
//                  icon: getIcon(Icons.arrow_forward_ios),
//                  onPressed: (){
//                    launchPage(context, TodaySMetricsPage());
//                  },
//                ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width-30,
                height: 150,
                child: ListView.builder(itemCount: Metric.values.length,itemBuilder: (ctx,ind){
                  return GestureDetector(
                    onTap: (){
                      launchPage(context, MetricPage(metric: Metric.values[ind],));
                    },
                    child: getBasicLinedBorder(Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 125,
                        height: 125,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            getText(getMetricName(Metric.values[ind]),textType: TextType.textTypeSubtitle),
                            Center(child: getMetricWidget(context, Metric.values[ind], StatPeriod.day, selectedDate,false)),
                          ],
                        ),
                      ),
                    ),smallRadius: true,color: MyColors.color_black_darker),
                  );
                },scrollDirection: Axis.horizontal,),
              ),
            ],
          ),
          color: MyColors.color_black,
          backEnabled: false,
          expandedHeight: 300,
        )
    );
  }
}