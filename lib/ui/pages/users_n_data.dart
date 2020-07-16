
import 'package:effectivenezz/ui/pages/iap_page.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/buttons_complex.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class UsersNData extends StatefulWidget {
  @override
  _UsersNDataState createState() => _UsersNDataState();
}

class _UsersNDataState extends State<UsersNData> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar("Users and Data",backEnabled: true,context: context),
      body: Column(
        children: <Widget>[
          ListTile(
            leading: CircleAvatar(
              maxRadius: 20,
              backgroundColor: Colors.blueAccent,
            ),
            title: getText(MyApp.dataModel.driveHelper.currentUser!=null?MyApp.dataModel.driveHelper.currentUser.displayName:"Logged off"),

          ),
          getDivider(),
          getSignInSignOutSettingsButton(context),
          getSaveToDriveButton(context),
          getDownloadsFromDrive(context),
          ListTile(
            title: getText("Delete everything"),
            leading: getIcon(Icons.delete_forever),
            onTap: (){
              deleteDb(context);
            },

          ),
          if(!kIsWeb)ListTile(
            title: getText("Pricing"),
            leading: getIcon(Icons.monetization_on),
            onTap: (){
              launchPage(context, IAPScreen());
            },

          ),
        ],
      ),
    );
  }
}
