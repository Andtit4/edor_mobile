class ServiceCategory {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String image;
  final bool isActive;
  final int prestataireCount;
  final DateTime createdAt;

  const ServiceCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.image,
    required this.isActive,
    required this.prestataireCount,
    required this.createdAt,
  });

  factory ServiceCategory.fromJson(Map<String, dynamic> json) {
    return ServiceCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      icon: json['icon'] as String,
      image: json['image'] as String,
      isActive: json['isActive'] as bool,
      prestataireCount: json['prestataireCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'icon': icon,
      'image': image,
      'isActive': isActive,
      'prestataireCount': prestataireCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  ServiceCategory copyWith({
    String? id,
    String? name,
    String? description,
    String? icon,
    String? image,
    bool? isActive,
    int? prestataireCount,
    DateTime? createdAt,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      image: image ?? this.image,
      isActive: isActive ?? this.isActive,
      prestataireCount: prestataireCount ?? this.prestataireCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceCategory && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ServiceCategory(id: $id, name: $name, description: $description)';
  }
}




