class ItemsModal {
  final String title;
  final String description;
  final String imageUrl;
  final String source;
  final String date;

  ItemsModal({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.source,
    required this.date,
  });

  factory ItemsModal.fromJson(Map<String, dynamic> json) {
    return ItemsModal(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'] ?? '',
      source: json['source_name'] ?? '',
      date: json['pubDate'] ?? '',
    );
  }
}
