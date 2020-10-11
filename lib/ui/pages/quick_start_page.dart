import 'package:effectivenezz/data/drive_helper.dart';
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/calendar.dart';
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_radio_group.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gswitchable.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext_field.dart';
import 'package:effectivenezz/ui/widgets/buttons/gsign_in_with_google_welcome_activity_button.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/scheduled/gdate_time_edit_widget_for_scheduled.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gmax_web_width.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';




class QuickStartPage extends StatefulWidget {

  final GoogleDriveHelper driveHelper;

  QuickStartPage(this.driveHelper);

  @override
  _QuickStartPageState createState() => _QuickStartPageState();
}

class _QuickStartPageState extends DistivityPageState<QuickStartPage> {

  Scheduled sleepScheduled = Scheduled(
    durationInMins: 8*60,
    isParentTask: false,
    repeatRule: RepeatRule.EveryXDays,
    repeatValue: 1,
    parentId: 1000,
  );
  bool addReview = true;
  List<MainOccupationType> mainOccupationTypes = [];

  TextEditingController activityDurationMinutesTEC= TextEditingController();
  TextEditingController activityNameTEC = TextEditingController();



  PageController pageController = PageController(initialPage: 0,);
  
  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      floatingActionButton: (pageIndex==4||pageIndex==0)?null:FloatingActionButton.extended(onPressed: ()async{
        pageController.
          animateToPage((pageIndex+1), duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
        setState(() {
          pageIndex++;
        });
      },backgroundColor: MyColors.color_black, label: GText(pageIndex==3?"Finish":"Next($pageIndex/3)")),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
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
                      padding: EdgeInsets.only(top: (MediaQuery.of(context).size.height/5),left: 10,right: 10),
                      child: Container(
                          constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/2.5),
                          child: Image.asset(AssetsPath.timeIllustration)
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10,left: 20,right: 20),
                      child: GText('Welcome to Effectivenezz, the place to manage your time. Let\'s start your'
                          'onboarding journey in less than 2 minutes(because we know that time is important)',
                        isCentered: true,),
                    ),
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
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GText("Already an user?"),
                        GButton("Log in", onPressed: (){
                          widget.driveHelper.handleSignIn(context).then((v)async{
                            await MyApp.dataModel.driveHelper.downloadAndReplaceFile(context,
                                (await MyApp.dataModel.driveHelper.getAllFiles(context))[0]);
                          });
                        },variant: 2),
                      ],
                    ),
                  ),
                ),
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
                        },isStartTime: true,scheduled: sleepScheduled,text:'',onlyTime: true,),
                        GSwitchable(text: "Schedule daily review(an essential habit for a productive day)",
                            checked: addReview, onCheckedChanged: (b){
                              setState(() {
                                addReview=b;
                              });
                            }, isCheckboxOrSwitch: true
                        ),
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
                                  child: GTextField(
                                      activityDurationMinutesTEC, hint: 'hours',small: true),
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
                          child: GTextField(activityNameTEC,hint: 'Activity name',),
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
                  GText("(and continue)",)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


  save()async{
    //cals
    MyApp.dataModel.databaseHelper.insertECalendar(ECalendar(
      name: 'Body',
      color: Colors.brown,
      parentId: -1,
      show: true,
      themesEnd: [],
      themesStart: [],
      value: 0,
      id: 1000,
    ));
    await MyApp.dataModel.databaseHelper.insertECalendar(ECalendar(
      name: 'Habits',
      color: Colors.green,
      parentId: -1,
      show: true,
      themesEnd: [],
      themesStart: [],
      value: 0,
      id: 1001,
    ));//habits
    await MyApp.dataModel.databaseHelper.insertECalendar(ECalendar(
        name: 'Work',
        value: 10000,
        color: Colors.red,
        show: true,
        themesEnd: [],
        themesStart: [],
        parentId: -1,
        id: 1010
    ));//work
    await MyApp.dataModel.databaseHelper.insertECalendar(ECalendar(
      name: 'Addictions',
      value: -1000,
      parentId: -1,
      themesStart: [],
      themesEnd: [],
      show: true,
      color: Colors.grey,
      id: 1005,
    ));
    //

    //addictions
    await MyApp.dataModel.databaseHelper.insertActivity(Activity(
        value: -1000,
        name: 'Social Media',
        parentCalendarId: 1005,
        trackedEnd: [],
        tags: [],
        trackedStart: [],
        color: Colors.grey,
        valueMultiply: false,
        icon: Icons.phone_android
    ));
    await MyApp.dataModel.databaseHelper.insertActivity(Activity(
        value: -1000,
        name: 'Netflix/TV',
        parentCalendarId: 1005,
        trackedEnd: [],
        tags: [],
        trackedStart: [],
        valueMultiply: false,
        color: Colors.grey,
        icon: Icons.tv
    ));
    await MyApp.dataModel.databaseHelper.insertActivity( Activity(
      value: -100,
      name: 'Gaming',
      parentCalendarId: 1005,
      trackedEnd: [],
      tags: [],
      color: Colors.grey,
      trackedStart: [],
      valueMultiply: false,
      icon: Icons.gamepad,
    ),);
    //

    //sleep
    await MyApp.dataModel.databaseHelper.insertActivity(Activity(
        name: "Sleep",
        parentCalendarId: 1000,
        value: 10,
        trackedEnd: [],
        tags: [],
        color: Colors.brown,
        trackedStart: [],
        valueMultiply: false,
        icon: Icons.hotel,
        id: 1000
    ),scheduleds: [sleepScheduled]);

    //activity
    if(activityNameTEC.text!=''&&activityDurationMinutesTEC.text!='')
      await MyApp.dataModel.databaseHelper.insertActivity( Activity(
        trackedEnd: [],
        tags: [],
        trackedStart: [],
        valueMultiply: false,
        name: activityNameTEC.text,
        value: 100000,
        color: Colors.red,
        parentCalendarId: 1010,
        id: 11,
        icon: Icons.star_border,
      ), scheduleds: [Scheduled(
        isParentTask: false,
        durationInMins: int.parse(activityDurationMinutesTEC.text)*60,
        repeatValue: 1,
        repeatRule: RepeatRule.EveryXDays,
        parentId: 11,
        startTime: (sleepScheduled.getEndTime()??getTodayFormated()).add(Duration(hours: 1)),
      )]);//activity
    if(addReview)await MyApp.dataModel.databaseHelper.insertTask(Task(
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
    ),scheduleds: [Scheduled(
        repeatRule: RepeatRule.EveryXDays,
        repeatValue: 1,
        durationInMins: 20,
        isParentTask: true,
        startTime: sleepScheduled.startTime.subtract(Duration(minutes: 20)),
        parentId: 12
    )]);//review

    mainOccupationTypes.forEach((element) async {
      switch(element){

        case MainOccupationType.NineToFive:
          await MyApp.dataModel.databaseHelper.insertActivity(Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: 'Job',
            value: 1000,
            color: Colors.red,
            parentCalendarId: 1010,
            id: 102,
            icon: Icons.work,
          ),scheduleds: [Scheduled(
            isParentTask: false,
            durationInMins: 60*8,
            repeatValue: 1,
            repeatRule: RepeatRule.EveryXDays,
            parentId: 102,
            startTime: DateTime(getTodayFormated().year,getTodayFormated().month,getTodayFormated().day,9),
          )]);
          break;
        case MainOccupationType.Freelance:
          await MyApp.dataModel.databaseHelper.insertActivity(Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Client 1",
            value: 1000,
            color: Colors.red,
            parentCalendarId: 1010,
            id: 101,
            icon: Icons.person,
          ),scheduleds: [Scheduled(
            isParentTask: false,
            durationInMins: 0,
            repeatValue: 1,
            repeatRule: RepeatRule.EveryXDays,
            parentId: 101,
          )]);
          await MyApp.dataModel.databaseHelper.insertActivity(Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Client 2",
            value: 1000,
            color: Colors.red,
            parentCalendarId: 1010,
            id: 100,
            icon: Icons.person,
          ),scheduleds: [Scheduled(
            isParentTask: false,
            durationInMins: 0,
            repeatValue: 1,
            repeatRule: RepeatRule.EveryXDays,
            parentId: 100,
          )]);
          await MyApp.dataModel.databaseHelper.insertActivity(Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Client 3",
            value: 1000,
            color: Colors.red,
            parentCalendarId: 1010,
            id: 103,
            icon: Icons.person,
          ),scheduleds: [Scheduled(
            isParentTask: false,
            durationInMins: 0,
            repeatValue: 1,
            repeatRule: RepeatRule.EveryXDays,
            parentId: 103,
          )]);
          break;
        case MainOccupationType.Business:
          await MyApp.dataModel.databaseHelper.insertActivity(Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Product",
            value: 1000,
            color: Colors.red,
            parentCalendarId: 1010,
            id: 104,
            icon: Icons.palette,
          ), scheduleds: [Scheduled(
            isParentTask: false,
            durationInMins: 0,
            repeatValue: 1,
            repeatRule: RepeatRule.EveryXDays,
            parentId: 104,
          )]);
          await MyApp.dataModel.databaseHelper.insertActivity(Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Traffic",
            value: 1000,
            color: Colors.red,
            parentCalendarId: 1010,
            id: 105,
            icon: Icons.people_outline,
          ),scheduleds: [Scheduled(
            isParentTask: false,
            durationInMins: 0,
            repeatValue: 1,
            repeatRule: RepeatRule.EveryXDays,
            parentId: 105,
          )]);
          await MyApp.dataModel.databaseHelper.insertActivity(Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Marketing",
            value: 1000,
            color: Colors.red,
            parentCalendarId: 1010,
            id: 106,
            icon: Icons.web,
          ), scheduleds: [Scheduled(
            isParentTask: false,
            durationInMins: 0,
            repeatValue: 1,
            repeatRule: RepeatRule.EveryXDays,
            parentId: 106,
          )]);
          await MyApp.dataModel.databaseHelper.insertActivity(Activity(
            trackedEnd: [],
            tags: [],
            trackedStart: [],
            valueMultiply: false,
            name: "Business management",
            value: 1000,
            color: Colors.red,
            parentCalendarId: 1010,
            id: 107,
            icon: Icons.pie_chart_outlined,
          ),scheduleds: [Scheduled(
            isParentTask: false,
            durationInMins: 0,
            repeatValue: 1,
            repeatRule: RepeatRule.EveryXDays,
            parentId: 107,
          )]);
          break;
      }
    });

    await MyApp.dataModel.databaseHelper.insertTask(Task(
        parentId: -1,
        value: 10000,
        name: 'Adjust your schedule to your likings in the \'Calendar\' Page',
        valueMultiply: false,
        trackedStart: [],
        tags: [],
        trackedEnd: [],
        isParentCalendar: true,
        checks: [],
        color: Colors.blue,
    ),scheduleds: [Scheduled(
        repeatRule: RepeatRule.None,
        repeatValue: 0,
        durationInMins: 10,
        isParentTask: true,
    )]);
    await MyApp.dataModel.databaseHelper.insertTask(Task(
      parentId: -1,
      value: 10000,
      name: 'Have a look at the metrics page',
      valueMultiply: false,
      trackedStart: [],
      tags: [],
      trackedEnd: [],
      isParentCalendar: true,
      checks: [],
      color: Colors.blue,
    ),scheduleds: [Scheduled(
      repeatRule: RepeatRule.None,
      repeatValue: 0,
      durationInMins: 10,
      isParentTask: true,
    )]);
    await MyApp.dataModel.databaseHelper.insertTask(Task(
      parentId: -1,
      value: 10000,
      name: 'Add your own activities/tasks',
      valueMultiply: false,
      trackedStart: [],
      tags: [],
      trackedEnd: [],
      isParentCalendar: true,
      checks: [],
      color: Colors.blue,
    ),scheduleds:[ Scheduled(
      repeatRule: RepeatRule.None,
      repeatValue: 0,
      durationInMins: 10,
      isParentTask: true,
    )]);
    await MyApp.dataModel.databaseHelper.insertTask(Task(
      parentId: -1,
      value: 10000,
      name: 'Read our encouragement letter(it\'s short believe me)',
      valueMultiply: false,
      trackedStart: [],
      tags: [],
      trackedEnd: [],
      isParentCalendar: true,
      checks: [],
      color: Colors.blue,
      description: 'We are so proud to have you here. But, for the first days, it will be annoying to track your '
          'time. YOU WILL MAKE MISTAKES, YOU WILL FORGET WHEN TO TRACK A NEW ACTIVITY, AND YOU WILL BE POTENTIALLY '
          'PISSED . But that\'s fine, we all make mistakes, and a 15-30 minute mistake won\'t reflect in your metrics'
          ' very much. So be patient with this journey, because on the other side there is unlimited potential for'
          ' your productivityWe addressed this problem by letting you edit the timestamp(do it by pressing on the'
          ' seconds passing or clicking the 3 dots button)'
    ),scheduleds: [Scheduled(
      repeatRule: RepeatRule.None,
      repeatValue: 0,
      durationInMins: 10,
      isParentTask: true,
    )]);
  }

}

enum MainOccupationType{
  NineToFive,Freelance,Business
}
