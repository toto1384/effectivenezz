import 'package:demoji/demoji.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class GEmojiSlider extends StatefulWidget {

  final double value;
  final Function(double) onChanged;
  final double size;

  GEmojiSlider(this. value, this. onChanged,this. size);

  @override
  _GEmojiSliderState createState() => _GEmojiSliderState();
}

class _GEmojiSliderState extends State<GEmojiSlider> {

  double value = 0;
  double size = 0;

  @override
  void initState() {
    value=widget.value;
    size=widget.size;
    if(size==null||size<=0)size=100;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height: 100,
      child:  FlutterSlider(
        values: [0,1,2,3,4],
        min: 0,
        max:4,
        onDragCompleted: (ind,low,high){
          widget.onChanged(value);
        },
        trackBar: FlutterSliderTrackBar(
            activeTrackBarHeight: 10,
            inactiveTrackBarHeight: 10,
            activeTrackBar: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            inactiveTrackBar: BoxDecoration(
                color: MyColors.color_gray_lighter,
                borderRadius: BorderRadius.circular(15)
            )
        ),

        onDragging: (ind,low,high){
          setState((){
            value=low.toDouble();
          });
        },
        decoration: BoxDecoration(color: Colors.transparent),
//          fixedValues: [
//            FlutterSliderFixedValue(value: 0,percent: 0),
//            FlutterSliderFixedValue(value: 1,percent: 25),
//            FlutterSliderFixedValue(value: 2,percent: 50),
//            FlutterSliderFixedValue(value: 3,percent: 75),
//            FlutterSliderFixedValue(value: 4,percent: 100)
//          ],
//          lockHandlers: true,
        tooltip: FlutterSliderTooltip(
          alwaysShowTooltip: false,
          custom: (val)=>Center(),
        ),
        handlerHeight: TextType.textTypeGigant.size+15,
        handlerWidth: TextType.textTypeGigant.size+15,

        handler: FlutterSliderHandler(
            decoration: BoxDecoration(color: Colors.transparent),
            child: GText(getEmojiVal(value.toInt()),textType: TextType.textTypeGigant)
        ),
      ),
    );
  }
  getEmojiVal(int value){
    switch(value){
      case 0:return Demoji.angry;break;
      case 1:return Demoji.worried;break;
      case 2:return Demoji.slightly_frowning_face	;break;
      case 3:return Demoji.grinning	;break;
      case 4:return Demoji.smiling_face_with_three_hearts	;break;
    }
  }
}
