import 'dart:async';

import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
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

showDistivityModalBottomSheet(BuildContext context, StateGetter stateGetter,{bool hideHandler}){

  if(hideHandler==null){
    hideHandler=false;
  }
  DistivityPageState state = context.findAncestorStateOfType<DistivityPageState>();

  if(state!=null){
    context=state.context;
  }
  state=null;
  showModalBottomSheet(
    shape: getShape(bottomSheetShape: true),
    backgroundColor: MyColors.getOverFlowColor(),
    isScrollControlled: true,context: context,builder: (ctx){
      return StatefulBuilder(
        builder: (ctx,setState){
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(bottom: MediaQuery.of((context)).viewInsets.bottom),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Visibility(
                    visible: !hideHandler,
                    child: getPadding(GestureDetector(
                        onTap: (){Navigator.pop(context);},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            getSkeletonView(75, 4)
                          ],
                        ),
                      ),vertical: 15,horizontal: 0),
                  ),
                  stateGetter(context,(func){
                      setState((){
                        func();
                      });
                    }),
                ],
              ),
            ),
          );
        },
      );
  },
  );
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