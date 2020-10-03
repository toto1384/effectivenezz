import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:flutter/material.dart';

class GIcon extends StatelessWidget {

  final Color color;
  final IconData iconData;
  final double size;

  GIcon(this. iconData,{this. color, this. size});

  @override
  Widget build(BuildContext context) {

    return Icon(iconData,size: size??25,color: color??MyColors.getIconTextColor(),);
  }
}
