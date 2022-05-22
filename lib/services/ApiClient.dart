import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:order/services/models/Item.dart';
import 'package:order/services/models/ItemsResponse.dart';
import 'package:order/services/models/OrderDetail.dart';
import 'package:order/services/models/OrderItem.dart';
import 'package:order/services/models/Token.dart';
import 'package:order/services/models/OrderResponse.dart';
import 'package:retrofit/retrofit.dart';
part 'ApiClient.g.dart';

const secureStorage = FlutterSecureStorage();

@RestApi(baseUrl: "http://192.168.1.56:8081/")
// @RestApi(baseUrl: "http://10.0.2.2:8081/")
abstract class ApiClient {
  factory ApiClient({String? baseUrl}) {
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
    return _ApiClient(dio, baseUrl: baseUrl);
  }

  @POST("/api-auth/")
  @FormUrlEncoded()
  Future<Token> getToken(
      @Field('username') String username, @Field('password') String password);

  @GET("/order/")
  Future<OrderResponse> getOrders();

  @POST("/order/")
  Future<OrderDetail> createOrder(@Body() Map<String, dynamic> data);

  @GET("/order/{id}/")
  Future<OrderDetail> getOrder(@Path("id") int orderId);

  @PATCH("/order/{id}/")
  Future<OrderDetail> updateOrder(
      @Path("id") int orderId, @Body() Map<String, dynamic> data);

  @GET("/item/")
  Future<ItemsResponse> getItems();

  @PATCH("/item/{id}/")
  Future<Item> updateItem(
      @Path("id") int itemId, @Body() Map<String, dynamic> data);

  @PATCH("/orderitem/{id}/")
  Future<OrderItem> updateOrderItem(
      @Path("id") int orderItemId, @Body() Map<String, dynamic> data);

  @GET("/comments?postId={id}")
  Future<Token> getCommentFromPostId(@Path("id") int postId);
}
