import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:services_package/api_client_service.dart';

import 'default_event.dart';
import 'default_state.dart';

class DefaultBloc extends Bloc<DefaultEvent, DefaultState> {
  final ApiSettings apiSettings;

  DefaultBloc(this.apiSettings) : super(DefaultState.initial()) {
    on<YearChanged>((event, emit) {
      final newState = state.copyWith(yearId: event.yearId);
      apiSettings.appDefaults.yearId = event.yearId;
      emit(newState);
    });

    on<PlaceChanged>((event, emit) {
      final newState = state.copyWith(placeId: event.placeId);
      apiSettings.appDefaults.placeId = event.placeId;
      emit(newState);
    });

    on<CashierChanged>((event, emit) {
      final newState = state.copyWith(cashierId: event.cashierId);
      apiSettings.appDefaults.cashierId = event.cashierId;
      emit(newState);
    });

    on<LanguageChanged>((event, emit) {
      final newState = state.copyWith(languageId: event.languageId);
      apiSettings.appDefaults.languageId = event.languageId;
      emit(newState);
    });

    on<CurrencyChanged>((event, emit) {
      final newState = state.copyWith(currencyId: event.currencyId);
      apiSettings.appDefaults.currencyId = event.currencyId;
      emit(newState);
    });
  }
}
