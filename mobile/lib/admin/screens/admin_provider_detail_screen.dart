import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/theme/app_theme.dart';
import '../providers/admin_provider.dart' as admin_providers;
import 'package:intl/intl.dart';

// =============================================================================
// Admin Provider Detail Screen (شاشة تفاصيل المزوّد)
//
// Shows detailed information about a single provider with action buttons
// for verification and type change. Gold/dark theme, RTL Arabic layout.
// =============================================================================

/// Placeholder detail screen for a single provider.
class AdminProviderDetailScreen extends ConsumerWidget {
  final String providerId;

  const AdminProviderDetailScreen({super.key, required this.providerId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(admin_providers.adminProvidersProvider);

    // Find the provider by ID
    final provider = state.providers.where((p) => p.id == providerId).firstOrNull;

    if (provider == null) {
      return Scaffold(
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.warmBg,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'تفاصيل المزوّد',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.gold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.goNamed(RouteNames.adminProviders),
          ),
        ),
        body: Center(
          child: Text(
            'المزوّد غير موجود',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ),
      );
    }

    final dateFormatter = DateFormat('yyyy/MM/dd');

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.warmBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تفاصيل المزوّد',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.gold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.goNamed(RouteNames.adminProviders),
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
                // ----- Brand Name Header -----
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppTheme.gold.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.store_rounded,
                          color: AppTheme.gold,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.brandName,
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            _typeBadge(provider.type),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // ----- Information Section -----
                _sectionTitle(theme, 'المعلومات الأساسية'),
                const SizedBox(height: 8),
                _infoCard(theme, [
                  _infoRow(theme, 'صاحب الحساب', provider.ownerName),
                  _infoRow(theme, 'الجوال', provider.phone),
                  _infoRow(theme, 'الإيميل', provider.email),
                  _infoRow(
                    theme,
                    'النوع',
                    _typeLabel(provider.type),
                  ),
                  _infoRow(
                    theme,
                    'حالة العقد',
                    _contractStatusLabel(provider.contractStatus),
                    valueWidget: _contractStatusIndicator(
                      provider.contractStatus,
                    ),
                  ),
                  _infoRow(
                    theme,
                    'تاريخ التسجيل',
                    dateFormatter.format(provider.registrationDate),
                  ),
                  _infoRow(
                    theme,
                    'عدد التيم',
                    provider.teamCount == 0
                        ? 'فردي'
                        : '${provider.teamCount} أعضاء',
                  ),
                  _infoRow(
                    theme,
                    'طلبات هذا الشهر',
                    '${provider.monthlyBookings} طلب',
                  ),
                ]),
                const SizedBox(height: 24),

                // ----- Documents Section -----
                _sectionTitle(theme, 'المستندات'),
                const SizedBox(height: 8),
                _infoCard(theme, [
                  _docRow(theme, 'الهوية', 'هوية_${provider.id}.pdf', Icons.description_rounded),
                  const SizedBox(height: 8),
                  _docRow(theme, 'الرخصة', 'رخصة_${provider.id}.pdf', Icons.verified_rounded),
                ]),
                const SizedBox(height: 24),

                // ----- Actions Section -----
                _sectionTitle(theme, 'الإجراءات'),
                const SizedBox(height: 8),

                // Verify / Reject buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم توثيق المزوّد (تجريبي)'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.verified_rounded, size: 18),
                        label: const Text('توثيق'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF38A169),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('تم رفض المزوّد (تجريبي)'),
                            ),
                          );
                        },
                        icon: const Icon(Icons.cancel_outlined, size: 18),
                        label: const Text('رفض'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Change type dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.colorScheme.outlineVariant
                          .withValues(alpha: 0.5),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: provider.type,
                      isExpanded: true,
                      hint: const Text('تغيير النوع'),
                      items: const [
                        DropdownMenuItem(value: 'new', child: Text('🟢 جديد')),
                        DropdownMenuItem(value: 'active', child: Text('🔵 نشط')),
                        DropdownMenuItem(
                          value: 'featured',
                          child: Text('🟣 مميز'),
                        ),
                        DropdownMenuItem(
                          value: 'needs_support',
                          child: Text('🟡 محتاج دعم'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('تم تغيير النوع (تجريبي)'),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _infoCard(ThemeData theme, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _infoRow(
    ThemeData theme,
    String label,
    String value, {
    Widget? valueWidget,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: valueWidget ??
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  textDirection: TextDirection.ltr,
                  textAlign: TextAlign.start,
                ),
          ),
        ],
      ),
    );
  }

  Widget _docRow(ThemeData theme, String label, String fileName, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 24, color: AppTheme.gold),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  fileName,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.preview_rounded,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }

  Widget _typeBadge(String type) {
    final (label, color) = switch (type) {
      'new' => ('جديد', const Color(0xFF38A169)),
      'active' => ('نشط', const Color(0xFF4A90D9)),
      'featured' => ('مميز', AppTheme.gold),
      'needs_support' => ('محتاج دعم', const Color(0xFFE8A838)),
      _ => ('غير معروف', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _typeLabel(String type) {
    return switch (type) {
      'new' => 'جديد',
      'active' => 'نشط',
      'featured' => 'مميز',
      'needs_support' => 'محتاج دعم',
      _ => 'غير معروف',
    };
  }

  String _contractStatusLabel(String status) {
    return switch (status) {
      'valid' => 'ساري',
      'expiring' => 'قارب على الانتهاء',
      'expired' => 'منتهي',
      _ => 'غير معروف',
    };
  }

  Widget _contractStatusIndicator(String status) {
    final (label, color) = switch (status) {
      'valid' => ('ساري', const Color(0xFF38A169)),
      'expiring' => ('قارب على الانتهاء', const Color(0xFFE8A838)),
      'expired' => ('منتهي', Colors.redAccent),
      _ => ('غير معروف', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}