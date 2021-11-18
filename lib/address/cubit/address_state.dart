part of 'address_cubit.dart';

enum AddressEnum { loading, success, failure }

class AddressState extends Equatable {
  const AddressState(this.address, this.addressEnum);

  final Address address;
  final AddressEnum addressEnum;

  @override
  List<Object> get props => [address, addressEnum];

  @override
  bool get stringify => true;

  AddressState copyWith({
    Address? address,
    AddressEnum? addressEnum,
  }) {
    return AddressState(
      address ?? this.address,
      addressEnum ?? this.addressEnum,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'address': address.toMap(),
      'addressEnum': addressEnum.index,
    };
  }

  factory AddressState.fromMap(Map<String, dynamic> map) {
    return AddressState(
      Address.fromMap(map['address']),
      AddressEnum.values.elementAt(map['addressEnum']),
    );
  }

  String toJson() => json.encode(toMap());

  factory AddressState.fromJson(String source) =>
      AddressState.fromMap(json.decode(source));
}
