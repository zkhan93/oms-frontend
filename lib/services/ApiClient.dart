import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:order/services/models/Customer.dart';
import 'package:order/services/models/Item.dart';
import 'package:order/services/models/ItemsResponse.dart';
import 'package:order/services/models/OrderDetail.dart';
import 'package:order/services/models/OrderItem.dart';
import 'package:order/services/models/Token.dart';
import 'package:order/services/models/OrderResponse.dart';
import 'package:retrofit/retrofit.dart';
part 'ApiClient.g.dart';

const secureStorage = FlutterSecureStorage();
String BACKEND_URL = dotenv.env["BACKEND_URL"] ?? 'https://oms.khancave.in/';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio) {
    return _ApiClient(dio, baseUrl: BACKEND_URL);
  }

  @POST("/api-auth/")
  @FormUrlEncoded()
  Future<Token> getToken(
      @Field('username') String username, @Field('password') String password);

  @POST("/customer/")
  Future<Customer> register(@Body() Map<String, dynamic> data);

  @GET("/customer/{id}/")
  Future<Customer> getCustomer(@Path("id") int customerId);

  @GET("/order/")
  Future<OrderResponse> getOrders(@Queries() Map<String, dynamic>? queries);

  @GET("/order/all/")
  Future<OrderResponse> getAllOrders();

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

  @GET("/order/{id}/receipt")
  @DioResponseType(ResponseType.bytes)
  Future<HttpResponse> getReceipt(@Path("id") int orderId);
}
