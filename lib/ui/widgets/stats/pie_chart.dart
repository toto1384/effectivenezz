
/// Donut chart with labels example. This is a simple pie chart with a hole in
/// the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/name_value_object.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';

class PieChart extends StatelessWidget {
  final List<NameValueObject> data;
  final bool animate;
  final double size;

  PieChart({@required this.data,this.animate,@required this.size});


  @override
  Widget build(BuildContext context) {
    if(data.length==0){
      data.add(NameValueObject("NO",1));
    }
    return Container(
      width: size,
      height: size,
      child: new charts.PieChart([
            new charts.Series<NameValueObject, int>(
              id: 'Sales',
              domainFn: (NameValueObject sales, _) => (data??<NameValueObject>[]).indexOf(sales),
              measureFn: (NameValueObject sales, _) => sales.value,
              data: data??<NameValueObject>[],
              colorFn: (NameValueObject sales,_)=>charts.ColorUtil.fromDartColor(MyApp.dataModel.findObjectColorByName(sales.name)),
              // Set a label accessor to control the text of the arc label.
              labelAccessorFn: (NameValueObject row, _) => '${row.name} - ${getTextFromDuration(Duration(minutes: row.value))}%',
            )
          ],
          animate: animate,
          // Configure the width of the pie slices to 60px. The remaining space in
          // the chart will be left as a hole in the center.
          //
          // [ArcLabelDecorator] will automatically position the label inside the
          // arc if the label will fit. If the label will not fit, it will draw
          // outside of the arc with a leader line. Labels can always display
          // inside or outside using [LabelPosition].
          //
          // Text style for inside / outside can be controlled independently by
          // setting [insideLabelStyleSpec] and [outsideLabelStyleSpec].
          //
          // Example configuring different styles for inside/outside:
          //       new charts.ArcLabelDecorator(
          //          insideLabelStyleSpec: new charts.TextStyleSpec(...),
          //          outsideLabelStyleSpec: new charts.TextStyleSpec(...)),
          defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: (size~/6).toInt(),

              arcRendererDecorators: [new charts.ArcLabelDecorator(
                  labelPosition: charts.ArcLabelPosition.inside)])),
    );
  }


}