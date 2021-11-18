part of 'skiin_type_cubit.dart';

class SkiinTypeState extends Equatable {
  const SkiinTypeState(this.burnIndex);

  final int burnIndex;

  @override
  List<Object> get props => [burnIndex];

  SkiinTypeState copyWith({
    int? burnIndex,
  }) {
    return SkiinTypeState(
      burnIndex ?? this.burnIndex,
    );
  }

  @override
  bool get stringify => true;
}
