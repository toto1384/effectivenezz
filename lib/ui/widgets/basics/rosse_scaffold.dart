import 'package:effectivenezz/ui/widgets/specific/gwidgets/ginfo_icon.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'gwidgets/gicon.dart';

class RosseSilver extends StatefulWidget {

  final Widget appBarWidget;
  final Widget body;
  final String title;
  final Widget trailing;
  final bool backEnabled;
  final Color color;
  final bool hideMenu;
  final String toolTip;
  final ScrollController scrollController;
//  final Widget subtitle


  RosseSilver(this.title,{Key key,
    this.color,this.backEnabled, this.hideMenu, this.appBarWidget,
    @required this.body,  this.trailing, this.toolTip,
    this.scrollController}):super(key:key);

  @override
  RosseSilverState createState() => RosseSilverState();
}

class RosseSilverState extends State<RosseSilver> with TickerProviderStateMixin {


  @override
  initState() {
    super.initState();
    _hideFabAnimation = AnimationController(vsync: this, duration: kThemeAnimationDuration,value: 1);
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {
        size=key.currentContext.size;
      });
    });
  }

  @override
  void dispose() {
    _hideFabAnimation.dispose();
    super.dispose();
  }

  Container appBar ;
  GlobalKey key = GlobalKey();
  Size size = Size(0,100);

  @override
  Widget build(BuildContext context) {
    appBar= Container(
      key: key,
      child: widget.appBarWidget,
    );
    return NotificationListener<ScrollNotification>(
      onNotification: (notification){
        if (notification.depth == 0) {
          if (notification is UserScrollNotification) {
            final UserScrollNotification userScroll = notification;
            switch (userScroll.direction) {
              case ScrollDirection.forward:
                _hideFabAnimation.forward();
                break;
              case ScrollDirection.reverse:
                _hideFabAnimation.reverse();
                break;
              case ScrollDirection.idle:
                break;
            }
          }
        }
        return false;
      },
      child: CustomScrollView(
        controller: widget.scrollController,
        shrinkWrap: true,
        slivers: [
          SliverAppBar(
            leading: Visibility(
              visible: !(widget.hideMenu??false),
              child: !(widget.backEnabled??false)?IconButton(
                icon: GIcon(Icons.menu,),
                onPressed: () {
                  DistivityPageState.customKey.openDrawer();
                },
              ):IconButton(
                icon: GIcon(Icons.chevron_left,color: Colors.white),
                onPressed: ()=>Navigator.pop(context),
              ),
            ),
            actions: <Widget>[
              widget.trailing??Center()
            ],
//              expandedHeight: widget.expandedHeight??100,
            floating: true,
            backgroundColor: Colors.transparent,
            flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    getSubtitle(widget.title),
                    Visibility(child: GInfoIcon( widget.toolTip),
                      visible: widget.toolTip != null,),
                  ],
                ),
                background: Stack(
                  children: <Widget>[
                    Center(child: appBar)
                  ],
                )
            ),
            expandedHeight: size.height+(widget.title==""?100:200),
          ),
          SliverToBoxAdapter(
            child: Container(
                decoration: BoxDecoration(color: MyColors.color_black,borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))),
                child: widget.body
            ),
          )
        ],
      ),
    );
  }

  bool showFab = true;
  AnimationController _hideFabAnimation;

}