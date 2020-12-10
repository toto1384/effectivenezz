import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gmax_web_width.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';


class GScaffold extends Scaffold {

  final Widget body;
  final PreferredSizeWidget appBar;
  final GlobalKey<ScaffoldState> key;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final Widget drawer;
  final Color backgroundColor;
  final Widget bottomNavigationBar;

  const GScaffold({this.body, this.appBar, this.floatingActionButton,
    this.floatingActionButtonLocation, this.drawer, this.backgroundColor, this.bottomNavigationBar, this.key}):super(key: key);

  @override
  GScaffoldState createState() => GScaffoldState();
}

class GScaffoldState extends ScaffoldState {

  GlobalKey<ScaffoldState> localKey = GlobalKey();

  static bool show = true;

  static DeviceScreenType deviceScreenType = DeviceScreenType.mobile;

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (ctx,b){
        deviceScreenType=b.deviceScreenType;
        switch(b.deviceScreenType){
          case DeviceScreenType.mobile:
            return Scaffold(
              key: localKey,
              bottomNavigationBar: widget.bottomNavigationBar,
              backgroundColor: widget.backgroundColor,
              body: widget.body,
              appBar: widget.appBar,
              floatingActionButton: widget.floatingActionButton,
              floatingActionButtonLocation: widget.floatingActionButtonLocation,
              drawer: widget.drawer,
            );
            break;
          case DeviceScreenType.tablet:
          case DeviceScreenType.desktop:
            return Scaffold(
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: AppBar( // Here we create one to set status bar color
                    brightness: Brightness.dark,
                    backgroundColor: Colors.transparent,// Set any color of status bar you want; or it defaults to your theme's primary color
                  )
              ),
              key: localKey,
              bottomNavigationBar: widget.bottomNavigationBar,
              backgroundColor: widget.backgroundColor,
              body: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if(widget.drawer!=null)AnimatedSwitcher(
                    child: show?widget.drawer:Container(),
                    duration: Duration(milliseconds: 100),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Center(
                        child: GMaxWebWidth(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              if(widget.appBar!=null)Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: widget.appBar,
                              ),
                              Expanded(child: widget.body),
                            ],
                          )
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              floatingActionButton: widget.floatingActionButton,
              floatingActionButtonLocation: widget.floatingActionButtonLocation,
            );
            break;
          case DeviceScreenType.watch:
            return Container();
            break;
          default:return Container();
        }
      },
    );
  }

  @override
  void openDrawer() {
    if(deviceScreenType==DeviceScreenType.mobile){
      localKey.currentState.openDrawer();
    }else{
      setState(() {
        show=!show;
      });
    }
  }
}
