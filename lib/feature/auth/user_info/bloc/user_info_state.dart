import 'package:equatable/equatable.dart';
import 'package:shared_core/data/auth/user/user_information/response_data.dart'
    as response;

abstract class UserInfoState extends Equatable {
  const UserInfoState();

  @override
  List<Object?> get props => [];
}

class UserInfoInitial extends UserInfoState {
  const UserInfoInitial();
}

class UserInfoLoadingState extends UserInfoState {
  const UserInfoLoadingState();
}

class UserInfoLoadedState extends UserInfoState {
  final List<response.ResponseData> userInfos;

  const UserInfoLoadedState(this.userInfos);

  @override
  List<Object?> get props => [userInfos];
}


// class UserInfoLoadedState extends UserInfoState {
//
//   final response.ResponseData userInfos;
//
//   UserInfoLoadedState(this.userInfos);
//
//   @override
//   List<Object?> get props => [userInfos];
// }

class UserInfoErrorState extends UserInfoState {
  final String? message;

  const UserInfoErrorState([this.message]);

  @override
  List<Object?> get props => [message];
}
