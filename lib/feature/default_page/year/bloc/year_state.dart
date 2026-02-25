import 'package:equatable/equatable.dart';
import 'package:shared_core/data/default/com/select/year/response_data.dart'
    as prefix0;

abstract class YearState extends Equatable {
  const YearState();

  @override
  List<Object?> get props => [];
}

class YearInitial extends YearState {
  const YearInitial();
}

class YearLoading extends YearState {
  const YearLoading();
}

class YearLoaded extends YearState {
  final List<prefix0.ResponseData> selectYears;
  const YearLoaded(this.selectYears);

  @override
  List<Object?> get props => [selectYears];
}

class YearError extends YearState {
  final String? message;
  const YearError([this.message]);

  @override
  List<Object?> get props => [message];
}
