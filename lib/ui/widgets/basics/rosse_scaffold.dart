import 'package:after_layout/after_layout.dart';
import 'package:effectivenezz/ui/widgets/specific/gwidgets/ginfo_icon.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'distivity_drawer.dart';
import 'gwidgets/gicon.dart';

class RosseScaffold extends StatefulWidget {

  final Widget appBarWidget;
  final Widget body;
  final String title;
  final Widget trailing;
  final bool backEnabled;
  final Color color;
  final Widget fab;
  final Widget bottomAppBar;
  final Key scaffoldKey;
  final bool hideMenu;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final String toolTip;
  final ScrollController scrollController;
//  final Widget subtitle


  RosseScaffold(this.title,{Key key, this.bottomAppBar,
    this.scaffoldKey,this.fab,this.color,this.backEnabled, this.hideMenu, this.appBarWidget,
    @required this.body, this.floatingActionButtonLocation, this.trailing, this.toolTip,
    this.scrollController}):super(key:key);

  @override
  _RosseScaffoldState createState() => _RosseScaffoldState();
}

class _RosseScaffoldState extends State<RosseScaffold> with AfterLayoutMixin,TickerProviderStateMixin {


  @override
  initState() {
    super.initState();
    _hideFabAnimation = AnimationController(vsync: this, duration: kThemeAnimationDuration,value: 1);
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
    return getSmallScreen();
  }

  bool showFab = true;
  AnimationController _hideFabAnimation;

  getSmallScreen(){

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(0),
          child: AppBar( // Here we create one to set status bar color
            brightness: Brightness.dark,
            backgroundColor: Colors.transparent,// Set any color of status bar you want; or it defaults to your theme's primary color
          )
      ),
      key: widget.scaffoldKey,
      drawer: DistivityDrawer(),
      backgroundColor: widget.color??MyColors.color_black,
      floatingActionButtonLocation: widget.floatingActionButtonLocation??FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ScaleTransition(
          scale: _hideFabAnimation,
          alignment: Alignment.bottomCenter,
          child: widget.fab??Container(),
      ),
      body: NotificationListener<ScrollNotification>(
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
                  decoration: BoxDecoration(color: MyColors.color_black_darker,borderRadius: BorderRadius.only(topRight: Radius.circular(15),topLeft: Radius.circular(15))),
                  child: widget.body
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: widget.bottomAppBar,
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    setState(() {
      size=key.currentContext.size;
    });
  }

}