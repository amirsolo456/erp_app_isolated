
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:models_package/index.dart';
import 'package:services_package/storage/domain/usecases/storage_service.dart';
import '../../../core/network/injection_container.dart';
import 'default_event.dart';
import 'default_state.dart';

class DefaultBloc extends Bloc<DefaultEvent, DefaultState> {
  final ApiSettings apiSettings;

  DefaultBloc(this.apiSettings) : super(DefaultState.initial()) {
    on<YearChanged>((event, emit) {
      final newState = state.copyWith(yearId: event.yearId);
      apiSettings.appDefaults.yearId = event.yearId;
      sl<StorageService>().saveCurrentYear(event.yearId);
      sl<AppNotifier>().setCurrentYear(event.yearId);
      emit(newState);
    });

    on<PlaceChanged>((event, emit) {
      final newState = state.copyWith(placeId: event.placeId);
      apiSettings.appDefaults.placeId = event.placeId;
      sl<StorageService>().savePlace(event.placeId);
      sl<AppNotifier>().setCurrentPlace(event.placeId);
      emit(newState);
    });

    on<CashierChanged>((event, emit) {
      final newState = state.copyWith(cashierId: event.cashierId);
      apiSettings.appDefaults.cashierId = event.cashierId;
      sl<StorageService>().saveCashier(event.cashierId);
      sl<AppNotifier>().setCurrentCashier(event.cashierId);
      emit(newState);
    });

    on<LanguageChanged>((event, emit) {
      final newState = state.copyWith(languageId: event.languageId);
      apiSettings.appDefaults.languageId = (event.languageId == 'en' ? 1 : 0);
      sl<StorageService>().saveLanguage(
        LanguageModel(languageCode: event.languageId),
      );
      // sl<AppNotifier>().setCurrentLocal(Locale(event.languageId));
      emit(newState);
    });

    on<CurrencyChanged>((event, emit) {
      final newState = state.copyWith(currencyId: event.currencyId);
      apiSettings.appDefaults.currencyId = event.currencyId;
      sl<StorageService>().saveCurrency(event.currencyId);
      sl<AppNotifier>().setCurrentCurrency(event.currencyId);
      emit(newState);
    });

    on<DefaultChanged>((event, emit) {
      final newState = state.copyWith(yearId: event.def);
      emit(newState);
    });
  }
}
