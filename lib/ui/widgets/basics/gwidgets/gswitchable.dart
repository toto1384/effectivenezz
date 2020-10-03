import 'package:flutter/material.dart';

import 'gtext.dart';

class GSwitchable extends StatelessWidget {


  final String text;
  final bool disabled;
  final bool checked;
  final Function(bool) onCheckedChanged;
  final bool isCheckboxOrSwitch;

  GSwitchable( {@required this. text,this. disabled,@required this. checked,
    @required this. onCheckedChanged, @required this. isCheckboxOrSwitch});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(8),
          child: (isCheckboxOrSwitch?
          Checkbox(
            onChanged: (disabled??false)?null:onCheckedChanged,
            value: checked,
          ):
          Switch(
            onChanged: onCheckedChanged,
            value: checked,
          )),
        ),
        Flexible(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: (GText(text)),
        )),
      ],

    );
  }
}
