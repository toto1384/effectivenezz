import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:flutter/material.dart';

class GText extends Text {

  final String text;
  final TextType textType;
  final Color color;
  final int maxLines;
  final bool crossed;
  final bool isCentered;
  final bool underline;
  final double sizeMultiplier;

  GText(this.text, { this.textType, this.color,this.maxLines,
    this.crossed,this.isCentered,this.underline,this. sizeMultiplier}) : super(text);


  @override
  Widget build(BuildContext context) {

    TextDecoration textDecoration = TextDecoration.none;

    if(crossed??false){
      textDecoration = TextDecoration.lineThrough;
    }
    if(underline??false){
      textDecoration = TextDecoration.underline;
    }

    return Text(text??"",
      overflow: TextOverflow.ellipsis,maxLines: maxLines??100,
      style: TextStyle(fontSize: (textType??TextType.textTypeNormal).size+
          (sizeMultiplier==null?0:((TextType.fromIndex(TextType.indexOf((textType??TextType.textTypeNormal))+2).size-
              TextType.fromIndex(TextType.indexOf((textType??TextType.textTypeNormal))-2).size)*sizeMultiplier-5)),
      color: color??Colors.white,
      fontWeight: (textType??TextType.textTypeNormal).fontWeight,
      decoration: textDecoration,
    ),textAlign: (isCentered??false)?TextAlign.center:null,);
  }
}
