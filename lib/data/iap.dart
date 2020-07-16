import 'package:effectivenezz/ui/pages/track_page.dart';
import 'package:effectivenezz/ui/widgets/distivity_restart_widget.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../main.dart';

class IAPHelper{


  static Future<IAPHelper> init(BuildContext context,String id) async {
    if(!kIsWeb){
      await Purchases.setDebugLogsEnabled(true);
      await Purchases.setup("NhStgtRStPcvQuPQvlLIjuoIaSyKSrDB",appUserId: id);

      Purchases.addPurchaserInfoUpdateListener((purchaserInfo){
      });
    }

    return IAPHelper();
  }

  purchase(BuildContext buildContext,PackageType packageType,bool anual)async{
    if(!kIsWeb){
      Package package;
      switch(packageType){

        case PackageType.Pro:
          Offering offering =(await getOfferings())['Default'];
          package=anual?offering.annual:offering.monthly;
          break;
      }

      try {
        if (package != null) {
          try {
            await Purchases.purchasePackage(package);
            MyApp.dataModel=null;
            DistivityRestartWidget.restartApp(buildContext);
          } on PlatformException catch (e) {
            var errorCode = PurchasesErrorHelper.getErrorCode(e);
            if (errorCode != PurchasesErrorCode.purchaseCancelledError) {
              //show error
            }
          }
        }
      } on PlatformException catch (e) {
        // optional error handling
        print('purchase error $e');
      }
    }
  }

  Future<bool> isSubscriptionActive()async{
    if(kIsWeb)return true;
    try {
      PurchaserInfo purchaserInfo = await Purchases.getPurchaserInfo();
//      purchaserInfo.entitlements.all.forEach((key, value) {
//        print('$key ${value.identifier} ${value.isActive}');
//      });
      if (purchaserInfo.activeSubscriptions.length>0) {
        return true;
      }
    } on PlatformException catch (e) {
      // Error fetching purchaser info
      print('is subscription active error $e');
    }
    return false;
  }

  Future<Map<String,Offering>> getOfferings()async{
    if(kIsWeb)return {};
    try {
      Offerings offerings = await Purchases.getOfferings();
      if (offerings.current != null) {
        return offerings.all;
      }
    } on PlatformException catch (e) {
      // optional error handling
    }
    return {};
  }




}

enum PackageType{
  Pro
}