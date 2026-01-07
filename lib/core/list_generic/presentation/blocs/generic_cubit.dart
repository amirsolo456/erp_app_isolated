import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_core/index.dart' as prefix0;

part 'generic_state.dart';

abstract class GenericBloc<
  T extends prefix0.BaseResponse<D>,
  D,
  C extends prefix0.BaseRequest
>
    extends Cubit<GenericState> {
  GenericBloc() : super(const LoadingState());

  Future<T> fetchData();

  Future<void> loadData() async {
    emit(const LoadingState());
    try {
      final data = await fetchData();
      emit(LoadedState<D>(data.data ?? []));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> refresh() async => loadData();

  void clearError() {
    if (state is ErrorState) {
      loadData();
    }
  }
}

abstract class SpecializedbaseBloc<
  T extends prefix0.BaseResponse<D>,
  D,
  C extends prefix0.BaseRequest
>
    extends GenericBloc<T, D, C> {
  SpecializedbaseBloc() : super();

  Future<void> loadWithParams(C params);

  Future<void> filterData(String query);
}
