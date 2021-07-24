import 'package:circular_check_box/circular_check_box.dart';
import 'package:effectivenezz/data/drive_helper.dart';
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/calendar.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_radio_group.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_restart_widget.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gswitchable.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext_field.dart';
import 'package:effectivenezz/ui/widgets/buttons/gsign_in_with_google_welcome_activity_button.dart';
import 'package:effectivenezz/ui/widgets/buttons/product_hunt.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/scheduled/gdate_time_edit_widget_for_scheduled.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gmax_web_width.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';




class QuickStartPage extends StatefulWidget {

  final GoogleDriveHelper driveHelper;

  QuickStartPage(this.driveHelper);

  @override
  _QuickStartPageState createState() => _QuickStartPageState();
}

class _QuickStartPageState extends DistivityPageState<QuickStartPage> {

  Scheduled sleepScheduled = Scheduled(
    durationInMinutes: 8*60,
    repeatRule: RepeatRule.EveryXDays,
    repeatValue: "1",
  );
  bool addReview = true;
  List<MainOccupationType> mainOccupationTypes = [];

  TextEditingController activityDurationMinutesTEC= TextEditingController();
  TextEditingController activityNameTEC = TextEditingController();



  PageController pageController = PageController(initialPage: 0,);
  
  int pageIndex = 0;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: (pageIndex==4||pageIndex==0)?ProductHunt():
      FloatingActionButton.extended(onPressed: ()async{
          pageController.
            animateToPage((pageIndex+1), duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
          setState(() {
            pageIndex++;
          });
        },backgroundColor: MyColors.color_yellow,
        label: GText(pageIndex==3?"Finish":"Next($pageIndex/3)",color: MyColors.color_black_darker,)),
      floatingActionButtonLocation: pageIndex==0?FloatingActionButtonLocation.startDocked:
        FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: pageIndex==0?Padding(
        padding: const EdgeInsets.only(top: 10,bottom: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  GText("Already an user?"),
                  GButton("Log in", onPressed: (){
                    widget.driveHelper.handleSignIn(context).then((value) {
                      MyApp.dataModel=null;
                      DistivityRestartWidget.restartApp(context);
                    });
                  },variant: 2),
                ],
              ),
            ),
          ],
        ),
      ):null,
      body: GMaxWebWidth(
        child: PageView(
          controller: pageController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height/7),left: 10,right: 10),
                      child: Container(
                          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2.5),
                          child: Image.asset(AssetsPath.timeIllustration)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,left: 20,right: 20,bottom: 5),
                      child: GText('Welcome to Effectivenezz. The easiest way to achieve 100h work-weeks. No motivation required.',
                        isCentered: true,textType: TextType.textTypeSubtitle,),
                    ),
                    GText('Let\'s start your '
                    'on-boarding journey in less than 2 minutes(because we know that time is important)',isCentered: true,),
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: GButton('Start',onPressed: (){
                        setState(() {
                          pageIndex++;
                        });
                        pageController.animateToPage
                          (pageIndex, duration: Duration(milliseconds: 200), curve: Curves.easeInOut);
                      },),
                    ),
                  ],
                )),
              ],
            ),
            ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GText("I work on :",textType: TextType.textTypeGigant),
                ),
                RosseRadioGroup(
                  isBig: true,
                  items: {
                    "9-5 Job":mainOccupationTypes.contains(MainOccupationType.values[0]),
                    "Freelance":mainOccupationTypes.contains(MainOccupationType.values[1]),
                    "Side Hustle/Job":mainOccupationTypes.contains(MainOccupationType.values[2]),
                  },
                  onSelected: (i,s){
                    setState(() {
                      if(mainOccupationTypes.contains(MainOccupationType.values[i])){
                        //contains
                        mainOccupationTypes.remove(MainOccupationType.values[i]);
                      }else{
                        mainOccupationTypes.add(MainOccupationType.values[i]);
                      }
                    });
                  },
                ),
                GText("(select 1 or more)"),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 50),
                    child: GText('We ask this to determine the basic activities you do at work so you can track them and get insights'),
                  ),
                ),
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GText("I go to sleep at:",textType: TextType.textTypeTitle),
                        GDateTimeEditWidgetForScheduled(onScheduledChange: (sch){
                          setState(() {
                            sleepScheduled=sch..startTime.subtract(Duration(days: 1));
                          });
                        },isStartTime: true,scheduled: sleepScheduled,text:'',gDateTimeShow: GDateTimeShow.Time,),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularCheckBox(
                                value: addReview,
                                onChanged: (b){
                                  setState(() {
                                    addReview=b;
                                  });
                                },checkColor: MyColors.color_black_darker,
                                activeColor: MyColors.color_yellow,
                              ),
                            ),
                            GText("Schedule daily review(an essential habit for a productive day)")
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 50),
                    child: GText('Everything centers around your sleep, so we use it to build your schedule. And no Johnny, we don\'t save your data'),
                  ),
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: MediaQuery.of(context).size.height/3),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: kIsWeb?Wrap(
                            direction: Axis.horizontal,
                            children: [
                              GText('What\'s that one activity that if I do everyday for',),
                              Container(
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: GTextField(activityDurationMinutesTEC, hint: 'hours',small: true,
                                    textInputType: TextInputType.number,),
                                ),
                              ),
                              GText(' hours will change my life in 6 months'),
                            ],
                          ):Text.rich(
                            TextSpan(children: <InlineSpan>[
                              TextSpan(text: 'What\'s that one activity that if I do everyday for',style: TextStyle(
                                color: Colors.white,
                                fontWeight: TextType.textTypeNormal.fontWeight,
                                fontSize: TextType.textTypeNormal.size,
                              ),),
                              WidgetSpan(
                                alignment: PlaceholderAlignment.middle,
                                child: Container(
                                  width: 100,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: GTextField(
                                        activityDurationMinutesTEC, hint: 'hours',small: true),
                                  ),
                                ),),
                              TextSpan(text: ' hours will change my life in 6 months?',style: TextStyle(
                                color: Colors.white,
                                fontWeight: TextType.textTypeNormal.fontWeight,
                                fontSize: TextType.textTypeNormal.size,
                              )),
                            ],),textAlign: TextAlign.center,
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 400),
                              child: GTextField(activityNameTEC,hint: 'Activity name',)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 50),
                    child: GText('It\'s not hard to push the needle forward. Consistent medium-sized action every day will get'
                        ' you very further in life. You can start your business with 4 hours a day, you can build an '
                        'amazing body with 30 minutes a day.'),
                  ),
                )
              ],
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GText("Time management shouldn\'t be that hard and STRICT. So we\'ve created a simple routine "
                      "for you and you will be notified before each activity.",textType: TextType.textTypeSubtitle,isCentered: true,),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: GSignInWithGoogleWelcomeActivityButton( widget.driveHelper,onSignInCompleted: ()async{
                      await save();
                    },),
                  ),
                  GText("(and continue)",),
                  if(loading)Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(width:25,height:25,child: CircularProgressIndicator()),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  save()async{
    setState(() {
      loading=true;
    });
    Uuid uuid = Uuid();
    //cals
    String bodyCalendarId = (await MyApp.dataModel.backend.calendar(context,RequestType.Post,calendar: ECalendar(
      name: 'Body',
      color: Colors.brown,
      show: true,
      value: 0,
      id: uuid.v4()
    ))).first.id;
    String habitsCalendarId = (await MyApp.dataModel.backend.calendar(context,RequestType.Post,calendar: ECalendar(
      name: 'Habits',
      color: Colors.green,
      show: true,
      value: 0,
      id: uuid.v4()
    ))).first.id;
    String workCalendarId = (await MyApp.dataModel.backend.calendar(context,RequestType.Post,calendar: ECalendar(
        name: 'Work',
        value: 10000,
        color: Colors.red,
        show: true,
        id: uuid.v4()
    ))).first.id;
    String addictionsCalendarId = (await MyApp.dataModel.backend.calendar(context,RequestType.Post,calendar: ECalendar(
      name: 'Addictions',
      value: -1000,
      show: true,
      color: Colors.grey,
      id: uuid.v4()
    ))).first.id;
    //

    //addictions
    await MyApp.dataModel.backend.activity(context,RequestType.Post,activity: Activity(
        value: -1000,
        name: 'Social Media',
        parentCalendarId: addictionsCalendarId,
        trackedEnd: [],
        schedules: [],
        tags: [],
        trackedStart: [],
        color: Colors.grey,
        valueMultiply: false,
        icon: Icons.phone_android,
        id: uuid.v4()
    ));
    await MyApp.dataModel.backend.activity(context,RequestType.Post,activity: Activity(
        value: -1000,
        name: 'Netflix/TV',
        parentCalendarId: addictionsCalendarId,
        schedules: [],
        trackedEnd: [],
        tags: [],
        trackedStart: [],
        valueMultiply: false,
        color: Colors.grey,
        icon: Icons.tv,
        id: uuid.v4()
    ));
    await MyApp.dataModel.backend.activity(context,RequestType.Post,activity: Activity(
      value: -100,
      name: 'Gaming',
      parentCalendarId: addictionsCalendarId,
      schedules: [],
      trackedEnd: [],
      tags: [],
      color: Colors.grey,
      trackedStart: [],
      valueMultiply: false,
      icon: Icons.gamepad,
      id: uuid.v4()
    ));
    //

    //sleep
    await MyApp.dataModel.backend.activity(context,RequestType.Post,activity: Activity(
        name: "Sleep",
        parentCalendarId: bodyCalendarId,
        schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: sleepScheduled)).first.id],
        value: 10,
        trackedEnd: [],
        tags: [],
        color: Colors.brown,
        trackedStart: [],
        valueMultiply: false,
        icon: Icons.hotel,
        id: uuid.v4()
    ));

    //activity
    if(activityNameTEC.text!=''&&activityDurationMinutesTEC.text!='')
      await MyApp.dataModel.backend.activity(context,RequestType.Post,activity:Activity(
        trackedEnd: [],
        tags: [],
        trackedStart: [],
        valueMultiply: false,
        name: activityNameTEC.text,
        schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
          durationInMinutes: int.parse(activityDurationMinutesTEC.text)*60,
          repeatValue: 1.toString(),
          repeatRule: RepeatRule.EveryXDays,
          startTime: sleepScheduled.getEndTime()??getTodayFormated().add(Duration(hours: 1)),
          id: uuid.v4()
        ))).first.id],
        value: 100000,
        color: Colors.red,
        parentCalendarId: habitsCalendarId,
        icon: Icons.star_border,
        id: uuid.v4()
      ));

    if(addReview)await MyApp.dataModel.backend.task(context,RequestType.Post,task:Task(
        parentId: habitsCalendarId,
        value: 10000,
        name: 'Review your day',
        valueMultiply: false,
        schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
            repeatRule: RepeatRule.EveryXDays,
            repeatValue: "1",
            durationInMinutes: 20,
            startTime: sleepScheduled.startTime.subtract(Duration(minutes: 20)),
            id: uuid.v4()
        ))).first.id],
        trackedStart: [],
        tags: [],
        trackedEnd: [],
        isParentCalendar: true,
        checks: [],
        color: Colors.blue,
        id: uuid.v4(),
        description: "ANSWER THESE QUESTIONS ON A PIECE OF PAPER!\n\n\n"
            "Look at your calendar,Have you spend your week on the right things?\nWhy?\n"
            "Did you followed your schedule?\nIf not, Why?\n"
            "Look at your metrics!\nWere you focused?\nWas your time of great value today?\n\n"
            "So, are you happy with your current results?\nWhat you can change to do better?\n"
            "How much did you spend on addictions?\nHow can you become more disciplined to do less of them?\n"
            "What are you doing different from your role models and for those that accomplish your goals?\n"
            "How much time did you spend building something that no one asked for?\n"
            "If you had a heart attack tomorrow and have to work only 2 hours a day, what will you work on?\n"
            "Has today added anything of value to your stock of knowledge or state of mind?\n"
            "Think of the most successful person who solved the biggest problem you have right now."
            " How did he did it and what advice he'd give to you?\n"
            "How can I solve the biggest flaw in myself that is holding me from achieving my goals\n"
            "Consider how many people work for years to get a 15% raise when they could quickly switch to"
            " a new job that pays 25% better. - How are you doing something similar in your life? How can you work smarter?\n"
    ));

    await mainOccupationTypes.forEach((element) async {
      switch(element){

        case MainOccupationType.NineToFive:
          await MyApp.dataModel.backend.activity(context,RequestType.Post,activity: Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: 'Job',
            value: 1000,
            color: Colors.red,
            parentCalendarId: workCalendarId,
            schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
              durationInMinutes: 60*8,
              repeatValue: "1",
              repeatRule: RepeatRule.EveryXDays,
              startTime: DateTime(getTodayFormated().year,getTodayFormated().month,getTodayFormated().day,9,0,0),
              id: uuid.v4()
            ))).first.id],
            icon: Icons.work,
            id: uuid.v4()
          ));
          break;
        case MainOccupationType.Freelance:
          await MyApp.dataModel.backend.activity(context,RequestType.Post,activity: Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Client 1",
            value: 1000,
            color: Colors.red,
            parentCalendarId: workCalendarId,
            schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
              durationInMinutes: 0,
              repeatValue: "1",
              repeatRule: RepeatRule.EveryXDays,
              id: uuid.v4()
            ))).first.id],
            icon: Icons.person,
            id: uuid.v4()
          ));
          await MyApp.dataModel.backend.activity(context,RequestType.Post,activity: Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Client 2",
            value: 1000,
            color: Colors.red,
            parentCalendarId: workCalendarId,
            schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
              durationInMinutes: 0,
              repeatValue: "1",
              repeatRule: RepeatRule.EveryXDays,
              id: uuid.v4()
            ))).first.id],
            icon: Icons.person,
            id: uuid.v4()
          ));
          await MyApp.dataModel.backend.activity(context,RequestType.Post,activity: Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Client 3",
            value: 1000,
            color: Colors.red,
            parentCalendarId: workCalendarId,
            schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
              durationInMinutes: 0,
              repeatValue: "1",
              repeatRule: RepeatRule.EveryXDays,
              id: uuid.v4()
            ))).first.id],
            icon: Icons.person,
            id: uuid.v4()
          ));
          break;
        case MainOccupationType.Business:
          await MyApp.dataModel.backend.activity(context,RequestType.Post,activity: Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Product",
            value: 1000,
            color: Colors.red,
            parentCalendarId: workCalendarId,
            schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
              durationInMinutes: 0,
              repeatValue: "1",
              id: uuid.v4(),
              repeatRule: RepeatRule.EveryXDays,
            ))).first.id],
            icon: Icons.palette,
            id: uuid.v4()
          ));
          await MyApp.dataModel.backend.activity(context,RequestType.Post,activity: Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Traffic",
            value: 1000,
            color: Colors.red,
            parentCalendarId: workCalendarId,
            icon: Icons.people_outline,
            id: uuid.v4(),
            schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
              durationInMinutes: 0,
              repeatValue: "1",
              repeatRule: RepeatRule.EveryXDays,
              id: uuid.v4()
            ))).first.id]
          ));
          await MyApp.dataModel.backend.activity(context,RequestType.Post,activity: Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Marketing",
            value: 1000,
            color: Colors.red,
            parentCalendarId: workCalendarId,
            schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
              durationInMinutes: 0,
              repeatValue: "1",
              repeatRule: RepeatRule.EveryXDays,
              id: uuid.v4()
            ))).first.id],
            icon: Icons.web,
            id: uuid.v4()
          ));
          await MyApp.dataModel.backend.activity(context,RequestType.Post,activity: Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Business management",
            value: 1000,
            schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
              durationInMinutes: 0,
              repeatValue: "1",
              repeatRule: RepeatRule.EveryXDays,
              id: uuid.v4()
            ))).first.id],
            color: Colors.red,
            parentCalendarId: workCalendarId,
            icon: Icons.pie_chart_outlined,
            id: uuid.v4()
          ));
          break;
      }
    });
    await MyApp.dataModel.backend.task(context,RequestType.Post,task: Task(
      value: 10000,
      schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
        repeatRule: RepeatRule.None,
        repeatValue: "0",
        durationInMinutes: 10,
        id: uuid.v4()
      ))).first.id],
      name: 'Adjust your schedule to your likings in the \'Calendar\' Page',
      valueMultiply: false,
      trackedStart: [],
      tags: [],
      trackedEnd: [],
      isParentCalendar: true,
      checks: [],
      color: Colors.blue,
      id: uuid.v4()
    ));
    await MyApp.dataModel.backend.task(context,RequestType.Post,task: Task(
      value: 10000,
      name: 'Have a look at the metrics page',
      valueMultiply: false,
      trackedStart: [],
      schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
        repeatRule: RepeatRule.None,
        repeatValue: "0",
        durationInMinutes: 10,
        id: uuid.v4()
      ))).first.id],
      tags: [],
      trackedEnd: [],
      isParentCalendar: true,
      checks: [],
      color: Colors.blue,
      id: uuid.v4()
    ));
    await MyApp.dataModel.backend.task(context,RequestType.Post,task: Task(
      value: 10000,
      name: 'Add your own activities/tasks',
      valueMultiply: false,
      trackedStart: [],
      tags: [],
      trackedEnd: [],
      isParentCalendar: true,
      checks: [],
      schedules: [(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
        repeatRule: RepeatRule.None,
        repeatValue: "0",
        durationInMinutes: 10,
        id: uuid.v4()
      ))).first.id],
      color: Colors.blue,
      id: uuid.v4()
    ));
    await MyApp.dataModel.backend.task(context,RequestType.Post,task: Task(
        value: 10000,
        name: 'Read our encouragement letter(it\'s short believe me)',
        valueMultiply: false,
        trackedStart: [],
        tags: [],
        trackedEnd: [],
        isParentCalendar: true,
        checks: [],
        color: Colors.blue,
        id: uuid.v4(),
        description: 'We are so proud to have you here. But, for the first days, it will be annoying to track your '
            'time. YOU WILL MAKE MISTAKES, YOU WILL FORGET WHEN TO TRACK A NEW ACTIVITY, AND YOU WILL BE POTENTIALLY '
            'PISSED . But that\'s fine, we all make mistakes, and a 15-30 minute mistake won\'t reflect in your metrics'
            ' very much. So be patient with this journey, because on the other side there is unlimited potential for'
            ' your productivityWe addressed this problem by letting you edit the timestamp(do it by pressing on the'
            ' seconds passing or clicking the 3 dots button)',
        schedules:[(await MyApp.dataModel.backend.scheduled(context,RequestType.Post,scheduled: Scheduled(
          repeatRule: RepeatRule.None,
          repeatValue: "0",
          durationInMinutes: 10,
          id: uuid.v4()
        ))).first.id]
    ));
    setState(() {
      loading=false;
    });
  }

}

enum MainOccupationType{
  NineToFive,Freelance,Business
}
