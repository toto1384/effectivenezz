import 'package:effectivenezz/ui/widgets/specific/gwidgets/ui/gscaffold.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GMaxWebWidth extends StatefulWidget {
  final Widget child;

  const GMaxWebWidth({Key key,@required this.child}) : super(key: key);

  @override
  _GMaxWebWidthState createState() => _GMaxWebWidthState();
}

class _GMaxWebWidthState extends State<GMaxWebWidth> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child : widget.child,
        constraints: kIsWeb?BoxConstraints(maxWidth: ((MediaQuery.of(context).size.height+
            (GScaffoldState.show?200:400)))):null,
      ),
    );
  }
}
