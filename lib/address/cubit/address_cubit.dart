import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sun_safety/address/address.dart';
import 'package:sun_safety/repository/goelocation.dart';
part 'address_state.dart';

class AddressCubit extends HydratedCubit<AddressState> {
  AddressCubit(this._locationRepository) : super(const AddressState(Address()));

  final UserLocationRepository _locationRepository;

  Future<void> getAddress() async {
    final Position? _position =
        await _locationRepository.getGeoLocationPosition();

    try {
      final _addressData =
          await _locationRepository.getAddressFromLatLong(_position!);
      emit(state.copyWith(address: _addressData));
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  AddressState? fromJson(Map<String, dynamic> json) {
    try {
      final address = Address.fromMap(json);
      return AddressState(address);
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  Map<String, dynamic>? toJson(AddressState state) {
    state.address.toJson();
  }
}
