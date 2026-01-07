
import 'package:services_package/api_service.dart';
import 'package:shared_core/index.dart' as prefix0;
import '../models/field_display_config.dart';

abstract class GenericEntityAction {}

// action برای شروع لودینگ
class StartLoadingAction extends GenericEntityAction {}

// action برای پایان لودینگ
class EndLoadingAction extends GenericEntityAction {}

// action برای دریافت داده با موفقیت
class FetchDataSuccessAction<
  T extends prefix0.BaseResponse<D>,
  D,
  C extends prefix0.BaseRequest
>
    extends GenericEntityAction {
  final String entityKey;
  final T? response;
  final List<D> data;
  final int totalCount;

  FetchDataSuccessAction({
    required this.entityKey,
    required this.response,
    required this.data,
    required this.totalCount,
  });
}

class FetchDataFailureAction extends GenericEntityAction {
  final String entityKey;
  final String error;

  FetchDataFailureAction({required this.entityKey, required this.error});
}

// CRUD Actions
class CreateDataAction<D> extends GenericEntityAction {
  final String entityKey;
  final D data;

  CreateDataAction({required this.entityKey, required this.data});
}

class UpdateDataAction<D> extends GenericEntityAction {
  final String entityKey;
  final D data;
  final int index;

  UpdateDataAction({
    required this.entityKey,
    required this.data,
    required this.index,
  });
}

class DeleteDataAction extends GenericEntityAction {
  final String entityKey;
  final int index;

  DeleteDataAction({required this.entityKey, required this.index});
}

// State Management Actions
class SetLoadingAction extends GenericEntityAction {
  final String entityKey;
  final bool loading;

  SetLoadingAction({required this.entityKey, required this.loading});
}

class SetErrorAction extends GenericEntityAction {
  final String entityKey;
  final String? error;

  SetErrorAction({required this.entityKey, required this.error});
}

class UpdateRequestAction<C extends prefix0.BaseRequest> extends GenericEntityAction {
  final String entityKey;
  final C request;

  UpdateRequestAction({required this.entityKey, required this.request});
}

class UpdateDisplayFieldsAction extends GenericEntityAction {
  final String entityKey;
  final Map<String, dynamic> displayFields;

  UpdateDisplayFieldsAction({
    required this.entityKey,
    required this.displayFields,
  });
}

class AddDisplayFieldAction extends GenericEntityAction {
  final String entityKey;
  final String key;
  final dynamic value;

  AddDisplayFieldAction({
    required this.entityKey,
    required this.key,
    required this.value,
  });
}

class RemoveDisplayFieldAction extends GenericEntityAction {
  final String entityKey;
  final String key;

  RemoveDisplayFieldAction({required this.entityKey, required this.key});
}

class ClearEntityAction extends GenericEntityAction {
  final String entityKey;

  ClearEntityAction({required this.entityKey});
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
