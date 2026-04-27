import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/router/app_router.dart';
import '../../../data/repositories/preferences_repository.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pages = [
    _OnboardingPage(
      title: AppStrings.onboarding1Title,
      subtitle: AppStrings.onboarding1Subtitle,
      illustration: Icons.mic_none_rounded,
    ),
    _OnboardingPage(
      title: AppStrings.onboarding2Title,
      subtitle: AppStrings.onboarding2Subtitle,
      illustration: Icons.color_lens_outlined,
    ),
    _OnboardingPage(
      title: AppStrings.onboarding3Title,
      subtitle: AppStrings.onboarding3Subtitle,
      illustration: Icons.lock_outline_rounded,
    ),
  ];

  bool get _isLastPage => _currentPage == _pages.length - 1;

  Future<void> _markCompleted() async {
    final repo = PreferencesRepository();
    final prefs = await repo.get();
    await repo.save(prefs.copyWith(onboardingCompleted: true));
  }

  Future<void> _continueAsGuest() async {
    await _markCompleted();
    if (!mounted) return;
    context.go(AppRoutes.galaxy);
  }

  void _goToAuth() {
    context.push(AppRoutes.auth);
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentPage = i),
                itemBuilder: (context, i) => _pages[i],
              ),
            ),
            _PageIndicator(count: _pages.length, current: _currentPage),
            const SizedBox(height: AppSpacing.lg),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: _isLastPage
                  ? _LastPageActions(
                      onGuest: _continueAsGuest,
                      onCreateAccount: _goToAuth,
                    )
                  : _NextButton(onPressed: _nextPage),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }
}

// ── Sayfa içeriği ─────────────────────────────────────────────────────────────

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.illustration,
  });

  final String title;
  final String subtitle;
  final IconData illustration;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(illustration, size: 96, color: AppColors.accent),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            title,
            style: AppTextStyles.displayMedium.copyWith(
              color: AppColors.darkOnSurface,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            subtitle,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.darkOnSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// ── Sayfa göstergesi ──────────────────────────────────────────────────────────

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.count, required this.current});

  final int count;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          width: isActive ? 24.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.accent
                : AppColors.darkOnSurfaceVariant.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}

// ── Devam butonu ──────────────────────────────────────────────────────────────

class _NextButton extends StatelessWidget {
  const _NextButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(AppStrings.onboardingContinue),
      ),
    );
  }
}

// ── Son sayfa aksiyonları ─────────────────────────────────────────────────────

class _LastPageActions extends StatelessWidget {
  const _LastPageActions({
    required this.onGuest,
    required this.onCreateAccount,
  });

  final VoidCallback onGuest;
  final VoidCallback onCreateAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: onCreateAccount,
            child: Text(AppStrings.onboardingCreateAccount),
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onGuest,
            child: Text(
              AppStrings.onboardingSkip,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.darkOnSurfaceVariant,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
