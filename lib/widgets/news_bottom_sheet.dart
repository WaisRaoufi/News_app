import 'package:flutter/material.dart';
import '../models/items_modal.dart';

class NewsBottomSheet extends StatelessWidget {
  final ItemsModal item;

  const NewsBottomSheet({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        constraints: const BoxConstraints(maxHeight: 250),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(item.source),
                SizedBox(height: 10),
                Text(item.date),
                Text(
                  item.description.isEmpty
                      ? 'No details available'
                      : item.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
