import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_drawer.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gapp_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gscaffold.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

class ManageCalendars extends StatefulWidget {
  @override
  ManageCalendarsState createState() => ManageCalendarsState();
}

class ManageCalendarsState extends DistivityPageState<ManageCalendars>{

  ScrollController scrollController= ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      DistivityPageState.listCallback.listen((object, d) {
        if(mounted)setState(() {

        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
        child: GScaffold(
          key: scaffoldKey,
          drawer: DistivityDrawer(),
          appBar: GAppBar("Manage Calendars",drawerEnabled: true),
          body: MyApp.dataModel.eCalendars.length!=0?ListView.builder(itemCount: MyApp.dataModel.eCalendars.length,itemBuilder: (ctx,ind){
            return ListTile(
              leading: CircleAvatar(
              backgroundColor: MyApp.dataModel.eCalendars[ind].color,
                maxRadius: 15,
              ),
              title: GText(MyApp.dataModel.eCalendars[ind].name),
              onTap: (){
                showAddEditCalendarBottomSheet(context,eCalendar: MyApp.dataModel.eCalendars[ind],index: ind,add: false);
              },
            );
          },controller: scrollController,):Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: MyApp.dataModel.screenWidth-50,
                  height: MyApp.dataModel.screenWidth-50,
                  child: SvgPicture.asset(AssetsPath.emptyView)
                ),
                GText('No calendars')
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: (){
              showAddEditCalendarBottomSheet(context,add: true);
            },
            child: GIcon(Icons.add,color: MyColors.color_black,),
            backgroundColor: MyColors.color_yellow,
          ),
        ),
    );
  }
}
