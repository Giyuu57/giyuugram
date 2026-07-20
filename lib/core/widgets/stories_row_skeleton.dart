import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StoriesRowSkeleton extends StatelessWidget {
  const StoriesRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlight = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return SizedBox(
      height: 100,
      child: Shimmer.fromColors(
        baseColor: base,
        highlightColor: highlight,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemCount: 6,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                const CircleAvatar(radius: 32, backgroundColor: Colors.white),
                const SizedBox(height: 6),
                Container(width: 40, height: 8, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
