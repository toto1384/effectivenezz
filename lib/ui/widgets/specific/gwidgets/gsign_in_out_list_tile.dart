import 'package:effectivenezz/ui/pages/quick_start_page.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_restart_widget.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../../../main.dart';

class GSignInOutListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GIcon(MyApp.dataModel.driveHelper.currentUser==null?Icons.chevron_right:Icons.chevron_left),
      title: GText(MyApp.dataModel.driveHelper.currentUser==null?'Sign in':'Sign out'),
      onTap: ()async{
        if(MyApp.dataModel.driveHelper.currentUser==null){
          launchPage(context, QuickStartPage(MyApp.dataModel.driveHelper));
        }else{
          if(MyApp.dataModel.eCalendars.length!=0||MyApp.dataModel.activities.length!=0||MyApp.dataModel.tasks.length!=0){
            await MyApp.dataModel.driveHelper.uploadFile(context);
            Fluttertoast.showToast(msg: 'Your data has been saved to cloud. Next time you log in with this account,'
                ' it will be automatically downloaded',toastLength: Toast.LENGTH_LONG);
          }
          if(!kIsWeb)await MyApp.dataModel.notificationHelper.cancelAllNotifications();
          await MyApp.dataModel.databaseHelper.deleteEveryThing();
          await MyApp.dataModel.driveHelper.handleSignOut();
          MyApp.dataModel=null;
          // MyAppState.ss(context);
          DistivityRestartWidget.restartApp(context);
        }
      },
    );
  }
}
