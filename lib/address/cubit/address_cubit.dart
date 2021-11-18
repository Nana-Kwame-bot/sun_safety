import 'dart:convert';
import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sun_safety/address/address.dart';
import 'package:sun_safety/repository/goelocation.dart';
part 'address_state.dart';

class AddressCubit extends HydratedCubit<AddressState> {
  AddressCubit(this._locationRepository)
      : super(const AddressState(Address(), AddressEnum.loading));

  final UserLocationRepository _locationRepository;

  Future<void> getAddress() async {
    emit(state.copyWith(addressEnum: AddressEnum.loading));
    final Position? _position =
        await _locationRepository.getGeoLocationPosition();

    try {
      final _addressData =
          await _locationRepository.getAddressFromLatLong(_position!);

      emit(state.copyWith(
          address: _addressData, addressEnum: AddressEnum.success));
    } on Exception catch (e) {
      log(e.toString());
      emit(state.copyWith(addressEnum: AddressEnum.failure));
    }
  }

  @override
  AddressState? fromJson(Map<String, dynamic> json) {
    try {
      return AddressState.fromMap(json);
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  Map<String, dynamic>? toJson(AddressState state) {
    state.toJson();
  }
}
