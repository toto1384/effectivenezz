import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:flutter/material.dart';

class GInfoIcon extends StatelessWidget {


  final GlobalKey key = GlobalKey();

  final String message;
  final String name;

  GInfoIcon(this. message, {this. name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        RenderBox box = key.currentContext.findRenderObject();
        Offset position = box.localToGlobal(Offset(0, 50));
        showMenu(context: context,
            position: RelativeRect.fromLTRB(
                position.dx, position.dy, position.dx, 0),
            items: [
              PopupMenuItem(
                child: GText(message??''),
              ),
            ],
            shape: getShape(subtleBorder: false),
            color: MyColors.color_gray_lighter);
      },
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GIcon(Icons.info_outline, color: MyColors.getHelpColor(), size: 20),
            Visibility(
                visible: name != null,
                child: GText(name??'', color: MyColors.getHelpColor(),
                    textType: TextType.textTypeSubNormal)
            )
          ],
        ),
      ),
    );
  }
}
