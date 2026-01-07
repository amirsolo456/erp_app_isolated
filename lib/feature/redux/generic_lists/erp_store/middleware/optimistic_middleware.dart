import 'package:shared_core/index.dart' as prefix0;
import 'package:services_package/api_service.dart';

import '../actions/generic_list_entity_actions.dart';
import '../actions/list_actions.dart';
import '../models/generic_list_entity_state.dart';

class GenericEntityMiddleware<
  T extends prefix0.BaseResponse<D>,
  D,
  C extends prefix0.BaseRequest
> {
  final ApiService<T, D, C> apiService;

  GenericEntityMiddleware({required this.apiService});

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
