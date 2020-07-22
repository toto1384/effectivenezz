import 'dart:async';

import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import '../date_n_strings.dart';
import 'widgets_basic.dart';
import 'typedef_and_enums.dart';
import 'values_utils.dart';

showDistivityDialog(BuildContext context,{@required List<Widget> actions ,@required String title,@required StateGetter stateGetter}){

  showDialog(context: context,builder: (ctx){
    return StatefulBuilder(
      builder: (ctx,setState){
        return AlertDialog(
          backgroundColor: MyColors.color_black_darker,
          shape: getShape(),
          actions: [
            getPadding(Row(
                mainAxisSize: MainAxisSize.min,
                children: actions
              ),)
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getPadding(getText(title,textType: TextType.textTypeSubtitle),vertical: 20,horizontal: 0),
              stateGetter(context,(func){
                setState((){
                  func();
                });
              }),
            ],
          ),
        );
      },
    );
  });
}

showYesNoDialog(BuildContext context,{@required String title,@required String text,String yesString, String noString,@required Function onYesPressed}){
  showDistivityDialog(context, actions: [
    getButton(yesString??"Yes", onPressed: (){
      onYesPressed();
      Navigator.pop(context);
    }),
    getButton(noString??"No!", onPressed: (){
      Navigator.pop(context);
    },variant: 2)
  ], title: title, stateGetter: (ctx,ss){
    return getText(text);
  });
}

showDistivityModalBottomSheet(BuildContext context, StateGetter stateGetter,{bool hideHandler,bool dismissible,double initialSnapping}){

  if(hideHandler==null){
    hideHandler=false;
  }

  showSlidingBottomSheet(context, builder: (ctx){
    return SlidingSheetDialog(
      duration: Duration(milliseconds: 100),
      elevation: 0,
      cornerRadius: 16,
      color: MyColors.color_black_darker,
      cornerRadiusOnFullscreen: 0,
      isDismissable: dismissible??true,
      snapSpec: SnapSpec(
        snap: true,
        snappings: [(initialSnapping??1), 1.0],
        positioning: SnapPositioning.relativeToAvailableSpace,
      ),

      builder: (context, state) {
        return StatefulBuilder(
          builder: (ctx,setState){
            return Card(
              color: MyColors.color_black_darker,
              elevation: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Visibility(
                    visible: !hideHandler,
                    child: getPadding(IconButton(
                      onPressed: (){Navigator.pop(context);},
                      icon: getIcon(Icons.close),
                    ),vertical: 15,horizontal: 0),
                  ),
                  stateGetter(context,(func){
                    setState((){
                      func();
                    });
                  }),
                ],
              ),
            );
          },
        );
      },
    );
  });
}

showDistivityDatePicker(BuildContext context,{@required Function(DateTime) onDateSelected,DateTime selectedDate}) {
  Future<DateTime> dateTime = showDatePicker(
    context: context,
    firstDate: DateTime(2019),
    lastDate: DateTime(2050),
    initialDate: selectedDate??getTodayFormated(),
  );

  dateTime.then((onValue) {
    onDateSelected(getDateFromString(getStringFromDate(onValue)));
  });
}

showDistivityTimePicker(BuildContext context,TimeOfDay timeOfDay,{@required Function(TimeOfDay) onTimeSelected}){
  showTimePicker(context: context, initialTime: timeOfDay).then((time){
    onTimeSelected(time);
  });
}

showPickDurationBottomSheet(BuildContext context,Function(Duration) onDurationPick){
  Duration _duration = Duration(hours: 0, minutes: 0);

  showDistivityDialog(
      context,
      actions: [
        getButton('Save', onPressed: (){
          onDurationPick(_duration);
          Navigator.pop(context);
        }),
      ],
      title: 'Pick Estimated Time',
      stateGetter: (ctx,ss){
        return Center(
          child: DurationPicker(
            duration: _duration,
            onChange: (val) {
              ss(() => _duration = val);
            },
            snapToMins: 5.0,
          ),
        );
      }
  );
}

showEditColorBottomSheet(BuildContext context,Color selectedColor, Function(Color) onSelected){
  showDistivityModalBottomSheet(context, (ctx,ss){
    return Center(
      child: Container(
        width: 300,
        height: 300,
        child: MaterialColorPicker(
          allowShades: true,
          onColorChange: (Color color) {
            onSelected(color);
            Navigator.pop(context);
          },
          onlyShadeSelection: true,
          selectedColor: selectedColor,
        ),
      ),
    );
  });
}