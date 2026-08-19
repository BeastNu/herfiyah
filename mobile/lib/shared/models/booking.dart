/// A booking / appointment for a beauty service.
///
/// Maps to the `bookings` table in Supabase.
class Booking {
  final String id;
  final String customerId;
  final String serviceId;
  final String artisanId;
  final DateTime scheduledAt;
  final String status; // 'pending' | 'confirmed' | 'in_progress' | 'completed' | 'cancelled'
  final String? notes;
  final double? totalPrice;
  final String? currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Booking({
    required this.id,
    required this.customerId,
    required this.serviceId,
    required this.artisanId,
    required this.scheduledAt,
    required this.status,
    this.notes,
    this.totalPrice,
    this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: json['id'] as String,
      customerId: json['customer_id'] as String,
      serviceId: json['service_id'] as String,
      artisanId: json['artisan_id'] as String,
      scheduledAt: DateTime.parse(json['scheduled_at'] as String),
      status: json['status'] as String,
      notes: json['notes'] as String?,
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      currency: json['currency'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'service_id': serviceId,
      'artisan_id': artisanId,
      'scheduled_at': scheduledAt.toIso8601String(),
      'status': status,
      'notes': notes,
      'total_price': totalPrice,
      'currency': currency,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() =>
      'Booking(id: $id, serviceId: $serviceId, status: $status)';
}