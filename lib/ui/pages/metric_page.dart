
import 'package:effectivenezz/ui/widgets/rosse_scaffold.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:effectivenezz/utils/stats_utils.dart';
import 'package:flutter/material.dart';

class MetricPage extends StatefulWidget {
  final Metric metric;

  const MetricPage({Key key,@required this.metric}) : super(key: key);



  @override
  _MetricPageState createState() => _MetricPageState();
}

class _MetricPageState extends State<MetricPage> {

  DateTime selectedDate = getTodayFormated();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: RosseScaffold(
        getMetricName(widget.metric),
        appBarWidget: Column(
          key: GlobalKey(),
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            getText('${getDatesNameForAppBarSelector(selectedDate,SelectedView.Day)}:'),
            getMetricWidget(context, widget.metric, StatPeriod.day, selectedDate, Size.Medium),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 20),
                child: getSelectedDaysWidgetForAppBar(context,
                    selectedDate: selectedDate, selectedView: SelectedView.Day, onNewDateSelectedPlusPage: (date,i){
                      setState(() {
                        selectedDate=date;
                      });
                    }),
              ),
              getSubtitle("Weekly(${getDatesNameForAppBarSelector(selectedDate,SelectedView.Week)})"),
              getMetricWidget(context, widget.metric, StatPeriod.week, selectedDate, Size.Large),
              getSubtitle("Monthly(${getDatesNameForAppBarSelector(selectedDate,SelectedView.Month)})"),
              getMetricWidget(context, widget.metric, StatPeriod.month, selectedDate, Size.Large),
            ],
          ),
        ),
//        expandedHeight: widget.metric==Metric.tracked_today?400:200,
        color: MyColors.color_black,
        backEnabled: true,
      ),
    );
  }
}
