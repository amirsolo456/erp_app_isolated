import 'package:equatable/equatable.dart';

abstract class SelectYearEvent extends Equatable {
  const SelectYearEvent();

  @override
  List<Object?> get props => [];
}

class LoadYearEvent extends SelectYearEvent {
  const LoadYearEvent();
}
