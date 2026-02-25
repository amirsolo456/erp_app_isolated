import 'package:equatable/equatable.dart';
import 'package:services_package/storage/domain/usecases/storage_service.dart';

abstract class MenuEvent extends Equatable {
  const MenuEvent();

  @override
  List<Object?> get props => [];
}

class LoadMenuEvent extends MenuEvent {
  const LoadMenuEvent();
}

class MenuErrorEvent extends MenuEvent {
  final String? message;

  const MenuErrorEvent({this.message});
}

class MenuTokenNeedEvent extends MenuEvent {
  final StorageService? storageService;

  const MenuTokenNeedEvent({this.storageService});
}
