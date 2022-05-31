// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ApiClient.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps

class _ApiClient implements ApiClient {
  _ApiClient(this._dio, {this.baseUrl});

  final Dio _dio;

  String? baseUrl;

  @override
  Future<Token> getToken(username, password) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'username': username, 'password': password};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Token>(Options(
                method: 'POST',
                headers: _headers,
                extra: _extra,
                contentType: 'application/x-www-form-urlencoded')
            .compose(_dio.options, '/api-auth/',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Token.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Customer> register(data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Customer>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/customer/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Customer.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Customer> getCustomer(customerId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Customer>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/customer/${customerId}/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Customer.fromJson(_result.data!);
    return value;
  }

  @override
  Future<OrderResponse> getOrders(queries) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.addAll(queries ?? <String, dynamic>{});
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<OrderResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/order/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = OrderResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<OrderResponse> getAllOrders() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<OrderResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/order/all/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = OrderResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<OrderDetail> createOrder(data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<OrderDetail>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/order/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = OrderDetail.fromJson(_result.data!);
    return value;
  }

  @override
  Future<OrderDetail> getOrder(orderId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<OrderDetail>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/order/${orderId}/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = OrderDetail.fromJson(_result.data!);
    return value;
  }

  @override
  Future<OrderDetail> updateOrder(orderId, data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<OrderDetail>(
            Options(method: 'PATCH', headers: _headers, extra: _extra)
                .compose(_dio.options, '/order/${orderId}/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = OrderDetail.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ItemsResponse> getItems() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ItemsResponse>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/item/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ItemsResponse.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Item> updateItem(itemId, data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch<Map<String, dynamic>>(_setStreamType<Item>(
        Options(method: 'PATCH', headers: _headers, extra: _extra)
            .compose(_dio.options, '/item/${itemId}/',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = Item.fromJson(_result.data!);
    return value;
  }

  @override
  Future<OrderItem> updateOrderItem(orderItemId, data) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(data);
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<OrderItem>(
            Options(method: 'PATCH', headers: _headers, extra: _extra)
                .compose(_dio.options, '/orderitem/${orderItemId}/',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = OrderItem.fromJson(_result.data!);
    return value;
  }

  @override
  Future<HttpResponse<dynamic>> getReceipt(orderId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch(_setStreamType<HttpResponse<dynamic>>(
        Options(
                method: 'GET',
                headers: _headers,
                extra: _extra,
                responseType: ResponseType.bytes)
            .compose(_dio.options, '/order/${orderId}/receipt',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = _result.data;
    final httpResponse = HttpResponse(value, _result);
    return httpResponse;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}
