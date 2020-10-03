import 'package:effectivenezz/ui/widgets/basics/distivity_drawer.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gapp_bar.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';

class TimeDoctorPage extends StatefulWidget {
  @override
  _TimeDoctorPageState createState() => _TimeDoctorPageState();
}

class _TimeDoctorPageState extends DistivityPageState<TimeDoctorPage> {


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: Scaffold(
        key: scaffoldKey,
        drawer: DistivityDrawer(),
        body: Center(child: GText("Time doctor will be implemented in a future release")),
        appBar: GAppBar("Time doctor",drawerEnabled: true),
      ),
    );
  }
}
