import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:newsapp/core/network/api_client.dart';
import 'package:newsapp/core/network/api_service.dart';
import 'package:newsapp/features/home/api/news_api.dart';
import 'package:newsapp/features/home/models/items_modal.dart';
import 'package:newsapp/features/shimmer/card_shimmer.dart';

import '../widgets/news_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final NewsApi _newsApi;
  late Future<List<ItemsModal>> _newsFuture;

  StreamSubscription<InternetStatus>? _internetSubscription;

  bool _hasInternet = true;

  @override
  void initState() {
    super.initState();

    // ApiClient creates Dio and adds the API key automatically.
    final apiClient = ApiClient();

    // ApiService uses Dio from ApiClient.
    final apiService = ApiService(
      dio: apiClient.dio,
    );

    // NewsApi uses ApiService.
    _newsApi = NewsApi(
      apiService: apiService,
    );

    // First request.
    _newsFuture = _fetchNews();

    _listenToInternetChanges();
  }

  void _listenToInternetChanges() {
    _internetSubscription =
        InternetConnection().onStatusChange.listen((status) {
      if (!mounted) return;

      final isConnected = status == InternetStatus.connected;

      setState(() {
        _hasInternet = isConnected;
      });

      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: Text(
              isConnected
                  ? 'You are online'
                  : 'You are offline',
            ),
          ),
        );

      if (isConnected) {
        _refreshNews();
      }
    });
  }

  Future<List<ItemsModal>> _fetchNews() async {
    final isConnected =
        await InternetConnection().hasInternetAccess;

    if (mounted) {
      setState(() {
        _hasInternet = isConnected;
      });
    }

    if (!isConnected) {
      return [];
    }

    return _newsApi.getNews();
  }

  Future<void> _refreshNews() async {
    final newFuture = _fetchNews();

    setState(() {
      _newsFuture = newFuture;
    });

    await newFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'News App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshNews,
        child: !_hasInternet
            ? _buildNoInternet()
            : FutureBuilder<List<ItemsModal>>(
                future: _newsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return _buildLoading();
                  }

                  if (snapshot.hasError) {
                    return _buildError(
                      snapshot.error.toString(),
                    );
                  }

                  final news = snapshot.data ?? [];

                  if (news.isEmpty) {
                    return _buildEmpty();
                  }

                  return ListView.builder(
                    physics:
                        const AlwaysScrollableScrollPhysics(),
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      final item = news[index];

                      return InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) {
                              return SafeArea(
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Text(
                                    item.description,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: NewsCard(
                          item: item,
                        ),
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Widget _buildLoading() {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) {
        return CardShimmer();
      },
    );
  }

  Widget _buildNoInternet() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        top: 140,
        left: 24,
        right: 24,
      ),
      children: [
        Image.asset(
          'assets/images/wifi.png',
          width: 200,
          height: 200,
        ),
        const SizedBox(height: 20),
        Text(
          'No internet connection',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildEmpty() {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 200),
      children: const [
        Icon(
          Icons.article_outlined,
          size: 70,
        ),
        SizedBox(height: 16),
        Text(
          'No news found',
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildError(String message) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
        top: 180,
        left: 24,
        right: 24,
      ),
      children: [
        const Icon(
          Icons.error_outline,
          size: 70,
        ),
        const SizedBox(height: 16),
        const Text(
          'Could not load news',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _refreshNews,
          child: const Text('Try again'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _internetSubscription?.cancel();
    super.dispose();
  }
}