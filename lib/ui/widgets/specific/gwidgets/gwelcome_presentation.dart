import 'package:effectivenezz/utils/basic/values_utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:flutter/material.dart';

class GWelcomePresentation extends StatelessWidget {

  final int currentPage;
  final List<String> assetPaths;
  final List<String> texts;
  final Function(int) onPageChanged;

  GWelcomePresentation(this. currentPage,
      {@required this. assetPaths, @required this. texts, @required this. onPageChanged});

  final PageController pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10),
          child: Container(
            height: 450,
            child: PageView(
              onPageChanged: onPageChanged,
              children: List<Widget>.generate(assetPaths.length, (index) =>
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Image.asset(
                          assetPaths[index], width: 300, height: 300,),
                      ),
                      getSubtitle(texts[index],),
                    ],
                  )),
              controller: pageController,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List<Widget>.generate(assetPaths.length, (index) =>
              Padding(
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  backgroundColor: index == currentPage ? MyColors
                      .color_yellow : MyColors.color_gray_lighter,
                  radius: 5,),
              )),
        ),

      ],
    );
  }
}
