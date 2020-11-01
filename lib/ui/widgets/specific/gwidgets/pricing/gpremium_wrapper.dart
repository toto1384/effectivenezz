import 'dart:ui';

import 'package:effectivenezz/ui/pages/iap_page.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:flutter/material.dart';

import '../../../../../main.dart';

class GPremiumWrapper extends StatefulWidget {

  final Widget child;
  final double height;
  final double width;
  final bool upgradeButton;

  GPremiumWrapper({@required this.child,this.height,this.width,this.upgradeButton=true});
  @override
  _GPremiumWrapperState createState() => _GPremiumWrapperState();
}

class _GPremiumWrapperState extends State<GPremiumWrapper> {

  @override
  Widget build(BuildContext context) {
    return MyApp.dataModel.driveHelper.isPremium?widget.child:Container(
      height: widget.height,
      width: widget.width,
      child: Stack(
        fit: StackFit.loose,
        children: [
          Center(child: widget.child),
          ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 5,
                  sigmaY: 5,
                ),
                child:  widget.height==null?Opacity(
                  opacity: 0.01,
                  child: widget.child,
                ):Container(
                  color: Colors.transparent,
                  height: widget.height,
                  width: widget.width,
                )
              ),
            ),
          if(widget.upgradeButton)
            Positioned.fill(child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GText('This is a premium feature',isCentered: true,),
                  GButton('Upgrade',onPressed: (){
                    launchPage(context, IAPScreen());
                  },)
                ],
              ),
            )),
        ],
      ),
    );
  }
}
