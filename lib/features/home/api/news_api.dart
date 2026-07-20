import 'package:dio/dio.dart';
import 'package:newsapp/core/network/api_service.dart';
import 'package:newsapp/features/home/models/items_modal.dart';

class NewsApi {
  final ApiService apiService;

  NewsApi({
    required this.apiService,
  });

  Future<List<ItemsModal>> getNews() async {
    final response = await apiService.get(
      '/latest',
      query: {
        'apikey': 'pub_9f7ac441e1e8496b944ee16d0f962004',
        'q': 'sport',
        'language': 'en',
      },
    );

    return getResults(response);
  }

  List<ItemsModal> getResults(Response response) {
    final data = response.data;

    if (data is! Map<String, dynamic>) {
      throw const FormatException('Invalid server response');
    }

    final results = data['results'];

    if (results is! List) {
      return [];
    }

    return results
        .map(
          (json) => ItemsModal.fromJson(
            json as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}