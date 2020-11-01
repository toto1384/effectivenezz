import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gmax_web_width.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';

import '../../../../main.dart';
import 'ginfo_icon.dart';

class GAppBar extends PreferredSize implements PreferredSizeWidget {

  final String title;
  final bool backEnabled;
  final bool centered;
  final bool drawerEnabled;
  final Widget trailing;
  final Widget subtitle;
  final bool smallSubtitle;
  final bool disablePadding;
  final double size;

  GAppBar(this. title, {this.size, this. backEnabled, this. centered, this. drawerEnabled, this. trailing,
    this. subtitle, this. smallSubtitle, this. disablePadding,
  });

  @override
  Widget build(BuildContext context) {

    return GMaxWebWidth(
      child: Padding(
        padding: EdgeInsets.only(top: (disablePadding??false)?10:30,left: 10,right: 10),
        child: (Column(
          crossAxisAlignment: (centered??false) ?CrossAxisAlignment.center : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              elevation: 0,
              brightness: Brightness.dark,
              actions: [if(trailing!=null)trailing],
              leading: (drawerEnabled??false)?IconButton(
                icon: GIcon(Icons.menu,),
                onPressed: () {
                  DistivityPageState.customKey.openDrawer();
                },
              ):(backEnabled??false)?IconButton(
                icon: GIcon(Icons.chevron_left), onPressed: () {
                Navigator.pop(context);
              },):Container(),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GText(title, textType: TextType.textTypeTitle,),
                  if(subtitle != null && (smallSubtitle??true))subtitle
                ],
              ),
            ),
            if((!(smallSubtitle??true)) && subtitle != null)subtitle
          ],
        )),
      ),
    );
  }

  @override
  Size get preferredSize => Size(MyApp.dataModel.screenWidth, (size??((smallSubtitle??true)?100:150)));
}
