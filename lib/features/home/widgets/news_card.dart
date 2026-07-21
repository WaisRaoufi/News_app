import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/core/constants/app_sizes.dart';
import 'package:newsapp/features/home/models/items_modal.dart';
import 'package:newsapp/features/home/widgets/news_details_bottom_sheet.dart';
import 'package:newsapp/features/shimmer/image_shimmer.dart';

class NewsCard extends StatelessWidget {
  final ItemsModal item;

  const NewsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    return InkWell(
      onTap: () {
        NewsDetailsBottomSheet.show(context: context, item: item);
      },
      child: Card(
        margin: const EdgeInsets.all(AppSizes.paddingMidium),
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.paddingMidium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => ImageShimmer(),
                  errorWidget: (context, url, error) => Container(
                    height: 180,
                    width: double.infinity,
                    color: colorScheme.primary,
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                item.title,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              Text(item.source, style: textTheme.bodyMedium),
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.touch_app, size: 18),
                  SizedBox(width: 5),
                  Text("More Details", style: textTheme.bodyMedium),
                ],
              ),

              Text(item.date, style: textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
