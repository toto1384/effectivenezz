import 'package:effectivenezz/data/iap.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_drawer.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/grich_text.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gswitchable.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/ui/widgets/basics/rosse_scaffold.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gapp_bar.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/gtab_bar.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../main.dart';
import '../../utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';

class IAPScreen extends StatefulWidget {

  IAPScreen({Key key}) : super(key: key);

  @override
  _IAPScreenState createState() => _IAPScreenState();
}

class _IAPScreenState extends DistivityPageState<IAPScreen> {


  YoutubePlayerController controller = YoutubePlayerController(
      initialVideoId: 'fPEYrpma4Ew',
      flags: YoutubePlayerFlags(
        autoPlay: false,
      )
  );

  int selected = 0;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  bool yearly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: DistivityDrawer(),
      appBar: GAppBar('Save weeks, months, years',backEnabled: true,smallSubtitle: false,
          subtitle: GTabBar(items: ['Plans', 'FAQ', 'Why I built it?'], selected: [selected],
              onSelected: (sel,b){
                if(sel==1){
                  launch('https://effectivenezz.com/faq/');
                }else if(b)setState(() {
                  if(sel==2){
                    selected=sel;
                  }else{
                    selected=sel;
                  }
                });
              })),
      body: selected==0?SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 15,right: 15,top: 20,bottom: 15),
              child: GText('Save years of your life wasted on useless activities. Fits easily in the budget of those who value their time and their money.'),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Card(
                  shape: getShape(subtleBorder: true),
                  elevation: 0,
                  color: Colors.transparent,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(child: GText('The \'Effective Executive\'',textType: TextType.textTypeTitle,isCentered: true)),
                        getSubtitle('What you get?'),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: YoutubePlayer(controller: controller,width: MyApp.dataModel.screenWidth/1.5,)),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 15),
                          child: GText('• THE RIGHT metrics\n• \$ Value your time\n• Powerful Calendar\n• “Compare what you’ve planned last night to what you’ve done today”\n• (Work in Progress) Time Doctor - AI based time analyzer'),
                        ),
                        GSwitchable(
                            text: 'Yearly plan(35% off)',
                            checked: yearly,
                            onCheckedChanged: (isYearly){
                              setState(() {
                                yearly=isYearly;
                              });
                            }, isCheckboxOrSwitch: false),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: GRichText([
                            yearly?'79.99\$/y':'9.99\$/m',
                            if(yearly)
                              '\n6.58\$/m'
                          ], [
                            TextType.textTypeGigant,
                            if(yearly)
                              TextType.textTypeTitle
                          ]),),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: FloatingActionButton.extended(
                              heroTag: null,
                              onPressed: ()=>MyApp.dataModel.driveHelper.iapHelper.purchase(context,PackageType.Pro,yearly),
                              label: GText('Start 14 day free trial :))'),
                              icon: GIcon(Icons.play_arrow),
                              backgroundColor: MyColors.color_black_darker,
                              shape: getShape(subtleBorder: true),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ):ListView(
        shrinkWrap: true,
        children: [
          Center(child: getSubtitle('Alexandru Totolici, CEO')),
          Padding(
            padding: const EdgeInsets.only(top: 20,left: 15,right: 15),
            child: GText('About 6 months ago I was watching a video by Nathaniel Drew, who tried tracking his time for 7 days. At the end of the experiment, I(and he too) was blown away by how chaotic his day was. This amazed me. We all think of ourselves as productivity machines, but even in our best days our outputs aren’t that high. So I wanted to make time tracking and time managing an easy thing to do by anyone'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: ()=>MyApp.dataModel.launchFeedback(context),
        label: GText('Chat with us!'),
        shape: getShape(subtleBorder: true),
        backgroundColor: MyColors.color_black_darker,
        icon: GIcon(Icons.chat),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}