import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:order/services/ApiClient.dart';
import 'package:order/services/models/Customer.dart';
import 'package:shared_preferences/shared_preferences.dart';

Dio getDio() {
  Dio dio = Dio();
  dio.options = BaseOptions(
    headers: {"Accept": "application/json"},
    responseType: ResponseType.json,
    receiveTimeout: 30000,
    connectTimeout: 50000,
    followRedirects: false,
    receiveDataWhenStatusError: true,
  );
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
    debugPrint(ex.response.toString());
    return 'Error response from the server';
  }
  if (ex.type == DioErrorType.connectTimeout) {
    debugPrint(ex.error.toString());
    return 'Connection timeout';
  }

  if (ex.type == DioErrorType.receiveTimeout) {
    return 'Connection timeout while receiving content';
  }

  if (ex.type == DioErrorType.other) {
    debugPrint(ex.toString());
    return 'Unknown error encountered';
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

Future<Customer?> fetchUserDetails(int customerId) async {
  Customer? customer;
  try {
    customer = await apiClient.getCustomer(customerId);
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("user", json.encode(customer.toJson()));
  } catch (e) {
    debugPrint(e.toString());
  }
  return customer;
}

Future<Customer?> getUser() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? jsonCustomer = await pref.getString("user");
  if (jsonCustomer != null && jsonCustomer.isNotEmpty) {
    return Customer.fromJson(json.decode(jsonCustomer));
  }
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
