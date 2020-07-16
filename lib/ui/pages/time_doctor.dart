import 'package:effectivenezz/ui/widgets/distivity_drawer.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
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
        body: Center(child: getText("Time doctor will be implemented in a future release")),
        appBar: getAppBar("Time doctor",context: context,drawerEnabled: true),
      ),
    );
  }
}
