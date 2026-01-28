import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:erp_app/feature/com/person/presentation/blocs/person_bloc/person_list_state.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:services_package/com/person/person_service.dart';
import 'package:shared_core/data/com/person/request.dart' as prefix0;
import 'package:shared_core/data/com/person/response.dart' as prefix0;

part 'person_list_event.dart';

class PersonListBloc extends Bloc<PersonListEvent, PersonListState> {
  final PersonService personService;
  final pageCacheProvider = GetIt.instance<AppNotifier>();
  PersonListBloc({required this.personService})
    : super(PersonListInitialState()) {
    on<LoadPersonListEvent>(_onLoadPersonList);
    on<PersonListInitialEvent>(_onPersonListInitial);

    /* on<LoadPersonListState>((event, emit) async {
      if (event is PersonListInitialEvent) {
        try {
          final Response? response = await personService.get(
            Request(),
            (json) => Response.fromJson(json),
          );
          emit(PersonListInitialState());
          if (response != null && response.data != null) {
            emit(LoadDataSource(response));
          } else {
            emit(LoadDataError());
          }
        } catch (e) {
          emit(LoadDataError());
        } finally {}
      } else if (event is FilterDataEvent) {
        try {
          emit(FilterDataLoading());
          await Future.delayed(Duration(seconds: 2));
          emit(FilterDataSuccess());
        } catch (e) {
          emit(FilterDataError());
        }
      } else if (event is SortDataEvent) {
        try {
          emit(SortDataLoading());
          await Future.delayed(Duration(seconds: 2));
          emit(SortDataSuccess());
        } catch (e) {
          emit(SortDataError());
        }
      } else if (event is PaginationDataEvent) {
        try {
          emit(PaginationDataLoading());
          await Future.delayed(Duration(seconds: 2));
          emit(PaginationDataSuccess());
        } catch (e) {
          emit(PaginationDataError());
        }
      } else {}
    });*/
  }

  Future<void> _onPersonListInitial(
    PersonListInitialEvent event,
    Emitter<PersonListState> emit,
  ) async {
    final completer = Completer<void>();
    pageCacheProvider.registerPendingOperation(completer);

    try {
      await Future.delayed(const Duration(seconds: 2));

      if (!completer.isCompleted) {
        completer.complete();
        pageCacheProvider.unregisterPendingOperation(completer);
      }
    } catch (e) {
      if (!completer.isCompleted) {
        completer.completeError(e);
        pageCacheProvider.unregisterPendingOperation(completer);
      }
    }
  }

  Future<void> _onLoadPersonList(
    LoadPersonListEvent event,
    Emitter<PersonListState> emit,
  ) async {
    emit(const PersonListLoadingState());
    try {
      final persons = await personService.get(
        prefix0.Request(repoViewId: 0),
        (json) => prefix0.Response.fromJson(json),
      );
      emit(PersonListLoadDataSourceState(data: persons));
    } catch (e) {
      // emit(MenuErrorState(e.toString()));
    }
  }
}
