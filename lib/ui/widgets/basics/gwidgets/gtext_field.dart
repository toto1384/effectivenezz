import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:flutter/material.dart';


class GTextField extends StatelessWidget {

  final TextType textType;
  final TextEditingController textEditingController;
  final String hint;
  final TextInputType textInputType;
  final bool focus;
  final Function(String) onChanged;
  final int variant;
  final bool small;


  GTextField(this. textEditingController,{this. hint,
    this.textInputType,this. focus,this. onChanged,this. variant,this. textType,this. small});

  @override
  Widget build(BuildContext context) {

    return Container(
      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
      decoration: BoxDecoration(
        color: (variant??1)==1?MyColors.color_black:Colors.transparent,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5,vertical: 1),
        child: TextFormField(
          onChanged: (str){if(onChanged!=null)onChanged(str);},
          autofocus: focus??false,
          keyboardType: textInputType,
          controller: textEditingController,
          maxLines: 1000,
          minLines: 1,
          style:
            TextStyle(fontSize: (textType??TextType.textTypeNormal).size,
                color: Colors.white,fontWeight: (textType??TextType.textTypeNormal).fontWeight),
          decoration: InputDecoration(
            hintText: hint??'',
            isDense: true,
            focusedBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            hintStyle: TextStyle(fontSize: (textType??TextType.textTypeNormal).size,
                color: MyColors.getIconTextGray(),fontWeight: (textType??TextType.textTypeNormal).fontWeight),
          ),
        ),
      ),
    );
  }
}
