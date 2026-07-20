import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/reels_providers.dart';
import '../widgets/reel_player.dart';

class ReelsScreen extends ConsumerStatefulWidget {
  const ReelsScreen({super.key});

  @override
  ConsumerState<ReelsScreen> createState() => _ReelsScreenState();
}

class _ReelsScreenState extends ConsumerState<ReelsScreen> {
  final _pageController = PageController();
  bool _isMuted = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    final reelsState = ref.read(reelsControllerProvider);
    if (index >= reelsState.reels.length - 2 && reelsState.hasMore) {
      ref.read(reelsControllerProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reelsState = ref.watch(reelsControllerProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: reelsState.reels.isEmpty
          ? (reelsState.isLoadingMore
              ? const Center(child: CircularProgressIndicator(color: Colors.white))
              : const Center(
                  child: Text('No reels yet', style: TextStyle(color: Colors.white)),
                ))
          : PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              onPageChanged: _onPageChanged,
              itemCount: reelsState.reels.length,
              itemBuilder: (context, index) {
                return ReelPlayer(
                  reel: reelsState.reels[index],
                  isMuted: _isMuted,
                  onToggleMute: () => setState(() => _isMuted = !_isMuted),
                );
              },
            ),
    );
  }
}
