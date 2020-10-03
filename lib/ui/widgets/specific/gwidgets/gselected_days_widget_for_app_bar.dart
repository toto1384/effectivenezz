import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';

class GSelectedDaysWidgetForAppBar extends StatelessWidget {

  final DateTime selectedDate;
  final SelectedView selectedView;
  final Function(DateTime,int) onNewDateSelectedPlusPage;

  GSelectedDaysWidgetForAppBar({@required this. selectedDate,
    @required this. selectedView,
    @required this. onNewDateSelectedPlusPage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: GText(getDatesNameForAppBarSelector(selectedDate, selectedView)),
      onTap: () {
        showDistivityDatePicker(context, onDateSelected: (datetime) {
          if (datetime != null) {
            int differenceFromNow = datetime
                .difference(getTodayFormated())
                .inDays;

            int differenceFromNowFormatted = 0;
            switch (selectedView) {
              case SelectedView.Day:
                differenceFromNowFormatted = differenceFromNow;
                break;
              case SelectedView.ThreeDay:
                if (differenceFromNow == 2) differenceFromNow = 3;

                if (differenceFromNow < 3) {
                  //less than 3
                  if (differenceFromNow > -3) {
                    //greater than -3
                    differenceFromNowFormatted = differenceFromNow > 0 ? 0 : -1;
                    break;
                  }
                }
                differenceFromNowFormatted = (differenceFromNow ~/ 3).toInt();
                break;
              case SelectedView.Week:
                if (differenceFromNow == 6) differenceFromNow = 7;
                if (differenceFromNow < 7) {
                  //less than 7
                  if (differenceFromNow > -7) {
                    //greater than -7
                    differenceFromNowFormatted = differenceFromNow > 0 ? 0 : -1;
                    break;
                  }
                }
                differenceFromNowFormatted = (differenceFromNow ~/ 7).toInt();
                break;
              case SelectedView.Month:
                if (differenceFromNow == 29) differenceFromNow = 30;
                if (differenceFromNow < 30) {
                  //less than 30
                  if (differenceFromNow > -30) {
                    //greater than -30
                    differenceFromNowFormatted = differenceFromNow > 0 ? 0 : -1;
                    break;
                  }
                }
                differenceFromNowFormatted = (differenceFromNow ~/ 30).toInt();
                break;
            }

            onNewDateSelectedPlusPage(datetime, differenceFromNowFormatted + 50);
          }
        });
      },
    );
  }
}
