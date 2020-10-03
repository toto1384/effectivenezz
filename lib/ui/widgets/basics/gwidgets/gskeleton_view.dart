import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:flutter/material.dart';

class GSkeletonView extends StatelessWidget {

  final int width;
  final int height;
  final int radius;

  GSkeletonView(this. width,this. height,{this. radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.toDouble(),
      width: width.toDouble(),
      decoration: BoxDecoration( color: MyColors.color_gray_darker,borderRadius: BorderRadius.circular(radius??7)),
    );
  }
}
