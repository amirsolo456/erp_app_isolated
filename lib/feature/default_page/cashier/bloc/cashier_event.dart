import 'package:equatable/equatable.dart';

abstract class CashierEvent extends Equatable {
  const CashierEvent();

  @override
  List<Object?> get props => [];
}

class LoadCashierEvent extends CashierEvent {
  const LoadCashierEvent();
}
