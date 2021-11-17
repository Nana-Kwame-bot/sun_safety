part of 'theme_cubit.dart';

class ThemeState extends Equatable {
  const ThemeState(this.themeMode);

  final ThemeMode themeMode;

  @override
  List<Object> get props => [themeMode];

  ThemeState copyWith({
    ThemeMode? themeMode,
  }) {
    return ThemeState(
      themeMode ?? this.themeMode,
    );
  }

  @override
  bool get stringify => true;
}
