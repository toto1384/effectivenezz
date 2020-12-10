// import 'package:effectivenezz/ui/pages/quick_start_page.dart';
// import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
// import 'package:effectivenezz/ui/widgets/basics/gwidgets/gicon.dart';
// import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
// import 'package:effectivenezz/utils/basic/overflows_basic.dart';
// import 'package:effectivenezz/utils/basic/utils.dart';
// import 'package:flutter/material.dart';
//
// import '../../../../main.dart';
//
// class GSaveToDriveListTile extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: GIcon(Icons.save),
//       title: GText('Save to Drive'),
//       onTap: ()async{
//         if(MyApp.dataModel.driveHelper.currentUser==null){
//           launchPage(context, QuickStartPage(MyApp.dataModel.driveHelper));
//         }else{
//           await MyApp.dataModel.driveHelper.uploadFile(context);
//           showDistivityDialog(context, actions: [GButton('Close', onPressed: ()=>Navigator.pop(context))], title: 'Saved', stateGetter: (ctx,ss){
//             return GText('Your calendars and your events are uploaded to Drive');
//           });
//         }
//       },
//     );
//   }
// }
