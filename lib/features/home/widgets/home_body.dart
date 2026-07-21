import 'package:flutter/material.dart';
import 'package:newsapp/features/home/models/items_modal.dart';
import 'package:newsapp/features/home/widgets/news_card.dart';
import 'package:newsapp/features/home/widgets/states/empty_state.dart';
import 'package:newsapp/features/home/widgets/states/error_state.dart';
import 'package:newsapp/features/home/widgets/states/internet_state.dart';
import 'package:newsapp/features/shimmer/card_shimmer.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({
    required this.showInternetState,
    required this.newsFuture,
    required this.onRefresh,
    required this.onRetry,
    required this.onNewsPressed,
    super.key,
  });

  final bool showInternetState;
  final Future<List<ItemsModal>> newsFuture;

  final Future<void> Function() onRefresh;
  final VoidCallback onRetry;
  final ValueChanged<ItemsModal> onNewsPressed;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.onPrimary,
      onRefresh: onRefresh,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (showInternetState) {
      return InternetState();
    }

    return FutureBuilder<List<ItemsModal>>(
      future: newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return _buildLoading();
        }

        if (snapshot.hasError) {
          return ErrorState(onPressed: onRetry);
        }

        final List<ItemsModal> news = snapshot.data ?? <ItemsModal>[];

        if (news.isEmpty) {
          return EmptyState();
        }

        return ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: news.length,
          itemBuilder: (context, index) {
            final ItemsModal item = news[index];

            return InkWell(
              onTap: () => onNewsPressed(item),
              child: NewsCard(item: item),
            );
          },
        );
      },
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
}
