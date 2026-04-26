import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../data/repositories/preferences_repository.dart';
import '../providers/auth_providers.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _markOnboardingCompleted() async {
    final repo = PreferencesRepository();
    final prefs = await repo.get();
    await repo.save(prefs.copyWith(onboardingCompleted: true));
  }

  Future<void> _signInWithGoogle() async {
    await ref.read(authProvider.notifier).signInWithGoogle();
    if (!mounted) return;
    final authState = ref.read(authProvider);
    if (authState is AuthActionSuccess) {
      await _markOnboardingCompleted();
      if (!mounted) return;
      context.go(AppRoutes.galaxy);
    }
  }

  Future<void> _submitEmailForm() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    if (email.isEmpty || password.isEmpty) return;

    final notifier = ref.read(authProvider.notifier);
    if (_isLogin) {
      await notifier.signInWithEmail(email, password);
    } else {
      await notifier.createAccount(email, password);
    }
    if (!mounted) return;
    final authState = ref.read(authProvider);
    if (authState is AuthActionSuccess) {
      await _markOnboardingCompleted();
      if (!mounted) return;
      context.go(AppRoutes.galaxy);
    }
  }

  Future<void> _continueAsGuest() async {
    await _markOnboardingCompleted();
    if (!mounted) return;
    context.go(AppRoutes.galaxy);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthActionLoading;
    final errorMessage =
        authState is AuthActionError ? authState.message : null;

    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkOnSurface),
          onPressed: isLoading ? null : () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _isLogin
                  ? AppStrings.authSignInTitle
                  : AppStrings.authCreateAccountTitle,
              style: AppTextStyles.headlineLarge.copyWith(
                color: AppColors.darkOnSurface,
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),

            // Google giriş butonu
            _SocialButton(
              label: AppStrings.authSignInWithGoogle,
              icon: Icons.g_mobiledata_rounded,
              onPressed: isLoading ? null : _signInWithGoogle,
            ),
            const SizedBox(height: AppSpacing.md),

            // Ayırıcı
            Row(
              children: [
                const Expanded(child: Divider(color: AppColors.darkSurfaceVariant)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text(
                    AppStrings.authOrDivider,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.darkOnSurfaceVariant,
                    ),
                  ),
                ),
                const Expanded(child: Divider(color: AppColors.darkSurfaceVariant)),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // Email alanı
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.darkOnSurface,
              ),
              decoration: _inputDecoration(AppStrings.authEmailHint),
              enabled: !isLoading,
            ),
            const SizedBox(height: AppSpacing.md),

            // Şifre alanı
            TextField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              textInputAction: TextInputAction.done,
              onSubmitted: (_) => _submitEmailForm(),
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.darkOnSurface,
              ),
              decoration: _inputDecoration(AppStrings.authPasswordHint).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.darkOnSurfaceVariant,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              enabled: !isLoading,
            ),

            // Hata mesajı
            if (errorMessage != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Text(
                errorMessage,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.error,
                ),
              ),
            ],

            const SizedBox(height: AppSpacing.xl),

            // Giriş / Kayıt butonu
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _submitEmailForm,
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        _isLogin
                            ? AppStrings.authSignIn
                            : AppStrings.authCreateAccount,
                      ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // Giriş ↔ Kayıt geçişi
            Center(
              child: TextButton(
                onPressed: isLoading
                    ? null
                    : () => setState(() => _isLogin = !_isLogin),
                child: Text(
                  _isLogin
                      ? AppStrings.authNoAccount
                      : AppStrings.authHaveAccount,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.darkOnSurfaceVariant,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),

            // Misafir devam
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: isLoading ? null : _continueAsGuest,
                child: Text(
                  AppStrings.onboardingSkip,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.darkOnSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: AppTextStyles.bodyLarge.copyWith(
        color: AppColors.darkOnSurfaceVariant,
      ),
      filled: true,
      fillColor: AppColors.darkSurfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.all(AppSpacing.md),
    );
  }
}

// ── Sosyal giriş butonu ───────────────────────────────────────────────────────

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColors.darkOnSurface),
        label: Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.darkOnSurface,
          ),
        ),
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.darkSurfaceVariant),
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
        ),
      ),
    );
  }
}
