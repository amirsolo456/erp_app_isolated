// ignore_for_file: library_prefixes

import 'package:erp_app/index.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:micro_app_core/index.dart';
import 'package:redux/redux.dart';
import 'package:services_package/api_client_service.dart';
import 'package:shared_core/index.dart' as prefix0;

import '../feature/list_generator/data/models/generic_list_entity_actions.dart';
import '../feature/list_generator/data/models/generic_list_entity_state.dart';
import '../feature/list_generator/presentation/bloc/store/list_reducer.dart';

class Inject {
  static void initialize() {
    // final manager = MicroAppManager.instance;
    // sl.registerSingleton<MicroAppNotifier<ErpCoreModel, ErpAppsCoreEnum>>(
    //   MicroAppNotifier<ErpCoreModel, ErpAppsCoreEnum>(ErpCoreModel()),
    // );
    final manager = MicroAppManager.instance;
    MicroAppFactories.registerResolverFactory(
      MicroAppsName.erpApp,
      () => ErpResolver(), // یا بدون پارامتر اگر امکان دارد
    );




    // 3. به Manager بگو که بعداً resolver را ایجاد کند
    _deferredRegistration(manager, MicroAppsName.erpApp);

    // sl.registerSingleton<MicroAppNotifier<ErpCoreModel, ErpAppsCoreEnum>>(
    //   notifier,
    // );
    // final loginNotifier = sl<MicroAppNotifier<ErpCoreModel, ErpAppsCoreEnum>>();
    //
    // sl.registerSingleton(loginNotifier);
    // manager.registerApp<ErpCoreModel, ErpAppsCoreEnum>(sl<ErpResolver>());
  }

  static void _deferredRegistration(
    MicroAppManager manager,
    MicroAppsName appName,
  ) {
    // تأخیر در ثبت تا زمانی که همه چیز آماده شود
    Future.microtask(() {
      try {
        final resolver = MicroAppFactories.createResolver(appName);
        manager.registerApp<ErpCoreModel, ErpAppsCoreEnum>(resolver);
      } catch (e) {
        print('Error registering $appName: $e');
      }
    });
  }

  static Store<ErpStoreState<T, D, C>> getStore<
    T extends prefix0.BaseResponse<D>,
    D,
    C extends prefix0.BaseRequest
  >({
    required C Function() requestFactory,
    required T Function(Map<String, dynamic>) fromJsonD,
  }) {
    // ایجاد reducer function
    ErpStoreState<T, D, C> reducer(
      ErpStoreState<T, D, C> state,
      dynamic action,
    ) {
      if (action is GenericEntityAction) {
        return GenericEntityReducer.reduce<T, D, C>(state, action);
      }
      return state;
    }

    final apiClient = sl<ApiClient>();
    final middleware = ErpApiMiddleware<T, D, C>(
      api: apiClient,
      requestFactory: requestFactory,
      fromJsonD: fromJsonD,
      request: null,
    );

    return Store<ErpStoreState<T, D, C>>(
      reducer,
      initialState: ErpStoreState<T, D, C>(),
      middleware: [middleware],
      distinct: true,
      syncStream: true,
    );
  }

  void dispose() {
    // اگر لازم است unregister یا cleanup انجام بدی (GetIt امکان unregister داره)
    if (sl.isRegistered<AppNotifier>()) {
      // sl.unregister<AppNotifier>(); // فقط اگر میخوای کامل حذف کنی
    }
  }
}

class MicroAppFactories {
  static final Map<MicroAppsName, Function()> _resolverFactories = {};

  static void registerResolverFactory(
    MicroAppsName appName,
    Function() factory,
  ) {
    _resolverFactories[appName] = factory;
  }

  static dynamic createResolver(MicroAppsName appName) {
    final factory = _resolverFactories[appName];
    if (factory == null) {
      throw StateError('No resolver factory registered for $appName');
    }
    return factory();
  }
}
