import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/calendar.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/pages/track_page.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:flutter/material.dart';

class QuickStartPage extends StatefulWidget {
  @override
  _QuickStartPageState createState() => _QuickStartPageState();
}

class _QuickStartPageState extends State<QuickStartPage> {

  Activity sleep = Activity(
    name: "Sleep",
    parentCalendarId: 1000,
    value: 10,
    trackedEnd: [],
    tags: [],
    trackedStart: [],
    valueMultiply: false,
    icon: Icons.hotel,
    id: 1000
  );

  Activity exercise = Activity(
      name: "Exercise",
      parentCalendarId: 1001,
      value: 1000,
      trackedEnd: [],
      tags: [],
      trackedStart: [],
      valueMultiply: false,
      icon: Icons.fitness_center,
      id: 1001,
      description: null
  );

  List<Scheduled> meals = [
    Scheduled(
      repeatValue: 1,
      repeatRule: RepeatRule.EveryXDays,
      isParentTask: false,
      durationInMins: 35,
    ),
  ];

  saveMeals()async{
    for(int i = 0 ; i< meals.length ; i++){
      Activity meal = Activity(
        valueMultiply: false,
        trackedStart: [],
        tags: [],
        trackedEnd: [],
        value: 0,
        name: 'Meal #${i+1}',
        parentCalendarId: 1000,
        id: 10000+i,
        icon: Icons.restaurant,
      );
      meals[i].parentId=10000+i;
      await MyApp.dataModel.activity(-1, meal, context, CUD.Create,addWith: meals[i]);
    }
  }

  Scheduled exerciseScheduled = Scheduled(
    durationInMins: 60,
    isParentTask: false,
    repeatRule: RepeatRule.EveryXDays,
    repeatValue: 2,
    parentId: 1001,
  );

  Scheduled reviewScheduled = Scheduled(
    repeatRule: RepeatRule.EveryXDays,
    repeatValue: 1,
    durationInMins: 20,
    isParentTask: true,
    parentId: 12
  );

  Scheduled sleepScheduled = Scheduled(
    durationInMins: 8*60,
    isParentTask: false,
    repeatRule: RepeatRule.EveryXDays,
    repeatValue: 1,
    parentId: 1000,
  );

  bool addAddictions = true;
  TextEditingController taskEditingController = TextEditingController();
  TextEditingController activityEditingController = TextEditingController();
  TextEditingController activityDurationEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar('Quick Start',context: context,backEnabled: true),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            getSubtitle('Schedule sleep'),
            getDateTimeEditWidgetForScheduled(context,onScheduledChange: (sch){
              setState(() {
                sleepScheduled=sch;
              });
            },isStartTime: true,scheduled: sleepScheduled,text:'I go to sleep at'),
            getDateTimeEditWidgetForScheduled(context,onScheduledChange: (sch){
              setState(() {
                sleepScheduled=sch;
              });
            },isStartTime: false,scheduled: sleepScheduled,text: 'I wake up at'),
            getDivider(),
            getSubtitle('Schedule your meals'),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(meals.length, (index) {
                return getDateTimeEditWidgetForScheduled(context,onScheduledChange: (sch){
                  setState(() {
                    meals[index]=sch;
                  });
                },isStartTime: true,scheduled: meals[index],text: "#${index+1} meal at:");
              }),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: getButton('Add meal', onPressed: (){
                  setState(() {
                    meals.add(Scheduled(
                      repeatValue: 1,
                      repeatRule: RepeatRule.EveryXDays,
                      isParentTask: false,
                      durationInMins: 35,
                    ),);
                  });
                },variant: 2),
              ),
            ),
            getDivider(),
            getDateTimeEditWidgetForScheduled(context,onScheduledChange: (sch){
              setState(() {
                exerciseScheduled=sch;
              });
            },isStartTime: true,scheduled: exerciseScheduled,text: 'I exercise at'),
            getDivider(),

            getSubtitle('Growth'),
            Padding(
              padding: const EdgeInsets.all(15),
              child: getText("What's that one task that if I do everyday will change my life in 6 months?"),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: getTextField(taskEditingController, hint: 'Task name',),
            ),

            getDivider(),

            Padding(
              padding: const EdgeInsets.all(15),
              child: Text.rich(
                TextSpan(children: <InlineSpan>[
                  TextSpan(text: 'What\'s that one activtiy that if I do everyday for',style: TextStyle(
                      color: Colors.white,
                      fontWeight: TextType.textTypeNormal.fontWeight,
                      fontSize: TextType.textTypeNormal.size,
                  )),
                  WidgetSpan(child: Container(
                    width: 100,
                    child: getTextField(
                      activityDurationEditingController, hint: 'hours',small: true),
                  ),),
                  TextSpan(text: ' hours will change my life in 6 months',style: TextStyle(
                    color: Colors.white,
                    fontWeight: TextType.textTypeNormal.fontWeight,
                    fontSize: TextType.textTypeNormal.size,
                  )),
                ],),textAlign: TextAlign.center,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(15.0),
              child: getTextField(activityEditingController,hint: 'Activity name',),
            ),
            getDivider(),
            getDateTimeEditWidgetForScheduled(context,onScheduledChange: (sch){
              setState(() {
                reviewScheduled=sch;
              });
            },isStartTime: true,scheduled: reviewScheduled,text: 'When would you like to review your day?(15-30m)'),
            getDivider(),
            getSwitchable(text: 'I spend time on social media, gaming or Netflix',
                checked: addAddictions, onCheckedChanged: (c){
                  setState(() {
                    addAddictions=c;
                  });
                }, isCheckboxOrSwitch: true),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: save,
          label: getText('Begin'),
          backgroundColor: MyColors.color_gray_darker,
          icon: getIcon(Icons.play_arrow),
      ),
    );
  }
  save()async{
    await MyApp.dataModel.eCalendar(-1, ECalendar(
      name: 'Body',
      color: Colors.brown,
      parentId: -1,
      show: true,
      themesEnd: [],
      themesStart: [],
      value: 0,
      id: 1000,
    ), context, CUD.Create,);//body
    await MyApp.dataModel.eCalendar(-1, ECalendar(
      name: 'Habits',
      color: Colors.green,
      parentId: -1,
      show: true,
      themesEnd: [],
      themesStart: [],
      value: 0,
      id: 1001,
    ), context, CUD.Create);//habits
    await MyApp.dataModel.eCalendar(-1, ECalendar(
      name: 'Work',
      value: 10000,
      color: Colors.red,
      show: true,
      themesEnd: [],
      themesStart: [],
      parentId: -1,
      id: 1010
    ), context, CUD.Create);//work
    if(addAddictions){
      await MyApp.dataModel.eCalendar(-1, ECalendar(
        name: 'Addictions',
        value: -1000,
        parentId: -1,
        themesStart: [],
        themesEnd: [],
        show: true,
        color: Colors.grey,
        id: 1005,
      ), context, CUD.Create);
      await MyApp.dataModel.activity(-1, Activity(
        value: -1000,
        name: 'Social Media',
        parentCalendarId: 1005,
        trackedEnd: [],
        tags: [],
        trackedStart: [],
        valueMultiply: false,
        icon: Icons.phone_android
      ), context, CUD.Create);
      await MyApp.dataModel.activity(-1, Activity(
          value: -1000,
          name: 'Netflix/TV',
          parentCalendarId: 1005,
          trackedEnd: [],
          tags: [],
          trackedStart: [],
          valueMultiply: false,
          icon: Icons.tv
      ), context, CUD.Create);
      await MyApp.dataModel.activity(-1, Activity(
          value: -100,
          name: 'Gaming',
          parentCalendarId: 1005,
          trackedEnd: [],
          tags: [],
          trackedStart: [],
          valueMultiply: false,
          icon: Icons.gamepad,
      ), context, CUD.Create);
    }

    await MyApp.dataModel.activity(-1, sleep, context, CUD.Create,addWith: sleepScheduled);//sleep
    await saveMeals();//meals
    await MyApp.dataModel.activity(-1, exercise, context, CUD.Create,addWith: exerciseScheduled);//exercise
    if(taskEditingController.text!='')await MyApp.dataModel.task(-1, Task(
      parentId: 1010,
      value: 1000,
      name: taskEditingController.text,
      valueMultiply: false,
      trackedStart: [],
      tags: [],
      trackedEnd: [],
      checks: [],
      isParentCalendar: true,
      id: 10
    ), context, CUD.Create,addWith: Scheduled(
      repeatRule: RepeatRule.EveryXDays,
      repeatValue: 1,
      durationInMins: 60,
      startTime: sleepScheduled.getEndTime(),
      isParentTask: true,
      parentId: 10
    ));//task
    if(activityEditingController.text!=''&&activityDurationEditingController.text!='')
     await MyApp.dataModel.activity(-1, Activity(
      trackedEnd: [],
      tags: [],
      trackedStart: [],
      valueMultiply: false,
      name: activityEditingController.text,
      value: 1000,
      parentCalendarId: 1010,
      id: 11,
      icon: Icons.work,
    ), context, CUD.Create,addWith: Scheduled(
      isParentTask: false,
      durationInMins: int.parse(activityDurationEditingController.text)*60,
      repeatValue: 1,
      repeatRule: RepeatRule.EveryXDays,
      parentId: 11,
      startTime: sleepScheduled.getEndTime().add(Duration(hours: 1)),
    ));//activity
    await MyApp.dataModel.task(-1, Task(
      id: 12,
      parentId: 1001,
      value: 10000,
      name: 'Review your day',
      valueMultiply: false,
      trackedStart: [],
      tags: [],
      trackedEnd: [],
      isParentCalendar: true,
      checks: [],
      color: Colors.blue,
      description: "ANSWER THESE QUESTIONS ON A PIECE OF PAPER!\N\N\N"
          "Look at your calendar,Have you spend your week on the right things?\NWhy?\N"
          "Did you followed your schedule?\nIf not, Why?\n"
          "Look at your metrics!\nWere you focused?\nWas your time of great value today?\n"
          "So, are you happy with your current results?\nWhat you can change to do better?\n"
          "How much did you spend on addictions?\n How can you become more disciplined to do less of them?\n"
          "What are you doing different from your role models and for those that accomplish your goals?\n"
          "How much time did you spend building something that no one asked for?\n"
          "If you had a heart attack tomorrow and have to work only 2 hours a day, what will you work on?\n"
          "Has today added anything of value to your stock of knowledge or state of mind?\n"
          "Think of the most successful person who solved the biggest problem you have right now."
          " How did he did it and what advice he'd give to you?\n"
          "How can I solve the biggest flaw in myself that is holding me from achieving my goals\n"
          "Consider how many people work for years to get a 15% raise when they could quickly switch to"
          " a new job that pays 25% better. - How are you doing something similar in your life? How can you work smarter?\n"
    ), context,CUD.Create,addWith: reviewScheduled);//review
    launchPage(context, TrackPage());
  }
}
