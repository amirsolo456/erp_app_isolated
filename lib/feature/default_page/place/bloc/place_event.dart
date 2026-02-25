

import 'package:equatable/equatable.dart';

abstract class PlaceEvent extends Equatable {
  const PlaceEvent();


  @override
  List<Object?> get props => [];
}


class LoadPlaceEvent extends PlaceEvent {
  const LoadPlaceEvent();
}