

import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DistivityFAB extends StatefulWidget {

  final Map<IconData,Function(BuildContext)> subItems;
  final Function(BuildContext) onTap;
  final Function(Function,Function) controllerLogic;

  const DistivityFAB({Key key,this.subItems,@required this.onTap,@required this.controllerLogic}) : super(key: key);

  @override
  _DistivityFABState createState() => _DistivityFABState();
}

class _DistivityFABState extends State<DistivityFAB> with TickerProviderStateMixin{

  bool extended = false;

  AnimationController animation ;
  AnimationController _hideFabAnimation;

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this,duration: Duration(milliseconds: 100));
    _hideFabAnimation = AnimationController(vsync: this, duration: kThemeAnimationDuration,value: 1);
    widget.controllerLogic(()=>_hideFabAnimation.forward(),()=>_hideFabAnimation.reverse());
  }

  @override
  void dispose() {
    animation.dispose();
    _hideFabAnimation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ScaleTransition(
          alignment: Alignment.bottomCenter,
          scale: _hideFabAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[

              AnimatedOpacity(opacity: extended?1:0,child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate((widget.subItems??{}).length, (i){
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            border:Border.all(color: Colors.white,width: 1),
                            color: MyColors.color_black_darker
                          ),
                          child: IconButton(
                            icon: getIcon(widget.subItems.keys.toList()[i]),
                            onPressed: (){
                              widget.subItems.values.toList()[i](context);
                            },
                          )
                      ),
                    );
                  }),
                ),duration: Duration(milliseconds: 100),),
              Padding(
                padding: const EdgeInsets.all(10),
                child: GestureDetector(
                  onTap: (){
                      if(widget.subItems==null){
                        widget.onTap(context);
                        return;
                      }
                      if(extended){
                        animation.reverse();
                        widget.onTap(context);
                      }else{
                        animation.forward();
                      }
                      setState(() {
                        extended=!extended;
                      });
                    },
                  child: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        border:Border.all(color: Colors.white,width: 2),
                      color: MyColors.color_black_darker
                      ),
                    child: Center(
                        child: AnimatedIcon(
                          progress: animation,
                          icon: AnimatedIcons.add_event,
                        ),
                      ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if(kIsWeb)
          SizedBox(width: 75,)
      ],
    );
  }
}

