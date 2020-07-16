
import 'package:effectivenezz/ui/widgets/rosse_scaffold.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/stats_utils.dart';
import 'package:flutter/material.dart';

class MetricPage extends StatefulWidget {
  final Metric metric;

  const MetricPage({Key key,@required this.metric}) : super(key: key);



  @override
  _MetricPageState createState() => _MetricPageState();
}

class _MetricPageState extends State<MetricPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: RosseScaffold(
        getMetricName(widget.metric),
        appBarWidget: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: getText('Today:'),
            ),
            getMetricWidget(context, widget.metric, StatPeriod.day, getTodayFormated(), true),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getText("Weekly",textType: TextType.textTypeSubtitle),
              getMetricWidget(context, widget.metric, StatPeriod.week, getTodayFormated(), true),
              getText("Monthly",textType: TextType.textTypeSubtitle),
              getMetricWidget(context, widget.metric, StatPeriod.month, getTodayFormated(), true),
            ],
          ),
        ),
        expandedHeight: widget.metric==Metric.tracked_today?500:200,
        color: MyColors.color_black,
        backEnabled: true,
      ),
    );
  }
}
