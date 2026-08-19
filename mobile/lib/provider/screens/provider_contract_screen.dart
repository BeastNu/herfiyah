import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/router.dart';
import '../../shared/theme/app_theme.dart';

// =============================================================================
// Provider Contract Screen (شاشة العقد والشروط)
//
// Step 2 of the provider onboarding flow. The provider reviews the terms and
// conditions / service agreement, checks a consent checkbox, then confirms
// their registration.
//
// Navigation target: /provider/contract
// =============================================================================

/// Step 2 — displays the service agreement and captures consent.
///
/// Features:
///   - Scrollable contract text (placeholder).
///   - Checkbox "أوافق على الشروط والأحكام".
///   - "تأكيد التسجيل" button (disabled until checkbox is checked).
///   - WhatsApp contact link below the button.
class ProviderContractScreen extends StatefulWidget {
  const ProviderContractScreen({super.key});

  @override
  State<ProviderContractScreen> createState() => _ProviderContractScreenState();
}

class _ProviderContractScreenState extends State<ProviderContractScreen> {
  /// Whether the user has checked the consent checkbox.
  bool _isConsented = false;

  /// Confirm registration and navigate to the profile setup screen.
  void _onConfirm() {
    if (!_isConsented) return;
    context.goNamed(RouteNames.providerProfileSetup);
  }

  /// Open WhatsApp with a placeholder number.
  void _onWhatsAppContact() {
    // Placeholder Saudi number — replace with the actual business number.
    const whatsappUrl = 'https://wa.me/966500000000';
    // Use Uri.tryParse to safely open the URL.
    final uri = Uri.tryParse(whatsappUrl);
    if (uri != null) {
      // In a real app, use url_launcher or a similar package.
      // For now, we copy the link to the clipboard and show a snackbar.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('رابط واتساب: $whatsappUrl'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

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
                        _StepBadge(currentStep: 2, totalSteps: 3),
                        const SizedBox(height: 16),

                        // ------ Title ------
                        Text(
                          'العقد والشروط',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ------ Subtitle ------
                        Text(
                          'يرجى قراءة الاتفاقية والموافقة عليها',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ------ Scrollable Contract Text ------
                        // Placeholder agreement text between the provider
                        // and the Herfiyah platform.
                        Container(
                          height: 280,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant,
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              _contractPlaceholder,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                height: 1.6,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ------ Consent Checkbox ------
                        // "أوافق على الشروط والأحكام"
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _isConsented
                                ? AppTheme.gold.withValues(alpha: 0.06)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'أوافق على الشروط والأحكام',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            activeColor: AppTheme.gold,
                            checkColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            value: _isConsented,
                            onChanged: (value) {
                              setState(() => _isConsented = value ?? false);
                            },
                            controlAffinity: ListTileControlAffinity.trailing,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // ------ Confirm Registration Button ------
                        // "تأكيد التسجيل" — disabled until checkbox is checked.
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: _isConsented ? _onConfirm : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.gold,
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  theme.colorScheme.onSurface.withValues(
                                alpha: 0.12,
                              ),
                              disabledForegroundColor:
                                  theme.colorScheme.onSurface.withValues(
                                alpha: 0.38,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'تأكيد التسجيل',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ------ WhatsApp Contact Link ------
                        // "للمساعدة تواصل معنا" — clickable WhatsApp link.
                        InkWell(
                          onTap: _onWhatsAppContact,
                          borderRadius: BorderRadius.circular(8),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.support_agent_rounded,
                                  color: AppTheme.gold,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'للمساعدة تواصل معنا',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.gold,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.open_in_new_rounded,
                                  color: AppTheme.gold,
                                  size: 16,
                                ),
                              ],
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

/// Placeholder contract text describing the agreement between the provider
/// and the Herfiyah platform.
///
/// This should be replaced with the actual legal contract in production.
const String _contractPlaceholder = '''
اتفاقية تقديم الخدمات بين مقدم الخدمة ومنصة حِرفيّة

بين:
منصة حِرفيّة (المنصة)
و
مقدم الخدمة المسجل (الطرف الثاني)

مقدمة:
تتيح المنصة لمقدمي الخدمات في مجال التجميل والعناية الشخصية فرصة عرض خدماتهم وإدارة حجوزاتهم والتواصل مع العميلات.

أولاً — التزامات مقدم الخدمة:
1. يلتزم مقدم الخدمة بتقديم الخدمات المسجلة في ملفه الشخصي بجودة عالية.
2. يلتزم بالحضور في المواعيد المحددة أو إلغاء الحجز قبل 24 ساعة.
3. يتحمل مقدم الخدمة مسؤولية دقة المعلومات المقدمة في ملفه الشخصي.

ثانياً — التزامات المنصة:
1. توفر المنصة منصة تقنية للحجز والدفع والتواصل.
2. تدعم المنصة مقدم الخدمة في حال وجود نزاعات مع العميلات.

ثالثاً — السياسات المالية:
1. تحصل المنصة على عمولة رمزية عن كل حجز يتم تأكيده عبر المنصة.
2. تُحول المستحقات بشكل أسبوعي حسب الاتفاق.

رابعاً — مدة الاتفاقية:
تسري هذه الاتفاقية من تاريخ التسجيل وتستمر حتى إلغاء الحساب من قبل أي من الطرفين مع الالتزام بشروط الإلغاء.

خامساً — أحكام عامة:
تخضع هذه الاتفاقية للأنظمة والقوانين في المملكة العربية السعودية.

نسخة محدثة — يتم تحديث الاتفاقية بشكل دوري وسيتم إشعارك بأي تغييرات.
''';

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