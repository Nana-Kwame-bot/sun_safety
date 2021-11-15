import 'package:equatable/equatable.dart';

class Results extends Equatable {
  // ignore: prefer_const_constructors_in_immutables
  Results({
    required this.elevation,
  });
  late final int elevation;

  Results.fromJson(Map<String, dynamic> json) {
    elevation = json['elevation'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['elevation'] = elevation;
    return _data;
  }

  @override
  List<Object> get props => [elevation];

  Results copyWith({
    int? elevation,
  }) {
    return Results(
      elevation: elevation ?? this.elevation,
    );
  }

  @override
  bool get stringify => true;
}
