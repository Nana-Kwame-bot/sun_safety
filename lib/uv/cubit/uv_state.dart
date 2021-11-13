part of 'uv_cubit.dart';

enum UVStatus { loading, success, failure }

class UVState extends Equatable {
  const UVState(this.uv, {this.status = UVStatus.loading});

  final UV uv;
  final UVStatus status;

  UVState copyWith({
    UV? uv,
    UVStatus? status,
  }) {
    return UVState(
      uv ?? this.uv,
      status: status ?? this.status,
    );
  }

  @override
  List<Object> get props => [uv];

  @override
  bool get stringify => true;
}
