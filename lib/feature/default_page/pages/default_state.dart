// ignore_for_file: unused_import

import 'package:equatable/equatable.dart';
import 'package:shared_core/data/default/response_data.dart' as prefix0;
import 'package:shared_core/data/default/response.dart' as prefix0;
import 'package:shared_core/data/default/request.dart' as prefix0;

class DefaultState extends Equatable {
  final prefix0.Defaults defaults;

  const DefaultState({required this.defaults});

  factory DefaultState.initial() => DefaultState(defaults: prefix0.Defaults());

  DefaultState copyWith({
    int? yearId,
    int? placeId,
    int? cashierId,
    int? languageId,
    int? currencyId,
  }) {
    return DefaultState(
      defaults: prefix0.Defaults(
        yearId: yearId ?? defaults.yearId,
        placeId: placeId ?? defaults.placeId,
        cashierId: cashierId ?? defaults.cashierId,
        languageId: languageId ?? defaults.languageId,
        currencyId: currencyId ?? defaults.currencyId,
        managementAccountId: defaults.managementAccountId,
      ),
    );
  }

  @override
  List<Object?> get props => [defaults];
}
