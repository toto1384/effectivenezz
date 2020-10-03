import 'package:after_layout/after_layout.dart';
import 'package:effectivenezz/main.dart';
import 'package:flutter/material.dart';


class DistivityZoomWidget extends StatefulWidget {
  final double maxScale;
  final Function(double) onScaleChange;
  final Widget child;

  DistivityZoomWidget({
    Key key,
    this.maxScale = 5.0,
    @required this.onScaleChange,
    @required this.child,
  })  : assert(maxScale >= 1.0),
        super(key: key);

  @override
  State<StatefulWidget> createState() =>DistivityZoomWidgetState();
}

class DistivityZoomWidgetState extends State<DistivityZoomWidget> with TickerProviderStateMixin,AfterLayoutMixin {

  ScaleUpdateDetails _latestScaleUpdateDetails;

  double scale=2;

  @override
  void afterFirstLayout(BuildContext context) {
    widget.onScaleChange(MyApp.dataModel.prefs.getHeightPerMinute());
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (details){
        setState(() {
          if (details.scale != 1.0) {
            if (_latestScaleUpdateDetails == null) {
              _latestScaleUpdateDetails = details;
              return;
            }

            double scaleIncrement = details.scale - _latestScaleUpdateDetails.scale;
            if (details.scale < 1.0 && scale > 1.0) {
              scaleIncrement *= scale;
            }
            if (scale < 1.0 && scaleIncrement < 0) {
              scaleIncrement *= (scale - 0.5);
            } else if (scale > widget.maxScale && scaleIncrement > 0) {
              scaleIncrement *= (2.0 - (scale - widget.maxScale));
            }
            scale += scaleIncrement*2;

            widget.onScaleChange(scale);

            _latestScaleUpdateDetails = details;
          }
        });
      },
      onScaleEnd: (details){
        _latestScaleUpdateDetails = null;
        MyApp.dataModel.prefs.setHeightPerMinute(scale);
      },
      child: widget.child,
    );
  }

}