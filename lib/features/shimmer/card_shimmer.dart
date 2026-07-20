import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CardShimmer extends StatelessWidget {
  const CardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bool isDarkMode = theme.brightness == Brightness.dark;

    final Color cardColor = colorScheme.surface;

    final Color baseColor = Color.alphaBlend(
      colorScheme.onSurface.withValues(alpha: isDarkMode ? 0.10 : 0.08),
      cardColor,
    );

    final Color highlightColor = Color.alphaBlend(
      colorScheme.onSurface.withValues(alpha: isDarkMode ? 0.25 : 0.02),
      cardColor,
    );

    return Card(
              margin: const EdgeInsets.all(18),

      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Shimmer.fromColors(
          baseColor: baseColor,
          highlightColor: highlightColor,
          period: const Duration(milliseconds: 1400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(
                height: 180,
                width: double.infinity,
                color: highlightColor,
              ),
              SizedBox(height: 10),
              SkeletonBox(
                height: 30,
                width: double.infinity,
                color: highlightColor,
              ),
              SizedBox(height: 10),
              SkeletonBox(
                height: 15,
                width: double.infinity,
                color: highlightColor,
              ),
              SizedBox(height: 10),
              SkeletonBox(height: 15, width: 230, color: highlightColor),
            ],
          ),
        ),
      ),
    );
  }
}

class SkeletonBox extends StatelessWidget {
  final double height;
  final double width;
  final Color color;
  const SkeletonBox({
    super.key,
    required this.height,
    required this.width,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }
}
