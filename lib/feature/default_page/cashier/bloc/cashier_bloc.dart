// ignore_for_file: unused_import

import 'package:bloc/bloc.dart';
import 'package:services_package/repo_view_id/repo_view_ids.dart';
import 'package:shared_core/data/default/trh/select/cashier/response_data.dart' as prefix0;
import 'package:shared_core/data/default/trh/select/cashier/response.dart' as prefix0;
import 'package:shared_core/data/default/trh/select/cashier/request.dart' as prefix0;
import 'package:services_package/default/trh/select/cashier_service.dart';

import 'cashier_event.dart';
import 'cashier_state.dart';

class CashierBloc extends Bloc<CashierEvent, CashierState> {
  final CashierService getCashierUseCase;

  CashierBloc({required this.getCashierUseCase})
    : super(const CashierInitial()) {
    on<LoadCashierEvent>(_onLoadCashier);
  }

  Future<void> _onLoadCashier(
    LoadCashierEvent event,
    Emitter<CashierState> emit,
  ) async {
    emit(const CashierLoading());
    try {
      final Cashier = await getCashierUseCase.get(
        prefix0.Request(repoViewId: RepoViewIds.cashRepoId,),
        (json) => prefix0.Response.fromJson(json),
      );

      if (Cashier == null || Cashier.data == null) {
        emit(CashierError(' Cashier Is Null'));
        return;
      }
      emit(CashierLoaded(Cashier.data ?? []));
    } catch (e) {
      emit(CashierError(e.toString()));
    }
  }
}
