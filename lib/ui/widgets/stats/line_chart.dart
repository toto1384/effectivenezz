/// Timeseries chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:effectivenezz/objects/date_value_object.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class LineChart extends StatelessWidget {
  final List<DateValueObject> data;
  final bool animate;
  final double width;

  LineChart({@required this.data, this.animate,this.width});


  @override
  Widget build(BuildContext context) {
    if(data.length==0){
      data.add(DateValueObject(getTodayFormated(),0));
    }
    return Container(
      width: width??MyApp.dataModel.screenWidth-30,
      height: width==null?MyApp.dataModel.screenWidth/16*9:width/16*9,
      child: new charts.TimeSeriesChart(
        [
          charts.Series<DateValueObject, DateTime>(
            id: 'Sales',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (DateValueObject sales, _) => sales.dateTime,
            measureFn: (DateValueObject sales, _) => sales.value,
            data: data,
          )
        ],
        animate: animate,
        // Optionally pass in a [DateTimeFactory] used by the chart. The factory
        // should create the same type of [DateTime] as the data provided. If none
        // specified, the default creates local date time.
        dateTimeFactory: const charts.LocalDateTimeFactory(),
      ),
    );
  }


}

