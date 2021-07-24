import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ProductHunt extends StatefulWidget {

  @override
  _ProductHuntState createState() => _ProductHuntState();
}

class _ProductHuntState extends State<ProductHunt> {
  bool show=true;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: show,
      child: GestureDetector(
        child: Stack(
          children: [
            Image.network("https://api.producthunt.com/widgets/embed-image/v1/featured.svg?post_id=219333&theme=dark"),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GIcon(Icons.close,size: 14,),
            ),
          ],
        ),
        onTap: (){
          setState(() {
            show=false;
          });
        },
      ),
    );
  }
}
