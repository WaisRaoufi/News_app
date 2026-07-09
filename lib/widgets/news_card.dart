import 'package:flutter/material.dart';

import '../models/items_modal.dart';

class NewsCard extends StatelessWidget {
  final ItemsModal item;

  const NewsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              item.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: const Icon(Icons.broken_image, size: 50),
                );
              },
            ),

            const SizedBox(height: 10),

            Text(
              item.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Text(item.source),
            const SizedBox(height: 10),

            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.touch_app, size: 18),
                SizedBox(width: 5),
                Text("More Details"),
              ],
            ),

            Text(item.date, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
