import 'package:equatable/equatable.dart';

abstract class DefaultEvent extends Equatable {
  const DefaultEvent();

  @override
  List<Object?> get props => [];
}

class YearChanged extends DefaultEvent {
  final int yearId;
  const YearChanged(this.yearId);

  @override
  List<Object?> get props => [yearId];
}

class PlaceChanged extends DefaultEvent {
  final int placeId;
  const PlaceChanged(this.placeId);

  @override
  List<Object?> get props => [placeId];
}

class CashierChanged extends DefaultEvent {
  final int cashierId;
  const CashierChanged(this.cashierId);

  @override
  List<Object?> get props => [cashierId];
}

class CurrencyChanged extends DefaultEvent {
  final int currencyId;
  const CurrencyChanged(this.currencyId);

  @override
  List<Object?> get props => [currencyId];
}

class LanguageChanged extends DefaultEvent {
  final int languageId;
  const LanguageChanged(this.languageId);

  @override
  List<Object?> get props => [languageId];
}
class DefaultChanged extends DefaultEvent {
  final int def;
  const DefaultChanged(this.def);

  @override
  List<Object?> get props => [def];
}
