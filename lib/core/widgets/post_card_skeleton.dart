import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PostCardSkeleton extends StatelessWidget {
  const PostCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? Colors.grey.shade800 : Colors.grey.shade300;
    final highlight = isDark ? Colors.grey.shade700 : Colors.grey.shade100;

    return Shimmer.fromColors(
      baseColor: base,
      highlightColor: highlight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const CircleAvatar(radius: 18, backgroundColor: Colors.white),
                const SizedBox(width: 10),
                Container(width: 100, height: 12, color: Colors.white),
              ],
            ),
          ),
          Container(width: double.infinity, height: 400, color: Colors.white),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(width: 150, height: 12, color: Colors.white),
          ),
        ],
      ),
    );
  }
}