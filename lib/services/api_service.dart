import 'package:dio/dio.dart';
import 'api_client.dart';
import '../models/items_modal.dart';

class ApiService {
  static const String apiKey = 'pub_9f7ac441e1e8496b944ee16d0f962004';

  Future<List<ItemsModal>> getNews() async {
    try {
      final response = await ApiClient.get(
        '/latest',
        query: {'apikey': apiKey, 'q': 'anima', 'language': 'en'},
      );
      return _getResults(response);
    } catch (e) {
      return [];
    }
  }

  /// استخراج دیتا از response
  List<ItemsModal> _getResults(Response response) {
    final List data = response.data['results'] ?? [];

    return data.map((json) => ItemsModal.fromJson(json)).toList();
  }
}
