import 'package:flutter/cupertino.dart' show immutable;
import 'package:shared_core/data/com/person/request.dart' as prefix0;
import 'package:shared_core/data/com/person/response.dart' as prefix0;
import 'package:shared_core/data/com/person/response_data.dart' as prefix0;

import '../../../../../../core/list_generic/presentation/blocs/generic_cubit.dart';
import '../../../domain/repositories/person_repository.dart';

part 'search_person_event.dart';
part 'search_person_state.dart';

class SearchPersonBloc
    extends
        GenericBloc<prefix0.Response, prefix0.ResponseData, prefix0.Request> {
  final PersonRepository _repository;

  SearchPersonBloc(this._repository) : super();

  Future<void> loadWithParams(prefix0.Request params) async {
    emit(const LoadingState());
    try {
      final data = await _repository.searchUsers(params);
      emit(LoadedState<prefix0.ResponseData>(data.data ?? []));
    } catch (e) {
      emit(ErrorState(e.toString()));
    }
  }

  Future<void> filterData(String query) async {
    final currentState = state;
    if (currentState is LoadedState<prefix0.ResponseData>) {
      final filteredUsers = currentState.data
          .where(
            (user) =>
                user.fullName?.toLowerCase().contains(query.toLowerCase()) ??
                false,
          )
          .toList();

      emit(LoadedState<prefix0.ResponseData>(filteredUsers));
    }
  }

  @override
  Future<prefix0.Response> fetchData() async {
    return await _repository.getAllUsers();
  }
}
