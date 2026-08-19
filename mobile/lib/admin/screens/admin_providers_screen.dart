import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/theme/app_theme.dart';
import '../providers/admin_provider.dart' as admin_providers;

// =============================================================================
// Admin Providers Screen (شاشة إدارة المزودات)
//
// Provider management list with filtering (type, contract status) and search.
// Gold/dark theme, RTL Arabic layout.
// =============================================================================

/// Provider management list screen.
class AdminProvidersScreen extends ConsumerWidget {
  const AdminProvidersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final state = ref.watch(admin_providers.adminProvidersProvider);
    final notifier = ref.read(admin_providers.adminProvidersProvider.notifier);

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.warmBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'إدارة المزودات',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.gold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.goNamed(RouteNames.adminDashboard),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              // ----- Search Bar -----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'البحث باسم البزنس...',
                    prefixIcon: Icon(Icons.search_rounded),
                    filled: true,
                  ),
                  onChanged: (value) => notifier.setSearchQuery(value),
                ),
              ),

              // ----- Filter Bar -----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Type filter
                    _FilterDropdown(
                      label: 'النوع',
                      value: state.filters.type,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('الكل')),
                        DropdownMenuItem(
                          value: 'new',
                          child: Text('🟢 جديد'),
                        ),
                        DropdownMenuItem(
                          value: 'active',
                          child: Text('🔵 نشط'),
                        ),
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
                        if (value != null) notifier.setTypeFilter(value);
                      },
                    ),
                    const SizedBox(height: 8),

                    // Contract status filter
                    _FilterDropdown(
                      label: 'حالة العقد',
                      value: state.filters.contractStatus,
                      items: const [
                        DropdownMenuItem(value: 'all', child: Text('الكل')),
                        DropdownMenuItem(
                          value: 'valid',
                          child: Text('🟢 ساري'),
                        ),
                        DropdownMenuItem(
                          value: 'expiring',
                          child: Text('🟡 قارب على الانتهاء'),
                        ),
                        DropdownMenuItem(
                          value: 'expired',
                          child: Text('🔴 منتهي'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          notifier.setContractStatusFilter(value);
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 8),

              // ----- Results Count -----
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  '${state.filteredProviders.length} مزود',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // ----- Provider List -----
              Expanded(
                child: state.filteredProviders.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 56,
                              color: theme.colorScheme.onSurfaceVariant
                                  .withValues(alpha: 0.4),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'لا توجد نتائج مطابقة',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: state.filteredProviders.length,
                        itemBuilder: (context, index) {
                          final provider = state.filteredProviders[index];
                          return _ProviderCard(provider: provider);
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Filter dropdown widget.
class _FilterDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?> onChanged;

  const _FilterDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value,
                isExpanded: true,
                items: items,
                onChanged: onChanged,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A single provider card/row in the list.
class _ProviderCard extends StatelessWidget {
  final admin_providers.AdminProvider provider;

  const _ProviderCard({required this.provider});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: () {
          context.goNamed(
            RouteNames.adminProviderDetail,
            pathParameters: {'providerId': provider.id},
          );
        },
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Row 1: Brand name + Type badge ---
              Row(
                children: [
                  Expanded(
                    child: Text(
                      provider.brandName,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _typeBadge(provider.type),
                ],
              ),
              const SizedBox(height: 8),

              // --- Row 2: Team count + Contract status + Monthly bookings ---
              Row(
                children: [
                  // Team count
                  _infoChip(
                    Icons.groups_rounded,
                    provider.teamCount == 0 ? 'فردي' : '${provider.teamCount} تيم',
                    theme,
                  ),
                  const SizedBox(width: 12),

                  // Contract status
                  _contractStatusChip(provider.contractStatus, theme),

                  const Spacer(),

                  // Monthly bookings
                  Text(
                    '${provider.monthlyBookings} طلب',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
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

  Widget _contractStatusChip(String status, ThemeData theme) {
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

  Widget _infoChip(IconData icon, String text, ThemeData theme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}