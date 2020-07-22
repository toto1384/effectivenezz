
import 'dart:math';

import 'package:after_layout/after_layout.dart';
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/list_callback.dart';
import 'package:effectivenezz/ui/pages/set_type_page.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:effectivenezz/utils/custom_key.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';


class DistivityPageState<T extends StatefulWidget> extends State<T> with AfterLayoutMixin{

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  static ListCallback listCallback = ListCallback();

  static CustomKey customKey;

  openDrawer(){
    scaffoldKey.currentState.openDrawer();
  }

  closeDrawer(){
    scaffoldKey.currentState.openEndDrawer();
  }

  getPageName(){
    return T.toString();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, init);
  }
  
  init(){

    customKey=CustomKey(this);
    if(!isShowingPage(context, SetTypePage)){
      if(Random().nextInt(17)==1){
        int currentIndex = 2;
        scaffoldKey.currentState.showSnackBar(SnackBar(
          shape: getShape(),
          duration: Duration(minutes: 1),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              getEmojiSlider(
                currentIndex.toDouble(),
                (index) {
                  currentIndex=index.toInt();
                  print(index);
                  scaffoldKey.currentState.hideCurrentSnackBar();
                  scaffoldKey.currentState.showSnackBar(SnackBar(
                    duration: Duration(minutes: 1),
                    shape: getShape(),
                    content: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          getText(currentIndex<2?"We are sorry to hear that, please tell us how we can change":kIsWeb?"Amazing, help us make it even better":"Great, rate maybe :)) ?",),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if(!kIsWeb)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: getButton("Suggest something", onPressed: (){
                                    MyApp.dataModel.launchFeedback(context);
                                  }),
                                ),
                              if(!kIsWeb&&currentIndex>2)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: getButton("Rate us :))", onPressed: (){
                                    LaunchReview.launch();
                                  }),
                                ),
                              IconButton(
                                icon: getIcon(Icons.close),
                                onPressed: ()=>scaffoldKey.currentState.hideCurrentSnackBar(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));
                },
                MediaQuery.of(context).size.width-120
              ),
              IconButton(
                icon: getIcon(Icons.close),
                onPressed: ()=>scaffoldKey.currentState.hideCurrentSnackBar(),
              )
            ],
          ),
        ));
//        showYesNoDialog(context, title: "This app is still in beta. Help me improve it",
//            text: "I want to make this the best time management tool out there and I would appreciate if you would shoot me an email and report bugs or suggest features. There are a lot of things in this app that are subject to change",
//            onYesPressed: mailMe,yesString: 'Mail me!',noString: "No!");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void afterFirstLayout(BuildContext context) {
  }

}