import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newsapp/models/items_modal.dart';
import '../Network/api_service.dart';
import '../widgets/news_card.dart';
import '../widgets/shimmer_card.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'dart:async';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService service = ApiService();

  List<ItemsModal> news = [];
  bool isLoading = true;
  bool hasInternet = true;

    late StreamSubscription subscription;

  Future<bool> checkInternet() async {
    final result = await InternetConnection().hasInternetAccess;

    setState(() {
      hasInternet = result;
    });

    return result;
  }

  @override
  void initState() {
    super.initState();
    loadNews();
      subscription = InternetConnection().onStatusChange.listen((status) {

    if (status == InternetStatus.connected) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You are Online"),
        ),
      );
      loadNews();

    } else {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("You are Offline"),
        ),
      );

    }

  });
  }

  Future<void> loadNews() async {
    final internet = await checkInternet();

    if (!internet) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    final data = await service.getNews();
    print(data);
    setState(() {
      news = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "News App",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await loadNews();
        },
        child: !hasInternet
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/wifi.svg',
                      width: 200.0,
                      height: 200.0,
                    ),
                    Text(
                      'NO Internet connection',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  setState(() {
                    isLoading = true;
                  });
                  await loadNews();
                },
                child: isLoading
                    ? ListView.builder(
                        itemCount: 10,
                        itemBuilder: (context, index) {
                          return ShimmerCard();
                        },
                      )
                    : ListView.builder(
                        itemCount: news.length,
                        itemBuilder: (context, index) {
                          final item = news[index];
                          return InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Text(item.description),
                                  );
                                },
                              );
                            },
                            child: NewsCard(item: item),
                          );
                        },
                      ),
              ),
      ),
    );
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
