import 'package:equatable/equatable.dart';
import 'package:shared_core/data/auth/menu/response_data.dart' as prefix0;

abstract class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object?> get props => [];
}

class MenuInitial extends MenuState {
  const MenuInitial();
}

class MenuLoadingState extends MenuState {
  const MenuLoadingState();
}

class MenuLoadedState extends MenuState {
  final List<prefix0.ResponseData> menus;

  const MenuLoadedState(this.menus);

  @override
  List<Object?> get props => [menus];
}

class MenuErrorState extends MenuState {
  final String? message;

  const MenuErrorState([this.message]);

  @override
  List<Object?> get props => [message];
}

class MenuTokenNeedState extends MenuState {
  const MenuTokenNeedState();
  @override
  List<Object?> get props => [];
}
