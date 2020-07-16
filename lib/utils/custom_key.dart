

import 'package:effectivenezz/utils/distivity_page.dart';

class CustomKey{

  Function openDrawer;
  Function closeDrawer;
  String pageName;

  CustomKey(DistivityPageState page){
    openDrawer=page.openDrawer;
    pageName=page.getPageName();
    closeDrawer=page.closeDrawer;
  }

}