import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/features/home/models/items_modal.dart';
import 'package:newsapp/features/shimmer/image_shimmer.dart';
import 'news_bottom_sheet.dart';

class NewsCard extends StatelessWidget {
  final ItemsModal item;

  const NewsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return NewsBottomSheet(item: item);
          },
        );
      },
      child: Card(
        margin: const EdgeInsets.all(18),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => ImageShimmer(),
                  errorWidget: (context, url, error) => Container(
                    height: 180,
                    width: double.infinity,
                    color: Theme.of(context).colorScheme.primary,
                    child: const Icon(Icons.broken_image, size: 50),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Text(
                item.title,
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 5),

              Text(item.source, style: Theme.of(context).textTheme.bodyMedium,),
              const SizedBox(height: 10),

               Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(Icons.touch_app, size: 18),
                  SizedBox(width: 5),
                  Text("More Details", style: Theme.of(context).textTheme.bodyMedium,),
                ],
              ),

              Text(item.date, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }
}
