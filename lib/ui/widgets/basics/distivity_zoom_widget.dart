import 'package:after_layout/after_layout.dart';
import 'package:dartx/dartx.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../main.dart';


class VerticalZoom extends StatefulWidget {
  const VerticalZoom({
    Key key,
    @required this.child,
    this.minChildHeight = 24*20.0,
    this.maxChildHeight = 24*60*5.0,
    @required this.onScaleChange,@required this.contentHeight
  })  : assert(child != null),
        assert(minChildHeight != null),
        assert(minChildHeight > 0),
        assert(maxChildHeight != null),
        assert(maxChildHeight > 0),
        assert(minChildHeight <= maxChildHeight),
        super(key: key);

  final Widget child;
  final double minChildHeight;
  final double maxChildHeight;
  final double contentHeight;
  final Function(double) onScaleChange;

  @override
  _VerticalZoomState createState() => _VerticalZoomState();
}

class _VerticalZoomState extends State<VerticalZoom> with AfterLayoutMixin{
  ScrollController _scrollController;
  double _contentHeightUpdateReference;
  double _lastFocus;


  ScaleUpdateDetails _latestScaleUpdateDetails;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    _scrollController ??= ScrollController();

    return GestureDetector(
      dragStartBehavior: DragStartBehavior.down,
      onScaleStart: (details) {
        if(!kIsWeb){
          _contentHeightUpdateReference = widget.contentHeight;
          _lastFocus = _getFocus(details.localFocalPoint,widget.contentHeight);
        }
      },
      onScaleUpdate: (details) {
        if(kIsWeb){
            double scale = widget.contentHeight/(24*60);
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
              } else if (scale > (widget.maxChildHeight/(24*60)) && scaleIncrement > 0) {
                scaleIncrement *= (2.0 - (scale - (widget.maxChildHeight/(24*60))));
              }
              scale += scaleIncrement*2;

              widget.onScaleChange(scale);

              _latestScaleUpdateDetails = details;
            }
        }else{
          double contentHeight = _coerceContentHeight(details.verticalScale * _contentHeightUpdateReference,);

          if(_contentHeightUpdateReference!=contentHeight)widget.onScaleChange(contentHeight);

          final scrollOffset = _lastFocus * (contentHeight) - details.localFocalPoint.dy;

          _scrollController.jumpTo(
              scrollOffset);

          _lastFocus = _getFocus(details.localFocalPoint,contentHeight);
        }
      },
      onScaleEnd: (details){
        if(kIsWeb){
          _latestScaleUpdateDetails = null;
        }else{
          MyApp.dataModel.prefs.setHeightPerMinute(widget.contentHeight/(24*60));
        }
      },
      child: SingleChildScrollView(
        // We handle scrolling manually to improve zoom detection.
        physics: kIsWeb?null:NeverScrollableScrollPhysics(),
        controller: _scrollController,
        child: Container(
            decoration: BoxDecoration(color: MyColors.color_black,
                borderRadius: BorderRadius.only(topRight: Radius.circular(10),
                    topLeft: Radius.circular(10))),
            child: widget.child
        ),
      ),
    );
  }

  double _coerceContentHeight(double childHeight,) {
    return childHeight.coerceIn(widget.minChildHeight, widget.maxChildHeight);
  }

  double _getFocus(Offset focalPoint,double height) => (_scrollController.offset + focalPoint.dy) / height;

  @override
  void afterFirstLayout(BuildContext context) {
    widget.onScaleChange(MyApp.dataModel.prefs.getHeightPerMinute()*24*60);
  }
}