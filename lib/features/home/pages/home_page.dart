import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:newsapp/core/network/api_client.dart';
import 'package:newsapp/core/network/api_service.dart';
import 'package:newsapp/core/network/internet_connection_service.dart';
import 'package:newsapp/core/theme/theme_controller.dart';
import 'package:newsapp/features/home/api/news_api.dart';
import 'package:newsapp/features/home/models/items_modal.dart';
import 'package:newsapp/features/home/widgets/home_body.dart';
import 'package:newsapp/features/home/widgets/news_details_bottom_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NewsApi _newsApi;
  late final InternetConnectionService _internetService;

  StreamSubscription<InternetStatus>? _internetSubscription;

  late Future<List<ItemsModal>> _newsFuture;
  bool? _hasInternet;
  bool _showInternetState = false;
  bool _isReloadingAfterReconnect = false;
  bool _receivedInitialInternetStatus = false;

  @override
  void initState() {
    super.initState();

    _initializeDependencies();
    _listenToInternetChanges();
    _newsFuture = _loadInitialNews();
  }

  void _initializeDependencies() {
    final ApiClient apiClient = ApiClient();

    final ApiService apiService = ApiService(dio: apiClient.dio);

    _newsApi = NewsApi(apiService: apiService);

    _internetService = InternetConnectionService();
  }

  void _listenToInternetChanges() {
    _internetSubscription = _internetService.onStatusChange.listen(
      _handleInternetStatusChange,
    );
  }

  void _handleInternetStatusChange(InternetStatus status) {
    if (!mounted) return;

    final bool isConnected = status == InternetStatus.connected;
    if (!_receivedInitialInternetStatus) {
      _receivedInitialInternetStatus = true;
      _hasInternet = isConnected;
      return;
    }
    if (_hasInternet == isConnected) {
      return;
    }

    _hasInternet = isConnected;
    _showInternetMessage(isConnected: isConnected);
    if (isConnected && _showInternetState) {
      unawaited(_reloadNewsAfterReconnect());
    }
  }

  Future<void> _reloadNewsAfterReconnect() async {
    if (_isReloadingAfterReconnect) return;

    _isReloadingAfterReconnect = true;

    try {
      final bool isConnected = await _internetService.checkInternetAccess();

      if (!mounted || !isConnected) return;

      final Future<List<ItemsModal>> newFuture = _newsApi.getNews();

      setState(() {
        _hasInternet = true;
        _showInternetState = false;
        _newsFuture = newFuture;
      });

      try {
        await newFuture;
      } catch (_) {}
    } finally {
      _isReloadingAfterReconnect = false;
    }
  }

 Future<List<ItemsModal>> _loadInitialNews() async {
  try {
    final news = await _newsApi.getNews();

    if (mounted) {
      setState(() {
        _hasInternet = true;
        _showInternetState = false;
      });
    }

    return news;

  } catch (e) {
    if (mounted) {
      setState(() {
        _hasInternet = false;
        _showInternetState = true;
      });
    }

    return [];
  }
}

  Future<void> _refreshNews() async {
    final bool isConnected = await _internetService.checkInternetAccess();

    if (!mounted) return;

    if (!isConnected) {
      final bool shouldShowSnackbar = _hasInternet != false;

      setState(() {
        _hasInternet = false;
        _showInternetState = true;
      });

      if (shouldShowSnackbar) {
        _showInternetMessage(isConnected: false);
      }

      return;
    }

    final Future<List<ItemsModal>> newFuture = _newsApi.getNews();

    setState(() {
      _hasInternet = true;
      _showInternetState = false;
      _newsFuture = newFuture;
    });

    try {
      await newFuture;
    } catch (_) {}
  }

  void _retryNews() {
    unawaited(_refreshNews());
  }

  void _showInternetMessage({required bool isConnected}) {
    if (!mounted) return;

    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: isConnected
              ? colorScheme.onPrimary
              : colorScheme.error,
          content: Row(
            children: [
              Icon(
                isConnected ? Icons.wifi_rounded : Icons.wifi_off_rounded,
                color: isConnected ? colorScheme.primary : colorScheme.onError,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  isConnected
                      ? 'You are back online'
                      : 'Your internet connection was lost',
                  style: TextStyle(
                    color: isConnected
                        ? colorScheme.primary
                        : colorScheme.onError,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  void _showNewsDetails(ItemsModal item) {
    unawaited(NewsDetailsBottomSheet.show(context: context, item: item));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: const EdgeInsets.symmetric(horizontal: 10),
        title: const Text('News App'),
        actions: [
          ValueListenableBuilder<ThemeMode>(
            valueListenable: ThemeController.themeMode,
            builder: (context, themeMode, child) {
              final bool isDarkMode = themeMode == ThemeMode.dark;

              return IconButton(
                tooltip: isDarkMode
                    ? 'Switch to light mode'
                    : 'Switch to dark mode',
                onPressed: ThemeController.toggleTheme,
                icon: Icon(
                  isDarkMode
                      ? Icons.light_mode_rounded
                      : Icons.dark_mode_rounded,
                ),
              );
            },
          ),
        ],
      ),
      body: HomeBody(
        showInternetState: _showInternetState,
        newsFuture: _newsFuture,
        onRefresh: _refreshNews,
        onRetry: _retryNews,
        onNewsPressed: _showNewsDetails,
      ),
    );
  }

  @override
  void dispose() {
    _internetSubscription?.cancel();
    super.dispose();
  }
}
