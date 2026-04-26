import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/repositories/preferences_repository.dart';
import '../data/auth_service.dart';

part 'auth_providers.g.dart';

// ── Auth servis singleton ──────────────────────────────────────────────────

@riverpod
AuthService authService(Ref ref) => AuthService();

// ── Mevcut kullanıcı stream'i ──────────────────────────────────────────────

@riverpod
Stream<User?> authState(Ref ref) {
  return ref.watch(authServiceProvider).authStateChanges;
}

// ── Onboarding tamamlandı mı? ──────────────────────────────────────────────

@riverpod
Future<bool> onboardingCompleted(Ref ref) async {
  final prefs = await PreferencesRepository().get();
  return prefs.onboardingCompleted;
}

// ── Auth işlemleri notifier'ı ──────────────────────────────────────────────

sealed class AuthActionState {}

class AuthActionIdle extends AuthActionState {}

class AuthActionLoading extends AuthActionState {}

class AuthActionSuccess extends AuthActionState {}

class AuthActionError extends AuthActionState {
  AuthActionError(this.message);
  final String message;
}

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  AuthActionState build() => AuthActionIdle();

  Future<void> signInWithGoogle() => _run(
    () => ref.read(authServiceProvider).signInWithGoogle(),
  );

  Future<void> signInWithEmail(String email, String password) => _run(
    () => ref.read(authServiceProvider).signInWithEmailPassword(email, password),
  );

  Future<void> createAccount(String email, String password) => _run(
    () => ref
        .read(authServiceProvider)
        .createAccountWithEmailPassword(email, password),
  );

  Future<void> signOut() => _run(
    () => ref.read(authServiceProvider).signOut(),
  );

  Future<void> _run(Future<dynamic> Function() action) async {
    state = AuthActionLoading();
    try {
      await action();
      state = AuthActionSuccess();
    } on AuthException catch (e) {
      state = AuthActionError(_mapCode(e.code));
    } catch (e) {
      state = AuthActionError(_mapFirebaseError(e));
    }
  }

  String _mapCode(String code) {
    switch (code) {
      case 'google-sign-in-aborted':
        return 'Google girişi iptal edildi.';
      case 'google-no-id-token':
        return 'Google kimlik doğrulaması başarısız oldu.';
      default:
        return 'Bir sorun oluştu, tekrar dener misin?';
    }
  }

  String _mapFirebaseError(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return 'Bu e-posta ile kayıtlı hesap bulunamadı.';
        case 'wrong-password':
          return 'Hatalı şifre. Tekrar dener misin?';
        case 'email-already-in-use':
          return 'Bu e-posta adresi zaten kullanımda.';
        case 'invalid-email':
          return 'Geçerli bir e-posta adresi gir.';
        case 'weak-password':
          return 'Şifre çok zayıf. En az 6 karakter kullan.';
        case 'network-request-failed':
          return 'İnternet bağlantısı yok. Tekrar dener misin?';
        default:
          return 'Bir sorun oluştu, tekrar dener misin?';
      }
    }
    return 'Bir sorun oluştu, tekrar dener misin?';
  }
}
