import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';

// =============================================================================
// Provider Authentication State (حالة تسجيل الدخول لمقدمي الخدمات)
//
// This provider manages the multi-step provider registration flow:
//   1. User enters brand name + phone number → sendOtp()
//   2. User enters 6-digit OTP code → verifyOtp()
//
// The actual Supabase integration will be added later — for now the
// methods contain placeholder logic (simulated delay + demo behaviour).
// =============================================================================

/// Possible states in the provider authentication flow.
enum ProviderAuthStatus {
  /// Initial state — user has not started registration.
  idle,

  /// OTP was sent successfully — waiting for user to enter the code.
  otpSent,

  /// OTP has been verified — user is authenticated.
  verified,

  /// Something went wrong.
  error,
}

/// The mutable state held by [ProviderAuthNotifier].
///
/// Every field is public and read-only from the outside. Only the notifier
/// (StateNotifier) should modify them.
class ProviderAuthState extends Equatable {
  const ProviderAuthState({
    this.brandName = '',
    this.phoneNumber = '',
    this.otpCode = '',
    this.isLoading = false,
    this.error,
    this.status = ProviderAuthStatus.idle,
  });

  /// The business / brand name entered by the provider (اسم البزنس).
  final String brandName;

  /// The Saudi phone number (without +966 prefix).
  final String phoneNumber;

  /// The 6-digit OTP code entered by the user.
  final String otpCode;

  /// Whether an async operation (sendOtp / verifyOtp) is in progress.
  final bool isLoading;

  /// A user-facing error message, or `null` when there is no error.
  final String? error;

  /// The current step in the auth flow.
  final ProviderAuthStatus status;

  /// Return the full phone number with Saudi country code.
  String get fullPhoneNumber => '+966$phoneNumber';

  @override
  List<Object?> get props => [
        brandName,
        phoneNumber,
        otpCode,
        isLoading,
        error,
        status,
      ];

  /// Convenience copy-with for immutable state updates.
  ProviderAuthState copyWith({
    String? brandName,
    String? phoneNumber,
    String? otpCode,
    bool? isLoading,
    String? error,
    ProviderAuthStatus? status,
  }) {
    return ProviderAuthState(
      brandName: brandName ?? this.brandName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otpCode: otpCode ?? this.otpCode,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      status: status ?? this.status,
    );
  }
}

// ---------------------------------------------------------------------------
// StateNotifier
// ---------------------------------------------------------------------------

/// Manages the provider registration flow (brand name → phone → OTP).
///
/// Usage in a widget:
/// ```dart
/// final authState = ref.watch(providerAuthProvider);
/// ref.read(providerAuthProvider.notifier).sendOtp('0555123456');
/// ```
class ProviderAuthNotifier extends StateNotifier<ProviderAuthState> {
  ProviderAuthNotifier() : super(const ProviderAuthState());

  // -----------------------------------------------------------------------
  // Actions
  // -----------------------------------------------------------------------

  /// Update the brand name as the user types.
  void setBrandName(String value) {
    state = state.copyWith(brandName: value);
  }

  /// Update the phone number as the user types (digits only).
  void setPhoneNumber(String value) {
    // Strip non-digit characters so we store clean numbers.
    final digitsOnly = value.replaceAll(RegExp(r'\D'), '');
    state = state.copyWith(phoneNumber: digitsOnly);
  }

  /// Update the OTP code as the user types.
  void setOtpCode(String value) {
    state = state.copyWith(otpCode: value);
  }

  /// Clear any error message.
  void clearError() {
    state = state.copyWith(error: null);
  }

  /// Reset the entire state back to idle.
  void reset() {
    state = const ProviderAuthState();
  }

  // -----------------------------------------------------------------------
  // Async — send OTP to the given phone number
  // -----------------------------------------------------------------------

  /// Sends a 6-digit OTP code to [phone] via SMS.
  ///
  /// This is a **placeholder** implementation. When Supabase is connected,
  /// this method will call `Supabase.instance.client.auth.signInWithOtp(...)`.
  Future<void> sendOtp(String phone) async {
    state = state.copyWith(
      phoneNumber: phone,
      isLoading: true,
      error: null,
      status: ProviderAuthStatus.idle,
    );

    try {
      // ----------------------------------------------------------------
      // TODO: Replace with Supabase OTP call:
      //   await Supabase.instance.client.auth.signInWithOtp(
      //     phone: '+966$phone',
      //   );
      // ----------------------------------------------------------------

      // Simulate network delay (2 seconds).
      await Future.delayed(const Duration(seconds: 2));

      // Placeholder: always succeed.
      state = state.copyWith(
        isLoading: false,
        status: ProviderAuthStatus.otpSent,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل إرسال الرمز. حاول مرة أخرى.', // Failed to send code.
        status: ProviderAuthStatus.error,
      );
    }
  }

  // -----------------------------------------------------------------------
  // Async — verify the OTP code
  // -----------------------------------------------------------------------

  /// Verifies the 6-digit [code] entered by the user.
  ///
  /// This is a **placeholder** implementation. When Supabase is connected,
  /// this method will call `Supabase.instance.client.auth.verifyOTP(...)`.
  Future<void> verifyOtp(String code) async {
    state = state.copyWith(
      otpCode: code,
      isLoading: true,
      error: null,
    );

    try {
      // ----------------------------------------------------------------
      // TODO: Replace with Supabase OTP verification:
      //   await Supabase.instance.client.auth.verifyOTP(
      //     phone: '+966${state.phoneNumber}',
      //     token: code,
      //     type: OtpType.sms,
      //   );
      // ----------------------------------------------------------------

      // Simulate network delay.
      await Future.delayed(const Duration(seconds: 2));

      // Placeholder: accept any 6-digit code.
      if (code.length < 6) {
        throw Exception('Invalid code');
      }

      state = state.copyWith(
        isLoading: false,
        status: ProviderAuthStatus.verified,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'رمز التحقق غير صحيح. حاول مرة أخرى.', // Incorrect code.
        status: ProviderAuthStatus.error,
      );
    }
  }
}

// ---------------------------------------------------------------------------
// Riverpod provider declaration
// ---------------------------------------------------------------------------

/// The single [ProviderAuthNotifier] instance used throughout the provider
/// authentication flow.
final providerAuthProvider =
    StateNotifierProvider<ProviderAuthNotifier, ProviderAuthState>((ref) {
  return ProviderAuthNotifier();
});