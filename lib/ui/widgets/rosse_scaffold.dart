import 'package:effectivenezz/ui/widgets/distivity_drawer.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/complex/widget_complex.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class RosseScaffold extends StatefulWidget {

  final Widget appBarWidget;
  final Widget body;
  final String title;
  final Widget trailing;
  final bool backEnabled;
  final Color color;
  final Widget fab;
  final Widget bottomAppBar;
  final double expandedHeight;
  final Key scaffoldKey;
  final bool hideMenu;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final String toolTip;
  final ScrollController scrollController;
//  final Widget subtitle


  RosseScaffold(this.title,{Key key, this.bottomAppBar,this.expandedHeight,
    this.scaffoldKey,this.fab,this.color,this.backEnabled, this.hideMenu, this.appBarWidget,
    @required this.body, this.floatingActionButtonLocation, this.trailing, this.toolTip,
    this.scrollController}):super(key:key);

  @override
  _RosseScaffoldState createState() => _RosseScaffoldState();
}

class _RosseScaffoldState extends State<RosseScaffold> with TickerProviderStateMixin<RosseScaffold> {


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
  

  @override
  Widget build(BuildContext context) {

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
                  icon: getIcon(Icons.menu,),
                  onPressed: () {
                    DistivityPageState.customKey.openDrawer();
                  },
                ):IconButton(
                  icon: getIcon(Icons.chevron_left,color: Colors.white),
                  onPressed: ()=>Navigator.pop(context),
                ),
              ),
              actions: <Widget>[
                widget.trailing??Center()
              ],
              expandedHeight: widget.expandedHeight??100,
              floating: true,
              backgroundColor: Colors.transparent,
              flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  collapseMode: CollapseMode.parallax,
                  title: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getText(widget.title,textType: TextType.textTypeSubtitle,maxLines: 3,isCentered: true),
                      Visibility(child: getInfoIcon(context, widget.toolTip),
                        visible: widget.toolTip != null,),
                    ],
                  ),
                  background: Stack(
                    children: <Widget>[
                      Center(child: widget.appBarWidget)
                    ],
                  )
              ),
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

}