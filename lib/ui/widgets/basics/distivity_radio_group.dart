import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:flutter/material.dart';

import 'gwidgets/gtext.dart';

class RosseRadioGroup extends StatelessWidget {

  final Map<String,bool> items;
  final Function(int,String) onSelected;
  final bool isBig;


  const RosseRadioGroup({Key key,@required this.items,@required this.isBig,@required this.onSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if(isBig){
      return Column(
        children: List.generate(items.length, (index){
          String key = items.keys.toList()[index];
          bool value = items.values.toList()[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: (RadioButton(index: index, keyString: key, value: value, height: 120,
              onTap: (){
                onSelected(index,key);
              },
            )
            ),
          );
        }),
      );
    }else{
      return Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(items.length, (index){
            String key = items.keys.toList()[index];
            bool value = items.values.toList()[index];

            return RadioButton(index: index, keyString: key, value: value,
              onTap: (){
                onSelected(index,key);
              },
            );
          }),
        ),
      );
    }
  }
}

class RadioButton extends StatelessWidget {

  final int index;
  final String keyString;
  final bool value;
  final double height;
  final Function onTap;

  const RadioButton({Key key,@required this.index, @required this.keyString, @required this.value , this.height,@required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.only(top: 6,bottom: 6),
      child: GestureDetector(
        onTap: onTap,
        child: Card(

          color: Colors.transparent,
          elevation: 0,
          shape: getShape(subtleBorder: !value),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            curve: Curves.ease,
            decoration: BoxDecoration(
              color: value?Colors.white:Colors.transparent,
              borderRadius: BorderRadius.circular(15),
            ),
            height: height??40,
            width: height==null?100:null,
            child:Center(
              child: GText(keyString,color:
                !value?Colors.white:MyColors.color_black,textType:((height??10)==120)?TextType.textTypeSubtitle:TextType.textTypeNormal),
            ),
          ),
        ),
      ),
    );
  }
}