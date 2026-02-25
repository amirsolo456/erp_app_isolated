import 'package:erp_app/feature/list_generator/data/models/generic_list_entity_actions.dart';
import 'package:erp_app/feature/list_generator/data/models/list_actions.dart';
import 'package:shared_core/index.dart';
import 'package:services_package/api_service.dart';

import '../models/generic_list_entity_state.dart';

class ErpGenericMiddleware<
  T extends BaseResponse<D>,
  D,
  C extends BaseRequest
> {
  final ApiService<T, D, C> apiService;

  ErpGenericMiddleware({required this.apiService});

  Future<void> handleFetchAction(
    FetchDataAction<T, D, C> action,
    Function(GenericEntityAction) dispatch,
    ErpStoreState<T, D, C> getState,
  ) async {
    try {
      dispatch(SetLoadingAction(entityKey: action.entityKey, loading: true));

      final response = await apiService.get(action.request, null);

      dispatch(
        FetchDataSuccessAction<T, D, C>(
          entityKey: action.entityKey,
          response: response,
          data: response?.data ?? [],
          totalCount: response?.totalCount ?? 0,
        ),
      );
    } catch (error) {
      dispatch(
        FetchDataFailureAction(
          entityKey: action.entityKey,
          error: error.toString(),
        ),
      );
    } finally {
      dispatch(SetLoadingAction(entityKey: action.entityKey, loading: false));
    }
  }
}
