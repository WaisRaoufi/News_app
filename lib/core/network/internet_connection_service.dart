import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetConnectionService {
  InternetConnectionService({
    InternetConnection? internetConnection,
  }) : _internetConnection = internetConnection ?? InternetConnection();

  final InternetConnection _internetConnection;

  Stream<InternetStatus> get onStatusChange {
    return _internetConnection.onStatusChange.distinct();
  }

  Future<bool> checkInternetAccess() async {
    try {
      return await _internetConnection.hasInternetAccess;
    } catch (_) {
      return false;
    }
  }
}