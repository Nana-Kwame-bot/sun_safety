import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sun_safety/presentation/home.dart';
import 'package:sun_safety/repository/goelocation.dart';
import 'package:sun_safety/repository/uv_repository.dart';
import 'package:http/http.dart' as http;
import 'package:sun_safety/uv/cubit/uv_cubit.dart';

class UVApp extends StatelessWidget {
  const UVApp({
    Key? key,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UVRepository>(
          create: (context) {
            return UVRepository(httpClient: http.Client())..getNow();
          },
        ),
        RepositoryProvider<UserLocationRepository>(
          create: (context) {
            return UserLocationRepository();
          },
        ),
      ],
      child: BlocProvider(
        create: (context) {
          return UvCubit(
            RepositoryProvider.of<UVRepository>(context),
            RepositoryProvider.of<UserLocationRepository>(context),
          )..fetchUV();
        },
        child: const NeumorphicApp(
          title: 'Sun Safetpy',
          themeMode: ThemeMode.light,
          theme: NeumorphicThemeData(
            baseColor: Color(0xFFFFFFFF),
            lightSource: LightSource.topLeft,
            depth: 10,
            accentColor: Colors.grey,
          ),
          darkTheme: NeumorphicThemeData(
            baseColor: Color(0xFF3E3E3E),
            lightSource: LightSource.topLeft,
            depth: 6,
            accentColor: Colors.grey,
          ),
          home: Home(),
        ),
      ),
    );
  }
}
