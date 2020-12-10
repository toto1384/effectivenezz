import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:flutter/material.dart';

class GTabBar extends StatelessWidget {

  final List<String> items;
  final List<int> selected;
  final Function(int,bool) onSelected;
  final int variant ;

  GTabBar({@required this. items, @required this. selected, this. onSelected,this. variant=1});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(items.length, (index) {
          bool isSelected = selected.contains(index);
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: (
                GButton(
                  items[index],
                  variant: isSelected ? 1 : variant==1?3:2,
                  onPressed: () {
                    onSelected(index, !isSelected);
                  },
                )
            ),
          );
        }),
      ),
    );
  }
}
