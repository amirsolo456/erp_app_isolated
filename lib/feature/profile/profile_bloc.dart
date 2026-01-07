import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitialState()) {
    on<ProfileInitialEvent>((event, emit) async  {

      emit(ProfileInitialState());
      await Future.delayed(Duration(seconds: 2));
      emit(ProfileLoadDataSuccess());
    });
  }
}

