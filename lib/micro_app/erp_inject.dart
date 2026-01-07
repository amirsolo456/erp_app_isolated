// ignore_for_file: library_prefixes

import 'package:redux/redux.dart';
import 'package:services_package/api_client_service.dart';
import 'package:shared_core/index.dart' as prefix0;

import '../core/network/injection_container.dart';
import '../feature/redux/generic_lists/erp_store/actions/generic_list_entity_actions.dart';
import '../feature/redux/generic_lists/erp_store/middleware/api_middleware.dart';
import '../feature/redux/generic_lists/erp_store/models/generic_list_entity_state.dart';
import '../feature/redux/generic_lists/erp_store/reducers/list_reducer.dart';

class Inject {
  static void initialize() {
    // prefix0.Defaults defaults;
    // if (!sl.isRegistered<prefix0.Defaults>()) {
    //   defaults = prefix0.Defaults(
    //     placeId: 1,
    //     yearId: 1403,
    //     languageId: 2,
    //     managementAccountId: 1,
    //     currencyId: 0,
    //     cashierId: 0,
    //   );
    //   sl.registerLazySingleton<prefix0.Defaults>(() => defaults);
    // } else {
    //   defaults = sl<prefix0.Defaults>();
    // }
    //
    // ApiSettings apiSetting;
    // if (!sl.isRegistered<ApiSettings>()) {
    //   apiSetting = ApiSettings(
    //     baseUrl: 'https://bff.ariansystem.net',
    //     loginUrl: 'api/auth/login',
    //     timeOut: Duration(seconds: 40),
    //     appDefaults: prefix0.Defaults(
    //       placeId: defaults.placeId,
    //       languageId: defaults.languageId,
    //       cashierId: defaults.cashierId,
    //       currencyId: defaults.cashierId,
    //       managementAccountId: defaults.managementAccountId,
    //       yearId: defaults.yearId,
    //     ),
    //   );
    //   sl.registerLazySingleton<ApiSettings>(() => apiSetting);
    // } else {
    //   apiSetting = sl<ApiSettings>();
    // }
    //
    // StorageService storageService;
    // if (!sl.isRegistered<StorageService>()) {
    //   SecureStorageUseCase? secureStorageUseCase;
    //   SharedStorageUseCase? sharedStorageUseCase;
    //   SqliteStorageUseCase? sqliteStorageUseCase;
    //   if (!sl.isRegistered<SecureStorageUseCase>()) {
    //     secureStorageUseCase = SecureStorageUseCase();
    //     sl.registerSingleton<SecureStorageUseCase>(secureStorageUseCase);
    //   }
    //   if (!sl.isRegistered<SharedStorageUseCase>()) {
    //     sharedStorageUseCase = SharedStorageUseCase();
    //     sl.registerSingleton<SharedStorageUseCase>(sharedStorageUseCase);
    //   }
    //   if (!sl.isRegistered<SqliteStorageUseCase>()) {
    //     sqliteStorageUseCase = SqliteStorageUseCase();
    //     sl.registerSingleton<SqliteStorageUseCase>(sqliteStorageUseCase);
    //   }
    //   sl.registerSingleton(
    //     () => StorageService(
    //       secureStorageUseCase: secureStorageUseCase,
    //       sharedStorageUseCase: sharedStorageUseCase,
    //       sqliteStorageUseCase: sqliteStorageUseCase,
    //     ),
    //   );
    //   storageService = sl<StorageService>();
    // } else {
    //   storageService = sl<StorageService>();
    // }
    //
    // if (!sl.isRegistered<ApiClient>()) {
    //   sl.registerLazySingleton<ApiClient>(
    //     () => ApiClient(storage: storageService, appSettings: apiSetting),
    //   );
    // }
    //
    // final apiClient = ApiClient(
    //   storage: storageService,
    //   appSettings: apiSetting,
    // );
    //
    // if (!sl.isRegistered<OtpService>()) {
    //   sl.registerLazySingleton<OtpService>(() => OtpService(apiClient));
    // }
    //
    // if (!sl.isRegistered<UserExistService>()) {
    //   sl.registerLazySingleton<UserExistService>(
    //     () => UserExistService(apiClientr: apiClient),
    //   );
    // }
    //
    // if (!sl.isRegistered<NotificationService>()) {
    //   sl.registerLazySingleton<NotificationService>(
    //     () => NotificationService(
    //       storage: storageService,
    //       refreshInterval: Duration(minutes: 5),
    //     ),
    //   );
    // }
    //
    // if (!sl.isRegistered<PersonRepository>()) {
    //   sl.registerLazySingleton(() => PersonRepository());
    // }
    //
    // if (!sl.isRegistered<ExceptionHelperService>()) {
    //   sl.registerLazySingleton<ExceptionHelperService>(
    //     () => ExceptionHelperService(),
    //   );
    // }
    //
    // final messengerService = sl<ExceptionHelperService>();
    // AppErrorHandler.registerMessengerService(messengerService);
    //
    // if (!sl.isRegistered<LoginService>()) {
    //   sl.registerLazySingleton<LoginService>(
    //     () => LoginService(client: apiClient),
    //   );
    // }
    //
    // if (!sl
    //     .isRegistered<
    //       ApiService<
    //         prefixMenu.Response,
    //         prefixMenu.ResponseData,
    //         prefixMenu.Request
    //       >
    //     >()) {
    //   sl.registerFactory(
    //     () =>
    //         ApiService<
    //           prefixMenu.Response,
    //           prefixMenu.ResponseData,
    //           prefixMenu.Request
    //         >,
    //   );
    // }
    //
    // if (!sl.isRegistered<MenuService>()) {
    //   sl.registerFactory<MenuService>(() => MenuService(apiClient));
    // }
    //
    // if (!sl.isRegistered<MenuBloc>()) {
    //   sl.registerFactory(() => MenuBloc(getMenuUseCase: sl<MenuService>()));
    // }
    //
    // // ==================   Defaults
    //
    // if (!sl.isRegistered<PlaceService>()) {
    //   sl.registerFactory<PlaceService>(() => PlaceService(apiClient));
    // }
    //
    // if (!sl.isRegistered<PlaceBloc>()) {
    //   sl.registerFactory(() => PlaceBloc(getPlaceUseCase: sl<PlaceService>()));
    // }
    //
    // if (!sl.isRegistered<YearService>()) {
    //   sl.registerFactory<YearService>(() => YearService(apiClient));
    // }
    //
    // if (!sl.isRegistered<YearBloc>()) {
    //   sl.registerFactory(
    //     () => YearBloc(getSelectYearUseCase: sl<YearService>()),
    //   );
    // }
    //
    // if (!sl.isRegistered<LanguageService>()) {
    //   sl.registerFactory<LanguageService>(
    //     () => LanguageService(
    //       apiClient,
    //       repoViewId: AppConstants().LanguageRepoViewId,
    //     ),
    //   );
    // }
    //
    // if (!sl.isRegistered<LanguageBloc>()) {
    //   sl.registerFactory(
    //     () => LanguageBloc(getLanguageUseCase: sl<LanguageService>()),
    //   );
    // }
    //
    // if (!sl.isRegistered<CashierService>()) {
    //   sl.registerFactory<CashierService>(
    //     () => CashierService(
    //       apiClient,
    //       repoViewId: AppConstants().CashierRepoViewId,
    //     ),
    //   );
    // }
    //
    // if (!sl.isRegistered<CashierBloc>()) {
    //   sl.registerFactory(
    //     () => CashierBloc(getCashierUseCase: sl<CashierService>()),
    //   );
    // }
    //
    // if (!sl.isRegistered<CurrencyService>()) {
    //   sl.registerFactory<CurrencyService>(() => CurrencyService(apiClient));
    // }
    //
    // if (!sl.isRegistered<CurrencyBloc>()) {
    //   sl.registerFactory(
    //     () => CurrencyBloc(getSelectCurrencyUseCase: sl<CurrencyService>()),
    //   );
    // }
    //
    // // ==================================
    //
    // if (!sl.isRegistered<SearchPersonBloc>()) {
    //   sl.registerFactory(() => SearchPersonBloc(sl.get<PersonRepository>()));
    // }
    //
    // if (!sl.isRegistered<PersonService>()) {
    //   sl.registerFactory(() => PersonService(apiClient));
    // }
    //
    // if (!sl.isRegistered<PersonListBloc>()) {
    //   sl.registerFactory(
    //     () => PersonListBloc(personService: sl<PersonService>()),
    //   );
    // }
    //
    // if (sl
    //         .isRegistered<
    //           ApiService<
    //             prefixPerson.Response,
    //             prefixPerson.ResponseData,
    //             prefixPerson.Request
    //           >
    //         >() ==
    //     false) {
    //   try {
    //     sl.registerLazySingleton(
    //       () =>
    //           ApiService<
    //             prefixPerson.Response,
    //             prefixPerson.ResponseData,
    //             prefixPerson.Request
    //           >(clientService: apiClient),
    //     );
    //   } catch (e) {
    //     print(e.toString());
    //   }
    // }
    //
    // final personStore =
    //     getStore<
    //       prefixPerson.Response,
    //       prefixPerson.ResponseData,
    //       prefixPerson.Request
    //     >(
    //       requestFactory: () => prefixPerson.Request(repoViewId: 0),
    //       fromJsonD: (json) => prefixPerson.Response.fromJson(json),
    //     );
    //
    // // 2. Factory برای ایجاد storeهای مختلف
    // sl.registerFactoryParam<
    //   Store<ErpStoreState<dynamic, dynamic, dynamic>>,
    //   dynamic,
    //   dynamic
    // >((typeArguments, _) {
    //   // این یک پیاده‌سازی عمومی است
    //   // در عمل باید انواع مشخص T, D, C را بدانیم
    //   throw ArgumentError('Please use getStore() method with specific types');
    // });
    //
    // // می‌توانید store را در GetIt با یک کلید خاص ثبت کنید
    // if (!sl.isRegistered<
    //   Store<
    //     ErpStoreState<
    //       prefixPerson.Response,
    //       prefixPerson.ResponseData,
    //       prefixPerson.Request
    //     >
    //   >
    // >(instanceName: 'personStore')) {
    //   sl.registerSingleton<
    //     Store<
    //       ErpStoreState<
    //         prefixPerson.Response,
    //         prefixPerson.ResponseData,
    //         prefixPerson.Request
    //       >
    //     >
    //   >(personStore, instanceName: 'personStore');
    // }
    //
    // if (!sl.isRegistered<GenericPage>()) {
    //   sl.registerFactory(
    //     () =>
    //         GenericPage<
    //           SearchPersonBloc,
    //           prefixPerson.Response,
    //           prefixPerson.ResponseData,
    //           prefixPerson.Request
    //         >(
    //           createBloc: () => SearchPersonBloc(sl.get<PersonRepository>()),
    //           builder: (context, state, bloc) {
    //             return Scaffold(
    //               appBar: AppBar(
    //                 title: const Text('Users'),
    //                 actions: [
    //                   IconButton(
    //                     icon: const Icon(Icons.refresh),
    //                     onPressed: () => state.props,
    //                   ),
    //                 ],
    //               ),
    //               body: Scaffold(
    //                 body: Stack(
    //                   children: [
    //                     Padding(
    //                       padding: const EdgeInsets.symmetric(
    //                         horizontal: 10,
    //                         vertical: 10,
    //                       ),
    //                       child: ListView.builder(
    //                         itemCount: state.props.length,
    //                         itemBuilder: (context, index) {
    //                           return PersonExpander(person: state.props[index]);
    //                         },
    //                       ),
    //                     ),
    //                     AbsoultNewButton(),
    //                   ],
    //                 ),
    //               ),
    //             );
    //           },
    //         ),
    //   );
    // }
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
