import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/router.dart';
import '../../shared/theme/app_theme.dart';
import '../../shared/widgets/app_text_field.dart';
import '../providers/provider_auth_provider.dart';

// =============================================================================
// Provider Registration Screen (شاشة تسجيل مقدم الخدمة)
//
// Web-first design intended for large screens (desktop dashboard).
// Layout: centred card, max 450px wide.
// Contents: brand name field, phone field (+966 prefix), create-account button.
// =============================================================================

/// The first step in the provider registration flow.
///
/// The provider enters their brand name (اسم البزنس) and Saudi phone number.
/// On submit, an OTP is sent via SMS and the user is navigated to
/// [ProviderOtpScreen] to verify.
class ProviderRegisterScreen extends ConsumerWidget {
  const ProviderRegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for state changes so the UI rebuilds when loading/error changes.
    final authState = ref.watch(providerAuthProvider);
    final notifier = ref.read(providerAuthProvider.notifier);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // -------------------------------------------------------------------
      // The whole screen uses RTL layout for Arabic text.
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
                        // ------ App Logo / Title ------
                        // "حِرفيّة" brand heading.
                        Text(
                          'حِرفيّة',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppTheme.gold,
                                fontSize: 36,
                              ),
                        ),
                        const SizedBox(height: 8),

                        // Arabic subtitle — welcome message.
                        Text(
                          'أهلاً بك، أنشئ حسابك وابدأ بإدارة أعمالك',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .bodyLarge
                              ?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                        const SizedBox(height: 36),

                        // ------ Brand Name Field ------
                        // "اسم البزنس" — the name of the beauty / craft business.
                        AppTextField(
                          label: 'اسم البزنس',
                          hintText: 'مثال: صالون الوردة الذهبية',
                          controller: TextEditingController(
                            text: authState.brandName,
                          ),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          onChanged: (value) => notifier.setBrandName(value),
                          prefixIcon: const Icon(Icons.business_outlined),
                        ),
                        const SizedBox(height: 20),

                        // ------ Phone Number Field with +966 prefix ------
                        // Saudi country code prefix followed by the number.
                        Text(
                          'رقم الجوال',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        const SizedBox(height: 8),
                        Directionality(
                          // Phone numbers should read LTR for correct display.
                          textDirection: TextDirection.ltr,
                          child: Row(
                            children: [
                              // +966 badge
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.gold.withValues(alpha: 0.15),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(12),
                                    bottomRight: Radius.circular(12),
                                  ),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.flag,
                                      color: AppTheme.gold,
                                      size: 18,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      '+966',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppTheme.gold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Phone number input
                              Expanded(
                                child: AppTextField(
                                  label: 'رقم الجوال',
                                  hintText: '5XXXXXXXX',
                                  controller: TextEditingController(
                                    text: authState.phoneNumber,
                                  ),
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                  onChanged: (value) =>
                                      notifier.setPhoneNumber(value),
                                  // Hide the icon here since we use the +966 badge.
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),

                        // ------ Error Message ------
                        if (authState.error != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .error
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: Theme.of(context).colorScheme.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    authState.error!,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // ------ Create Account Button ------
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: authState.isLoading
                                ? null
                                : () => _onSubmit(context, ref),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.gold,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: authState.isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Text(
                                    'إنشاء حساب',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ------ Login Link ------
                        TextButton(
                          onPressed: () {
                            // Navigate to the provider login screen (to be built).
                            // For now redirects to the existing customer login.
                            context.go('/auth/login');
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'عندك حساب؟ ',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                              children: [
                                TextSpan(
                                  text: 'تسجيل الدخول',
                                  style: TextStyle(
                                    color: AppTheme.gold,
                                    fontWeight: FontWeight.bold,
                                  ),
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

  /// Validate and submit the registration form.
  void _onSubmit(BuildContext context, WidgetRef ref) {
    final state = ref.read(providerAuthProvider);
    final notifier = ref.read(providerAuthProvider.notifier);

    // -- Validate brand name --
    if (state.brandName.trim().isEmpty) {
      notifier.state = state.copyWith(
        error: 'يرجى إدخال اسم البزنس', // Please enter a brand name.
      );
      return;
    }

    // -- Validate phone number --
    if (state.phoneNumber.length < 9) {
      notifier.state = state.copyWith(
        error: 'يرجى إدخال رقم جوال صحيح', // Please enter a valid phone number.
      );
      return;
    }

    // -- Clear any previous error and send OTP --
    notifier.clearError();
    notifier.sendOtp(state.phoneNumber).then((_) {
      // After OTP is sent, navigate to the OTP verification screen.
      if (context.mounted) {
        context.goNamed(
          RouteNames.providerOtp,
          extra: state.phoneNumber,
        );
      }
    });
  }
}