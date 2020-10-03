import 'package:effectivenezz/data/drive_helper.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';
import '../basics/distivity_restart_widget.dart';

class GSignInWithGoogleWelcomeActivityButton extends StatelessWidget {

  final GoogleDriveHelper driveHelper;
  final Function onSignInCompleted;

  GSignInWithGoogleWelcomeActivityButton(this.driveHelper,{this.onSignInCompleted});

  @override
  Widget build(BuildContext context) {
    return GButton('Sign in with google', onPressed: (){
      driveHelper.handleSignIn(context).then((v)async{
        if(onSignInCompleted!=null){
          await onSignInCompleted();
        }
        DistivityRestartWidget.restartApp(context);
      });
    });
  }
}
