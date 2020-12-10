import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:flutter/material.dart';

import 'gtext.dart';

class GButton extends StatelessWidget {

  final String text;
  final int variant;
  final Function onPressed;

  GButton(this. text,{this. variant,@required this. onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 3,horizontal: 8),
        child: GText("$text",color: (variant??1)==1?MyColors.color_black_darker:Colors.white),
      ),
      onPressed: onPressed,
      shape: getShape(smallRadius: true),

      color: (variant??1)==1?MyColors.color_yellow:(variant==2)?MyColors.color_black_darker:MyColors.color_black,
    );
  }

}
