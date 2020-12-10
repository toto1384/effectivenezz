import 'dart:async';


import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: (Row(
                  mainAxisSize: MainAxisSize.min,
                  children: actions
                )),
            )
          ],
          content: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              getSubtitle(title),
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
    GButton(yesString??"Yes", onPressed: (){
      onYesPressed();
      Navigator.pop(context);
    }),
    GButton(noString??"No!", onPressed: (){
      Navigator.pop(context);
    },variant: 2)
  ], title: title, stateGetter: (ctx,ss){
    return GText(text);
  });
}

showDistivityModalBottomSheet(BuildContext context, SheetStateGetter stateGetter,
    {bool hideHandler,bool dismissible,double initialSnapping,Function onCollapsed}){

  if(hideHandler==null){
    hideHandler=false;
  }

  SheetController sheetController = SheetController();

  showSlidingBottomSheet(context, builder: (ctx){
    return SlidingSheetDialog(
      controller: sheetController,
      maxWidth: MediaQuery.of(context).size.height,
      listener: (state){
        if(state.isHidden){
          if(onCollapsed!=null)onCollapsed();
        }
      },
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Visibility(
                        visible: !hideHandler,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: (IconButton(
                            onPressed: (){Navigator.pop(context);},
                            icon: GIcon(Icons.close),
                          )),
                        ),
                      ),
                      Visibility(
                        visible: kIsWeb&&!hideHandler,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: (IconButton(
                            onPressed: ()async{
                              if(sheetController.state.isExpanded){
                                Fluttertoast.showToast(msg: 'Sheet already expanded');
                              }else sheetController.expand();
                            },
                            icon: GIcon(Icons.vertical_align_top_outlined),
                          )),
                        ),
                      ),
                    ],
                  ),
                  stateGetter(context,(func){
                    setState((){
                      func();
                    });
                  },sheetController),
                ],
              ),
            );
          },
        );
      },
    );
  });
}


showDistivityDialogAtPosition(BuildContext context,{@required RenderBox renderBox,
  @required StateCloseGetter stateGetter,@required SelectedView selectedView})async{
  Completer<OverlayEntry> completer = Completer();

  double dx = 0;

  print((renderBox.localToGlobal(Offset(0,0)).dy));

  if(selectedView==SelectedView.Day){
    dx = MediaQuery.of(context).size.width/2;
  }else{
    if((renderBox.localToGlobal(Offset(0,0)).dx) > (MediaQuery.of(context).size.width/2)){
      print("right");
      dx = (renderBox.localToGlobal(Offset(0, 0)).dx-500);
    }else {
      print('left');
      dx =renderBox.localToGlobal(Offset(renderBox.size.width,0)).dx;
    }
  }

  Offset position = Offset(dx, 50);

  OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => StatefulBuilder(
          builder: (context, ss) {
            return Positioned(
                top: position.dy,
                width: 500,
                left: position.dx,
                child: Card(
                  color: MyColors.color_black_darker,
                  elevation: 20,
                  shadowColor: MyColors.color_gray_darker,
                  shape: getShape(),
                  child: Container(
                    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height-100),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                          child: stateGetter(context,(func){ss((){func();});},()async{(await completer.future).remove();}),
                      ),
                    ),
                  ),
                )
            );
          }
      ));
  Overlay.of(context).insert(overlayEntry);
  completer.complete(overlayEntry);
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
        GButton('Save', onPressed: (){
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
  showDistivityDialog(context, actions: [], title: "Pick color!", stateGetter: (ctx,ss){
    return BlockPicker(pickerColor: selectedColor??Colors.red, onColorChanged: (color){
      onSelected(color);
      Navigator.pop(context);
    });
  });
}