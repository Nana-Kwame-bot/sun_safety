// import 'dart:convert';

// import 'package:equatable/equatable.dart';

// class CloudCoverage extends Equatable {
//   final String dropdownValue;
//   final List<String> items;

//   const CloudCoverage(this.dropdownValue, this.items);

//   CloudCoverage copyWith({
//     String? dropdownValue,
//     List<String>? items,
//   }) {
//     return CloudCoverage(
//       dropdownValue ?? this.dropdownValue,
//       items ?? this.items,
//     );
//   }

//   @override
//   List<Object> get props => [dropdownValue, items];

//   Map<String, dynamic> toMap() {
//     return {
//       'dropdownValue': dropdownValue,
//       'items': items,
//     };
//   }

//   factory CloudCoverage.fromMap(Map<String, dynamic> map) {
//     return CloudCoverage(
//       map['dropdownValue'],
//       List<String>.from(map['items']),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory CloudCoverage.fromJson(String source) =>
//       CloudCoverage.fromMap(json.decode(source));

//        @override
//   bool get stringify => true;
// }
