import 'package:equatable/equatable.dart';
import 'package:shared_core/data/default/mng/select/place/response_data.dart'
    as prefix0;

abstract class PlaceState extends Equatable {
  const PlaceState();

  @override
  List<Object?> get props => [];
}

class PlaceInitial extends PlaceState {
  const PlaceInitial();
}

class PlaceLoading extends PlaceState {
  const PlaceLoading();
}

class PlaceLoaded extends PlaceState {
  final List<prefix0.ResponseData> places;
  const PlaceLoaded(this.places);

  @override
  List<Object?> get props => [places];
}

class PlaceError extends PlaceState {
  final String? message;
  const PlaceError([this.message]);

  @override
  List<Object?> get props => [message];
}
