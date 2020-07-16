

import 'package:effectivenezz/data/google_drive.dart';
import 'package:effectivenezz/ui/pages/welcome_page.dart';
import 'package:effectivenezz/ui/widgets/distivity_restart_widget.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:flutter/material.dart';

import '../../main.dart';
import '../date_n_strings.dart';
import 'package:flutter/services.dart';
import 'overflows_complex.dart';

Widget getSignInWithGoogleWelcomeActivityButton(BuildContext context,DriveHelper driveHelper){
  return getButton('Sign in with google', onPressed: (){
    driveHelper.handleSignIn().then((v){
      DistivityRestartWidget.restartApp(context);
    });
  });
}

getSignInSignOutSettingsButton(BuildContext context){
  return ListTile(
    leading: getIcon(MyApp.dataModel.driveHelper.currentUser==null?Icons.chevron_right:Icons.chevron_left),
    title: getText(MyApp.dataModel.driveHelper.currentUser==null?'Sign in':'Sign out'),
    onTap: ()async{
      if(MyApp.dataModel.driveHelper.currentUser==null){
        launchPage(context, WelcomePage(MyApp.dataModel.driveHelper));
      }else{
        await MyApp.dataModel.driveHelper.handleSignOut();
        launchPage(context, WelcomePage(MyApp.dataModel.driveHelper));
      }
    },
  );
}

getSaveToDriveButton(BuildContext context){
  return ListTile(
    leading: getIcon(Icons.save),
    title: getText('Save to Drive'),
    onTap: ()async{
      if(MyApp.dataModel.driveHelper.currentUser==null){
        launchPage(context, WelcomePage(MyApp.dataModel.driveHelper));
      }else{
        await MyApp.dataModel.driveHelper.uploadFile(context);
        showDistivityDialog(context, actions: [getButton('Close', onPressed: ()=>Navigator.pop(context))], title: 'Saved', stateGetter: (ctx,ss){
          return getText('Your calendars and your events are uploaded to Drive');
        });
      }
    },
  );
}

getDownloadsFromDrive(BuildContext context){
  return ListTile(
    leading: getIcon(Icons.cloud_download),
    title: getText("Download from Drive saves"),
    onTap: (){
      if(MyApp.dataModel.driveHelper.currentUser==null){
        launchPage(context, WelcomePage(MyApp.dataModel.driveHelper));
      }else showAllDriveSavesBottomSheet(context);
    },
  );
}

getPickDateButton(BuildContext buildContext,{@required DateTime dateTime,@required Function(DateTime) onDateTimeSet}){
  return getButton(
    dateTime==null?'Pick date': getStringFromDate(dateTime),
    variant: 2,
    onPressed: (){
      showDistivityDatePicker(
          buildContext,onDateSelected: (DateTime val){
        onDateTimeSet(val);
      }
      );
    },
  );
}
