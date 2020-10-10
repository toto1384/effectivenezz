import 'package:countdown_flutter/countdown_flutter.dart';
import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/specific/distivity_secondary_item.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:flutter/material.dart';

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
                  MyApp.dataModel.setPlaying(context, MyApp.dataModel.isPlaying(widget.object)?null:widget.object);
                });
              }),
            ),
            if(!MyApp.dataModel.isPlaying(widget.object))
              GButton('Exit', onPressed: ()=>Navigator.pop(context))
          ],
        ),
      ),
      bottomNavigationBar: MyApp.dataModel!=null?(MyApp.dataModel.currentPlaying!=null)?DistivitySecondaryItem():null:null,
    );
  }
}
