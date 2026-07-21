import 'package:flutter/material.dart';
import 'package:newsapp/core/constants/app_sizes.dart';
import 'package:newsapp/features/home/models/items_modal.dart';

class NewsDetailsBottomSheet extends StatelessWidget {
  const NewsDetailsBottomSheet({required this.item, super.key});

  final ItemsModal item;

  static Future<void> show({
    required BuildContext context,
    required ItemsModal item,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return NewsDetailsBottomSheet(item: item);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    final TextStyle infoStyle =
        textTheme.bodyMedium ?? const TextStyle(fontSize: 14);

    final String title = item.title.trim().isEmpty
        ? 'Untitled news'
        : item.title.trim();

    final String description = item.description.trim().isEmpty
        ? 'There is no description for this news.'
        : item.description.trim();

    return SafeArea(
      top: false,
      child: Container(
        width: double.infinity,
        constraints: BoxConstraints(
          minHeight: MediaQuery.sizeOf(context).height * 0.4,
          maxHeight: MediaQuery.sizeOf(context).height * 0.6,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppSizes.radiusLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),

            Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: colorScheme.onSurface.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            const SizedBox(height: 20),

            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),

                    const SizedBox(height: 16),

                    NewsInfoItem(
                      icon: Icons.newspaper_rounded,
                      title: 'Source:',
                      text: item.source,
                      style: infoStyle,
                    ),

                    const SizedBox(height: 8),

                    NewsInfoItem(
                      icon: Icons.schedule_rounded,
                      title: 'Date:',
                      text: item.date,
                      style: infoStyle,
                    ),

                    const SizedBox(height: 20),

                    Divider(
                      height: 1,
                      thickness: 1,
                      color: colorScheme.outlineVariant,
                    ),

                    const SizedBox(height: 20),

                    Text(description, style: textTheme.bodyLarge),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsInfoItem extends StatelessWidget {
  const NewsInfoItem({
    required this.icon,
    required this.text,
    required this.title,
    required this.style,
    super.key,
  });

  final IconData icon;
  final String text;
  final String title;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    final String value = text.trim().isEmpty ? 'Unknown' : text.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$title ',
                  style: style.copyWith(fontWeight: FontWeight.w600),
                ),
                TextSpan(text: value, style: style),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
