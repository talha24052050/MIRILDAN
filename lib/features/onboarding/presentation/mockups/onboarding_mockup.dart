import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';

class OnboardingMockup extends StatefulWidget {
  const OnboardingMockup({super.key});

  @override
  State<OnboardingMockup> createState() => _OnboardingMockupState();
}

class _OnboardingMockupState extends State<OnboardingMockup> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (i) => setState(() => _currentPage = i),
            children: const [
              _OnboardingPage(
                pageIndex: 0,
                title: AppStrings.onboarding1Title,
                subtitle: AppStrings.onboarding1Subtitle,
              ),
              _OnboardingPage(
                pageIndex: 1,
                title: AppStrings.onboarding2Title,
                subtitle: AppStrings.onboarding2Subtitle,
              ),
              _OnboardingPage(
                pageIndex: 2,
                title: AppStrings.onboarding3Title,
                subtitle: AppStrings.onboarding3Subtitle,
                isLast: true,
              ),
            ],
          ),
          Positioned(
            bottom: AppSpacing.xxl,
            left: AppSpacing.md,
            right: AppSpacing.md,
            child: Column(
              children: [
                _PageIndicator(currentPage: _currentPage),
                const SizedBox(height: AppSpacing.lg),
                if (_currentPage < 2)
                  ElevatedButton(
                    onPressed: () => _controller.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    ),
                    child: const Text('Devam'),
                  )
                else ...[
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text(AppStrings.onboardingStart),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  TextButton(
                    onPressed: () {},
                    child: const Text(AppStrings.onboardingCreateAccount),
                  ),
                ],
                const SizedBox(height: AppSpacing.sm),
                TextButton(
                  onPressed: () {},
                  child: const Text(AppStrings.onboardingSkip),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    required this.pageIndex,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  final int pageIndex;
  final String title;
  final String subtitle;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.darkBackground, Color(0xFF0D1528)],
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _IllustrationPlaceholder(pageIndex: pageIndex),
          const SizedBox(height: AppSpacing.xxl),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTextStyles.displayLarge.copyWith(
              color: AppColors.darkOnSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.darkOnSurfaceVariant,
            ),
          ),
          const SizedBox(height: 160),
        ],
      ),
    );
  }
}

class _IllustrationPlaceholder extends StatelessWidget {
  const _IllustrationPlaceholder({required this.pageIndex});
  final int pageIndex;

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.emotionPurple,
      AppColors.emotionBlue,
      AppColors.emotionGreen,
    ];
    final color = colors[pageIndex];

    return SizedBox(
      width: 180,
      height: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.08),
            ),
          ),
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.12),
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.9),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.5),
                  blurRadius: 32,
                  spreadRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.currentPage});
  final int currentPage;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final isActive = i == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: isActive
                ? AppColors.accent
                : AppColors.darkOnSurfaceVariant.withValues(alpha: 0.4),
          ),
        );
      }),
    );
  }
}
