import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:order/services/ApiClient.dart';

ApiClient apiClient = ApiClient();
const secureStorage = FlutterSecureStorage();

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
