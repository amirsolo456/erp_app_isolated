// ignore_for_file: unused_import

import 'package:equatable/equatable.dart';
import 'package:shared_core/data/default/mng/select/language/response_data.dart' as prefix0;
import 'package:shared_core/data/default/mng/select/language/response.dart' as prefix0;
import 'package:shared_core/data/default/mng/select/language/request.dart' as prefix0;


abstract class LanguageState extends Equatable {
  const LanguageState();

  @override
  List<Object?> get props => [];
}

class LanguageInitial extends LanguageState {
  const LanguageInitial();
}

class LanguageLoading extends LanguageState {
  const LanguageLoading();
}

class LanguageLoaded extends LanguageState {
  final List<prefix0.Language> languages;
  const LanguageLoaded(this.languages);

  @override
  List<Object?> get props => [languages];
}

class LanguageError extends LanguageState {
  final String? message;
  const LanguageError([this.message]);

  @override
  List<Object?> get props => [message];
}
