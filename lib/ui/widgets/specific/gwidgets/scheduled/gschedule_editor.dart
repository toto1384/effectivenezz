
import 'package:effectivenezz/objects/scheduled.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ginfo_icon.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/scheduled/gduration_widget_for_scheduled.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/scheduled/grepeat_editor.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'gdate_time_edit_widget_for_scheduled.dart';

class GScheduleEditor extends StatefulWidget {

  final List<Scheduled> scheduled;
  final Function(Scheduled) onScheduledChange;
  final Function(Scheduled) onScheduledDeleted;
  final Function() onScheduledAdded;
  final bool isInCalendar;

  GScheduleEditor(this. scheduled, this. onScheduledChange,
      {@required this.isInCalendar,@required this.onScheduledAdded,@required this.onScheduledDeleted});

  @override
  _GScheduleEditorState createState() => _GScheduleEditorState();
}

class _GScheduleEditorState extends State<GScheduleEditor>{

  double height;
  GlobalKey stackKey = GlobalKey();

  void _afterLayout(d) {
    final RenderBox renderBoxRed = stackKey.currentContext.findRenderObject();
    final sizeRed = renderBoxRed.size;
    setState(() {
      height = sizeRed.height;
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(_afterLayout);
    super.initState();
  }

  int index = 0;

  @override
  Widget build(BuildContext context) {

    Widget firstElement;
    if (height == null) {
      firstElement = Container();
    } else {
      firstElement = Container(
        height: height+20,
        child: PageView.builder(
          onPageChanged: (i){
            setState(() {
              index = i;
            });
          },
          itemCount: widget.scheduled.length,
          itemBuilder: (ctx,i){
            if(widget.onScheduledChange is Function){
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //starts
                    GDateTimeEditWidgetForScheduled( onScheduledChange: widget.onScheduledChange,
                        scheduled: widget.scheduled[i], isStartTime: true),
                    widget.isInCalendar?(GDateTimeEditWidgetForScheduled(
                      isStartTime: false,
                      onScheduledChange: widget.onScheduledChange,
                      scheduled: widget.scheduled[i],
                    )):(GDurationWidgetForScheduled( scheduled: widget.scheduled[i],
                      onScheduledChange: widget.onScheduledChange,)),
                    GRepeatEditor( widget.scheduled[i], (sc){
                      setState((){
                        widget.scheduled[i].repeatRule=sc.repeatRule;
                        widget.scheduled[i].repeatUntil=sc.repeatUntil;
                        widget.scheduled[i].repeatValue=sc.repeatValue;
                      });
                    }),
                  ],
                ),
              );
            }else return Container();
          },
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GText('Schedule on: ${widget.scheduled[index].isOverdue()?'(overdue)':""}'
                      '(${index+1}/${widget.scheduled.length})',textType: TextType.textTypeSubtitle,),
                  GInfoIcon('Unlike other apps, events(activities and tasks) can be scheduled multiple times for easy time boxing'
                      '(it\'s easier to do this directly in the calendar)'),
                ],
              ),
              IconButton(
                icon: GIcon(Icons.more_vert),
                onPressed: (){
                  showDistivityModalBottomSheet(context, (ctx,ss){
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          title: GText('New schedule'),
                          leading: GIcon(Icons.add),
                          onTap: (){
                            widget.onScheduledAdded();
                            Navigator.pop(context);
                          },
                        ),
                        ListTile(
                          title: GText('Delete this schedule'),
                          leading: GIcon(Icons.delete),
                          onTap: (){
                            widget.onScheduledDeleted(widget.scheduled[index]);
                          },
                        )
                      ],
                    );
                  });
                },
              )
            ],
          ),
        ),
        IndexedStack(
          key: stackKey,
          children: <Widget>[
            firstElement,
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //starts
                  GText(widget.scheduled[0].parentId.toString()+widget.scheduled[0].isParentTask.toString()),
                  GDateTimeEditWidgetForScheduled( onScheduledChange: widget.onScheduledChange,
                      scheduled: widget.scheduled[0], isStartTime: true),
                  widget.isInCalendar?(GDateTimeEditWidgetForScheduled(
                    isStartTime: false,
                    onScheduledChange: widget.onScheduledChange,
                    scheduled: widget.scheduled[0],
                  )):(GDurationWidgetForScheduled( scheduled: widget.scheduled[0],
                    onScheduledChange: widget.onScheduledChange,)),
                  GRepeatEditor( widget.scheduled[0], (sc){
                    setState((){
                      widget.scheduled[0].repeatRule=sc.repeatRule;
                      widget.scheduled[0].repeatUntil=sc.repeatUntil;
                      widget.scheduled[0].repeatValue=sc.repeatValue;
                    });
                  }),
                ],
              ),
            )
          ],
        ),
        Container(
          height: 10,
          child: ListView.builder(itemBuilder: (ctx,i){
            return Icon(
              widget.scheduled[i].isOverdue()?Icons.close:Icons.circle,
              size: 7,color: index==i?Colors.white:Colors.grey,
            );
          },itemCount:widget.scheduled.length,shrinkWrap: true,scrollDirection: Axis.horizontal,),
        ),
      ],
    );
  }
}
