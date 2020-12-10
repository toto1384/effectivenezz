import 'package:effectivenezz/ui/pages/quick_start_page.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_restart_widget.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';

class GSignInOutListTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: GIcon(MyApp.dataModel.backend.driveHelper.currentUser==null?Icons.chevron_right:Icons.chevron_left),
      title: GText(MyApp.dataModel.backend.driveHelper.currentUser==null?'Sign in':'Sign out'),
      onTap: ()async{
        if(MyApp.dataModel.backend.driveHelper.currentUser==null){
          launchPage(context, QuickStartPage(MyApp.dataModel.backend.driveHelper));
        }else{
          if(!kIsWeb)await MyApp.dataModel.notificationHelper.cancelAllNotifications();
          if(!kIsWeb)await MyApp.dataModel.databaseHelper.deleteEveryThing();
          await MyApp.dataModel.backend.driveHelper.handleSignOut();
          MyApp.dataModel=null;
          DistivityRestartWidget.restartApp(context);
        }
      },
    );
  }
}
