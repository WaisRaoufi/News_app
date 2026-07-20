abstract final class AppConfig {
  static const String baseUrl = 'https://newsdata.io/api/1';

  static const String apiKey = String.fromEnvironment(
    'pub_9f7ac441e1e8496b944ee16d0f962004',
    defaultValue: '',
  );

  static void validate() {
    if (apiKey.isEmpty) {
      throw StateError(
        'API KEY is missing. Run the app using.',
      );
    }
  }
}