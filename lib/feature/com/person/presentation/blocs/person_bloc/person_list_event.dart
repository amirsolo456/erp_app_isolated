part of 'person_list_bloc.dart';

@immutable
sealed class PersonListEvent {}

class PersonListInitialEvent extends PersonListEvent {}
class LoadPersonListEvent extends PersonListEvent {}
class PersonListLoadingEvent extends PersonListEvent {}

class FilterDataEvent extends PersonListEvent {}

class SortDataEvent extends PersonListEvent {}

class PaginationDataEvent extends PersonListEvent {}
