import 'package:effectivenezz/objects/activity.dart';
import 'package:effectivenezz/objects/task.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/specific/distivity_animated_list_obj.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/complex/overflows_complex.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class GSortByMoneyTasksAndActivities extends StatefulWidget {

  final ScrollController controller;
  final DateTime selectedDate;
  final bool areMinimal;
  final Function(dynamic) onSelected;
  final bool scrollable;
  final WhatToShow whatToShow;

  GSortByMoneyTasksAndActivities(this. controller,
      this. selectedDate,{this. areMinimal,this. onSelected, this. scrollable, this.whatToShow});

  @override
  _GSortByMoneyTasksAndActivitiesState createState() => _GSortByMoneyTasksAndActivitiesState();
}

class _GSortByMoneyTasksAndActivitiesState extends State<GSortByMoneyTasksAndActivities> {

  bool showing = false;


  @override
  Widget build(BuildContext context) {
    return DistivityAnimatedListObj(
      scrollable: widget.scrollable,
      onSelected: widget.onSelected,
      getHeader: (ctx,ind){
        return Container(
          child: Row(
            children: <Widget>[
              getSubtitle("\$${formatDouble(figures(15-ind.toDouble()))}"),
            ],
          ), color: MyColors.color_black_darker,
        );
      },
      additionalButton: Container(
        width: MediaQuery.of(context).size.width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: GButton(showing?'Hide low value entries':'Show low value entries', onPressed: (){
              if(showing==true){
                setState((){
                  showing=false;
                });
                return;
              }
              showDistivityDialog(context, actions: [
                GButton('Show', onPressed: (){
                  setState((){
                    showing=!showing;
                  });
                  Navigator.pop(context);
                },variant: 2),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GButton('Return to excellence', onPressed: ()=>Navigator.pop(context)),
                ),
              ], title: 'Show low value entries?', stateGetter: (ctx,ss){
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GText('Below 0\$ activities will only make you feel good and will not make you happy. Time for yourself'
                        ' should be about your relatives, journaling, reading, exercising and meditation. These will actually make '
                        'you happy. \n Watch this video, it explains this concept better'),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height/3),
                        child: YoutubePlayer(
                          controller: YoutubePlayerController(
                              initialVideoId: 'u_zMDLQgFrM',
                              flags: YoutubePlayerFlags(
                                  autoPlay: false
                              )
                          ),

                        ),
                      ),
                    ),
                  ],
                );
              });
            }),
          ),
        ),
      ),
      getHeaderSelectedDate: (ind){
        return [widget.selectedDate];
      },
      headerItemCount: showing?15:9,
      isObjectSuitableForHeader: (item, ind){
        if(item is Task && (widget.whatToShow??WhatToShow.All)==WhatToShow.Activities)return false;
        if(item is Activity && (widget.whatToShow??WhatToShow.All)==WhatToShow.Tasks)return false;
        if(item.value == figures(15.0-ind.toDouble()).toInt()){
          return true;
        }return false;
      },
      whatToShow: widget.whatToShow??WhatToShow.All,
      areMinimal: widget.areMinimal,
      scrollController: widget.controller,
    );
  }
}
