/*
// ignore_for_file: unused_import

import 'package:bloc/bloc.dart';
import 'package:shared_core/data/default/mng/select/language/response_data.dart';
import 'package:shared_core/data/default/mng/select/language/response.dart';
import 'package:shared_core/data/default/mng/select/language/request.dart';
import 'package:services_package/Repo_ViewId/repo_view_id.dart';
import 'package:services_package/default/mng/select/language_service.dart';

import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  final LanguageService getLanguageUseCase;

  LanguageBloc({required this.getLanguageUseCase})
    : super(const LanguageInitial()) {
    on<LoadLanguageEvent>(_onLoadLanguage);
  }

  Future<void> _onLoadLanguage(
    LoadLanguageEvent event,
    Emitter<LanguageState> emit,
  ) async {
    emit(const LanguageLoading());
    try {
      final languages = await getLanguageUseCase.get(
        Request(repoViewId: AppConstants().languageRepoViewId),
        (json) => Response.fromJson(json),
      );

      if (languages == null || languages.data == null) {
        emit(LanguageError('Language Is Null'));
        return;
      }
      emit(LanguageLoaded(languages.data ?? []));
    } catch (e) {
      emit(LanguageError(e.toString()));
    }
  }
}
*/
