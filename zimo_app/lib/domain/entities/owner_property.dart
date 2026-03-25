import 'package:flutter/material.dart';

class OwnerProperty {
  const OwnerProperty({
    this.id = '',
    required this.name,
    required this.propertyType,
    this.bedrooms = 1,
    required this.address,
    required this.status,
    required this.statusColor,
    required this.rent,
    this.photos = const [],
  });

  final String id;
  final String name;
  final String propertyType;
  final int bedrooms;
  final String address;
  final String status;
  final Color statusColor;
  final String rent;
  final List<String> photos;

  factory OwnerProperty.fromApi(Map<String, dynamic> json) {
    return OwnerProperty(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      propertyType: json['property_type']?.toString() ?? 'Apartamento',
      bedrooms: int.tryParse(json['bedrooms']?.toString() ?? '') ?? 1,
      address: json['address']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Disponivel',
      statusColor: ownerPropertyStatusColor(
        json['status_key']?.toString() ?? json['status']?.toString() ?? '',
      ),
      rent: '${json['rent']?.toString() ?? '0'} MT',
      photos: (json['photos'] as List<dynamic>? ?? [])
          .map((photo) => photo.toString())
          .toList(growable: false),
    );
  }
}

Color ownerPropertyStatusColor(String rawStatus) {
  switch (rawStatus.toLowerCase()) {
    case 'rented':
    case 'arrendado':
      return const Color(0xFFB6452C);
    case 'maintenance':
    case 'manutencao':
      return const Color(0xFFB3261E);
    default:
      return const Color(0xFF0E6E6E);
  }
}
