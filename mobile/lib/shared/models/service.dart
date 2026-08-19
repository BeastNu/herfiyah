/// A beauty service listing posted by an artisan.
///
/// Maps to the `services` table in Supabase.
class Service {
  final String id;
  final String artisanId;
  final String title;
  final String description;
  final double price;
  final String? currency; // 'SAR', 'AED', etc.
  final int durationMinutes;
  final String? category;
  final List<String> imageUrls;
  final double? rating;
  final int reviewCount;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Service({
    required this.id,
    required this.artisanId,
    required this.title,
    required this.description,
    required this.price,
    this.currency,
    required this.durationMinutes,
    this.category,
    this.imageUrls = const [],
    this.rating,
    this.reviewCount = 0,
    this.isAvailable = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      artisanId: json['artisan_id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      currency: json['currency'] as String?,
      durationMinutes: json['duration_minutes'] as int,
      category: json['category'] as String?,
      imageUrls: (json['image_urls'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['review_count'] as int? ?? 0,
      isAvailable: json['is_available'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'artisan_id': artisanId,
      'title': title,
      'description': description,
      'price': price,
      'currency': currency,
      'duration_minutes': durationMinutes,
      'category': category,
      'image_urls': imageUrls,
      'rating': rating,
      'review_count': reviewCount,
      'is_available': isAvailable,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() => 'Service(id: $id, title: $title, price: $price)';
}