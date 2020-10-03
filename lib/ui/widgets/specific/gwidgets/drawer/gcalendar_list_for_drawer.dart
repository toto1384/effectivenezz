import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:flutter/material.dart';

import '../../../../../main.dart';

class GCalendarListForDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(MyApp.dataModel.eCalendars.length, (i) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: MyApp.dataModel.eCalendars[i].color,
            maxRadius: 15,
          ),
          //IconButton(
//          icon: GIcon(MyApp.dataModel.eCalendars[i].show
//              ? Icons.check_circle_outline
//              : Icons.radio_button_unchecked,
//              color: MyApp.dataModel.eCalendars[i].color),
//          onPressed: () {
//            ECalendar eCalendar = MyApp.dataModel.eCalendars[i];
//            eCalendar.show = !eCalendar.show;
//            MyApp.dataModel.eCalendar(i, eCalendar, buildContext, CUD.Update);
//          },
//        ),
          title: GText(MyApp.dataModel.eCalendars[i].name,
              color: MyApp.dataModel.eCalendars[i].color),
        ),
      );
    }),
    );
  }
}
