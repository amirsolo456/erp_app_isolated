import 'package:bloc/bloc.dart';
import 'package:erp_app/feature/auth/user_info/bloc/user_info_event.dart';
import 'package:erp_app/feature/auth/user_info/bloc/user_info_state.dart';
import 'package:models_package/base/api_settings.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:services_package/auth/user/user_info/user_info_service.dart';
import 'package:shared_core/data/auth/user/user_information/user_information.dart';

import '../../../../core/network/injection_container.dart';

class UserInfoBloc extends Bloc<UserInfoEvent, UserInfoState> {
  final UserInfoService service;

  UserInfoBloc(this.service) : super(const UserInfoInitial()) {
    on<UserInfoSubmitEvent>(_onSubmitUserInfo);
  }

  Future<void> _onSubmitUserInfo(
    UserInfoSubmitEvent event,
    Emitter<UserInfoState> emit,
  ) async {
    emit(const UserInfoLoadingState());

    try {
      final userInfo = await service.insert(
        Request(
            firstName: event.firstName,
            lastName: event.lastName,
             userId: 12),
        
        Response.fromJson,
      );

    if (userInfo == null) {
    emit(UserInfoErrorState('UserInfo Is Null'));
    return;
    }

    if (userInfo.data == null) {
    emit(UserInfoErrorState('UserInfo Data Is Null'));
    return;
    }

    if(userInfo.status==200 && userInfo.data!.isNotEmpty){
      emit(UserInfoLoadedState(userInfo.data ?? []));

    }



    } catch (e) {
      emit(UserInfoErrorState(e.toString()));
    }
  }
}
