import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../../core/services/providers.dart';
import '../providers/stories_providers.dart';
import '../../../../shared_models/story.dart';

class StoryViewerScreen extends ConsumerStatefulWidget {
  final List<StoryGroup> groups;
  final int initialIndex;

  const StoryViewerScreen({super.key, required this.groups, required this.initialIndex});

  @override
  ConsumerState<StoryViewerScreen> createState() => _StoryViewerScreenState();
}

class _StoryViewerScreenState extends ConsumerState<StoryViewerScreen> {
  late PageController _groupController;
  int _groupIndex = 0;
  int _storyIndex = 0;
  Timer? _timer;
  double _progress = 0;

  static const _storyDuration = Duration(seconds: 5);
  static const _tickInterval = Duration(milliseconds: 50);

  @override
  void initState() {
    super.initState();
    _groupIndex = widget.initialIndex;
    _groupController = PageController(initialPage: _groupIndex);
    _startTimer();
    _markCurrentViewed();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _groupController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _progress = 0;
    _timer = Timer.periodic(_tickInterval, (timer) {
      setState(() {
        _progress += _tickInterval.inMilliseconds / _storyDuration.inMilliseconds;
        if (_progress >= 1) {
          _nextStory();
        }
      });
    });
  }

  void _markCurrentViewed() {
    final userId = ref.read(currentUserIdProvider);
    if (userId == null) return;
    final story = widget.groups[_groupIndex].stories[_storyIndex];
    ref.read(storiesRepositoryProvider).markStoryViewed(storyId: story.id, viewerId: userId);
  }

  void _nextStory() {
    final currentGroup = widget.groups[_groupIndex];
    if (_storyIndex < currentGroup.stories.length - 1) {
      setState(() => _storyIndex++);
      _startTimer();
      _markCurrentViewed();
    } else {
      _nextGroup();
    }
  }

  void _previousStory() {
    if (_storyIndex > 0) {
      setState(() => _storyIndex--);
      _startTimer();
      _markCurrentViewed();
    } else {
      _previousGroup();
    }
  }

  void _nextGroup() {
    if (_groupIndex < widget.groups.length - 1) {
      setState(() {
        _groupIndex++;
        _storyIndex = 0;
      });
      _groupController.animateToPage(_groupIndex,
          duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
      _startTimer();
      _markCurrentViewed();
    } else {
      Navigator.of(context).pop();
    }
  }

  void _previousGroup() {
    if (_groupIndex > 0) {
      setState(() {
        _groupIndex--;
        _storyIndex = widget.groups[_groupIndex].stories.length - 1;
      });
      _groupController.animateToPage(_groupIndex,
          duration: const Duration(milliseconds: 250), curve: Curves.easeInOut);
      _startTimer();
      _markCurrentViewed();
    } else {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final group = widget.groups[_groupIndex];
    final story = group.stories[_storyIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapUp: (details) {
          final screenWidth = MediaQuery.of(context).size.width;
          if (details.globalPosition.dx < screenWidth / 3) {
            _previousStory();
          } else if (details.globalPosition.dx > screenWidth * 2 / 3) {
            _nextStory();
          }
        },
        onLongPressStart: (_) => _timer?.cancel(),
        onLongPressEnd: (_) => _startTimer(),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: story.mediaUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey.shade900),
            ),
            SafeArea(
              child: Column(
                children: [
                  Row(
                    children: List.generate(group.stories.length, (i) {
                      return Expanded(
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 2),
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(2),
                          ),
                          child: FractionallySizedBox(
                            alignment: Alignment.centerLeft,
                            widthFactor: i < _storyIndex
                                ? 1
                                : i == _storyIndex
                                    ? _progress.clamp(0, 1)
                                    : 0,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundImage:
                              group.avatarUrl != null ? CachedNetworkImageProvider(group.avatarUrl!) : null,
                        ),
                        const SizedBox(width: 8),
                        Text(group.username,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        Text(timeago.format(story.createdAt),
                            style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
