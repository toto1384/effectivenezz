import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/date_n_strings.dart';
import 'package:flutter/material.dart';

class GTrackedIntervalsWidget extends StatelessWidget {

  final dynamic object;

  GTrackedIntervalsWidget(this.object);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(object.trackedStart.length, (ind) {
        bool show = (object.trackedEnd.length != 0) && (object.trackedEnd.length > ind);

        return GestureDetector(
          onTap: (){
            showEditTimestampsBottomSheet(context, object: object,indexTimestamp: ind);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(
              children: <Widget>[
                Center(child: GIcon(Icons.chevron_right),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Visibility(
                      visible: object.trackedStart.length != 0,
                      child: Card(
                        color: Colors.transparent,
                        shape: getShape(subtleBorder: true),
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: (GText(
                              getStringFromDate(object.trackedStart[ind]), color: object.color)),
                        ),
                      ),
                    ),
                    Card(
                      color: Colors.transparent,
                      elevation: 0,
                      shape: getShape(subtleBorder: true),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: (GText(
                            show ? getStringFromDate(object.trackedEnd[ind]) : 'Active',
                            color: object.color)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
