import 'package:effectivenezz/ui/widgets/distivity_restart_widget.dart';
import 'package:firebase_remote_config_hybrid/firebase_remote_config_hybrid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../main.dart';

class IAPHelper{


  final FirebaseRemoteConfig remoteConfig;

  IAPHelper(this.remoteConfig);



  static Future<IAPHelper> init(BuildContext context,String id) async {
    if(!kIsWeb){
      await Purchases.setDebugLogsEnabled(true);
      await Purchases.setup("NhStgtRStPcvQuPQvlLIjuoIaSyKSrDB",appUserId: id);

      Purchases.addPurchaserInfoUpdateListener((purchaserInfo){
      });
    }
    print(11);
    IAPHelper iapHelper = IAPHelper(await FirebaseRemoteConfig.instance);

    print(12);
    await iapHelper.remoteConfig.fetch();
    print(13);
    await iapHelper.remoteConfig.activateFetched();
    print(14);


    return iapHelper;
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
    if(remoteConfig.getString('skip_purchases')=='1')return true;
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
    } on PlatformException catch (v) {
      print(v);
    }
    return {};
  }




}

enum PackageType{
  Pro
}