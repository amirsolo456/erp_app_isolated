// ignore_for_file: library_prefixes

import 'package:erp_app/feature/default_page/pages/default_bloc.dart';
import 'package:erp_app/index.dart';
import 'package:erp_app/src/erp_notifier.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:models_package/index.dart';
import 'package:redux/redux.dart';
import 'package:resources_package/Resources/Theme/theme_manager.dart';
import 'package:services_package/Interfaces/front_helper_services/isnackbar_service.dart'
    as snack_bar;
import 'package:services_package/Repo_ViewId/repo_view_id.dart';
import 'package:services_package/api_client_service.dart';
import 'package:services_package/api_service.dart';
import 'package:services_package/auth/menu/menu_service.dart';
import 'package:services_package/auth/toolbar/toolbar_service.dart';
import 'package:services_package/com/person/person_service.dart';
import 'package:services_package/default/com/select/currency_service.dart';
import 'package:services_package/default/com/select/year_service.dart';
import 'package:services_package/default/mng/select/language_service.dart';
import 'package:services_package/default/mng/select/place_service.dart';
import 'package:services_package/default/trh/select/cashier_service.dart';
import 'package:services_package/extension/exception_handler_service.dart';
import 'package:services_package/login_service.dart';
import 'package:services_package/otp_service.dart';
import 'package:services_package/storage/domain/usecases/secure_storage_usecasae.dart';
import 'package:services_package/storage/domain/usecases/shared_storage_usecase.dart';
import 'package:services_package/storage/domain/usecases/sqlite_storage_usecase.dart';
import 'package:services_package/storage/domain/usecases/storage_service.dart';
import 'package:services_package/user_exist.dart';
import 'package:shared_core/data/auth/menu/request.dart' as prefixMenu;
import 'package:shared_core/data/auth/menu/response.dart' as prefixMenu;
import 'package:shared_core/data/auth/menu/response_data.dart' as prefixMenu;
import 'package:shared_core/data/com/person/request.dart' as prefixPerson;
import 'package:shared_core/data/com/person/response.dart' as prefixPerson;
import 'package:shared_core/data/com/person/response_data.dart' as prefixPerson;
import 'package:ui_components_package/erp_app_componenets/common/Buttons/language_button_standalone/language_button_stand_alone_cubit.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Buttons/absoluted_button.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Expanders/list_datas_expander.dart';

import '../../feature/com/person/domain/repositories/person_repository.dart';
import '../../feature/com/person/presentation/blocs/person_bloc/person_list_bloc.dart';
import '../../feature/com/person/presentation/blocs/search_person_bloc/search_person_bloc.dart';
import '../../feature/default_page/cashier/bloc/cashier_bloc.dart';
import '../../feature/default_page/currency/bloc/currency_bloc.dart';
import '../../feature/default_page/place/bloc/place_bloc.dart';
import '../../feature/default_page/year/bloc/year_bloc.dart';
import '../../feature/list_generator/data/models/generic_list_entity_actions.dart';
import '../../feature/list_generator/data/models/generic_list_entity_state.dart';
import '../../feature/list_generator/presentation/bloc/store/list_reducer.dart';
import '../list_generic/presentation/features/generic_page.dart';

final GetIt sl = GetIt.instance;

extension GetItX on GetIt {
  void lazySingleton<T extends Object>(T Function() factoryFunc) =>
      registerLazySingleton<T>(factoryFunc);

  void factory<T extends Object>(T Function() factoryFunc) =>
      registerFactory<T>(factoryFunc);
}

class InjectionContainer {
  static Future<void> init() async {
    // -------------------------
    // 1. UseCases (singletons)
    // -------------------------

    sl.registerSingleton<AppNotifier>(AppNotifier());
    sl.registerSingleton<ErpAppNotifier>(ErpAppNotifier());
    if (!sl.isRegistered<SecureStorageUseCase>()) {
      final secure = SecureStorageUseCase();
      sl.registerSingleton<SecureStorageUseCase>(secure);
    }

    if (!sl.isRegistered<SharedStorageUseCase>()) {
      final shared = SharedStorageUseCase();
      sl.registerSingleton<SharedStorageUseCase>(shared);
    }

    if (!sl.isRegistered<SqliteStorageUseCase>()) {
      final sqlite = SqliteStorageUseCase();
      sl.registerSingleton<SqliteStorageUseCase>(sqlite);
    }

    // -------------------------
    // 2. Defaults & ApiSettings
    // -------------------------
    if (!sl.isRegistered<Defaults>()) {
      final defaults = Defaults(
        placeId: 1,
        yearId: 1403,
        languageId: 0,
        managementAccountId: 1,
        currencyId: 0,
        cashierId: 72,
      );
      sl.registerLazySingleton<Defaults>(() => defaults);
    }

    if (!sl.isRegistered<ApiSettings>()) {
      sl.registerLazySingleton<ApiSettings>(
        () => ApiSettings(
          baseUrl: 'https://bff.ariansystem.net',
          loginUrl: 'api/auth/login',
          timeOut: Duration(seconds: 40),
          appDefaults: Defaults(
            placeId: sl<Defaults>().placeId,
            languageId: sl<Defaults>().languageId,
            cashierId: sl<Defaults>().cashierId,
            currencyId: sl<Defaults>().currencyId,
            managementAccountId: sl<Defaults>().managementAccountId,
            yearId: sl<Defaults>().yearId,
          ),
        ),
      );
    }

    // -------------------------
    // 3. StorageService
    // -------------------------
    if (!sl.isRegistered<StorageService>()) {
      sl.registerLazySingleton<StorageService>(
        () => StorageService(
          secureStorageUseCase: sl<SecureStorageUseCase>(),
          sharedStorageUseCase: sl<SharedStorageUseCase>(),
          sqliteStorageUseCase: sl<SqliteStorageUseCase>(),
        ),
      );
    }

    sl<StorageService>();

    // -------------------------
    // 4. ApiClient
    // -------------------------
    if (!sl.isRegistered<ApiClient>()) {
      sl.registerLazySingleton<ApiClient>(
        () => ApiClient(
          storage: sl<StorageService>(),
          appSettings: sl<ApiSettings>(),
        ),
      );
    }

    // -------------------------
    // 5. Core services that depend on ApiClient
    // -------------------------
    if (!sl.isRegistered<OtpService>()) {
      sl.registerLazySingleton<OtpService>(() => OtpService(sl<ApiClient>()));
    }

    if (!sl.isRegistered<ToolbarService>()) {
      sl.registerLazySingleton<ToolbarService>(
        () => ToolbarService(sl<ApiClient>()),
      );
    }

    if (!sl.isRegistered<UserExistService>()) {
      sl.registerLazySingleton<UserExistService>(
        () => UserExistService(apiClient: sl<ApiClient>()),
      );
    }

    // -------------------------
    // 6. Repositories / Helpers / Messenger
    // -------------------------
    if (!sl.isRegistered<PersonRepository>()) {
      sl.registerLazySingleton<PersonRepository>(() => PersonRepository());
    }

    if (!sl.isRegistered<ExceptionHelperService>()) {
      sl.registerLazySingleton<ExceptionHelperService>(
        () => ExceptionHelperService(),
      );
    }

    final messengerService = sl<ExceptionHelperService>();
    AppErrorHandler.registerMessengerService(messengerService);

    if (!sl.isRegistered<snack_bar.ISnackBarService>()) {
      sl.registerLazySingleton<snack_bar.ISnackBarService>(
        () => SnackBarService(),
      );
    }

    if (!sl.isRegistered<LoginService>()) {
      sl.registerLazySingleton<LoginService>(
        () => LoginService(client: sl<ApiClient>()),
      );
    }
    if (!sl.isRegistered<LanguageButtonStandAloneCubit>()) {
      sl.registerLazySingleton<LanguageButtonStandAloneCubit>(
        () =>
            LanguageButtonStandAloneCubit(initialLocale: AppTheme.local.value),
      );
    }
    // -------------------------
    // 7. Generic ApiService registrations (fix factory)
    // -------------------------
    if (!sl
        .isRegistered<
          ApiService<
            prefixMenu.Response,
            prefixMenu.ResponseData,
            prefixMenu.Request
          >
        >()) {
      sl.registerFactory<
        ApiService<
          prefixMenu.Response,
          prefixMenu.ResponseData,
          prefixMenu.Request
        >
      >(
        () =>
            ApiService<
              prefixMenu.Response,
              prefixMenu.ResponseData,
              prefixMenu.Request
            >(clientService: sl<ApiClient>()),
      );
    }

    if (!sl
        .isRegistered<
          ApiService<
            prefixPerson.Response,
            prefixPerson.ResponseData,
            prefixPerson.Request
          >
        >()) {
      sl.registerLazySingleton<
        ApiService<
          prefixPerson.Response,
          prefixPerson.ResponseData,
          prefixPerson.Request
        >
      >(
        () =>
            ApiService<
              prefixPerson.Response,
              prefixPerson.ResponseData,
              prefixPerson.Request
            >(clientService: sl<ApiClient>()),
      );
    }

    // -------------------------
    // 8. Menu / Domain services & Blocs
    // -------------------------
    if (!sl.isRegistered<MenuService>()) {
      sl.registerFactory<MenuService>(() => MenuService(sl<ApiClient>()));
    }

    if (!sl.isRegistered<LanguageService>()) {
      sl.registerFactory<LanguageService>(
        () => LanguageService(
          sl<ApiClient>(),
          repoViewId: AppConstants().languageRepoViewId,
        ),
      );
    }

    if (!sl.isRegistered<DefaultBloc>()) {
      sl.registerFactory(() => DefaultBloc(sl<ApiSettings>()));
    }
    //
    // if (!sl.isRegistered<LanguageBloc>()) {
    //   sl.registerFactory(
    //     () => LanguageBloc(getLanguageUseCase: sl<LanguageService>()),
    //   );
    // }

    // Defaults: Place / Year / Language / Cashier / Currency
    if (!sl.isRegistered<PlaceService>()) {
      sl.registerFactory<PlaceService>(() => PlaceService(sl<ApiClient>()));
    }

    if (!sl.isRegistered<YearService>()) {
      sl.registerFactory<YearService>(() => YearService(sl<ApiClient>()));
    }

    if (!sl.isRegistered<CashierService>()) {
      sl.registerFactory<CashierService>(
        () => CashierService(
          sl<ApiClient>(),
          repoViewId: AppConstants().cashierRepoViewId,
        ),
      );
    }

    if (!sl.isRegistered<CurrencyService>()) {
      sl.registerFactory<CurrencyService>(
        () => CurrencyService(sl<ApiClient>()),
      );
    }

    if (!sl.isRegistered<PlaceBloc>()) {
      sl.registerFactory(() => PlaceBloc(getPlaceUseCase: sl<PlaceService>()));
    }
    if (!sl.isRegistered<YearBloc>()) {
      sl.registerFactory(
        () => YearBloc(getSelectYearUseCase: sl<YearService>()),
      );
    }
    if (!sl.isRegistered<CurrencyBloc>()) {
      sl.registerFactory(
        () => CurrencyBloc(getSelectCurrencyUseCase: sl<CurrencyService>()),
      );
    }
    if (!sl.isRegistered<CashierBloc>()) {
      sl.registerFactory(
        () => CashierBloc(getCashierUseCase: sl<CashierService>()),
      );
    }
    // -------------------------
    // 9. Person-related services & Blocs
    // -------------------------
    if (!sl.isRegistered<SearchPersonBloc>()) {
      sl.registerFactory(() => SearchPersonBloc(sl.get<PersonRepository>()));
    }

    if (!sl.isRegistered<PersonService>()) {
      sl.registerFactory(() => PersonService(sl<ApiClient>()));
    }

    if (!sl.isRegistered<PersonListBloc>()) {
      sl.registerFactory(
        () => PersonListBloc(personService: sl<PersonService>()),
      );
    }

    // -------------------------
    // 10. personStore (redux store instance)
    // -------------------------
    final personStore =
        getStore<
          prefixPerson.Response,
          prefixPerson.ResponseData,
          prefixPerson.Request
        >(
          requestFactory: () => prefixPerson.Request(repoViewId: 0),
          fromJsonD: (json) => prefixPerson.Response.fromJson(json),
        );

    if (!sl.isRegistered<
      Store<
        ErpStoreState<
          prefixPerson.Response,
          prefixPerson.ResponseData,
          prefixPerson.Request
        >
      >
    >(instanceName: 'personStore')) {
      sl.registerSingleton<
        Store<
          ErpStoreState<
            prefixPerson.Response,
            prefixPerson.ResponseData,
            prefixPerson.Request
          >
        >
      >(personStore, instanceName: 'personStore');
    }

    // -------------------------
    // 11. GenericPage factory (only register once)
    // -------------------------
    if (!sl.isRegistered<GenericPage>()) {
      sl.registerFactory(
        () =>
            GenericPage<
              SearchPersonBloc,
              prefixPerson.Response,
              prefixPerson.ResponseData,
              prefixPerson.Request
            >(
              createBloc: () => SearchPersonBloc(sl.get<PersonRepository>()),
              builder: (context, state, bloc) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text('Users'),
                    actions: [
                      IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () => state.props,
                      ),
                    ],
                  ),
                  body: Scaffold(
                    body: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: ListView.builder(
                            itemCount: state.props.length,
                            itemBuilder: (context, index) {
                              return ListDataExpander(data: state.props[index]);
                            },
                          ),
                        ),
                        AbsoultNewButton(),
                      ],
                    ),
                  ),
                );
              },
            ),
      );
    }

    // -------------------------
    // 12. Helper: validate (optional)
    // -------------------------
    // debug prints (optional)
    // print('Registered: StorageService=${sl.isRegistered<StorageService>()}');
    // print('Registered: ApiClient=${sl.isRegistered<ApiClient>()}');
  }

  static Store<ErpStoreState<T, D, C>>
  getStore<T extends BaseResponse<D>, D, C extends BaseRequest>({
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

    // ایجاد middleware
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
}
