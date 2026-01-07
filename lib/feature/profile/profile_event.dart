part of 'profile_bloc.dart';

@immutable
sealed class ProfileEvent {}

class ProfileInitialEvent extends ProfileEvent {}

class ProfileFilterDataEvent extends ProfileEvent {}

class ProfileSortDataEvent extends ProfileEvent {}

class ProfilePaginationDataEvent extends ProfileEvent {}
