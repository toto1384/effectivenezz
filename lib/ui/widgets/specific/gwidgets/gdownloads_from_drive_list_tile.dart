// import 'package:effectivenezz/ui/pages/quick_start_page.dart';
// import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
// import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
// import 'package:effectivenezz/utils/basic/utils.dart';
// import 'package:effectivenezz/utils/complex/overflows_complex.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../main.dart';
//
// class GDownloadsFromDriveListTile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: GIcon(Icons.cloud_download),
//       title: GText("Download from Drive saves"),
//       onTap: (){
//         if(MyApp.dataModel.driveHelper.currentUser==null){
//           launchPage(context, QuickStartPage(MyApp.dataModel.driveHelper));
//         }else showAllDriveSavesBottomSheet(context);
//       },
//     );
//   }
// }
