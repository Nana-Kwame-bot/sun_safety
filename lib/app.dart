import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sun_safety/address/cubit/address_cubit.dart';
import 'package:sun_safety/cloud_coverage/cubit/cloud_coverage_cubit.dart';
import 'package:sun_safety/elevation/cubit/elevation_cubit.dart';
import 'package:sun_safety/presentation/home.dart';
import 'package:sun_safety/repository/cloud_coverage_repository.dart';
import 'package:sun_safety/repository/elevation_repository.dart';
import 'package:sun_safety/repository/goelocation.dart';
import 'package:sun_safety/repository/uv_repository.dart';
import 'package:http/http.dart' as http;
import 'package:sun_safety/theme/cubit/theme_cubit.dart';
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
        RepositoryProvider<CloudCoverageRepository>(
          create: (context) {
            return CloudCoverageRepository();
          },
        ),
        RepositoryProvider<UserLocationRepository>(
          create: (context) {
            return UserLocationRepository();
          },
        ),
        RepositoryProvider<ElevationRepository>(
          create: (context) {
            return ElevationRepository(httpClient: http.Client());
          },
        ),
        RepositoryProvider<UVRepository>(
          create: (context) {
            return UVRepository(httpClient: http.Client())..getNow();
          },
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) {
              return ThemeCubit()..onAppStarted();
            },
          ),
          BlocProvider(
            create: (context) {
              return CloudCoverageCubit(
                RepositoryProvider.of<CloudCoverageRepository>(context),
              )..getData();
            },
          ),
          BlocProvider(
            create: (context) {
              return ElevationCubit(
                RepositoryProvider.of<ElevationRepository>(context),
                RepositoryProvider.of<UserLocationRepository>(context),
              )..fetchElevationData();
            },
          ),
          BlocProvider(
            create: (context) {
              return AddressCubit(
                RepositoryProvider.of<UserLocationRepository>(context),
              )..getAddress();
            },
          ),
          BlocProvider(
            create: (context) {
              return UvCubit(
                RepositoryProvider.of<UVRepository>(context),
                RepositoryProvider.of<UserLocationRepository>(context),
                BlocProvider.of<ElevationCubit>(context),
                BlocProvider.of<CloudCoverageCubit>(context),
              )..fetchUV();
            },
          ),
        ],
        child: Builder(builder: (context) {
          return NeumorphicApp(
            title: 'Sun Safety',
            themeMode: context.select((ThemeCubit cubit) {
              return cubit.state.themeMode;
            }),
            theme: const NeumorphicThemeData(
              baseColor: Color(0xFFFFFFFF),
              lightSource: LightSource.topLeft,
              depth: 10,
              accentColor: Colors.grey,
            ),
            darkTheme: const NeumorphicThemeData(
              baseColor: Color(0xFF3E3E3E),
              lightSource: LightSource.topLeft,
              depth: 6,
              accentColor: Colors.grey,
            ),
            home: const Home(),
          );
        }),
      ),
    );
  }
}
