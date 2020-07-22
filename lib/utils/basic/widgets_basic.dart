import 'dart:ui';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import 'typedef_and_enums.dart';
import 'values_utils.dart';


Text getText(String text, { TextType textType, Color color,int maxLines,bool crossed,bool isCentered,bool underline,double sizeMultiplier}){

  if(sizeMultiplier==null) {
    sizeMultiplier = 0;
  }else{
    sizeMultiplier=(TextType.fromIndex(TextType.indexOf(textType)+2).size-TextType.fromIndex(TextType.indexOf(textType)-2).size)*sizeMultiplier-5;
  }
  if(textType==null){
    textType=TextType.textTypeNormal;
  }

  if(color==null){
    color= Colors.white;
  }

  if(crossed==null){
    crossed=false;
  }

  if(isCentered==null){
    isCentered=false;
  }

  if(underline==null){
    underline= false;
  }

  TextDecoration textDecoration = TextDecoration.none;

  if(crossed){
    textDecoration = TextDecoration.lineThrough;
  }
  if(underline){
    textDecoration = TextDecoration.underline;
  }

  return Text(text??"",overflow: TextOverflow.ellipsis,maxLines: maxLines??100,style: TextStyle(fontSize: textType.size+sizeMultiplier,
    color: color,
    fontWeight: textType.fontWeight,
    decoration: textDecoration,
  ),textAlign: isCentered?TextAlign.center:null,);

}

getDivider(){
  return Padding(
    padding: const EdgeInsets.all(20),
    child: Divider(
      color: Colors.white,
      thickness: 1.5,
    ),
  );
}

Widget getBasicLinedBorder(Widget child,{Color color,bool smallRadius}){
  if(smallRadius==null)smallRadius=false;
  return Card(
    shape: getShape(smallRadius: smallRadius),
    elevation: 0,
    color: color??MyColors.color_black,
    child: child,
  );
}


getRichText(List<String> strings , List<TextType> textTypes, {List<Color> colors}){
  if(colors==null){
    colors=[];
  }
  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children: List.generate(strings.length, (index){
        bool existsTextType = textTypes[index]!=null;
        bool existsColor = colors.length>index;

        return TextSpan(
          text: strings[index],
          style: TextStyle(
            color: existsColor?colors[index]:MyColors.getIconTextColor(),
            fontWeight: existsTextType?textTypes[index].fontWeight:TextType.textTypeNormal.fontWeight,
            fontSize: existsTextType?textTypes[index].size:TextType.textTypeNormal.size,
          ),
        );
      }),
    ),
  );
}

Widget getPadding(Widget child,{double horizontal,double vertical}){
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: horizontal??8,vertical: vertical??8),
    child: child,
  );
}

getSliderThemeData(){
  return SliderThemeData(
    activeTrackColor: MyColors.color_primary,
    inactiveTrackColor: MyColors.color_primary.withOpacity(0.3),
    thumbColor: MyColors.color_primary,
    trackHeight: 8,
    overlayColor: MyColors.color_primary.withOpacity(0.3),
    valueIndicatorColor: MyColors.color_black_darker,
    activeTickMarkColor: Colors.transparent,
    inactiveTickMarkColor: Colors.transparent,
  );
}

getAppDarkTheme(){
  return ThemeData(
    fontFamily: 'Montserrat',
    unselectedWidgetColor: Colors.white,
    canvasColor: MyColors.color_black_darker,
    accentColor: Colors.white,
    cursorColor: Colors.white,
    snackBarTheme: SnackBarThemeData(
      shape: getShape(subtleBorder: true),
      backgroundColor: MyColors.color_black,
    ),
    sliderTheme: getSliderThemeData(),
    primaryColor: Colors.white,
    primaryColorDark: Colors.white,
    scaffoldBackgroundColor: MyColors.color_black_darker,
    iconTheme: IconThemeData(
      color: Colors.white
    ),
    bottomAppBarColor: MyColors.color_black_darker,
    popupMenuTheme: PopupMenuThemeData(
      shape: getShape(),
      color: MyColors.color_black_darker,
    ),
  );
}

Icon getIcon(IconData iconData,{Color color, double size}){


  if(color==null){
    color=MyColors.getIconTextColor();
  }
  return Icon(iconData,size: size??25,color: color,);
}

Widget getFlareCheckbox(bool enabled,{Function(bool) onCallbackCompleted,Function() onTap}){
    return Container(
      width: 30,
      height: 30,
      child: GestureDetector(
        onTap: (){
          MyApp.snapToEnd=false;
          onTap();
        },
        child: FlareActor(AssetsPath.checkboxAnimation,snapToEnd: MyApp.snapToEnd,
          animation: enabled?'onCheck':'onUncheck',
          callback: (name){
            if(onCallbackCompleted!=null)onCallbackCompleted(name=='onCheck');
          },
        ),
      ),
    );
  }

getTextField(TextEditingController textEditingController,{String hint,@required int width,
  TextInputType textInputType,bool focus,Function(String) onChanged,int variant,TextType textType}){

    if(textType==null)textType=TextType.textTypeNormal;

    if(focus==null){
      focus = false;
    }

    if(variant==null){
      variant=1;
    }

    if(textInputType==null){
      textInputType = TextInputType.text;
    }

  return Container(
    width: (width.toDouble()),
    child: Card(
      shape: getShape(smallRadius: false),
      color: variant==1?MyColors.color_black:Colors.transparent,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
        child: TextFormField(
          onChanged: (str){onChanged(str);},
          autofocus: focus,
          keyboardType: textInputType,
          controller: textEditingController,
          maxLines: 1000,
          minLines: 1,
          style: TextStyle(fontSize: textType.size,color: Colors.white,fontWeight: textType.fontWeight),
          decoration: InputDecoration.collapsed(
            hintText: hint??'',
            hintStyle: TextStyle(fontSize: textType.size,color: MyColors.getIconTextGray(),fontWeight: textType.fontWeight),
          ),
        ),
      ),
    ),
  );

}

getSkeletonView(int width,int height,{int radius}){
  return Container(
    height: height.toDouble(),
    width: width.toDouble(),
    decoration: BoxDecoration( color: MyColors.color_gray_darker,borderRadius: BorderRadius.circular(radius??7)),
  );
}

FlatButton getButton(String text,{int variant,@required Function onPressed}){
  if(variant==null||variant>2){
    variant=1;
  }

  return FlatButton(
    child: getPadding(getText("$text",color: Colors.white),
      horizontal: 7,vertical: 9),
    onPressed: onPressed,
    shape: getShape(smallRadius: false),

    color: variant==1?MyColors.color_black:MyColors.color_black_darker,
  );
}

getSwitchable({@required String text,bool disabled,@required bool checked,@required Function(bool) onCheckedChanged, @required bool isCheckboxOrSwitch}){
  if(disabled ==null){
    disabled=false;
  }

  return Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      getPadding(isCheckboxOrSwitch?
        Checkbox(

          onChanged: disabled?null:onCheckedChanged,
          value: checked,
        ):
        Switch(
          onChanged: onCheckedChanged,
          value: checked,
        ),),
      getPadding(getText(text)),
    ],

  );
}

RoundedRectangleBorder getShape({bool bottomSheetShape,bool smallRadius, bool webCardShape,bool subtleBorder,Color subtleBorderColor}){

  if(bottomSheetShape==null){
    bottomSheetShape=false;
  }
  if(smallRadius==null){
    smallRadius=true;
  }

  double radius = smallRadius?10:30;

  if(webCardShape==null){
    webCardShape=false;
  }

  if(subtleBorder==null){
    subtleBorder=false;
  }

  if(bottomSheetShape){
    return RoundedRectangleBorder(
      side: subtleBorder?BorderSide(
        width: 1,
        color: subtleBorderColor??Colors.white,
      ):BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      )
    );
  }else if(webCardShape){
    return RoundedRectangleBorder(
      side: subtleBorder?BorderSide(
        width: 1,
        color: Colors.white,
      ):BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomRight: Radius.circular(radius),
      ),
    );
  }else{
    return RoundedRectangleBorder(
      side: subtleBorder?BorderSide(
        width: 1,
        color: Colors.white,
      ):BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(radius)
    );
  }
}



