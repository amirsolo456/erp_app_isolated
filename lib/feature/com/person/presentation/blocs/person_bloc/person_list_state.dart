import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_core/data/com/person/response.dart' as prefix0;

@immutable
abstract class PersonListState extends Equatable {
  const PersonListState();

  @override
  List<Object?> get props => [];
}

final class PersonListInitialState extends PersonListState {}

class LoadPersonListState extends PersonListState {
  const LoadPersonListState();
}

class PersonListLoadingState extends PersonListState {
  const PersonListLoadingState();
}

class LoadDataSuccess extends PersonListState {}

class LoadDataError extends PersonListState {}

class PersonListLoadDataSourceState extends PersonListState {
  final prefix0.Response? data;

  PersonListLoadDataSourceState({required this.data});
}

class FilterDataLoading extends PersonListState {}

class FilterDataSuccess extends PersonListState {}

class FilterDataError extends PersonListState {}

class SortDataLoading extends PersonListState {}

class SortDataSuccess extends PersonListState {}

class SortDataError extends PersonListState {}

class PaginationDataLoading extends PersonListState {}

class PaginationDataSuccess extends PersonListState {}

class PaginationDataError extends PersonListState {}
