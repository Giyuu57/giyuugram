import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/providers.dart';
import '../../data/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});

enum AuthStatus { idle, loading, error }

class AuthControllerState {
  final AuthStatus status;
  final String? errorMessage;

  const AuthControllerState({
    this.status = AuthStatus.idle,
    this.errorMessage,
  });

  AuthControllerState copyWith({AuthStatus? status, String? errorMessage}) {
    return AuthControllerState(
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class AuthController extends StateNotifier<AuthControllerState> {
  final AuthRepository _repository;
  AuthController(this._repository) : super(const AuthControllerState());

  Future<bool> signUp({
    required String email,
    required String password,
    required String username,
    required String fullName,
  }) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _repository.signUpWithEmail(
        email: email,
        password: password,
        username: username,
        fullName: fullName,
      );
      state = state.copyWith(status: AuthStatus.idle);
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: _friendly(e));
      return false;
    }
  }

  Future<bool> signIn({required String email, required String password}) async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _repository.signInWithEmail(email: email, password: password);
      state = state.copyWith(status: AuthStatus.idle);
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: _friendly(e));
      return false;
    }
  }

  Future<bool> signInWithGoogle() async {
    state = state.copyWith(status: AuthStatus.loading, errorMessage: null);
    try {
      await _repository.signInWithGoogle();
      state = state.copyWith(status: AuthStatus.idle);
      return true;
    } catch (e) {
      state = state.copyWith(status: AuthStatus.error, errorMessage: _friendly(e));
      return false;
    }
  }

  Future<void> resetPassword(String email) async {
    await _repository.resetPassword(email);
  }

  Future<void> signOut() async {
    await _repository.signOut();
  }

  String _friendly(Object e) {
    final msg = e.toString().replaceFirst('AuthException: ', '');
    return msg.replaceFirst('Exception: ', '');
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthControllerState>((ref) {
  return AuthController(ref.watch(authRepositoryProvider));
});