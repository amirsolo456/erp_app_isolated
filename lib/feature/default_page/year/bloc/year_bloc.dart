// ignore_for_file: unused_import

import 'package:bloc/bloc.dart';
import 'package:services_package/default/com/select/year_service.dart';
import 'package:services_package/index.dart';
import 'package:shared_core/data/default/com/select/year/request.dart'
    as prefix0;
import 'package:shared_core/data/default/com/select/year/response.dart'
    as prefix0;
import 'package:shared_core/data/default/com/select/year/response_data.dart'
    as prefix0;

import 'year_event.dart';
import 'year_state.dart';

class YearBloc extends Bloc<SelectYearEvent, YearState> {
  final YearService getSelectYearUseCase;
  final int? ShowMode;

  YearBloc({required this.getSelectYearUseCase, this.ShowMode})
    : super(const YearInitial()) {
    on<LoadYearEvent>(_onLoadSelectYear);
  }

  Future<void> _onLoadSelectYear(
    LoadYearEvent event,
    Emitter<YearState> emit,
  ) async {
    emit(const YearLoading());
    try {
      final selectYears = await getSelectYearUseCase.get(
        prefix0.Request(
          repoViewId:RepoViewIds.yearId,
          showMode: ShowMode ?? 10,
        ),
        (json) => prefix0.Response.fromJson(json),
      );

      if (selectYears == null || selectYears.data == null) {
        emit(YearError('Select Years Is Null'));
        return;
      }
      emit(YearLoaded(selectYears.yearData ?? []));
    } catch (e) {
      emit(YearError(e.toString()));
    }
  }
}
