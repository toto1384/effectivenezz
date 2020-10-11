import 'package:effectivenezz/ui/pages/users_n_data.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_drawer.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gapp_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gscaffold.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:launch_review/launch_review.dart';
import '../../main.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends DistivityPageState<SettingsPage>{

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: GScaffold(
        key: scaffoldKey,
        drawer: DistivityDrawer(),
        appBar: GAppBar('Settings',drawerEnabled: true),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: MyApp.dataModel.driveHelper!=null?<Widget>[
              ListTile(
                leading: GIcon(Icons.person),
                title: GText('Users and Data'),
                onTap: (){
                  launchPage(context, UsersNData());
                },
                trailing: GIcon(Icons.chevron_right),
              ),
              Divider(),
              if(!kIsWeb)
                ListTile(
                  leading: GIcon(Icons.feedback),
                  title: GText("Send feedback"),
                  onTap: (){
                    MyApp.dataModel.launchFeedback(context);
                  },
                ),
              if(!kIsWeb)
                ListTile(
                  leading: GIcon(Icons.star_half),
                  title: GText("Rate us :))"),
                  trailing: GIcon(Icons.chevron_right),
                  onTap: (){
                    LaunchReview.launch();
                  },
                ),
              ListTile(
                leading: GIcon(Icons.info_outline),
                title: GText("About this app"),
                onTap: (){
                  showAboutDialog(
                    context: context,
                    applicationIcon: Image.asset(AssetsPath.icon,width: 50,height: 50,),
                    applicationName: "Effectivenezz",
                    applicationVersion: "0.5",
                  );
                },

              ),
            ]:[CircularProgressIndicator()],
          ),
        ),
      ),
    );
  }
}
