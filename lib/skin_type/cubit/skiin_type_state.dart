part of 'skiin_type_cubit.dart';

class SkinTypeState extends Equatable {
  const SkinTypeState(this.burnIndex);

  final int burnIndex;

  @override
  List<Object> get props => [burnIndex];

  SkinTypeState copyWith({
    int? burnIndex,
  }) {
    return SkinTypeState(
      burnIndex ?? this.burnIndex,
    );
  }

  @override
  bool get stringify => true;
}
