// list_actions.dart
import 'package:shared_core/index.dart' as prefix0;

import '../models/generic_list_entity_state.dart';
import 'generic_list_entity_actions.dart';

class CreateItem<T> {
  final String listKey;
  final T item;

  CreateItem(this.listKey, this.item);
}

class CreateItemSuccess<T> {
  final String listKey;
  final T item;

  CreateItemSuccess(this.listKey, this.item);
}

class UpdateItem<T> {
  final String listKey;
  final String id;
  final Map<String, dynamic> changes;

  UpdateItem(this.listKey, this.id, this.changes);
}

class UpdateItemSuccess<T> {
  final String listKey;
  final T item;

  UpdateItemSuccess(this.listKey, this.item);
}

class DeleteItem {
  final String listKey;
  final String id;

  DeleteItem(this.listKey, this.id);
}

class DeleteItemSuccess {
  final String listKey;
  final String id;

  DeleteItemSuccess(this.listKey, this.id);
}

class SetFilter {
  final String listKey;
  final Map<String, dynamic> filters;

  SetFilter(this.listKey, this.filters);
}

class SetSort {
  final String listKey;
  final String sortBy;
  final bool desc;

  SetSort(this.listKey, this.sortBy, this.desc);
}

class SetPage {
  final String listKey;
  final int page;

  SetPage(this.listKey, this.page);
}

class ClearList {
  final String listKey;

  ClearList(this.listKey);
}

// load
class LoadEntity {
  final String key;

  LoadEntity(this.key);
}

class LoadEntityFailure {
  final String key;
  final String error;

  LoadEntityFailure(this.key, this.error);
}

// Fetch Actions
class FetchDataAction<T extends prefix0.BaseResponse<D>, D, C extends prefix0.BaseRequest>
    extends GenericEntityAction {
  final String entityKey;
  final C request;

  FetchDataAction({required this.entityKey, required this.request});
}

class UpdatePaging {
  final String key;
  final prefix0.PagingInfo paging;

  UpdatePaging(this.key, this.paging);
}

class UpdateFilters {
  final String key;
  final prefix0.Filters filters;

  UpdateFilters(this.key, this.filters);
}

class UpdateSorting {
  final String key;
  final List<prefix0.OrderInfo> orderInfo;

  UpdateSorting(this.key, this.orderInfo);
}

class LoadEntitySuccess<D> {
  final String key;
  final List<D> items;
  final int totalCount;

  LoadEntitySuccess(this.key, this.items, this.totalCount);
}

enum RandomTypes { Numbers, Alphabets }

// Store Actions
class AddEntityAction<T extends prefix0.BaseResponse<D>, D, C extends prefix0.BaseRequest>
    extends GenericEntityAction {
  final String entityKey;
  final GenericListEntityState<T, D, C> entityState;

  AddEntityAction({required this.entityKey, required this.entityState});
}

class RemoveEntityAction extends GenericEntityAction {
  final String entityKey;

  RemoveEntityAction({required this.entityKey});
}

class ClearStoreAction extends GenericEntityAction {}
