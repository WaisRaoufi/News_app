import 'package:dio/dio.dart';

class ApiService {
  final Dio dio;
  ApiService({required this.dio});

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    try {
      final response = await dio.get(path, queryParameters: query);

      return response;
    } on DioException catch (e) {
      throw Exception(handleError(e));
    }
  }

  static String handleError(DioException e) {
    if (e.response != null) {
      return e.response?.data.toString() ?? "Server error";
    } else {
      return "No internet connection";
    }
  }
}
