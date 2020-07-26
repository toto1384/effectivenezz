

import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/ui/pages/iap_page.dart';
import 'package:effectivenezz/ui/pages/manage_calendars.dart';
import 'package:effectivenezz/ui/pages/metrics_and_stats.dart';
import 'package:effectivenezz/ui/pages/plan_vs_tracked_page.dart';
import 'package:effectivenezz/ui/pages/settings_page.dart';
import 'package:effectivenezz/ui/pages/time_doctor.dart';
import 'package:effectivenezz/ui/pages/track_page.dart';
import 'package:effectivenezz/ui/pages/users_n_data.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:flutter/material.dart';

class DistivityDrawer extends StatefulWidget {
  @override
  _DistivityDrawerState createState() => _DistivityDrawerState();
}

class _DistivityDrawerState extends State<DistivityDrawer> {

  bool showCals = false;

  @override
  Widget build(BuildContext context) {

    return Drawer(
        elevation: 10,
        child: FutureBuilder(
          future: MyApp.dataModel.driveHelper.iapHelper.isSubscriptionActive(),
          builder: (context, snapshot) {
            return Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height-100,
                    child: ListView(
                        children: <Widget>[
                          getDrawerHeader(),
                          getPageItem(name: "Track", page: TrackPage(), icon: Icons.timer),
                          getCalendarWidget(locked: !(snapshot.data??false)),
                          getPageItem(name: "Metrics&Stats", page: MetricsAndStatsPage(), icon: Icons.insert_chart,locked:!(snapshot.data??false)),
                          getDivider(),
                          getPageItem(name: "Time Doctor", page: TimeDoctorPage(), icon: Icons.av_timer,locked: !(snapshot.data??false)),
                        ]
                    ),
                  ),
                  getPageItem(name: "Settings", page: SettingsPage(),icon: Icons.settings),
                ]
            );
          }
        )
    );
  }

  getCalendarWidget({bool minimal,bool locked}){

    if(locked==null)locked=false;
    if(minimal==null){
      minimal=false;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Card(
            shape: getShape(smallRadius: false),
            color: isShowingPage(context, PlanVsTrackedPage)?MyColors.color_black:Colors.transparent,
            elevation: 0,
            child: ListTile(
              leading: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5,top: 5),
                    child: getIcon(Icons.calendar_today,color: locked?Colors.blueGrey:Colors.white),
                  ),
                  if(locked)
                    Container(
                      width: 20,
                      height: 20,
                      child: Card(
                        shape: getShape(),
                        color: Colors.red,
                        child: getIcon(Icons.lock_outline,size: 10),
                      ),
                    )
                ],
              ),
              title: getText("Calendars",color: locked?Colors.blueGrey:Colors.white),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    icon: getIcon(Icons.edit),
                    onPressed: (){
                      launchPage(context, ManageCalendars());
                    },
                  ),
                  IconButton(
                    icon: getIcon(showCals?Icons.arrow_drop_up:Icons.arrow_drop_down),
                    onPressed: (){
                      setState(() {
                        showCals=!showCals;
                      });
                    },
                  ),
                ],
              ),
              onTap: (){
                if(locked)launchPage(context,IAPScreen());
                if(!locked)launchPage(context, PlanVsTrackedPage());
              },
            ),
          ),
        ),
      ]+(showCals?getCalendarsListForDrawer(context):[])+[
        (MyApp.dataModel.eCalendars.length==0&&showCals)?Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(child: getText("No calendars"),),
        ):Container(),
        showCals?getDivider():Container()
      ],
    );
  }
  getDrawerHeader(){
    return DrawerHeader(
        child: ListTile(
          leading: CircleAvatar(
            maxRadius: 20,
            backgroundColor: Colors.blueAccent,
          ),
          title: getText(MyApp.dataModel.driveHelper.currentUser!=null?MyApp.dataModel.driveHelper.currentUser.displayName:"Logged off"),
          onTap: (){
            launchPage(context, UsersNData());
          },
        )
    );
  }

  getPageItem({@required String name,@required Widget page,IconData icon,bool locked}){
    if(locked==null){
      locked=false;
    }

    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Card(
        color: isShowingPage(context, page.runtimeType)?MyColors.color_black:Colors.transparent,
        elevation: 0,
        shape: getShape(smallRadius: false,),
        child: GestureDetector(
          onTap: (){
            if(isShowingPage(context, page.runtimeType)){
              return;
            }
            if(!(page is Container))if(!locked)launchPage(context, page);
            if(locked)launchPage(context,IAPScreen());
          },
          child: ListTile(
            leading: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 5,top: 5),
                  child: icon!=null?getIcon(icon,color: locked?Colors.blueGrey:Colors.white):null,
                ),
                if(locked)Container(
                  width: 20,
                  height: 20,
                  child: Card(
                    shape: getShape(),
                    color: Colors.red,
                    child: getIcon(Icons.lock_outline,size: 10),
                  ),
                )
              ],
            ),
            title: getText(name,color: locked?Colors.blueGrey:Colors.white),
          ),
        ),
      ),
    );
  }
}
