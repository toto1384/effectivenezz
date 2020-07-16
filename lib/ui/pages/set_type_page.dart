import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/ui/widgets/distivity_drawer.dart';
import 'package:effectivenezz/ui/widgets/distivity_restart_widget.dart';
import 'package:effectivenezz/ui/widgets/platform_svg.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


class SetTypePage extends StatefulWidget {

  const SetTypePage({Key key}) : super(key: key);

  @override
  _SetTypePageState createState() => _SetTypePageState();
}

class _SetTypePageState extends DistivityPageState<SetTypePage> {
  bool isMinimal=MyApp.dataModel.prefs.getAppMode();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: Scaffold(
        key: scaffoldKey,
        drawer: DistivityDrawer(),
        body: Center(
          child: Card(
            color: MyColors.color_black,
            shape: getShape(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 150,
                            height: 150,
                            child : PlatformSvg.asset(AssetsPath.typeA),
                          ),
                          Radio(
                            onChanged: (v){
                              setState(() {
                                isMinimal=v;
                              });
                            },
                            groupValue: isMinimal,
                            value: false,
                          ),
                          getText('Schedule'),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            width: 150,
                            height: 150,
                            child : PlatformSvg.asset(AssetsPath.typeB),
                          ),
                          Radio(
                            onChanged: (v){
                              setState(() {
                                isMinimal=v;
                              });
                            },
                            groupValue: isMinimal,
                            value: true,
                          ),
                          getText("Minimal"),
                        ],
                      )
                    ],
                  ),
                  getPadding(getButton("Done", onPressed: ()async{
                    await MyApp.dataModel.prefs.setAppMode(isMinimal);
                    DistivityPageState.customKey=null;
                    DistivityRestartWidget.restartApp(context);
                  }),),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
