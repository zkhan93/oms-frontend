import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:order/services/ApiClient.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dio getDio() {
  Dio dio = Dio();
  dio.options = BaseOptions(receiveTimeout: 5000, connectTimeout: 5000);
  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
    secureStorage.read(key: "token").then((token) {
      if (token != null && token.isNotEmpty) {
        options.headers["authorization"] = "Token $token";
      }
      handler.next(options);
    }, onError: (error) {
      debugPrint(error.toString());
      debugPrint("Error Fetching Token");
      handler.next(options);
    });
  }));
  return dio;
}

Dio dio = getDio();
ApiClient apiClient = ApiClient(dio);
const secureStorage = FlutterSecureStorage();

const rs = "₹";

String getErrorMsg(ex) {
  if (ex.type == DioErrorType.response) {
    return 'No Response from the server';
  }
  if (ex.type == DioErrorType.connectTimeout) {
    return 'check your connection';
  }

  if (ex.type == DioErrorType.receiveTimeout) {
    return 'unable to connect to the server';
  }

  if (ex.type == DioErrorType.other) {
    debugPrint(ex.toString());
    return 'Something went wrong';
  }
  return ex.message;
}

Map? getErrorResponse(ex) {
  Map? response;

  if (ex.response != null && ex.response.data != null) {
    try {
      response = ex.response.data as Map;
    } catch (parsingError) {
      debugPrint(
          "failed to parse response in JSON, see first 100 characters below...");
      debugPrint((ex.response.data as String).substring(0, 100));
      response = null;
    }
  }
  return response;
}

Future<List<Widget>> getDefaultActions(context) async {
  List<String> roles = await getRoles();
  return <Widget>[
    IconButton(
        onPressed: () async {
          if (await secureStorage.containsKey(key: "token")) {
            await secureStorage.delete(key: "token");
          }
          Navigator.of(context).pushNamedAndRemoveUntil(
              "/login", (Route<dynamic> route) => false);
        },
        icon: const Icon(Icons.logout)),
    if (roles.contains("admin"))
      IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed("/manage-products");
          },
          icon: const Icon(Icons.list_sharp))
  ];
}

Future<List<String>> getRoles() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  List<String> roles = pref.getStringList("roles") ?? [];
  debugPrint(roles.toString());
  return roles;
}

Future<bool> setRoles(List<String> roles) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.setStringList("roles", roles);
}
