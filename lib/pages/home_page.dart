import 'package:flutter/material.dart';
import 'package:newsapp/models/items_modal.dart';
import '../services/api_service.dart';
import 'news_model.dart';
import '../widgets/news_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ApiService service = ApiService();

  List<ItemsModal> news = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadNews();
  }

  Future<void> loadNews() async {
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
      appBar: AppBar(title: const Text("News App")),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            isLoading = true;
          });
          await loadNews();
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: news.length,
                itemBuilder: (context, index) {
                  final item = news[index];

                  print(item);
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
