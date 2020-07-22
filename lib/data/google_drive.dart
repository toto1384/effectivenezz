import 'dart:async';
import 'dart:io';

import 'package:effectivenezz/main.dart';
import 'package:effectivenezz/ui/pages/welcome_page.dart';
import 'package:effectivenezz/ui/widgets/distivity_restart_widget.dart';
import 'package:effectivenezz/utils/basic/overflows_basic.dart';
import 'package:effectivenezz/utils/basic/utils.dart';
import 'package:effectivenezz/utils/basic/widgets_basic.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:http/http.dart' show BaseRequest, Response;
import 'package:googleapis/drive/v2.dart' as drive;
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'iap.dart';



class DriveHelper{
  GoogleSignInAccount  currentUser ;

// Specify the permissions required at login
  GoogleSignIn  _googleSignIn  =  new  GoogleSignIn (
    scopes:  < String > [
      DriveApi . DriveFileScope ,
    ],
    signInOption: SignInOption.standard,
  );

  IAPHelper iapHelper;

  static init(BuildContext buildContext)async{
    DriveHelper driveHelper=DriveHelper();

    driveHelper._googleSignIn.onCurrentUserChanged.listen(( GoogleSignInAccount  account ) async {
      driveHelper.currentUser=account ;
      if(account!=null){
        driveHelper.iapHelper = await IAPHelper.init(buildContext,driveHelper.currentUser.id.toString());
      }
    } );

    driveHelper._googleSignIn.signInSilently().then((value) {
      if(value==null){
        launchPage(buildContext, WelcomePage(driveHelper));
      }
    });

    return driveHelper;
  }

  // google sign in
  Future < Null >  handleSignIn ()  async  {
    await  _googleSignIn.signIn ();
  }

  Future handleSignOut()async{
    await _googleSignIn.signOut();
  }



  listenForChanges(String fileId)async{

    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
    var api = new drive.DriveApi(client);

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
      launchPage(buildContext, WelcomePage(this));
      return;
    }
    //
    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
    var api = new drive.DriveApi(client);

    List<int> dataAsBytes = utf8.encode(jsonEncode(MyApp.dataModel.toDriveData()));

    var media = new drive.Media(
        Future.value(dataAsBytes).asStream(),
        dataAsBytes.length
    );

    drive.File driveFile = new drive.File()..title = "Save";

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

  Future deleteFile(BuildContext buildContext,drive.File file)async {

    if(currentUser==null){
      launchPage(buildContext, WelcomePage(this));
      return;
    }

    //
    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
    var api = new drive.DriveApi(client);

    await api.files.delete(file.id);


  }

// Download a file from Google Drive.
  Future downloadAndReplaceFile(BuildContext buildContext,drive.File file) async{

    if(currentUser==null){
      launchPage(buildContext, WelcomePage(this));
      return false;
    }

    saveFromDriveFile(
        buildContext: buildContext,
        headers: await currentUser.authHeaders,
        url: file.downloadUrl??'',
    );

    return true;
    //
  }

  Future<List<File>> getAllFiles(BuildContext buildContext)async{
    if(currentUser==null){
      launchPage(buildContext, WelcomePage(this));
      return [];
    }
    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
    var api = new drive.DriveApi(client);

    return  (await api.files.list()).items;
  }


  Future saveFromDriveFile({@required BuildContext buildContext,@required Map<String,String> headers,@required String url})async{
    GoogleHttpClient client = GoogleHttpClient(await currentUser.authHeaders);
    List<int> bytes = await client.readBytes(url);

    if(bytes!=null&&bytes.length!=0){

      String bytesString = utf8.decode(bytes);
      Map<String,List> map = Map.from(jsonDecode(bytesString));
      await MyApp.dataModel.databaseHelper.saveFromDriveData(map);

      showDistivityDialog(buildContext, actions: [getButton('Refresh', onPressed: (){
        MyApp.dataModel=null;
        DistivityRestartWidget.restartApp(buildContext);
      })], title: 'Calendars and events downloaded', stateGetter: (ctx,ss){
        return getText('Your calendars and your events from your last saved file from Drive are now on your device');
      });
    }else{
      return null;
    }
  }
}
class GoogleHttpClient extends http.BaseClient{
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<http.StreamedResponse> send(BaseRequest request)async{
    return http.Client().send(request..headers.addAll(_headers));
//    var stream = request.finalize();
//
//    try{
//      var ioRequest = (await _inner.openUrl(request.method, request.url))
//        ..followRedirects = request.followRedirects
//        ..maxRedirects = request.maxRedirects
//        ..contentLength = (request?.contentLength ?? -1)
//        ..persistentConnection = request.persistentConnection;
//      request.headers.forEach((name, value) {
//        ioRequest.headers.set(name, value);
//      });
//
//      var response = await stream.pipe(ioRequest) as HttpClientResponse;
//
//      var headers = <String, String>{};
//      response.headers.forEach((key, values) {
//        headers[key] = values.join(',');
//      });
//
//      return http.StreamedResponse(
//          response.handleError(
//                  (HttpException error) =>
//              throw http.ClientException(error.message, error.uri),
//              test: (error) => error is HttpException),
//          response.statusCode,
//          contentLength:
//          response.contentLength == -1 ? null : response.contentLength,
//          request: request,
//          headers: headers,
//          isRedirect: response.isRedirect,
//          persistentConnection: response.persistentConnection,
//          reasonPhrase: response.reasonPhrase);
//
//    }on io.HttpException catch(error){
//      throw http.ClientException(error.message, error.uri);
//    }
  }

  @override
  Future<Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));

}