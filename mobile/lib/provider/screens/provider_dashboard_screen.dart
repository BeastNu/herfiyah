import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';

// =============================================================================
// Provider Dashboard Screen (شاشة لوحة التحكم)
//
// Placeholder dashboard shown after the onboarding flow is complete.
// Displays high-level stats and an active account status indicator.
//
// Navigation target: /provider/dashboard
// =============================================================================

/// A simple placeholder dashboard for the provider.
///
/// Features:
///   - AppBar with the brand name "حِرفيّة".
///   - "لوحة التحكم" (Dashboard) title.
///   - "حسابك نشط ✅" active account indicator.
///   - Stat cards showing zero values for: الحجوزات (bookings), التقييمات
///     (reviews), الأرباح (earnings).
class ProviderDashboardScreen extends StatelessWidget {
  const ProviderDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'حِرفيّة',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.gold,
          ),
        ),
        actions: [
          // ----- Active Account Indicator -----
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.green.withValues(alpha: 0.3),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle, color: Colors.green, size: 16),
                  SizedBox(width: 6),
                  Text(
                    'حسابك نشط ✅',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ----- Dashboard Title -----
                Text(
                  'لوحة التحكم',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'مرحباً بعودتك! إليك ملخص أعمالك',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 28),

                // ----- Stats Cards -----
                // Booking stats card
                _StatCard(
                  icon: Icons.calendar_today_rounded,
                  label: 'الحجوزات',
                  value: '0',
                  color: const Color(0xFF4A90D9),
                ),
                const SizedBox(height: 14),

                // Reviews stats card
                _StatCard(
                  icon: Icons.star_rounded,
                  label: 'التقييمات',
                  value: '0',
                  color: const Color(0xFFE8A838),
                ),
                const SizedBox(height: 14),

                // Earnings stats card
                _StatCard(
                  icon: Icons.trending_up_rounded,
                  label: 'الأرباح',
                  value: '0 ر.س',
                  color: const Color(0xFF38A169),
                ),
                const SizedBox(height: 40),

                // ----- Coming Soon Placeholder -----
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppTheme.gold.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.construction_rounded,
                        color: AppTheme.gold.withValues(alpha: 0.5),
                        size: 48,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'قريباً — المزيد من الميزات',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.gold,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'إدارة الحجوزات، التقارير المتقدمة، والتواصل المباشر',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A single stat card showing a metric on the dashboard.
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Coloured icon circle
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),

          // Label and value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}