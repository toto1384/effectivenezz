import 'dart:convert';
import 'package:effectivenezz/data/prefs.dart';
import 'package:effectivenezz/ui/pages/quick_start_page.dart';
import 'package:effectivenezz/ui/widgets/basics/distivity_restart_widget.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gbutton.dart';
import 'package:effectivenezz/ui/widgets/basics/gwidgets/gtext.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/google_http_client.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:uuid/uuid.dart';

import '../main.dart';
import 'iap.dart';

class GoogleDriveHelper{
  GoogleSignInAccount  currentUser ;

  IAPHelper iapHelper;

  bool isPremium;

// Specify the permissions required at login
  GoogleSignIn  _googleSignIn  =  new  GoogleSignIn (
    scopes:  < String > [
      DriveApi . DriveFileScope ,
    ],
    signInOption: SignInOption.standard,
  );

  static init(BuildContext buildContext,Prefs prefs)async{
    GoogleDriveHelper driveHelper = GoogleDriveHelper();

    driveHelper.currentUser = await driveHelper._googleSignIn.signInSilently();

    if(driveHelper.currentUser==null){
      launchPage(buildContext, QuickStartPage(driveHelper));
    }else{
      driveHelper.iapHelper=
      await (kIsWeb?WebIapHelper.init(driveHelper.currentUser.id.toString()):
      MobileIAPHelper.init(buildContext,driveHelper.currentUser.id.toString()));
      driveHelper.isPremium=await driveHelper.iapHelper.isSubscriptionActive(prefs);
    }

    return driveHelper;
  }

  // google sign in
  Future < Null >  handleSignIn (BuildContext context)  async  {
    GoogleSignInAccount account = await  _googleSignIn.signIn ();
    currentUser=account ;
    if(account!=null){

      iapHelper= await (kIsWeb?WebIapHelper.init(currentUser.id.toString()):
      MobileIAPHelper.init(context,currentUser.id.toString()));
      //:MobileIAPHelper.init(context,dataModel.driveHelper.currentUser.id.toString()));
    }
  }

  Future handleSignOut()async{
    await _googleSignIn.signOut();
  }

  listenForChanges(String fileId)async{

    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
    var api = new DriveApi(client);

    //changes

    Channel channel = Channel();
    channel.type='web_hook';
    channel.id=Uuid().v1();

    try{
      var t = await api.files.watch(channel, fileId);
      t.execute((channel){print(channel);});
    }catch(err){
      print(err);
    }
  }

  // Upload a file to Google Drive.
  Future uploadFile(BuildContext buildContext)async {

    if(currentUser==null){
      launchPage(buildContext, QuickStartPage(this));
      return;
    }
    //
    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
    var api = new DriveApi(client);

    List<int> dataAsBytes = utf8.encode(jsonEncode(MyApp.dataModel.toDriveData()));

    var media = new Media(
        Future.value(dataAsBytes).asStream(),
        dataAsBytes.length
    );

    File driveFile = new File()..title = "Save";

    return  (await api.files.insert(driveFile, uploadMedia: media,)).id;


  }

//  updateFile(BuildContext context,drive.File file)async{
//    if(currentUser==null){
//      launchPage(context, WelcomePage());
//      return;
//    }
//
//    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
//    var api = new drive.DriveApi(client);
//
//
//    List<int> dataAsBytes = utf8.encode(jsonEncode(MyApp.dataModel.toDriveData()));
//
//    var media = new drive.Media(
//        Future.value(dataAsBytes).asStream(),
//        dataAsBytes.length
//    );
//    drive.File driveFile = new drive.File()..title = "Save";
//
//    return (await api.files.update(driveFile, file.id,uploadMedia: media,)).id;
//  }

  // Upload a file to Google Drive.

  Future deleteFile(BuildContext buildContext,File file)async {

    if(currentUser==null){
      launchPage(buildContext, QuickStartPage(this));
      return;
    }

    //
    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
    var api = new DriveApi(client);

    await api.files.delete(file.id);


  }

// Download a file from Google Drive.
  Future downloadAndReplaceFile(BuildContext buildContext,File file,{bool silent}) async{

    if(silent==null)silent=false;

    if(currentUser==null){
      launchPage(buildContext, QuickStartPage(this));
      return false;
    }

    saveFromDriveFile(
      buildContext: buildContext,
      headers: await currentUser.authHeaders,
      url: file.downloadUrl??'',
      silent: silent
    );

    return true;
    //
  }

  Future<List<File>> getAllFiles(BuildContext buildContext)async{
    if(currentUser==null){
      launchPage(buildContext, QuickStartPage(this));
      return [];
    }
    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
    var api = new DriveApi(client);

    return  (await api.files.list()).items;
  }


  Future saveFromDriveFile({@required BuildContext buildContext,@required Map<String,String> headers,
      @required String url,bool silent})async{

    if(silent==null)silent=false;

    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
    List<int> bytes = await client.readBytes(url);

    if(bytes!=null&&bytes.length!=0){

      String bytesString = utf8.decode(bytes);
      Map<String,List> map = Map.from(jsonDecode(bytesString));
      if(!kIsWeb)MyApp.dataModel.notificationHelper.cancelAllNotifications();
      await MyApp.dataModel.databaseHelper.saveFromDriveData(map);

      if(silent){
        MyApp.dataModel=null;
        DistivityRestartWidget.restartApp(buildContext);
      }else{
        showDistivityDialog(buildContext, actions: [GButton('Refresh', onPressed: (){
          MyApp.dataModel=null;
          DistivityRestartWidget.restartApp(buildContext);
        })], title: 'Calendars and events downloaded', stateGetter: (ctx,ss){
          return GText('Your calendars and your events from your last saved file from Drive are now on your device');
        });
      }
    }else{
      return null;
    }
  }
}