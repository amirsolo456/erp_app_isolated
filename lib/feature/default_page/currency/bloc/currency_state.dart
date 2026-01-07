import 'package:equatable/equatable.dart';
import 'package:shared_core/data/default/com/select/currency/response_data.dart' as prefix0;

abstract class CurrencyState extends Equatable {
  const CurrencyState();

  @override
  List<Object?> get props => [];
}

class SelectCurrencyInitial extends CurrencyState {
  const SelectCurrencyInitial();
}

class CurrencyLoading extends CurrencyState {
  const CurrencyLoading();
}

class CurrencyLoaded extends CurrencyState {
  final List<prefix0.ResponseData> selectCurrency;
  const CurrencyLoaded(this.selectCurrency);

  @override
  List<Object?> get props => [selectCurrency];
}

class CurrencyError extends CurrencyState {
  final String? message;
  const CurrencyError([this.message]);

  @override
  List<Object?> get props => [message];
}
