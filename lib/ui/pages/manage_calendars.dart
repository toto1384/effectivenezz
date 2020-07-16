
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/ui/widgets/distivity_drawer.dart';
import 'package:effectivenezz/ui/widgets/distivity_fab.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

class ManageCalendars extends StatefulWidget {
  @override
  _ManageCalendarsState createState() => _ManageCalendarsState();
}

class _ManageCalendarsState extends DistivityPageState<ManageCalendars> {

  ScrollController scrollController= ScrollController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
        child: Scaffold(
          key: scaffoldKey,
          drawer: DistivityDrawer(),
          appBar: getAppBar("Manage Calendars",context: context,drawerEnabled: true),
          body: MyApp.dataModel.eCalendars.length!=0?ListView.builder(itemCount: MyApp.dataModel.eCalendars.length,itemBuilder: (ctx,ind){
            return ListTile(
              leading: CircleAvatar(
              backgroundColor: MyApp.dataModel.eCalendars[ind].color,
                maxRadius: 15,
              ),
              title: getText(MyApp.dataModel.eCalendars[ind].name),
              onTap: (){
                showAddEditCalendarBottomSheet(context,eCalendar: MyApp.dataModel.eCalendars[ind],index: ind,add: false);
              },
            );
          },controller: scrollController,):Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width-50,
                  height: MediaQuery.of(context).size.width-50,
                  child: SvgPicture.asset(AssetsPath.emptyView)
                ),
                getText('No calendars')
              ],
            ),
          ),
          floatingActionButton: DistivityFAB(
            onTap: (c){
              showAddEditCalendarBottomSheet(c,add: true);
            },
            controllerLogic: (f,b){
              scrollController.addListener(() {
                if(scrollController.position.userScrollDirection == ScrollDirection.reverse){
                  b();
                } else {
                  if(scrollController.position.userScrollDirection == ScrollDirection.forward){
                    f();
                  }
                }
              });
            },
          ),
        ),
    );
  }
}
