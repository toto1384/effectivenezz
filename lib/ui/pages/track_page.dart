import 'package:effectivenezz/ui/widgets/distivity_drawer.dart';
import 'package:effectivenezz/ui/widgets/distivity_fab.dart';
import 'package:effectivenezz/ui/widgets/distivity_secondary_item.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../main.dart';

class TrackPage extends StatefulWidget {
  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends DistivityPageState<TrackPage> {
  DateTime selectedDate= getTodayFormated();

  int pageIndex = 0 ;
  PageController pageController = PageController(
      initialPage: 0,
  );

  ScrollController scrollController = ScrollController();

  bool showing = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: Scaffold(
        key: scaffoldKey,
        drawer: DistivityDrawer(),
        appBar: getAppBar('Track',smallSubtitle: false,context: context,drawerEnabled: true,trailing: Visibility(
          visible: false,
          child: PopupMenuButton(
            icon: getIcon(Icons.more_vert),
            itemBuilder: (ctx){
              return[];
            },
          ),
        ),subtitle: getTabBar(
            items: ['Sort by Value',"Upcoming"],
            selected: [pageIndex],
            onSelected:(i,b){
              setState(() {
                if(b){
                  setState(() {
                    pageIndex=i;
                  });
                }
              });
              pageController.animateToPage(i, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
            }
          ),
        ),
        floatingActionButton:DistivityFAB(controllerLogic:(f,b){
          scrollController.addListener(() {
            if(scrollController.position.userScrollDirection == ScrollDirection.reverse){
              b();
            } else {
              if(scrollController.position.userScrollDirection == ScrollDirection.forward){
                f();
              }
            }
          });
        }),
        bottomNavigationBar: MyApp.dataModel!=null?(MyApp.dataModel.currentPlaying!=null)?DistivitySecondaryItem():null:null,
        body: PageView(
          onPageChanged: (i){
            setState(() {
              pageIndex=i;
            });
          },
          controller: pageController,
          children: <Widget>[
            sortByMoneyTasksAndActivities(context, scrollController, selectedDate,),
            upcomingTasksAndActivities(context,scrollController,selectedDate,),
          ],
        ),
      ),
    );
  }
}