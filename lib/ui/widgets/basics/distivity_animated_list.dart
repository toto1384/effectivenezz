import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/distivity_page.dart';
import 'package:flutter/cupertino.dart';


typedef IsObjectSuitableForList = bool Function(dynamic object);
typedef OnUpdate = bool Function(dynamic object,int index);
typedef GetObjectIndexInTheList = int Function(dynamic object);
typedef OnRemoveItemBuilder = Widget Function(dynamic object,Animation<double> duration);

class DistivityAnimatedList extends StatefulWidget {
  final ScrollController scrollController;
  final ScrollPhysics scrollPhysics;

  final OnUpdate onUpdate;
  final  IsObjectSuitableForList isObjectSuitableForList;
  final GetObjectIndexInTheList getObjectIndexInTheList;
  final GetObjectIndexInTheList onAdd;
  final Function(dynamic,int) onRemove;
  final OnRemoveItemBuilder animatedListRemovedItemBuilder;
  final int initialItemCount;
  final AnimatedListItemBuilder animatedListItemBuilder;

  const DistivityAnimatedList({
    Key key,this.scrollController, @required this.onUpdate,@required this.isObjectSuitableForList,
    @required this.getObjectIndexInTheList,@required this.onAdd,@required this.onRemove,
    @required this.animatedListRemovedItemBuilder, this.scrollPhysics,@required this.initialItemCount,
    @required this.animatedListItemBuilder,}) : super(key: key);

  @override
  DistivityAnimatedListState createState() => DistivityAnimatedListState();
}

class DistivityAnimatedListState extends State<DistivityAnimatedList> {

  GlobalKey<AnimatedListState> key = GlobalKey();
  dynamic removedObject;

  Duration duration = Duration(milliseconds: 500);

  onRemove(dynamic object){
    int index= widget.getObjectIndexInTheList(object);
    if(index>=0){
      widget.onRemove(object,index);
      key.currentState.removeItem(index, (context, animation) =>
          widget.animatedListRemovedItemBuilder(object,animation));
    }
  }

  onAdd(dynamic object){
    print('ON ADD PREPARING TO ADD');
    int index = widget.onAdd(object);
    print('ON ADD FINISHED ADDING');
    if(index>=0)key.currentState.insertItem(index,duration: duration);
    print('ON ADD NOTIFY LIST');
  }

  onUpdate(dynamic object){
    int index = widget.getObjectIndexInTheList(object);
    if(index>=0){
      widget.onUpdate(object,index);
      if(!widget.isObjectSuitableForList(object)){
        DistivityPageState.listCallback.notifyRemoved(object);
        DistivityPageState.listCallback.notifyAdd(object);
      }
    }
  }

  bool initedCallback = false;

  @override
  void initState() {
    if(!initedCallback){
      DistivityPageState.listCallback.listen((obj,cud ){
        if(key.currentState==null||obj==null)return;
        if(cud==CUD.Create){
          onAdd(obj);
        }else if(cud==CUD.Delete){
          removedObject=obj;
          onRemove(obj);
        }else if(cud==CUD.Update){
          onUpdate(obj);
        }
      });
      initedCallback=true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedList(
      controller: widget.scrollController,
      shrinkWrap: true,
      physics: widget.scrollPhysics,
      initialItemCount: widget.initialItemCount,
      itemBuilder: widget.animatedListItemBuilder,
      key: key,

    );
  }
}

