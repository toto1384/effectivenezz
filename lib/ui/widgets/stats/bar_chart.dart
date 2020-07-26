
/// Bar chart example
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:effectivenezz/objects/date_value_object.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class BarChart extends StatelessWidget {
  final List<DateValueObject> data;
  final bool animate;
  final double width;

  BarChart( {this.animate,@required this.data, this.width});


  @override
  Widget build(BuildContext context) {
    if(data.length==0){
      data.add(DateValueObject(getTodayFormated(),0));
    }
    return Container(
      width: width??MyApp.dataModel.screenWidth-30,
      height: width==null?MyApp.dataModel.screenWidth/16*9:width/16*9,
      child: new charts.BarChart(
        [
          charts.Series<DateValueObject, String>(
            id: 'Sales',
            colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
            domainFn: (DateValueObject sales, _) => getDateName(sales.dateTime),
            measureFn: (DateValueObject sales, _) => sales.value,
            data: data,
          )
        ],
        animate: animate,
        defaultRenderer: new charts.BarRendererConfig(
          // By default, bar renderer will draw rounded bars with a constant
          // radius of 100.
          // To not have any rounded corners, use [NoCornerStrategy]
          // To change the radius of the bars, use [ConstCornerStrategy]
            cornerStrategy: const charts.ConstCornerStrategy(7)),
      ),
    );
  }
}

