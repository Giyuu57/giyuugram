import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/feed/presentation/screens/home_feed_screen.dart';
import 'route_names.dart';

// Placeholder screens — will be replaced feature by feature in later phases.
class _Placeholder extends StatelessWidget {
  final String label;
  const _Placeholder(this.label);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(label)));
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: _AuthRefreshNotifier(ref),
    redirect: (context, state) {
      final loggedIn = ref.read(currentUserIdProvider) != null;
      final loggingIn = state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!loggedIn && !loggingIn) return '/login';
      if (loggedIn && loggingIn) return '/home';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: RouteNames.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        name: RouteNames.signup,
        builder: (context, state) => const SignupScreen(),
      ),
      // Shell route for bottom-nav tabs (Home, Explore, Reels, Activity, Profile)
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            _ScaffoldWithNavBar(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              name: RouteNames.home,
              builder: (context, state) => const HomeFeedScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/explore',
              name: RouteNames.explore,
              builder: (context, state) => const _Placeholder('Explore'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/reels',
              name: RouteNames.reels,
              builder: (context, state) => const _Placeholder('Reels'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/activity',
              name: RouteNames.activity,
              builder: (context, state) => const _Placeholder('Activity'),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              name: RouteNames.profile,
              builder: (context, state) => const ProfileScreen(), // userId: null => own profile
            ),
          ]),
        ],
      ),
      GoRoute(
        path: '/create_post',
        name: RouteNames.createPost,
        builder: (context, state) => const _Placeholder('Create Post'),
      ),
      GoRoute(
        path: '/edit_profile',
        name: RouteNames.editProfile,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/profile/:userId',
        name: RouteNames.userProfile,
        builder: (context, state) => ProfileScreen(
          userId: state.pathParameters['userId'],
        ),
      ),
      GoRoute(
        path: '/chat',
        name: RouteNames.chatList,
        builder: (context, state) => const _Placeholder('Chat List'),
      ),
      GoRoute(
        path: '/chat/:conversationId',
        name: RouteNames.chatDetail,
        builder: (context, state) => _Placeholder(
          'Chat with ${state.pathParameters['conversationId']}',
        ),
      ),
    ],
  );
});

/// Bridges Riverpod's authStateProvider stream to GoRouter's Listenable API.
class _AuthRefreshNotifier extends ChangeNotifier {
  _AuthRefreshNotifier(Ref ref) {
    ref.listen(authStateProvider, (_, __) => notifyListeners());
  }
}

/// Bottom navigation shell — the 5 main Instagram tabs.
class _ScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const _ScaffoldWithNavBar({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.movie_creation_outlined), label: 'Reels'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: 'Activity'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }
}