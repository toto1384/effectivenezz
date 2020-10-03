import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:flutter/material.dart';

class GRichText extends StatelessWidget {


  final List<String> strings;
  final List<TextType> textTypes;
  final List<Color> colors;

  GRichText(this. strings , this. textTypes, {this. colors});

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: List.generate(strings.length, (index){
          bool existsTextType = textTypes[index]!=null;
          bool existsColor = (colors??[]).length>index;

          return TextSpan(
            text: strings[index],
            style: TextStyle(
              color: existsColor?(colors??[])[index]:MyColors.getIconTextColor(),
              fontWeight: existsTextType?textTypes[index].fontWeight:TextType.textTypeNormal.fontWeight,
              fontSize: existsTextType?textTypes[index].size:TextType.textTypeNormal.size,
            ),
          );
        }),
      ),
    );
  }
}
