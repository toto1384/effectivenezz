import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:flutter/material.dart';

import 'gtext.dart';

class GSelector<T> extends StatelessWidget {

  final T currentValue;
  final List<T> values;
  final Function(T) getName;
  final Function(T) onSelect;
  final TextType textType;
  final Widget bottomWidget;

  const GSelector({Key key,@required this.currentValue,@required this.values,
    this.getName,@required this.onSelect, this.textType, this.bottomWidget}) : super(key: key);

  getname(T val){
    if(val==null)return "No ${T.toString()}";
    if(getName==null){
      return val.toString();
    }else return getName(val);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: GText(getname(currentValue)+' ▼',textType: textType,),
      onTap: (){
        showDistivityModalBottomSheet(context, (ctx,ss,c){
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[Padding(
              padding: const EdgeInsets.all(8.0),
              child: GText("Select ${T.toString()}",textType: TextType.textTypeTitle,),
            )]+List<Widget>.generate(values.length, (index) => ListTile(
              title: GText(getname(values[index])),
              onTap: (){
                onSelect(values[index]);
                Navigator.pop(context);
              },
            ))+(bottomWidget!=null?[Divider(),bottomWidget]:[]),
          );
        });
      },
    );
  }
}
