import 'dart:convert';
import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String street;
  final String subLocality;
  final String locality;
  final String postalCode;
  final String country;

  const Address({
    this.street = "",
    this.subLocality = "",
    this.locality = "",
    this.postalCode = "",
    this.country = "",
  });

  Address copyWith({
    String? street,
    String? subLocality,
    String? locality,
    String? postalCode,
    String? country,
  }) {
    return Address(
      street: street ?? this.street,
      subLocality: subLocality ?? this.subLocality,
      locality: locality ?? this.locality,
      postalCode: postalCode ?? this.postalCode,
      country: country ?? this.country,
    );
  }

  @override
  List<Object> get props {
    return [
      street,
      subLocality,
      locality,
      postalCode,
      country,
    ];
  }

  @override
  bool get stringify => true;

  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'subLocality': subLocality,
      'locality': locality,
      'postalCode': postalCode,
      'country': country,
    };
  }

  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      street: map['street'],
      subLocality: map['subLocality'],
      locality: map['locality'],
      postalCode: map['postalCode'],
      country: map['country'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Address.fromJson(String source) => Address.fromMap(json.decode(source));
}
