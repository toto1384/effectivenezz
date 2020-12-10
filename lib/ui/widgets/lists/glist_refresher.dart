import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../main.dart';

class GListRefresher extends StatefulWidget {

  final Widget child;

  const GListRefresher({Key key,@required this.child}) : super(key: key);

  @override
  _GListRefresherState createState() => _GListRefresherState();
}

class _GListRefresherState extends State<GListRefresher> {
  RefreshController refreshController = RefreshController();
  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      header: CustomHeader(
        refreshStyle: RefreshStyle.Behind,
        height: 50,
        builder: (c,mode){
          return Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GText(
                    mode==RefreshStatus.refreshing?"Refreshing":mode==RefreshStatus.completed?"Completed":"Pull to refresh",
                    textType: TextType.textTypeSubtitle,
                  ),
                ),
                Container(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(value: mode==RefreshStatus.refreshing?null:1,)
                ),
              ],
            ),
          );
        },
      ),
      controller: refreshController,
      onRefresh: ()async{
        MyApp.dataModel.scheduleds= await MyApp.dataModel.backend.scheduled(context,RequestType.Query);
        MyApp.dataModel.tasks=await MyApp.dataModel.backend.task(context,RequestType.Query);
        MyApp.dataModel.activities = await MyApp.dataModel.backend.activity(context,RequestType.Query);
        MyApp.dataModel.tasks.forEach((element) {
          if(!element.isParentCalendar){
            MyApp.dataModel.activities.forEach((act) {
              if(act.id==element.parentId){
                act.childs.add(element);
              }
            });
          }
        });
        MyApp.dataModel.populatePlaying();
        MyAppState.ss(context);
        refreshController.refreshCompleted();
      },
      child: widget.child,

    );
  }
}
