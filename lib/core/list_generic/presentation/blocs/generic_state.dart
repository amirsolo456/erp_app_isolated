part of 'generic_cubit.dart';

abstract class GenericState<D> extends Equatable {
  const GenericState();

  @override
  List<D> get props => [];
}

class LoadingState extends GenericState {
  const LoadingState();
}

class LoadedState<D> extends GenericState {
  const LoadedState(this.data);

  final List<D> data;

  @override
  List<D> get props => data;
}

class ErrorState extends GenericState {
  const ErrorState(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}
