import 'package:effectivenezz/ui/pages/set_type_page.dart';
import 'package:effectivenezz/ui/pages/users_n_data.dart';
import 'package:effectivenezz/ui/widgets/distivity_drawer.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:effectivenezz/ui/pages/welcome_page.dart';
import 'package:launch_review/launch_review.dart';
import '../../main.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends DistivityPageState<SettingsPage>{

  static const platform = const MethodChannel('flutter.native/helper');

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: Scaffold(
        key: scaffoldKey,
        drawer: DistivityDrawer(),
        appBar: getAppBar('Settings',context: context,drawerEnabled: true),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: MyApp.dataModel.driveHelper!=null?<Widget>[
              ListTile(
                leading: getIcon(Icons.person),
                title: getText('Users and Data'),
                onTap: (){
                  launchPage(context, UsersNData());
                },
                trailing: getIcon(Icons.chevron_right),
              ),
              ListTile(
                leading: getIcon(Icons.burst_mode),
                title: getText("Set app mode"),
                onTap: ()=>launchPage(context, SetTypePage()),
                trailing: getIcon(Icons.chevron_right),
              ),
              getDivider(),
              if(!kIsWeb)
                ListTile(
                  leading: getIcon(Icons.feedback),
                  title: getText("Send feedback"),
                  onTap: (){
                    MyApp.dataModel.launchFeedback(context);
                  },
                ),
              if(!kIsWeb)
                ListTile(
                  leading: getIcon(Icons.star_half),
                  title: getText("Rate us :))"),
                  trailing: getIcon(Icons.chevron_right),
                  onTap: (){
                    LaunchReview.launch();
                  },
                ),
              ListTile(
                leading: getIcon(Icons.info_outline),
                title: getText("About this app"),
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
