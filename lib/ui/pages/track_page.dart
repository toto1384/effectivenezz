import 'package:after_layout/after_layout.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_drawer.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_fab.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/lists/gsort_by_calendar_list_view.dart';
import 'package:effectivenezz/ui/widgets/lists/gsort_by_money_tasks_and_activities.dart';
import 'package:effectivenezz/ui/widgets/specific/distivity_secondary_item.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gapp_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gtab_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gscaffold.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:sweetsheet/sweetsheet.dart';

import '../../main.dart';

class TrackPage extends StatefulWidget {
  @override
  _TrackPageState createState() => _TrackPageState();
}

class _TrackPageState extends DistivityPageState<TrackPage> with AfterLayoutMixin{
  DateTime selectedDate= getTodayFormated();

  int pageIndex = 0 ;
  PageController pageController = PageController(
      initialPage: 0,
  );


  @override
  void afterFirstLayout(BuildContext context) async{
    if(await MyApp.dataModel.prefs.isFirstTime(this.runtimeType.toString())){
      SweetSheet sweetSheet = SweetSheet();
      sweetSheet.show(
          context: context,
          title: GText('Here you can track your activities.',textType: TextType.textTypeTitle,
            color: MyColors.color_black_darker,),
          description: GText('Sorted by value and calendars. Press play to track them and see how much time'
              ' you have remaining of that activity(or long press to start a pomodoro timer)"',color: MyColors.color_black_darker,),
          color: MyColors.customSheetColor,
          icon: Icons.play_arrow,
          positive: SweetSheetAction(
            color: Colors.white,
            title: 'NEXT(1/3)',
            onPressed: (){
              Navigator.pop(context);
              sweetSheet.show(
                context: context,
                description: GText('Use the 3 dots at the bottom to modify the activity that\'s'
                    'playing or the start and end time of it',color: MyColors.color_black_darker,),
                color: MyColors.customSheetColor,
                icon: Icons.more_horiz,
                positive: SweetSheetAction(
                  onPressed: () {
                    Navigator.of(context).pop();
                    sweetSheet.show(
                        context: context,
                        description: GText('Once a task/activity is playing, open the notification panel and tap '
                            'on the new notification. Then you will do everything within a popup',color: MyColors.color_black_darker,),
                        title: GText('Or you can do this without opening the app',textType: TextType.textTypeTitle,color: MyColors.color_black_darker,),
                        color: MyColors.customSheetColor,
                        positive: SweetSheetAction(
                          title: 'FINISH',
                          onPressed: (){
                            Navigator.pop(context);
                          },
                        )
                    );
                  },
                  title: 'NEXT(2/3)',
                ),
              );
            },
          )
      );
    }
  }

  ScrollController scrollController = ScrollController();

  bool showing = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()=>customOnBackPressed(context),
      child: GScaffold(
        key: scaffoldKey,
        drawer: DistivityDrawer(),
        appBar: GAppBar('Track',smallSubtitle: false,drawerEnabled: true,trailing: Visibility(
          visible: false,
          child: PopupMenuButton(
            icon: GIcon(Icons.more_vert),
            itemBuilder: (ctx){
              return[];
            },
          ),
        ),subtitle: GTabBar(
            items: ["Activities by value",'Tasks by value'],
            selected: [pageIndex],
            onSelected:(i,b){
              setState(() {
                if(b){
                    pageIndex=i;
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
        },isInCalendar: false,),
        bottomNavigationBar: MyApp.dataModel!=null?(MyApp.dataModel.currentPlaying!=null)?DistivitySecondaryItem():null:null,
        body: PageView(
          onPageChanged: (i){
            setState(() {
              pageIndex=i;
            });
          },
          controller: pageController,
          children: <Widget>[
            GSortByMoneyTasksAndActivities(scrollController,selectedDate,whatToShow: WhatToShow.Activities,),
            GSortByMoneyTasksAndActivities(scrollController,selectedDate,whatToShow: WhatToShow.Tasks,),
          ],
        ),
      ),
    );
  }
}