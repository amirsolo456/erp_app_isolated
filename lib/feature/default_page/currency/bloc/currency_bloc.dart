import 'package:bloc/bloc.dart';
import 'package:services_package/index.dart';
import 'package:shared_core/data/default/com/select/currency/request.dart' as prefix0;
import 'package:shared_core/data/default/com/select/currency/response.dart' as prefix0;
import 'package:services_package/default/com/select/currency_service.dart';

import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  final CurrencyService getSelectCurrencyUseCase;

  CurrencyBloc({required this.getSelectCurrencyUseCase})
    : super(const SelectCurrencyInitial()) {
    on<LoadCurrencyEvent>(_onLoadSelectCurrency);
  }

  Future<void> _onLoadSelectCurrency(
    LoadCurrencyEvent event,
    Emitter<CurrencyState> emit,
  ) async {
    emit(const CurrencyLoading());
    try {
      final selectCurrencys = await getSelectCurrencyUseCase.get(
        prefix0.Request(repoViewId: RepoViewIds.yearId, showMode: 10),
        (json) => prefix0.Response.fromJson(json),
      );

      if (selectCurrencys == null || selectCurrencys.data == null) {
        emit(CurrencyError('Select Currencys Is Null'));
        return;
      }
      emit(CurrencyLoaded(selectCurrencys.data ?? []));
    } catch (e) {
      emit(CurrencyError(e.toString()));
    }
  }
}
