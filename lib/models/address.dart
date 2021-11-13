import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String street;
  final String subLocality;
  final String locality;
  final String postalCode;
  final String country;

  const Address(
      {required this.street,
      required this.subLocality,
      required this.locality,
      required this.postalCode,
      required this.country});

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
}
