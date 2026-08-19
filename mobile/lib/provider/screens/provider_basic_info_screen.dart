import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../shared/router.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/app_text_field.dart';

// =============================================================================
// Provider Basic Info Screen (شاشة البيانات الأساسية)
//
// Step 1 of the provider onboarding flow. The provider enters their personal
// details: owner name, ID number, and email address.
//
// Navigation target: /provider/basic-info
// =============================================================================

/// Step 1 — collects basic owner information.
///
/// Fields:
///   - اسم المالك (owner full name)
///   - رقم الهوية (national ID — 10 digits)
///   - الإيميل (email address)
///
/// All fields are required. Validation checks email format and ID length.
class ProviderBasicInfoScreen extends StatefulWidget {
  const ProviderBasicInfoScreen({super.key});

  @override
  State<ProviderBasicInfoScreen> createState() =>
      _ProviderBasicInfoScreenState();
}

class _ProviderBasicInfoScreenState extends State<ProviderBasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  /// Validate the form and navigate to the contract screen on success.
  void _onNext() {
    if (!_formKey.currentState!.validate()) return;

    // Navigate to the contract step.
    context.goNamed(RouteNames.providerContract);
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
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // ------ Step Indicator ------
                          // Shows which step the user is on.
                          _StepBadge(currentStep: 1, totalSteps: 3),
                          const SizedBox(height: 16),

                          // ------ Title ------
                          Text(
                            'البيانات الأساسية',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),

                          // ------ Subtitle ------
                          Text(
                            'يرجى إدخال معلومات المالك الأساسية',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 36),

                          // ------ Owner Name Field ------
                          // "اسم المالك" — the provider's full name.
                          AppTextField(
                            label: 'اسم المالك',
                            hintText: 'مثال: أحمد محمد',
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const Icon(Icons.person_outline),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'يرجى إدخال اسم المالك';
                              }
                              if (value.trim().length < 3) {
                                return 'الاسم يجب أن يكون 3 أحرف على الأقل';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // ------ National ID Field ------
                          // "رقم الهوية" — Saudi national ID (10 digits).
                          AppTextField(
                            label: 'رقم الهوية',
                            hintText: 'مثال: 1234567890',
                            controller: _idController,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            prefixIcon: const Icon(Icons.badge_outlined),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'يرجى إدخال رقم الهوية';
                              }
                              final digitsOnly =
                                  value.replaceAll(RegExp(r'\D'), '');
                              if (digitsOnly.length != 10) {
                                return 'رقم الهوية يجب أن يتكون من 10 أرقام';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),

                          // ------ Email Field ------
                          // "الإيميل" — email address with format validation.
                          AppTextField(
                            label: 'الإيميل',
                            hintText: 'example@domain.com',
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.done,
                            prefixIcon: const Icon(Icons.email_outlined),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'يرجى إدخال الإيميل';
                              }
                              final emailRegex = RegExp(
                                r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                              );
                              if (!emailRegex.hasMatch(value.trim())) {
                                return 'يرجى إدخال إيميل صحيح';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 36),

                          // ------ Next Button ------
                          // "التالي" — proceeds to the contract screen.
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: _onNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.gold,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              child: const Text(
                                'التالي',
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
      ),
    );
  }
}

/// A small badge indicating the current step out of the total.
///
/// Example: "الخطوة 1 من 3"
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