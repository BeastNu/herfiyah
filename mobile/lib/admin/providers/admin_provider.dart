import 'package:flutter_riverpod/flutter_riverpod.dart';

// ---------------------------------------------------------------------------
// Admin provider — Riverpod StateNotifier for admin state
// ---------------------------------------------------------------------------

/// Authentication state for the admin panel.
class AdminAuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final String? error;

  const AdminAuthState({
    this.isLoggedIn = false,
    this.isLoading = false,
    this.error,
  });

  AdminAuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    String? error,
  }) {
    return AdminAuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Filters for the providers list.
class ProviderFilters {
  final String type; // 'all', 'new', 'active', 'featured', 'needs_support'
  final String contractStatus; // 'all', 'valid', 'expiring', 'expired'

  const ProviderFilters({
    this.type = 'all',
    this.contractStatus = 'all',
  });

  ProviderFilters copyWith({String? type, String? contractStatus}) {
    return ProviderFilters(
      type: type ?? this.type,
      contractStatus: contractStatus ?? this.contractStatus,
    );
  }
}

/// A single provider entry in the admin list.
class AdminProvider {
  final String id;
  final String brandName;
  final String ownerName;
  final String phone;
  final String email;
  final String type; // 'new', 'active', 'featured', 'needs_support'
  final String contractStatus; // 'valid', 'expiring', 'expired'
  final int teamCount;
  final int monthlyBookings;
  final DateTime registrationDate;

  const AdminProvider({
    required this.id,
    required this.brandName,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.type,
    required this.contractStatus,
    this.teamCount = 0,
    this.monthlyBookings = 0,
    required this.registrationDate,
  });
}

/// State for the providers list page.
class AdminProvidersState {
  final List<AdminProvider> providers;
  final List<AdminProvider> filteredProviders;
  final ProviderFilters filters;
  final String searchQuery;
  final bool isLoading;

  const AdminProvidersState({
    this.providers = const [],
    this.filteredProviders = const [],
    this.filters = const ProviderFilters(),
    this.searchQuery = '',
    this.isLoading = false,
  });

  AdminProvidersState copyWith({
    List<AdminProvider>? providers,
    List<AdminProvider>? filteredProviders,
    ProviderFilters? filters,
    String? searchQuery,
    bool? isLoading,
  }) {
    return AdminProvidersState(
      providers: providers ?? this.providers,
      filteredProviders: filteredProviders ?? this.filteredProviders,
      filters: filters ?? this.filters,
      searchQuery: searchQuery ?? this.searchQuery,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

/// StateNotifier that manages admin authentication.
class AdminAuthNotifier extends StateNotifier<AdminAuthState> {
  AdminAuthNotifier() : super(const AdminAuthState());

  /// Attempt to log in (placeholder — no real auth yet).
  Future<void> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // TODO: Connect to Supabase admin auth
      await Future.delayed(const Duration(seconds: 1));
      if (email == 'admin@herfiyah.com' && password == 'admin123') {
        state = state.copyWith(isLoggedIn: true, isLoading: false);
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'بيانات الدخول غير صحيحة',
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Log out.
  void logout() {
    state = const AdminAuthState();
  }

  /// Clear error.
  void clearError() {
    state = state.copyWith(error: null);
  }
}

/// StateNotifier that manages the providers list and filters.
class AdminProvidersNotifier extends StateNotifier<AdminProvidersState> {
  AdminProvidersNotifier() : super(AdminProvidersState(providers: _placeholderProviders)) {
    _applyFilters();
  }

  /// Placeholder data until Supabase is connected.
  static final List<AdminProvider> _placeholderProviders = [
    AdminProvider(
      id: '1',
      brandName: 'صالون الجمال الفاخر',
      ownerName: 'سارة أحمد',
      phone: '0555123456',
      email: 'sara@example.com',
      type: 'featured',
      contractStatus: 'valid',
      teamCount: 5,
      monthlyBookings: 34,
      registrationDate: DateTime(2025, 1, 15),
    ),
    AdminProvider(
      id: '2',
      brandName: 'كوافيرة لمسة',
      ownerName: 'نورة محمد',
      phone: '0555987654',
      email: 'nora@example.com',
      type: 'active',
      contractStatus: 'valid',
      teamCount: 2,
      monthlyBookings: 18,
      registrationDate: DateTime(2025, 3, 10),
    ),
    AdminProvider(
      id: '3',
      brandName: 'بيوتي سبوت',
      ownerName: 'هدى خالد',
      phone: '0555112233',
      email: 'huda@example.com',
      type: 'new',
      contractStatus: 'expiring',
      teamCount: 0,
      monthlyBookings: 5,
      registrationDate: DateTime(2026, 7, 1),
    ),
    AdminProvider(
      id: '4',
      brandName: 'سنترال بوتيك',
      ownerName: 'ريم سامي',
      phone: '0555443322',
      email: 'reem@example.com',
      type: 'needs_support',
      contractStatus: 'expired',
      teamCount: 1,
      monthlyBookings: 0,
      registrationDate: DateTime(2024, 11, 20),
    ),
    AdminProvider(
      id: '5',
      brandName: 'ملكات التجميل',
      ownerName: 'لينا عبدالله',
      phone: '0555778899',
      email: 'lina@example.com',
      type: 'active',
      contractStatus: 'valid',
      teamCount: 8,
      monthlyBookings: 42,
      registrationDate: DateTime(2025, 6, 5),
    ),
  ];

  /// Update the type filter.
  void setTypeFilter(String type) {
    state = state.copyWith(
      filters: state.filters.copyWith(type: type),
    );
    _applyFilters();
  }

  /// Update the contract status filter.
  void setContractStatusFilter(String contractStatus) {
    state = state.copyWith(
      filters: state.filters.copyWith(contractStatus: contractStatus),
    );
    _applyFilters();
  }

  /// Update the search query.
  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
    _applyFilters();
  }

  /// Apply all filters and search to produce filteredProviders.
  void _applyFilters() {
    var filtered = List<AdminProvider>.from(state.providers);

    // Apply type filter
    if (state.filters.type != 'all') {
      filtered = filtered.where((p) => p.type == state.filters.type).toList();
    }

    // Apply contract status filter
    if (state.filters.contractStatus != 'all') {
      filtered = filtered
          .where((p) => p.contractStatus == state.filters.contractStatus)
          .toList();
    }

    // Apply search query
    if (state.searchQuery.isNotEmpty) {
      final query = state.searchQuery.toLowerCase();
      filtered = filtered
          .where((p) => p.brandName.toLowerCase().contains(query))
          .toList();
    }

    state = state.copyWith(filteredProviders: filtered);
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final adminAuthProvider =
    StateNotifierProvider<AdminAuthNotifier, AdminAuthState>((ref) {
  return AdminAuthNotifier();
});

final adminProvidersProvider =
    StateNotifierProvider<AdminProvidersNotifier, AdminProvidersState>((ref) {
  return AdminProvidersNotifier();
});