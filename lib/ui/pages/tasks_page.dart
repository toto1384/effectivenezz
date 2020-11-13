import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_drawer.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gapp_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gscaffold.dart';
import 'package:effectivenezz/ui/widgets/specific/task_list_item.dart';
import 'package:effectivenezz/utils/basic/date_basic.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';

class TasksPage extends StatefulWidget {
  @override
  _TasksPageState createState() => _TasksPageState();
}

class _TasksPageState extends DistivityPageState<TasksPage> {


  List<Task> undoneTasks = [];

  @override
  void initState() {
    if(undoneTasks.length==0){
      MyApp.dataModel.tasks.forEach((element) {
        if(!element.isCheckedOnDate(getTodayFormated())){
          undoneTasks.add(element);
        }
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GScaffold(
      key: scaffoldKey,
      appBar: GAppBar(
        'Tasks to do',
        drawerEnabled: true,
      ),
      drawer: DistivityDrawer(),
      body: ListView.builder(itemBuilder: (ctx,i){
        return TaskListItem(task: undoneTasks[i], selectedDate: getTodayFormated(),);
      },itemCount: undoneTasks.length,),
      floatingActionButton: FloatingActionButton(
        onPressed: ()=>showAddEditObjectBottomSheet(
          context,isInCalendar: false,
          selectedDate: getTodayFormated(),
          isTask: true,
        ),
        child: GIcon(Icons.add,color: MyColors.color_black_darker,),
      ),
    );
  }
}
