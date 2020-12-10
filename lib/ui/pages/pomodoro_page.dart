import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/specific/distivity_secondary_item.dart';
import 'package:effectivenezz/ui/widgets/specific/task_list_item.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class PomodoroPage extends StatefulWidget {
  final dynamic object;

  const PomodoroPage({Key key,@required this.object}) : super(key: key);
  @override
  _PomodoroPageState createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.object.color,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                    MyApp.dataModel.isPlaying(widget.object)?CountdownFormatted(
                      duration: Duration(hours: 1),
                      builder: (BuildContext ctx, String remaining) {
                        return GText(remaining,color: getContrastColor(widget.object.color),
                          textType: TextType.textTypeGigant,); // 01:00:00
                      },
                    ):GText("1:00:00",color: getContrastColor(widget.object.color),textType: TextType.textTypeGigant,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GButton(MyApp.dataModel.isPlaying(widget.object)?'Stop':"Start", onPressed: (){
                      setState(() {
                        MyApp.dataModel.setPlaying(context, MyApp.dataModel.currentPlaying!=null?null:widget.object);
                      });
                    }),
                  ),
                  if(!MyApp.dataModel.isPlaying(widget.object))
                    GButton('Exit', onPressed: ()=>Navigator.pop(context)),
                ],
              ),
            ),
            if(widget.object is Activity)Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height/1.7
              ),
              child: SingleChildScrollView(
                child: ExpansionTile(
                  title: Padding(
                    padding: const EdgeInsets.all(7),
                    child: GText('Sub-tasks',textType: TextType.textTypeSubtitle,underline: true),
                  ),
                  children: List<Widget>.generate(widget.object.childs.length, (i){
                    return TaskListItem(task: MyApp.dataModel.tasks[MyApp.dataModel.tasks.indexOf(widget.object.childs[i])],
                      selectedDate: getTodayFormated(),minimal: true,onTap: (){},);
                  },)+<Widget>[ GButton('Add task', onPressed: (){
                    showAddEditObjectBottomSheet(
                      context,
                      isInCalendar: false,
                      selectedDate: getTodayFormated(),
                      isTask: true,
                      add: true,
                      object: Task(
                          name: '',schedules: [],
                          id: Uuid().v4(),
                          trackedEnd: [],
                          trackedStart: [],
                          parentId: widget.object.id,
                          isParentCalendar: false,
                          value: widget.object.value,
                          checks: [],
                          valueMultiply: false,
                          tags: [],
                          color: widget.object.color
                      ),
                    );
                  })],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyApp.dataModel!=null?(MyApp.dataModel.currentPlaying!=null)?DistivitySecondaryItem():null:null,
    );
  }
}
