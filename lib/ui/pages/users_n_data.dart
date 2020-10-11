
import 'package:effectivenezz/ui/pages/iap_page.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext_field.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gapp_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gdownloads_from_drive_list_tile.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gsave_to_drive_list_tile.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gsign_in_out_list_tile.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gmax_web_width.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
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
      appBar: GAppBar("Users and Data",backEnabled: true,),
      body: Center(
        child: GMaxWebWidth(
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  maxRadius: 20,
                  backgroundColor: MyColors.color_yellow,
                ),
                title: GText(MyApp.dataModel.driveHelper.currentUser!=null?MyApp.dataModel.driveHelper.currentUser.displayName:"Logged off"),

              ),
              Divider(),
              GSignInOutListTile(),
              GSaveToDriveListTile(),
              GDownloadsFromDriveListTile(),
              ListTile(
                title: GText("Delete everything"),
                leading: GIcon(Icons.delete_forever),
                onTap: (){
                  deleteDb(context);
                },

              ),
              if(!kIsWeb)ListTile(
                title: GText("Pricing"),
                leading: GIcon(Icons.monetization_on),
                onTap: (){
                  launchPage(context, IAPScreen());
                },

              ),
              ListTile(
                title: GText('Enter promo code'),
                leading: GIcon(Icons.subdirectory_arrow_left),
                onTap: (){
                  TextEditingController tec = TextEditingController();
                  showDistivityModalBottomSheet(context, (ctx,ss){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            child: GTextField(
                              tec,hint: 'Promo code',
                            ),width: 300,
                          ),
                          IconButton(
                            icon: GIcon(Icons.send),
                            onPressed: ()async{
                              await MyApp.dataModel.prefs.setPromoCode(tec.text);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
