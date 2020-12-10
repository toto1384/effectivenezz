import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

class GSelectedViewIconButton extends StatelessWidget {

  final SelectedView selectedView;
  final double zoom;
  final Function(SelectedView) onSelectedView;
  final Function(double) onZoomUpdate;


  GSelectedViewIconButton(this. selectedView,this.zoom,
  {@required this. onSelectedView,@required this.onZoomUpdate});

  @override
  Widget build(BuildContext context) {
    double actualZoom = zoom;

    return IconButton(
      icon: GIcon(Icons.preview_rounded),
      onPressed: () {
        showDistivityModalBottomSheet(context, (ctx, ss,c) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              if(kIsWeb)
                getSubtitle('Zoom'),
              if(kIsWeb)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Slider(

                    onChanged: (v){
                      ss((){
                        actualZoom=v;
                        onZoomUpdate(v);
                      });
                    },
                    onChangeEnd: (v){
                      MyApp.dataModel.backend.prefs.setHeightPerMinute(v);
                    },
                    value: (actualZoom<(1/3))?1/3:actualZoom,
                    min: 1.0/3.0,
                    max: 5,
                  ),
                ),
              getSubtitle('Views'),
              ListTile(
                leading: GIcon(Icons.calendar_view_day),
                title: GText('Day view'),
                onTap: () {
                  onSelectedView(SelectedView.Day);
                  MyApp.dataModel.backend.prefs.setSelectedView(SelectedView.Day);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: GIcon(Icons.calendar_today),
                title: GText('3 Day view'),
                onTap: () {
                  onSelectedView(SelectedView.ThreeDay);
                  MyApp.dataModel.backend.prefs.setSelectedView(SelectedView.ThreeDay);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: GIcon(Icons.today),
                title: GText('Week view'),
                onTap: () {
                  onSelectedView(SelectedView.Week);
                  MyApp.dataModel.backend.prefs.setSelectedView(SelectedView.Week);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: GIcon(Icons.grid_on),
                title: GText('Month view'),
                onTap: () {
                  onSelectedView(SelectedView.Month);
                  MyApp.dataModel.backend.prefs.setSelectedView(SelectedView.Month);
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
