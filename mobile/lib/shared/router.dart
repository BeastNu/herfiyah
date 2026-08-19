import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../admin/screens/admin_dashboard_screen.dart';
import '../admin/screens/admin_login_screen.dart';
import '../admin/screens/admin_provider_detail_screen.dart';
import '../admin/screens/admin_providers_screen.dart';
import '../provider/screens/provider_basic_info_screen.dart';
import '../provider/screens/provider_contract_screen.dart';
import '../provider/screens/provider_dashboard_screen.dart';
import '../provider/screens/provider_otp_screen.dart';
import '../provider/screens/provider_profile_setup_screen.dart';
import '../provider/screens/provider_register_screen.dart';
import '../provider/screens/provider_welcome_screen.dart';

// ---------------------------------------------------------------------------
// Route names — use these with context.goNamed() for type-safe navigation.
// ---------------------------------------------------------------------------
class RouteNames {
  // --- Customer (mobile) routes ---
  static const splash = 'splash';
  static const login = 'login';
  static const register = 'register';
  static const home = 'home';
  static const profile = 'profile';
  static const serviceDetail = 'serviceDetail';
  static const booking = 'booking';

  // --- Provider (web dashboard) routes ---
  static const providerRegister = 'providerRegister';
  static const providerOtp = 'providerOtp';
  static const providerWelcome = 'providerWelcome';
  static const providerBasicInfo = 'providerBasicInfo';
  static const providerContract = 'providerContract';
  static const providerProfileSetup = 'providerProfileSetup';
  static const providerDashboard = 'providerDashboard';

  // --- Admin panel routes ---
  static const adminLogin = 'adminLogin';
  static const adminDashboard = 'adminDashboard';
  static const adminProviders = 'adminProviders';
  static const adminProviderDetail = 'adminProviderDetail';
}

// ---------------------------------------------------------------------------
// GoRouter configuration
//
// Each route is described as a GoRoute with a name, path, and builder.
// Add child routes (e.g. nested tabs) by nesting in the `routes` list.
// ---------------------------------------------------------------------------

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',

  // --- Error screen (404) -------------------------------------------------
  errorBuilder: (context, state) => _buildErrorScreen(state.error?.message),

  routes: [
    GoRoute(
      name: RouteNames.splash,
      path: '/splash',
      builder: (context, state) => const _PlaceholderScreen(
        title: 'Splash',
        message: 'صانعة الجمال — Beauty Artisan',
      ),
    ),

    GoRoute(
      name: RouteNames.login,
      path: '/auth/login',
      builder: (context, state) => const _PlaceholderScreen(
        title: 'Login',
        message: 'تسجيل الدخول — Sign in',
      ),
    ),

    GoRoute(
      name: RouteNames.register,
      path: '/auth/register',
      builder: (context, state) => const _PlaceholderScreen(
        title: 'Register',
        message: 'إنشاء حساب — Create account',
      ),
    ),

    GoRoute(
      name: RouteNames.home,
      path: '/',
      builder: (context, state) => const _PlaceholderScreen(
        title: 'Home',
        message: 'الرئيسية — Home feed',
      ),
    ),

    GoRoute(
      name: RouteNames.profile,
      path: '/profile',
      builder: (context, state) => const _PlaceholderScreen(
        title: 'Profile',
        message: 'الملف الشخصي — User profile',
      ),
    ),

    GoRoute(
      name: RouteNames.serviceDetail,
      path: '/services/:serviceId',
      builder: (context, state) {
        final serviceId = state.pathParameters['serviceId'] ?? '';
        return _PlaceholderScreen(
          title: 'Service #$serviceId',
          message: 'تفاصيل الخدمة — Service details',
        );
      },
    ),

    GoRoute(
      name: RouteNames.booking,
      path: '/booking/:serviceId',
      builder: (context, state) {
        final serviceId = state.pathParameters['serviceId'] ?? '';
        return _PlaceholderScreen(
          title: 'Booking #$serviceId',
          message: 'حجز موعد — Book appointment',
        );
      },
    ),

    // --- Provider (web dashboard) routes ---------------------------------
    GoRoute(
      name: RouteNames.providerRegister,
      path: '/provider/register',
      builder: (context, state) => const ProviderRegisterScreen(),
    ),

    GoRoute(
      name: RouteNames.providerOtp,
      path: '/provider/otp',
      builder: (context, state) {
        // Phone number is passed via state.extra from the register screen.
        return const ProviderOtpScreen();
      },
    ),

    GoRoute(
      name: RouteNames.providerWelcome,
      path: '/provider/welcome',
      builder: (context, state) => const ProviderWelcomeScreen(),
    ),

    GoRoute(
      name: RouteNames.providerBasicInfo,
      path: '/provider/basic-info',
      builder: (context, state) => const ProviderBasicInfoScreen(),
    ),

    GoRoute(
      name: RouteNames.providerContract,
      path: '/provider/contract',
      builder: (context, state) => const ProviderContractScreen(),
    ),

    GoRoute(
      name: RouteNames.providerProfileSetup,
      path: '/provider/profile-setup',
      builder: (context, state) => const ProviderProfileSetupScreen(),
    ),

    GoRoute(
      name: RouteNames.providerDashboard,
      path: '/provider/dashboard',
      builder: (context, state) => const ProviderDashboardScreen(),
    ),

    // --- Admin panel routes -----------------------------------------------

    GoRoute(
      name: RouteNames.adminLogin,
      path: '/admin/login',
      builder: (context, state) => const AdminLoginScreen(),
    ),

    GoRoute(
      name: RouteNames.adminDashboard,
      path: '/admin/dashboard',
      builder: (context, state) => const AdminDashboardScreen(),
    ),

    GoRoute(
      name: RouteNames.adminProviders,
      path: '/admin/providers',
      builder: (context, state) => const AdminProvidersScreen(),
    ),

    GoRoute(
      name: RouteNames.adminProviderDetail,
      path: '/admin/provider/:providerId',
      builder: (context, state) {
        final providerId = state.pathParameters['providerId'] ?? '';
        return AdminProviderDetailScreen(providerId: providerId);
      },
    ),
  ],
);

/// Temporary placeholder screen used while routes are scaffolded.
/// Replace each with the real screen from features/ when ready.
class _PlaceholderScreen extends StatelessWidget {
  const _PlaceholderScreen({required this.title, this.message});

  final String title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

Widget _buildErrorScreen(String? message) {
  return Scaffold(
    appBar: AppBar(title: const Text('Page not found')),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message ?? 'The requested page could not be found.',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 16),
        ),
      ),
    ),
  );
}