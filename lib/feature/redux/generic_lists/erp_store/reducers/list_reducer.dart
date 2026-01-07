// list_reducer.dart
import 'package:shared_core/index.dart' as prefix0;
import 'package:services_package/api_service.dart';

import '../actions/generic_list_entity_actions.dart';
import '../actions/list_actions.dart';
import '../models/field_display_config.dart';
import '../models/generic_list_entity_state.dart';

// reducer
GenericListEntityState<T, D, C> genericEntityReducer<
  T extends prefix0.BaseResponse<D>,
  D,
  C extends prefix0.BaseRequest
>(GenericListEntityState<T, D, C> state, GenericEntityAction action) {
  if (action is StartLoadingAction) {
    return state.copyWith(loading: true, error: null);
  } else if (action is EndLoadingAction) {
    return state.copyWith(loading: false);
  } else if (action is FetchDataSuccessAction<T, D, C>) {
    return state.copyWith(
      fetchData: action.data,
      totalCount: action.totalCount,
      loading: false,
      error: null,
      lastFetched: DateTime.now(),
    );
  } else if (action is FetchDataFailureAction) {
    return state.copyWith(loading: false, error: action.error);
  } else if (action is UpdateDisplayFieldsAction) {
    return state.copyWith(displayFields: action.displayFields);
  } else if (action is UpdateRequestAction<C>) {
    return state.copyWith(request: action.request);
  }

  return state;
}

class InitializeEntityAction<
  T extends prefix0.BaseResponse<D>,
  D,
  C extends prefix0.BaseRequest
>
    extends GenericEntityAction {
  final String entityKey;
  final C request;
  final T response;
  final ApiService<T, D, C> apiService;
  final List<FieldDisplayConfig> fields;
  final Map<String, dynamic>? displayFields;

  InitializeEntityAction({
    required this.entityKey,
    required this.request,
    required this.response,
    required this.apiService,
    required this.fields,
    this.displayFields,
  });
}

class GenericEntityReducer {
  static ErpStoreState<T, D, C> reduce<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, GenericEntityAction action) {
    if (action is InitializeEntityAction<T, D, C>) {
      return _initializeEntity(state, action);
    } else if (action is FetchDataAction<T, D, C>) {
      return _fetchData(state, action);
    } else if (action is FetchDataSuccessAction<T, D, C>) {
      return _fetchDataSuccess(state, action);
    } else if (action is FetchDataFailureAction) {
      return _fetchDataFailure(state, action);
    } else if (action is CreateDataAction<D>) {
      return _createData(state, action);
    } else if (action is UpdateDataAction<D>) {
      return _updateData(state, action);
    } else if (action is DeleteDataAction) {
      return _deleteData(state, action);
    } else if (action is SetLoadingAction) {
      return _setLoading(state, action);
    } else if (action is SetErrorAction) {
      return _setError(state, action);
    } else if (action is UpdateRequestAction<C>) {
      return _updateRequest(state, action);
    } else if (action is UpdateDisplayFieldsAction) {
      return _updateDisplayFields(state, action);
    } else if (action is AddDisplayFieldAction) {
      return _addDisplayField(state, action);
    } else if (action is RemoveDisplayFieldAction) {
      return _removeDisplayField(state, action);
    } else if (action is ClearEntityAction) {
      return _clearEntity(state, action);
    } else if (action is AddEntityAction<T, D, C>) {
      return _addEntity(state, action);
    } else if (action is RemoveEntityAction) {
      return _removeEntity(state, action);
    } else if (action is ClearStoreAction) {
      return _clearStore(state);
    }

    return state;
  }

  // ========== Private Reducer Methods ==========

  static ErpStoreState<T, D, C> _initializeEntity<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, InitializeEntityAction<T, D, C> action) {
    final newEntity = GenericListEntityState<T, D, C>(
      request: action.request,
      response: action.response,
      fields: action.fields,
      displayFields: action.displayFields ?? {},
    );

    return state.copyWith(
      entities: {...state.entities, action.entityKey: newEntity},
    );
  }

  static ErpStoreState<T, D, C> _fetchData<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, FetchDataAction<T, D, C> action) {
    final entity = state.getEntity(action.entityKey);
    if (entity == null) return state;

    final updatedEntity = entity.copyWith(
      loading: true,
      error: null,
      request: action.request,
    );

    return state.copyWith(
      entities: {...state.entities, action.entityKey: updatedEntity},
    );
  }

  static ErpStoreState<T, D, C> _fetchDataSuccess<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, FetchDataSuccessAction<T, D, C> action) {
    final entity = state.getEntity(action.entityKey);
    if (entity == null) return state;

    final updatedEntity = entity.copyWith(
      loading: false,
      error: null,
      response: action.response,
      fetchData: action.data,
      totalCount: action.totalCount,
      lastFetched: DateTime.now(),
    );

    return state.copyWith(
      entities: {...state.entities, action.entityKey: updatedEntity},
    );
  }

  static ErpStoreState<T, D, C> _fetchDataFailure<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, FetchDataFailureAction action) {
    final entity = state.getEntity(action.entityKey);
    if (entity == null) return state;

    final updatedEntity = entity.copyWith(loading: false, error: action.error);

    return state.copyWith(
      entities: {...state.entities, action.entityKey: updatedEntity},
    );
  }

  static ErpStoreState<T, D, C> _createData<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, CreateDataAction<D> action) {
    final entity = state.getEntity(action.entityKey);
    if (entity == null) return state;

    final newData = [...entity.fetchData, action.data];
    final updatedEntity = entity.copyWith(
      fetchData: newData,
      totalCount: newData.length,
    );

    return state.copyWith(
      entities: {...state.entities, action.entityKey: updatedEntity},
    );
  }

  static ErpStoreState<T, D, C> _updateData<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, UpdateDataAction<D> action) {
    final entity = state.getEntity(action.entityKey);
    if (entity == null || action.index >= entity.fetchData.length) return state;

    final newData = List<D>.from(entity.fetchData);
    newData[action.index] = action.data;

    final updatedEntity = entity.copyWith(fetchData: newData);

    return state.copyWith(
      entities: {...state.entities, action.entityKey: updatedEntity},
    );
  }

  static ErpStoreState<T, D, C> _deleteData<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, DeleteDataAction action) {
    final entity = state.getEntity(action.entityKey);
    if (entity == null || action.index >= entity.fetchData.length) return state;

    final newData = List<D>.from(entity.fetchData);
    newData.removeAt(action.index);

    final updatedEntity = entity.copyWith(
      fetchData: newData,
      totalCount: newData.length,
    );

    return state.copyWith(
      entities: {...state.entities, action.entityKey: updatedEntity},
    );
  }

  static ErpStoreState<T, D, C> _setLoading<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, SetLoadingAction action) {
    final entity = state.getEntity(action.entityKey);
    if (entity == null) return state;

    final updatedEntity = entity.copyWith(loading: action.loading);

    return state.copyWith(
      entities: {...state.entities, action.entityKey: updatedEntity},
    );
  }

  static ErpStoreState<T, D, C> _setError<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, SetErrorAction action) {
    final entity = state.getEntity(action.entityKey);
    if (entity == null) return state;

    final updatedEntity = entity.copyWith(error: action.error);

    return state.copyWith(
      entities: {...state.entities, action.entityKey: updatedEntity},
    );
  }

  static ErpStoreState<T, D, C> _updateRequest<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, UpdateRequestAction<C> action) {
    final entity = state.getEntity(action.entityKey);
    if (entity == null) return state;

    final updatedEntity = entity.copyWith(request: action.request);

    return state.copyWith(
      entities: {...state.entities, action.entityKey: updatedEntity},
    );
  }

  static ErpStoreState<T, D, C> _updateDisplayFields<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, UpdateDisplayFieldsAction action) {
    final entity = state.getEntity(action.entityKey);
    if (entity == null) return state;

    final updatedEntity = entity.copyWith(displayFields: action.displayFields);

    return state.copyWith(
      entities: {...state.entities, action.entityKey: updatedEntity},
    );
  }

  static ErpStoreState<T, D, C> _addDisplayField<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, AddDisplayFieldAction action) {
    final entity = state.getEntity(action.entityKey);
    if (entity == null) return state;

    final newDisplayFields = {
      ...entity.displayFields,
      action.key: action.value,
    };
    final updatedEntity = entity.copyWith(displayFields: newDisplayFields);

    return state.copyWith(
      entities: {...state.entities, action.entityKey: updatedEntity},
    );
  }

  static ErpStoreState<T, D, C> _removeDisplayField<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, RemoveDisplayFieldAction action) {
    final entity = state.getEntity(action.entityKey);
    if (entity == null) return state;

    final newDisplayFields = Map<String, dynamic>.from(entity.displayFields);
    newDisplayFields.remove(action.key);

    final updatedEntity = entity.copyWith(displayFields: newDisplayFields);

    return state.copyWith(
      entities: {...state.entities, action.entityKey: updatedEntity},
    );
  }

  static ErpStoreState<T, D, C> _clearEntity<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, ClearEntityAction action) {
    final entity = state.getEntity(action.entityKey);
    if (entity == null) return state;

    final updatedEntity = entity.copyWith(
      fetchData: [],
      totalCount: 0,
      error: null,
      displayFields: {},
    );

    return state.copyWith(
      entities: {...state.entities, action.entityKey: updatedEntity},
    );
  }

  static ErpStoreState<T, D, C> _addEntity<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, AddEntityAction<T, D, C> action) {
    return state.copyWith(
      entities: {...state.entities, action.entityKey: action.entityState},
    );
  }

  static ErpStoreState<T, D, C> _removeEntity<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state, RemoveEntityAction action) {
    final newEntities = Map<String, GenericListEntityState<T, D, C>>.from(
      state.entities,
    );
    newEntities.remove(action.entityKey);

    return state.copyWith(entities: newEntities);
  }

  static ErpStoreState<T, D, C> _clearStore<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >(ErpStoreState<T, D, C> state) {
    return ErpStoreState<T, D, C>();
  }
}
