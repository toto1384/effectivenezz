import 'package:http/http.dart' as http;

class GoogleHttpClient extends http.BaseClient{
  Map<String, String> _headers;

  GoogleHttpClient(this._headers) : super();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request)async{
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
  Future<http.Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));

}