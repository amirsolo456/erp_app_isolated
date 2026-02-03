// ==================== Store ====================
import 'package:erp_app/feature/list_generator/data/data_source/erp_generic_middleware.dart';
import 'package:shared_core/index.dart';
import 'package:erp_app/feature/list_generator/presentation/bloc/store/list_reducer.dart';
import '../../../data/models/generic_list_entity_actions.dart';
import '../../../data/models/list_actions.dart';
import '../../../data/models/generic_list_entity_state.dart';

class GenericEntityStore<
  T extends BaseResponse<D>,
  D,
  C extends BaseRequest
> {
  ErpStoreState<T, D, C> _state;
  final List<ErpGenericMiddleware<T, D, C>> _middlewares;

  GenericEntityStore({
    required ErpStoreState<T, D, C> initialState,
    List<ErpGenericMiddleware<T, D, C>> middlewares = const [],
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
