import 'package:equatable/equatable.dart';
import 'package:services_package/storage/domain/usecases/storage_service.dart';

abstract class UserInfoEvent extends Equatable {
  const UserInfoEvent();

  @override
  List<Object?> get props => [];
}

class UserInfoSubmitEvent extends UserInfoEvent {
  final String firstName;
  final String lastName;


  UserInfoSubmitEvent({required this.firstName, required this.lastName});

  @override
  List<Object?> get props => [firstName, lastName];
}
// class UserInfoLoadingEvent extends UserInfoEvent {
//   const UserInfoLoadingEvent();
// }

// class UserInfoLoadedEvent extends UserInfoEvent {
//   const UserInfoLoadedEvent();
// }

class UserInfoTokenNeedEvent extends UserInfoEvent {
  final StorageService? storageService;

  const UserInfoTokenNeedEvent({this.storageService});
}

// class UserInfoErrorEvent extends UserInfoEvent {
//   final String? message;
//
//   const UserInfoErrorEvent(this.message);
// }
