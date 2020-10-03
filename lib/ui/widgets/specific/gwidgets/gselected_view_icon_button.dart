import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

class GSelectedViewIconButton extends StatelessWidget {

  final SelectedView selectedView;
  final Function(SelectedView) onSelectedView;


  GSelectedViewIconButton(this. selectedView,
      this. onSelectedView);

  @override
  Widget build(BuildContext context) {
    IconData iconData;
    switch (selectedView) {
      case SelectedView.Day:
        iconData = Icons.calendar_view_day;
        break;
      case SelectedView.ThreeDay:
        iconData = Icons.today;
        break;
      case SelectedView.Week:
        iconData = Icons.calendar_today;
        break;
      case SelectedView.Month:
        iconData = Icons.grid_on;
        break;
    }

    return IconButton(
      icon: GIcon(iconData),
      onPressed: () {
        showDistivityModalBottomSheet(context, (ctx, ss) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: GIcon(Icons.calendar_view_day),
                title: GText('Day view'),
                onTap: () {
                  onSelectedView(SelectedView.Day);
                  MyApp.dataModel.prefs.setSelectedView(SelectedView.Day);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: GIcon(Icons.calendar_today),
                title: GText('3 Day view'),
                onTap: () {
                  onSelectedView(SelectedView.ThreeDay);
                  MyApp.dataModel.prefs.setSelectedView(SelectedView.ThreeDay);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: GIcon(Icons.today),
                title: GText('Week view'),
                onTap: () {
                  onSelectedView(SelectedView.Week);
                  MyApp.dataModel.prefs.setSelectedView(SelectedView.Week);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: GIcon(Icons.grid_on),
                title: GText('Month view'),
                onTap: () {
                  onSelectedView(SelectedView.Month);
                  MyApp.dataModel.prefs.setSelectedView(SelectedView.Month);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
      },
    );
  }
}
