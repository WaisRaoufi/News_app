import 'package:dio/dio.dart';

class ApiClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: "https://newsdata.io/api/1",
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {"Content-Type": "application/json"},
    ),
  );

  /// GET request
  static Future<Response> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    try {
      final response = await dio.get(path, queryParameters: query);

      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  /// POST request (اختیاری)
  static Future<Response> post(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      final response = await dio.post(path, data: data);

      return response;
    } on DioException catch (e) {
      throw Exception(_handleError(e));
    }
  }

  static String _handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data.toString() ?? "Server error";
    } else {
      return "No internet connection";
    }
  }
}
