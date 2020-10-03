import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';

class GPickDateButton extends StatelessWidget {

  final DateTime dateTime;
  final Function(DateTime) onDateTimeSet;

  GPickDateButton({@required this. dateTime,@required this. onDateTimeSet});

  @override
  Widget build(BuildContext context) {
    return GButton(
      dateTime==null?'Pick date': getStringFromDate(dateTime),
      variant: 2,
      onPressed: (){
        showDistivityDatePicker(
            context,onDateSelected: (DateTime val){
          onDateTimeSet(val);
        }
        );
      },
    );
  }
}
