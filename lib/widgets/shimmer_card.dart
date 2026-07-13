import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.white,
      child: Card(
        margin: const EdgeInsets.all(18),
        child: Container(
          height: 500,
          width: double.infinity,
          color: Colors.white,
        ),
      ),
    );
  }
}
