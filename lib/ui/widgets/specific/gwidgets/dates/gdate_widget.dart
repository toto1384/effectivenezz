import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';

class GDateWidget extends StatelessWidget {

  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  GDateWidget({@required this. selectedDate, @required this. onDateSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          GIcon(Icons.chevron_left, size: 16),
          GText(getDateName(selectedDate),),
          GIcon(Icons.chevron_right, size: 16)
        ],
      ),
      onTap: () {
        showDistivityDatePicker(context, onDateSelected: (datetime) {
          if (datetime != null) {
            onDateSelected(datetime);
          }
        });
      },
    );
  }
}
