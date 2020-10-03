import 'package:effectivenezz/ui/widgets/basics/platform_svg.dart';
import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:flutter/material.dart';

class GEmptyView extends StatelessWidget {


  final String text;

  GEmptyView(this.text);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 50, maxHeight: MediaQuery.of(context).size.width - 50),
                  child: PlatformSvg.asset(AssetsPath.emptyView)
              ),
              getSubtitle(text),
            ],
          ),
        ),
      ),
    );
  }
}
