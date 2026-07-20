import 'package:flutter/material.dart';

class StatColumn extends StatelessWidget {
  final int count;
  final String label;
  final VoidCallback? onTap;

  const StatColumn({super.key, required this.count, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(
            _formatCount(count),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 13, color: Colors.grey)),
        ],
      ),
    );
  }

  String _formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
