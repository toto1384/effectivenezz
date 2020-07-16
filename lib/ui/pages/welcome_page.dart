

import 'package:effectivenezz/data/google_drive.dart';
import 'package:effectivenezz/ui/pages/track_page.dart';
import 'package:effectivenezz/ui/widgets/distivity_drawer.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/complex/buttons_complex.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class WelcomePage extends StatefulWidget {

  final DriveHelper driveHelper;
  WelcomePage(this.driveHelper);
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends DistivityPageState<WelcomePage> {

  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    if(widget.driveHelper.currentUser!=null){
      launchPage(context, TrackPage());
    }


    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: Scaffold(
        key: scaffoldKey,
        drawer: DistivityDrawer(),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              getWelcomePresentation(
                  context,
                  currentPage,
                  assetPaths: [
                    AssetsPath.timeIllustration,
                    AssetsPath.planningIllustration,
                    AssetsPath.metricIllustration,
                    AssetsPath.doctorIllustration
                  ], texts: [
                    "Track your time. Manage it",
                    "Plan your time in advance",
                    "Measure your time. Efficiently",
                    "Let the \'Time Doctor\' do the work for you(W.I.P.)"
                  ], onPageChanged: (i){
                    setState(() {
                      currentPage=i;
                    });
              }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: getSignInWithGoogleWelcomeActivityButton(context,widget.driveHelper),
              ),
            ],
          ),
        )
      ),
    );
  }
}
