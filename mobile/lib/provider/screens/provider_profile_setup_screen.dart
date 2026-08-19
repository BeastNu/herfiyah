import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/router.dart';
import '../../shared/theme/app_theme.dart';

// =============================================================================
// Provider Profile Setup Screen (شاشة إعداد البروفايل)
//
// Step 3 of the provider onboarding flow. After the contract is signed, the
// provider is guided through setting up their business profile:
//   - Logo / brand image
//   - Services and pricing
//   - Portfolio / gallery
//   - Availability schedule
//
// Navigation target: /provider/profile-setup
// =============================================================================

/// Step 3 — profile setup placeholder after contract acceptance.
///
/// Each profile item is displayed as a card with a "قريباً" (Coming soon)
/// badge, indicating that the feature will be available in future updates.
/// The "تم" (Done) button navigates to the provider dashboard.
class ProviderProfileSetupScreen extends StatelessWidget {
  const ProviderProfileSetupScreen({super.key});

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
              // Centered card — max 450px wide
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
                      vertical: 40,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // ------ Step Indicator ------
                        _StepBadge(currentStep: 3, totalSteps: 3),
                        const SizedBox(height: 16),

                        // ------ Title ------
                        Text(
                          'إعداد البروفايل',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ------ Subtitle ------
                        Text(
                          'أكمل ملفك الشخصي لتستقبل الحجوزات',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 36),

                        // ------ Profile Setup Items ------
                        // Each item is a card with an icon, label, and coming-soon badge.
                        _ProfileSetupCard(
                          icon: Icons.image_outlined,
                          label: 'أضف لوقو البزنس',
                          description: 'أضف شعار و صور لمتجرك',
                        ),
                        const SizedBox(height: 14),
                        _ProfileSetupCard(
                          icon: Icons.shopping_bag_outlined,
                          label: 'أضف خدماتك وأسعارك',
                          description: 'حدد الخدمات والأسعار',
                        ),
                        const SizedBox(height: 14),
                        _ProfileSetupCard(
                          icon: Icons.photo_library_outlined,
                          label: 'أضف معرض أعمالك',
                          description: 'اعرض أعمالك السابقة',
                        ),
                        const SizedBox(height: 14),
                        _ProfileSetupCard(
                          icon: Icons.calendar_month_outlined,
                          label: 'حدد أوقات توفرك',
                          description: 'اختر أيام وساعات العمل',
                        ),
                        const SizedBox(height: 36),

                        // ------ Done Button ------
                        // "تم" — navigates to the provider dashboard.
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () {
                              context.goNamed(RouteNames.providerDashboard);
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
                              'تم',
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

/// A single profile-setup card with an icon, label, description, and a
/// "قريباً" (Coming soon) badge.
class _ProfileSetupCard extends StatelessWidget {
  const _ProfileSetupCard({
    required this.icon,
    required this.label,
    this.description,
  });

  final IconData icon;
  final String label;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest
            .withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.gold.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppTheme.gold, size: 24),
          ),
          const SizedBox(width: 14),

          // Label + Description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    description!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),

          // "قريباً" badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppTheme.gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'قريباً',
              style: theme.textTheme.labelSmall?.copyWith(
                color: AppTheme.gold,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A small badge indicating the current step out of the total.
class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.currentStep, required this.totalSteps});

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back_rounded, color: AppTheme.gold, size: 16),
          const SizedBox(width: 8),
          Text(
            'الخطوة $currentStep من $totalSteps',
            style: theme.textTheme.labelLarge?.copyWith(
              color: AppTheme.gold,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}