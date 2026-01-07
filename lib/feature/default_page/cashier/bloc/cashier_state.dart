import 'package:equatable/equatable.dart';
import 'package:shared_core/data/default/trh/select/cashier/response_data.dart' as prefix0;

abstract class CashierState extends Equatable {
  const CashierState();

  @override
  List<Object?> get props => [];
}

class CashierInitial extends CashierState {
  const CashierInitial();
}

class CashierLoading extends CashierState {
  const CashierLoading();
}

class CashierLoaded extends CashierState {
  final List<prefix0.ResponseData> Cashier;
  const CashierLoaded(this.Cashier);

  @override
  List<Object?> get props => [Cashier];
}

class CashierError extends CashierState {
  final String? message;
  const CashierError([this.message]);

  @override
  List<Object?> get props => [message];
}
