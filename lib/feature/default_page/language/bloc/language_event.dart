

import 'package:equatable/equatable.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();


  @override
  List<Object?> get props => [];
}


class LoadLanguageEvent extends LanguageEvent {
  const LoadLanguageEvent();
}