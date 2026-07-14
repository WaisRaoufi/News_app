import 'package:flutter/material.dart';
import 'package:newsapp/models/items_modal.dart';
import '../Network/api_service.dart';
import '../widgets/news_card.dart';
import '../widgets/shimmer_card.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

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
      body: !hasInternet
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images.png', width: 200),

                  const Text('NO Internet connection'),
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
    );
  }
}
