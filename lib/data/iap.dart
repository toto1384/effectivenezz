import 'dart:convert';

import 'package:effectivenezz/data/prefs.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_restart_widget.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/typedef_and_enums.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:firebase_remote_config_hybrid/firebase_remote_config_hybrid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;
import '../main.dart';


abstract class IAPHelper{

  purchase(BuildContext buildContext,PackageType packageType, bool anual);

  Future<bool> isSubscriptionActive(Prefs prefs);
}

class MobileIAPHelper extends IAPHelper{


  final FirebaseRemoteConfig remoteConfig;

  MobileIAPHelper(this.remoteConfig);



  static Future<MobileIAPHelper> init(BuildContext context,String id) async {
    if(!kIsWeb){
      await Purchases.setup("NhStgtRStPcvQuPQvlLIjuoIaSyKSrDB",appUserId: id);

      Purchases.addPurchaserInfoUpdateListener((purchaserInfo){
      });
    }
    MobileIAPHelper iapHelper = MobileIAPHelper(await FirebaseRemoteConfig.instance);

    await iapHelper.remoteConfig.fetch();
    await iapHelper.remoteConfig.activateFetched();


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

  Future<bool> isSubscriptionActive(Prefs prefs)async{
    if(remoteConfig.getString('skip_purchases')=='1')return true;
    if(prefs.getPromoCode()==remoteConfig.getString('promo_code'))return true;
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


class WebIapHelper extends IAPHelper{


  bool isPro;
  final FirebaseRemoteConfig remoteConfig;

  WebIapHelper(this.remoteConfig);

  static Future<WebIapHelper> init(String id) async{
    print(11);
    http.Response response = await performApiRequest(RequestType.Query, "https://api.revenuecat.com/v1/subscribers/$id", {
      "authorization" : "Bearer NhStgtRStPcvQuPQvlLIjuoIaSyKSrDB",
      "content-type": "application/json",
      "x-platform": "stripe",
    });


    print(12);
    WebIapHelper iapHelper = WebIapHelper(await FirebaseRemoteConfig.instance);

    await iapHelper.remoteConfig.fetch();
    await iapHelper.remoteConfig.activateFetched();
    print(13);
    Map data = jsonDecode(response.body);
    Map entitlements = data['subscriber']['entitlements'];
    if(entitlements.length>0){
      entitlements.forEach((k,v) {
        DateFormat dateFormat = DateFormat('yyyy-MM-ddTHH:mm:ssZ');
        DateTime expiresDate = dateFormat.parse(v['expires_date']);
        if(expiresDate.isBefore(DateTime.now())){
          //expired
          iapHelper.isPro=false;
        }else{
          iapHelper.isPro=true;
        }
      });
    }else iapHelper.isPro=false;
    print(14);

    return iapHelper;
  }

  @override
  Future<bool> isSubscriptionActive(Prefs prefs) async{
    if(remoteConfig.getString('skip_purchases')=='1')return true;
    if(prefs.getPromoCode()==remoteConfig.getString('promo_code'))return true;
    return isPro??false;
  }

  @override
  purchase(BuildContext buildContext, PackageType packageType, bool anual) async{
    
    showDistivityDialog(
        buildContext,
        actions: [
          GButton(
              'Download Android App',
              onPressed: ()=>launch("https://play.google.com/store/apps/details?id=com.effectivenezz.effectivenezz&hl=en")
          )
        ],
        title: "You need to purchase using the mobile app", stateGetter: (ctx,ss){
          return GText('We are sorry for the inconvenience, but for now we do not support web payments. Purchase the app using our mobile app, then return here');
    });
//    HttpClientResponse httpClientResponse = await performApiRequest(RequestType.Post, "https://api.revenuecat.com/v1/receipts", {
//      "authorization": 'Bearer NhStgtRStPcvQuPQvlLIjuoIaSyKSrDB',
//      "content-type" : "application/json",
//      "x-platform": "stripe",
//    },data: {
//      "price": 1.99,
//      "currency": "USD",
//      "product_id": "com.my.product.iap",
//      "is_restore": "false"
//    });
//
//    MyApp.dataModel=null;
//    DistivityRestartWidget.restartApp(buildContext);
  }

}

enum PackageType{
  Pro
}