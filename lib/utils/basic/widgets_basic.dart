import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'typedef_and_enums.dart';



Widget getSubtitle(String text,{bool isCentered}){
  return Padding(
    padding: const EdgeInsets.only(left: 15,bottom: 20,top: 8),
    child: GText(text,textType: TextType.textTypeSubtitle,isCentered: isCentered??true),
  );
}

//Widget getFlareCheckbox(bool enabled,{Function(bool) onCallbackCompleted,Function() onTap}){
//    return Container(
//      width: 30,
//      height: 30,
//      child: GestureDetector(
//        onTap: (){
//          MyApp.snapToEnd=false;
//          onTap();
//        },
//        child: FlareActor(AssetsPath.checkboxAnimation,snapToEnd: MyApp.snapToEnd,
//          animation: enabled?'onCheck':'onUncheck',
//          callback: (name){
//            if(onCallbackCompleted!=null)onCallbackCompleted(name=='onCheck');
//          },
//        ),
//      ),
//    );
//  }




