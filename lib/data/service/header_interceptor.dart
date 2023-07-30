import 'dart:async';
import 'package:chopper/chopper.dart';

class HeaderInterceptor implements RequestInterceptor {
  static const String authHeader = "Authorization";
  static const String bearer = "Bearer ";
  static const String v4AuthHeader = String.fromEnvironment('IMDB_KEY');

  @override
  FutureOr<Request> onRequest(Request request) async {
    Request newRequest = request.copyWith(headers: {authHeader: bearer + v4AuthHeader, 'Accept': "application/json"});
    return newRequest;
  }
}
