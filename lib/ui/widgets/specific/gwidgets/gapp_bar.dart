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
  final String tooltip;

  GAppBar(this. title, {this. backEnabled, this. centered, this. drawerEnabled, this. trailing,
    this. subtitle, this. smallSubtitle, this. tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return GMaxWebWidth(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: (Align(
          alignment: (centered??false) ? Alignment.bottomCenter : Alignment.bottomLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                brightness: Brightness.dark,
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
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Flexible(child: GText(title, textType: TextType.textTypeTitle,)),
                        Visibility(child: GInfoIcon( tooltip),
                          visible: tooltip != null,),
                      ],
                    ),
                    if(subtitle != null && (smallSubtitle??true))
                      subtitle
                  ],
                ),
              ),
              if(!(smallSubtitle??true) && subtitle != null)
                subtitle
            ],
          ),
        )),
      ),
    );
  }

  @override
  Size get preferredSize => Size(MyApp.dataModel.screenWidth, (smallSubtitle??true) ? 100 : 150);
}
