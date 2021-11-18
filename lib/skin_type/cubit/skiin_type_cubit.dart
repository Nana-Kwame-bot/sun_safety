import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'skiin_type_state.dart';

class SkinTypeCubit extends HydratedCubit<SkinTypeState> {
  SkinTypeCubit() : super(const SkinTypeState(0));

  void setBurnIndex({required int burnIndex}) {
    emit(state.copyWith(burnIndex: burnIndex));
  }

  String getVitaminD({required double indexLevel}) {
    // final double indexLevel = state.currentUV;
    switch (state.burnIndex) {
      case 0:
        if (0 <= indexLevel && indexLevel <= 3) {
          return "15-20m";
        } else if (3 <= indexLevel && indexLevel <= 6) {
          return "10-15m";
        } else if (6 <= indexLevel && indexLevel <= 8) {
          return "5-10m";
        } else if (8 <= indexLevel && indexLevel <= 11) {
          return "2-8m";
        } else if (indexLevel > 11) {
          return "1-5m";
        }
        return "15-20m";
      case 1:
        if (0 <= indexLevel && indexLevel <= 3) {
          return "20-30m";
        } else if (3 <= indexLevel && indexLevel <= 6) {
          return "15-20m";
        } else if (6 <= indexLevel && indexLevel <= 8) {
          return "10-15m";
        } else if (8 <= indexLevel && indexLevel <= 11) {
          return "5-10m";
        } else if (indexLevel > 11) {
          return "2-8m";
        }
        return "20-30m";
      case 2:
        if (0 <= indexLevel && indexLevel <= 3) {
          return "30-40m";
        } else if (3 <= indexLevel && indexLevel <= 6) {
          return "20-30m";
        } else if (6 <= indexLevel && indexLevel <= 8) {
          return "15-20m";
        } else if (8 <= indexLevel && indexLevel <= 11) {
          return "10-15m";
        } else if (indexLevel > 11) {
          return "5-10m";
        }
        return "30-40m";
      case 3:
        if (0 <= indexLevel && indexLevel <= 3) {
          return "40-60m";
        } else if (3 <= indexLevel && indexLevel <= 6) {
          return "30-40m";
        } else if (6 <= indexLevel && indexLevel <= 8) {
          return "20-30m";
        } else if (8 <= indexLevel && indexLevel <= 11) {
          return "15-20m";
        } else if (indexLevel > 11) {
          return "10-15m";
        }
        return "40-60m";
      case 4:
        if (0 <= indexLevel && indexLevel <= 3) {
          return "60-80m";
        } else if (3 <= indexLevel && indexLevel <= 6) {
          return "40-60m";
        } else if (6 <= indexLevel && indexLevel <= 8) {
          return "30-40m";
        } else if (8 <= indexLevel && indexLevel <= 11) {
          return "20-30m";
        } else if (indexLevel > 11) {
          return "15-20m";
        }
        return "60-80m";
      case 5:
        if (0 <= indexLevel && indexLevel <= 3) {
          return "";
        } else if (3 <= indexLevel && indexLevel <= 6) {
          return "60-80m";
        } else if (6 <= indexLevel && indexLevel <= 8) {
          return "40-60m";
        } else if (8 <= indexLevel && indexLevel <= 11) {
          return "30-40m";
        } else if (indexLevel > 11) {
          return "20-30m";
        }
        return "";
      default:
        return "";
    }
  }

  double getTimeToBurn({required double currentUV}) {
    if (currentUV.isInfinite || currentUV.isNaN || currentUV <= 0) {
      currentUV = 1;
    }
    switch (state.burnIndex) {
      case 0:
        return (200 * 2.5) / (3 * currentUV);

      case 1:
        return (200 * 3) / (3 * currentUV);

      case 2:
        return (200 * 4) / (3 * currentUV);

      case 3:
        return (200 * 5) / (3 * currentUV);

      case 4:
        return (200 * 8) / (3 * currentUV);

      case 5:
        return (200 * 15) / (3 * currentUV);

      default:
        return 0.0;
    }
  }

  @override
  SkinTypeState? fromJson(Map<String, dynamic> json) {
    final int burnIndex = json['burnIndex'] as int;

    return SkinTypeState(burnIndex);
  }

  @override
  Map<String, dynamic>? toJson(SkinTypeState state) {
    return {
      'burnIndex': state.burnIndex,
    };
  }
}
