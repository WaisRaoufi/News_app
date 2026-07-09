import 'package:flutter/material.dart';

class NewsModel {
  static void show(
    BuildContext context,
    String title,
    String source,
    String description,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title),
              const SizedBox(height: 10),
              Text(source),
              const SizedBox(height: 20),
              Text(description),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Close"),
              ),
            ],
          ),
        );
      },
    );
  }
}
