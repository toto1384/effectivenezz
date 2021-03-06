
import 'dart:math';
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/list_callback.dart';
import 'package:effectivenezz/ui/pages/quick_start_page.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gemoji_slider.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/custom_key.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';


class DistivityPageState<T extends StatefulWidget> extends State<T> {

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  static ListCallback listCallback = ListCallback();
  static PageChangeCallback pageChangeCallback = PageChangeCallback();

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
    customKey=CustomKey(this);
    super.initState();
    Future.delayed(Duration.zero, init);
  }
  
  init(){
    if(!isShowingPage(QuickStartPage)){
      if(Random().nextInt(17)==1){
        int currentIndex = 2;
        scaffoldKey.currentState.showSnackBar(SnackBar(
          shape: getShape(),
          duration: Duration(minutes: 1),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              GEmojiSlider(
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
                          GText(currentIndex<2?"We are sorry to hear that, please tell us how we can change":kIsWeb?"Amazing, help us make it even better by suggesting something":"Great, rate maybe :)) ?",),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              if(!kIsWeb)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GButton("Suggest something", onPressed: (){
                                    MyApp.dataModel.launchFeedback(context);
                                  },variant: 2),
                                ),
                              if(!kIsWeb&&currentIndex>2)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GButton("Rate us :))", onPressed: (){
                                    LaunchReview.launch();
                                  },variant: 2),
                                ),
                              IconButton(
                                icon: GIcon(Icons.close),
                                onPressed: ()=>scaffoldKey.currentState.hideCurrentSnackBar(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ));
                },
                  MyApp.dataModel.screenWidth-120
              ),
              IconButton(
                icon: GIcon(Icons.close),
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

}