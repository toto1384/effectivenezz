import 'package:circular_check_box/circular_check_box.dart';
import 'package:effectivenezz/objects/calendar.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:flutter/material.dart';

import '../../../../../main.dart';

class GCalendarListForDrawer extends StatefulWidget {
  @override
  _GCalendarListForDrawerState createState() => _GCalendarListForDrawerState();
}

class _GCalendarListForDrawerState extends State<GCalendarListForDrawer> {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(MyApp.dataModel.eCalendars.length, (i) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircularCheckBox(
            onChanged: (b){
              setState(() {
                ECalendar eCalendar = MyApp.dataModel.eCalendars[i];
                eCalendar.show = !eCalendar.show;
                MyApp.dataModel.eCalendar(i, eCalendar, context, CUD.Update);
                MyAppState.ss(context);
              });
            },
            value: MyApp.dataModel.eCalendars[i].show,
            activeColor: MyApp.dataModel.eCalendars[i].color,
            inactiveColor: MyApp.dataModel.eCalendars[i].color,
          ),
          title: GText(MyApp.dataModel.eCalendars[i].name,
              color: MyApp.dataModel.eCalendars[i].color),
        ),
      );
    }),
    );
  }
}
