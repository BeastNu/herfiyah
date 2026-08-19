import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../shared/theme/app_theme.dart';
import '../providers/provider_auth_provider.dart';
import '../widgets/otp_code_field.dart';

// =============================================================================
// OTP Verification Screen (شاشة إدخال رمز التحقق)
//
// After the user submits their phone number, they are navigated here to
// enter the 6-digit code sent via SMS.
//
// Features:
//   - Back arrow to return to the registration screen
//   - Title + subtitle showing the phone number
//   - 6 separate OTP input fields with auto-advance
//   - Resend link with a 60-second countdown timer
// =============================================================================

/// The second step of the provider registration flow — OTP verification.
class ProviderOtpScreen extends ConsumerStatefulWidget {
  const ProviderOtpScreen({super.key});

  @override
  ConsumerState<ProviderOtpScreen> createState() => _ProviderOtpScreenState();
}

class _ProviderOtpScreenState extends ConsumerState<ProviderOtpScreen> {
  /// Timer countdown (seconds) before the user can request a new code.
  int _resendSeconds = 60;

  /// Whether the resend timer is active.
  bool _isTimerActive = true;

  /// The countdown timer handle.
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  /// Start (or restart) the 60-second resend countdown.
  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() {
      _resendSeconds = 60;
      _isTimerActive = true;
    });

    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendSeconds <= 1) {
        timer.cancel();
        if (mounted) {
          setState(() => _isTimerActive = false);
        }
      } else {
        setState(() => _resendSeconds--);
      }
    });
  }

  /// Handle the resend link tap.
  void _onResend() {
    final notifier = ref.read(providerAuthProvider.notifier);
    final phone = ref.read(providerAuthProvider).phoneNumber;

    notifier.sendOtp(phone);
    _startResendTimer();
  }

  /// Called when all 6 OTP digits have been entered.
  void _onOtpCompleted(String code) {
    final notifier = ref.read(providerAuthProvider.notifier);
    notifier.verifyOtp(code);

    // In a real app we'd listen to the state change and navigate on verified.
    // For now, show a snackbar indicating success.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم التحقق بنجاح!'), // Verified successfully!
        backgroundColor: Colors.green,
      ),
    );
  }

  /// Format the phone number for display: +966 XXX XXXX.
  String _formatPhone(String raw) {
    if (raw.length >= 4) {
      return '+966 ${raw.substring(0, 3)} ${raw.substring(3)}';
    }
    return '+966 $raw';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(providerAuthProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,

      // -------------------------------------------------------------------
      // RTL layout for Arabic text.
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
                        // ------ Back Arrow ------
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: () => context.pop(),
                            tooltip: 'رجوع',
                          ),
                        ),
                        const SizedBox(height: 4),

                        // ------ Title ------
                        // "أدخلي رمز التحقق" — Enter the verification code.
                        Text(
                          'أدخلي رمز التحقق',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // ------ Subtitle ------
                        // Shows the masked phone number: "أرسلنا رمز إلى +966 XXX XXXX"
                        Text(
                          'أرسلنا رمز إلى ${_formatPhone(authState.phoneNumber)}',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 36),

                        // ------ OTP Code Input ------
                        // 6 separate digit fields with auto-advance.
                        OtpCodeField(
                          fieldCount: 6,
                          onChanged: (partial) {
                            ref
                                .read(providerAuthProvider.notifier)
                                .setOtpCode(partial);
                          },
                          onCompleted: _onOtpCompleted,
                        ),
                        const SizedBox(height: 32),

                        // ------ Error Message ------
                        if (authState.error != null) ...[
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.error
                                  .withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  color: theme.colorScheme.error,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    authState.error!,
                                    style: TextStyle(
                                      color: theme.colorScheme.error,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                        ],

                        // ------ Loading Indicator ------
                        if (authState.isLoading)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 16),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),

                        // ------ Verify Button ------
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            onPressed: authState.isLoading ||
                                    authState.otpCode.length < 6
                                ? null
                                : () =>
                                    _onOtpCompleted(authState.otpCode),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.gold,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                            ),
                            child: const Text(
                              'تأكيد',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // ------ Resend Link ------
                        Center(
                          child: _isTimerActive
                              // Show countdown while timer is active.
                              ? Text.rich(
                                  TextSpan(
                                    text: 'لم يصلك الرمز؟ أعد المحاولة بعد ',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: '$_resendSeconds ثانية',
                                        style: const TextStyle(
                                          color: AppTheme.gold,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              // Show clickable resend link when timer expires.
                              : InkWell(
                                  onTap: _onResend,
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'لم يصلك الرمز؟ ',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: theme
                                            .colorScheme.onSurfaceVariant,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: 'إعادة الإرسال',
                                          style: const TextStyle(
                                            color: AppTheme.gold,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
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