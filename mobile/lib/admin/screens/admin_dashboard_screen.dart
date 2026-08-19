import 'package:flutter/material.dart';

import '../../shared/theme/app_theme.dart';

// =============================================================================
// Admin Dashboard Screen (شاشة لوحة التحكم — الأدمن)
//
// Main admin dashboard showing top-level stats and a recent providers table.
// Gold/dark theme, RTL Arabic layout.
// =============================================================================

/// The admin main dashboard screen.
class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.warmBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'حِرفيّة',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.gold,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ----- Title -----
                Text(
                  'لوحة التحكم',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'ملخص المنصة وإدارة المزودات',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // ----- Stats Cards Grid (2x2) -----
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _AdminStatCard(
                      icon: Icons.store_rounded,
                      label: 'إجمالي المزودات',
                      value: '0',
                      color: AppTheme.gold,
                      flex: 1,
                    ),
                    _AdminStatCard(
                      icon: Icons.calendar_month_rounded,
                      label: 'الحجوزات (الشهر)',
                      value: '0',
                      color: const Color(0xFF4A90D9),
                      flex: 1,
                    ),
                    _AdminStatCard(
                      icon: Icons.trending_up_rounded,
                      label: 'الإيرادات',
                      value: '0 ر.س',
                      color: const Color(0xFF38A169),
                      flex: 1,
                    ),
                    _AdminStatCard(
                      icon: Icons.person_add_rounded,
                      label: 'المزودات الجديدة (هذا الأسبوع)',
                      value: '0',
                      color: const Color(0xFFE8A838),
                      flex: 1,
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // ----- Recent Providers Section -----
                Text(
                  'آخر المزودات',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                // Placeholder table
                Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color:
                          theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      _listTile(
                        theme,
                        'صالون الجمال الفاخر',
                        'مميز',
                        Icons.star_rounded,
                        AppTheme.gold,
                        isLast: false,
                      ),
                      _divider(theme),
                      _listTile(
                        theme,
                        'كوافيرة لمسة',
                        'نشط',
                        Icons.check_circle_rounded,
                        const Color(0xFF4A90D9),
                        isLast: false,
                      ),
                      _divider(theme),
                      _listTile(
                        theme,
                        'بيوتي سبوت',
                        'جديد',
                        Icons.fiber_new_rounded,
                        const Color(0xFF38A169),
                        isLast: false,
                      ),
                      _divider(theme),
                      _listTile(
                        theme,
                        'سنترال بوتيك',
                        'محتاج دعم',
                        Icons.help_rounded,
                        const Color(0xFFE8A838),
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // ----- Quick Action Card -----
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.gold.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.admin_panel_settings_rounded,
                        color: AppTheme.gold,
                        size: 36,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'إدارة المزودات',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'تصفح وإدارة جميع المزودات المسجلة',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.goNamed(RouteNames.adminProviders);
                        },
                        child: const Text('عرض الكل ←'),
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

  Widget _listTile(
    ThemeData theme,
    String brandName,
    String typeLabel,
    IconData icon,
    Color iconColor, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsetsDirectional.only(
        start: 16,
        end: 16,
        top: 12,
        bottom: isLast ? 12 : 0,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              brandName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              typeLabel,
              style: TextStyle(
                fontSize: 12,
                color: iconColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider(ThemeData theme) {
    return Divider(
      height: 1,
      thickness: 1,
      indent: 16,
      endIndent: 16,
      color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
    );
  }
}

/// A single stat card for the admin dashboard.
class _AdminStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final int flex;

  const _AdminStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.flex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Two cards per row using flex sizing
    final width = (MediaQuery.of(context).size.width - 24 * 2 - 12) / 2;

    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}