
/// Donut chart with labels example. This is a simple pie chart with a hole in
/// the middle.
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/name_value_object.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';

class PieChart extends StatefulWidget{

  final List<NameValueObject> data;
  final bool animate;
  final double size;

  PieChart({@required this.data,this.animate,@required this.size});

  @override
  State<StatefulWidget> createState() {return PieChartState();}
}


class PieChartState extends State<PieChart> {

  String getPercentTracked(int duration){
    int totalDuration = 0;

    widget.data.forEach((element) {
      totalDuration+=element.value;
    });

    return "${formatDouble((100 / totalDuration)*duration)}%";
  }

  @override
  Widget build(BuildContext context) {
    if(widget.data.length==0){
      widget.data.add(NameValueObject("NO",1));
    }
    return Stack(
      children: [
        Container(
          width: widget.size,
          height: widget.size,
          child: new charts.PieChart([
            new charts.Series<NameValueObject, int>(
              id: 'Sales',
              domainFn: (NameValueObject sales, _) => (widget.data??<NameValueObject>[]).indexOf(sales),
              measureFn: (NameValueObject sales, _) => sales.value,
              data: widget.data??<NameValueObject>[],
              insideLabelStyleAccessorFn: (NameValueObject sales, _)=> charts.TextStyleSpec(
                  color: charts.ColorUtil.fromDartColor(getContrastColor(MyApp.dataModel.findObjectColorByName(sales.name)))
              ),

              colorFn: (NameValueObject sales,_)=>charts.ColorUtil.fromDartColor(MyApp.dataModel.findObjectColorByName(sales.name)),
              // Set a label accessor to control the text of the arc label.
              labelAccessorFn: (NameValueObject row, _) => '${row.name}',
            )
          ],
              animate: false,
              selectionModels: [
                charts.SelectionModelConfig(
                  type: charts.SelectionModelType.info,
                  updatedListener: (model) async{
                    if (model.selectedDatum.isNotEmpty) {
                      setState(() {
                        text = "${model.selectedDatum.first.datum.name}\n\n"
                            "${getTextFromDuration(Duration(minutes:model.selectedDatum.first.datum.value))} Hours spent"
                            "\n${getPercentTracked(model.selectedDatum.first.datum.value)} of total";
                      });
                    }
                  },
                ),
              ],
              defaultRenderer: new charts.ArcRendererConfig(
                  arcRendererDecorators: [new charts.ArcLabelDecorator(
                      labelPosition: charts.ArcLabelPosition.inside)])),
        ),
        Positioned(
          top: widget.size/2-30,
          left: 0,
          right: 0,
          child: Center(
            child: Visibility(
              visible: text!='',
              child: Card(
               shape: getShape(),
               color: MyColors.color_black,
               child: InkWell(
                 onTap: (){
                   setState(() {
                     text='';
                   });
                 },
                 child: Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: getText(text,isCentered: true),
                 ),
               ),
              ),
            ),
          ),
        )
      ],
    );
  }
  String text = '';


}