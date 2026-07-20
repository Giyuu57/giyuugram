import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/providers.dart';
import '../../../../shared_models/activity.dart';
import '../../data/activity_repository.dart';

final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  return ActivityRepository(ref.watch(supabaseClientProvider));
});

class ActivityState {
  final List<ActivityItem> items;
  final bool isLoading;
  final Object? error;

  const ActivityState({this.items = const [], this.isLoading = false, this.error});

  ActivityState copyWith({List<ActivityItem>? items, bool? isLoading, Object? error}) {
    return ActivityState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ActivityController extends StateNotifier<ActivityState> {
  final ActivityRepository _repository;
  final String _userId;
  StreamSubscription? _realtimeSub;

  ActivityController(this._repository, this._userId) : super(const ActivityState()) {
    _load();
    _listenForRealtimeUpdates();
  }

  Future<void> _load() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final items = await _repository.getActivities(_userId);
      state = state.copyWith(items: items, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e);
    }
  }

  void _listenForRealtimeUpdates() {
    _realtimeSub = _repository.watchNewActivities(_userId).listen((_) {
      _load();
    });
  }

  Future<void> refresh() => _load();

  Future<void> markAllAsRead() async {
    await _repository.markAllAsRead(_userId);
    final updated = state.items.map((item) => item.copyWith(isRead: true)).toList();
    state = state.copyWith(items: updated);
  }

  @override
  void dispose() {
    _realtimeSub?.cancel();
    super.dispose();
  }
}

final activityControllerProvider =
    StateNotifierProvider.autoDispose<ActivityController, ActivityState>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  return ActivityController(ref.watch(activityRepositoryProvider), userId ?? '');
});

final unreadActivityCountProvider = FutureProvider.autoDispose<int>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return 0;
  ref.watch(activityControllerProvider);
  return ref.watch(activityRepositoryProvider).getUnreadCount(userId);
});
