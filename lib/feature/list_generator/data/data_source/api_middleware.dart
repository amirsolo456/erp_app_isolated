// ignore_for_file: unused_local_variable

 import 'package:erp_app/feature/list_generator/data/models/generic_list_entity_state.dart';
import 'package:erp_app/feature/list_generator/data/models/list_actions.dart';
import 'package:shared_core/index.dart';
import 'package:redux/redux.dart';
import 'package:services_package/api_client_service.dart';



class ErpApiMiddleware<T extends BaseResponse<D>, D, C extends BaseRequest>
    implements MiddlewareClass<ErpStoreState> {
  final C? request;
  final ApiClient api;
  final T Function(Map<String, dynamic>) fromJsonD;

  ErpApiMiddleware({
    required this.api,
    required this.request,
    required this.fromJsonD,
    required BaseRequest Function() requestFactory,
  });

  @override
  void call(Store<ErpStoreState> store, action, NextDispatcher next) async {
    next(action);

    if (action is LoadEntity) {
      final entity = store.state.entities[action.key]!;
      await api
          .sendRequestAsync(
            '',
            HttpMethods.post,
            request,
            true,
            Exception(''),
            fromJsonD,
          )
          .then((response) {
            store.dispatch(
              LoadEntitySuccess<D>(
                action.key,
                response?.data ?? [],
                response?.totalCount ?? 0,
              ),
            );
          })
          .catchError((e) {
            store.dispatch(LoadEntityFailure(action.key, e.toString()));
          });
    }
  }
}

// api_middleware.dart (نمونه)
