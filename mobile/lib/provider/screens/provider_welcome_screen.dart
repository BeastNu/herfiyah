import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/router.dart';
import '../../shared/theme/app_theme.dart';

// =============================================================================
// Provider Welcome Screen (شاشة الترحيب بعد التحقق)
//
// Displayed after OTP verification is successful. It introduces the provider
// onboarding flow with a 3-step visual indicator and a call to action.
//
// Navigation target: /provider/welcome
// =============================================================================

/// The welcome screen shown after the user successfully verifies their OTP.
///
/// This screen:
///   - Shows the app logo and a welcome heading.
///   - Displays a 3-step indicator outlining the onboarding process.
///   - Provides a "هيا نبدأ" (Let's start) button that navigates to
///     the first step — basic info collection.
class ProviderWelcomeScreen extends StatelessWidget {
  const ProviderWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // -------------------------------------------------------------------
      // RTL layout for Arabic content.
      // -------------------------------------------------------------------
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),

              // -----------------------------------------------------------
              // Centered card — max 450px wide (web-first design)
              // -----------------------------------------------------------
              child: Container(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 48,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ------ App Logo / Icon ------
                        // A large brand icon as a visual anchor.
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppTheme.gold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Icon(
                            Icons.auto_awesome_rounded,
                            color: AppTheme.gold,
                            size: 52,
                          ),
                        ),
                        const SizedBox(height: 28),

                        // ------ Welcome Title ------
                        // "أهلاً بك في حِرفيّة" — Welcome to Herfiyah.
                        Text(
                          'أهلاً بك في حِرفيّة',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.gold,
                            fontSize: 32,
                          ),
                        ),
                        const SizedBox(height: 12),

                        // ------ Subtitle ------
                        // "خطوات بسيطة لبدء رحلتك" — Simple steps to start
                        // your journey.
                        Text(
                          'خطوات بسيطة لبدء رحلتك',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // ------ 3-Step Indicator ------
                        // Visual list showing the onboarding steps.
                        _StepItem(
                          stepNumber: '1️⃣',
                          title: 'البيانات الأساسية',
                          subtitle: 'المعلومات الشخصية وبيانات التواصل',
                        ),
                        const SizedBox(height: 16),
                        _StepItem(
                          stepNumber: '2️⃣',
                          title: 'العقد والشروط',
                          subtitle: 'الموافقة على اتفاقية العمل',
                        ),
                        const SizedBox(height: 16),
                        _StepItem(
                          stepNumber: '3️⃣',
                          title: 'إعداد البروفايل',
                          subtitle: 'إضافة الخدمات والأعمال',
                        ),
                        const SizedBox(height: 40),

                        // ------ Let's Start Button ------
                        // "هيا نبدأ" navigates to the basic-info step.
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              context.goNamed(RouteNames.providerBasicInfo);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.gold,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'هيا نبدأ',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// A single row in the 3-step indicator.
///
/// Displays an emoji step number, the step title, and a brief subtitle.
class _StepItem extends StatelessWidget {
  const _StepItem({
    required this.stepNumber,
    required this.title,
    this.subtitle,
  });

  final String stepNumber;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.gold.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppTheme.gold.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Text(stepNumber, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}