part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitialState extends ProfileState {}

class ProfileLoadDataInitial extends ProfileState {}

class ProfileLoadDataSecondary extends ProfileState {}

class ProfileLoadDataSuccess extends ProfileState {}

class ProfileLoadDataError extends ProfileState {}

  class ProfileLoadDataSource extends ProfileState {}
