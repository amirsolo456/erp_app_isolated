// ==================== Store ====================
import 'package:shared_core/index.dart' as prefix0;
import 'package:erp_app/feature/redux/generic_lists/erp_store/reducers/list_reducer.dart';


import 'actions/generic_list_entity_actions.dart';
import 'actions/list_actions.dart';
import 'middleware/optimistic_middleware.dart';
import 'models/generic_list_entity_state.dart';

class GenericEntityStore<T extends prefix0.BaseResponse<D>, D, C extends prefix0.BaseRequest> {
  ErpStoreState<T, D, C> _state;
  final List<GenericEntityMiddleware<T, D, C>> _middlewares;

  GenericEntityStore({
    required ErpStoreState<T, D, C> initialState,
    List<GenericEntityMiddleware<T, D, C>> middlewares = const [],
  }) : _state = initialState,
       _middlewares = middlewares;

  ErpStoreState<T, D, C> get state => _state;

  Future<void> dispatch(GenericEntityAction action) async {
    // Run middleware before reduction
    for (final middleware in _middlewares) {
      if (action is FetchDataAction<T, D, C>) {
        await middleware.handleFetchAction(action, _dispatchSync, _state);
        return;
      }
    }

    // If no middleware handles the action, reduce it
    _dispatchSync(action);
  }

  void _dispatchSync(GenericEntityAction action) {
    final newState = GenericEntityReducer.reduce(_state, action);
    _state = newState;
  }

  Stream<ErpStoreState<T, D, C>> get stream async* {
    yield _state;
  }
}
