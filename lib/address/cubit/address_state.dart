part of 'address_cubit.dart';

class AddressState extends Equatable {
  const AddressState(this.address);

  final Address address;

  @override
  List<Object> get props => [address];

  AddressState copyWith({
    Address? address,
  }) {
    return AddressState(
      address ?? this.address,
    );
  }

  @override
  bool get stringify => true;
}
