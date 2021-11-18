part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  const ThemeState(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];

  @override
  bool get stringify => true;

  /// Returns a JSON like Map of this User object
  Map<String, dynamic> toJson() {
    return {
      "theme": themeMode.index,
    };
  }

  /// Returns [ThemeState] build from a map with informationen
  factory ThemeState.fromJson(Map<String, dynamic> parsedJson) {
    return ThemeState(
      ThemeMode.values.elementAt(
        parsedJson['theme'],
      ),
    );
  }

  ThemeState copyWith({
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      themeMode ?? this.themeMode,
    );
  }
}
