// ignore_for_file: library_prefixes, unused_local_variable

import 'dart:io';

import 'package:erp_app/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:models_package/Base/enums.dart';
import 'package:models_package/base/language_model.dart';
import 'package:models_package/base/login_module.dart';
import 'package:provider/provider.dart';
import 'package:resources_package/l10n/app_localizations.dart';
import 'package:services_package/api_client_service.dart';
import 'package:services_package/default/com/select/currency_service.dart';
import 'package:services_package/default/com/select/year_service.dart';
import 'package:services_package/default/mng/select/language_service.dart';
import 'package:services_package/default/mng/select/place_service.dart';
import 'package:services_package/default/trh/select/cashier_service.dart';
import 'package:services_package/login_service.dart';
import 'package:services_package/storage/domain/usecases/storage_service.dart';
import 'package:shared_core/index.dart' as prefix0;

import 'content_wrapper.dart';
import 'feature/auth/menu/bloc/menu_bloc.dart';
import 'feature/auth/menu/bloc/menu_event.dart';
import 'feature/com/person/domain/repositories/person_repository.dart';
import 'feature/com/person/presentation/blocs/search_person_bloc/search_person_bloc.dart';
import 'feature/default_page/Language/bloc/language_bloc.dart';
import 'feature/default_page/cashier/bloc/cashier_bloc.dart';
import 'feature/default_page/currency/bloc/currency_bloc.dart';
import 'feature/default_page/place/bloc/place_bloc.dart';
import 'feature/default_page/year/bloc/year_bloc.dart';
import 'feature/profile/profile_bloc.dart';

final apiClient = sl<ApiClient>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  // Inject.initialize();
  await InjectionContainer.init();

  usePathUrlStrategy(); // برای وب

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sl<AppNotifier>()),
        Provider<LoginService>(
          create: (_) => LoginService(client: sl<ApiClient>()),
        ),
        Provider<PlaceBloc>(
          create: (_) => PlaceBloc(getPlaceUseCase: sl<PlaceService>()),
        ),
        Provider<CashierBloc>(
          create: (_) => CashierBloc(getCashierUseCase: sl<CashierService>()),
        ),
        Provider<CurrencyBloc>(
          create: (_) =>
              CurrencyBloc(getSelectCurrencyUseCase: sl<CurrencyService>()),
        ),
        Provider<YearBloc>(
          create: (_) => YearBloc(getSelectYearUseCase: sl<YearService>()),
        ),
        BlocProvider(
          create: (_) =>
              LanguageBloc(getLanguageUseCase: sl<LanguageService>()),
        ),
        BlocProvider(create: (_) => sl<MenuBloc>()..add(LoadMenuEvent())),
        BlocProvider(create: (_) => ProfileBloc()),
        BlocProvider(create: (_) => SearchPersonBloc(sl<PersonRepository>())),
      ],
      child: MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        ),
        showSemanticsDebugger: false,
        title: 'ERP App',
        debugShowCheckedModeBanner: false,

        darkTheme: ThemeData.dark(),
        themeMode: ThemeMode.system,
        home: buildERPApp(loginData: {}),
      ),
    ),
  );
}

Widget buildERPApp({required Map<String, dynamic> loginData}) {
  if (loginData.isEmpty) return const SizedBox();

  if (loginData[SessionKeysExt(SessionKeys.language).key] == null) {
    loginData[SessionKeysExt(SessionKeys.language).key] = LanguageModel(
      languageCode: 'fa',
      smallName: 'fa',
      id: 0,
      bigName: 'IR',
      completeName: 'fa_IR',
    );
  }

  usePathUrlStrategy();
  final loginModuleResult = LoginModuleResult.success(
    userDto: prefix0.UserDto(
      id: 0,
      refreshToken: '',
      firstName: 'a',
      fullName: 'a',
      lastName: 'a',
      token: '',
      type: 'user',
      password: '12',
      userName: '12',
    ),
    token: loginData[SessionKeysExt(SessionKeys.token).key],
    deviceToken: loginData[SessionKeysExt(SessionKeys.deviceToken).key],
    networkMode: loginData[SessionKeysExt(SessionKeys.networkType).key] ?? 0,
    cachedKey: 'a',
    language: LanguageModel(
      id: 0,
      bigName: 'fa',
      completeName: 'fa',
      languageCode: 'fa',
    ),
    managementAccount: [],
    success: loginData[SessionKeysExt(SessionKeys.success).key] ?? false,
    error: loginData[SessionKeysExt(SessionKeys.error).key] as String?,
    timestamp: loginData[SessionKeysExt(SessionKeys.timeStamp).key] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            loginData[SessionKeysExt(SessionKeys.timeStamp).key] as int,
          )
        : DateTime.now(),
    selectedManagementAccount: prefix0.ManagementAccounts(
      packageId: 0,
      managementAccountDesc: 'AMIR',
      expireDate: '',
      inActive: true,
      credit: 0,
      managementAccountId: 0,
    ),
  );

  final storageService = sl<StorageService>();

  storageService.saveLoginSessionModel(loginModuleResult);

  final placeService = sl<PlaceService>();
  final getCashierUseCase = sl<CashierService>();
  final getCurrencyUseCase = sl<CurrencyService>();
  final getYearUseCase = sl<YearService>();
  final getLanguageUseCase = sl<LanguageService>();

  try {
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider.value(value: sl<PageCacheProvider>()),
        Provider<LoginService>(
          create: (_) => LoginService(client: sl<ApiClient>()),
        ),
        Provider<PlaceBloc>(
          create: (_) => PlaceBloc(getPlaceUseCase: placeService),
        ),
        Provider<CashierBloc>(
          create: (_) => CashierBloc(getCashierUseCase: getCashierUseCase),
        ),
        Provider<CurrencyBloc>(
          create: (_) =>
              CurrencyBloc(getSelectCurrencyUseCase: getCurrencyUseCase),
        ),
        Provider<YearBloc>(
          create: (_) => YearBloc(getSelectYearUseCase: getYearUseCase),
        ),
        BlocProvider(
          create: (_) => LanguageBloc(getLanguageUseCase: getLanguageUseCase),
        ),
        BlocProvider(create: (_) => sl<MenuBloc>()..add(LoadMenuEvent())),
        BlocProvider(create: (_) => ProfileBloc()),
        // BlocProvider(
        //   create: (_) => PersonListBloc(personService: sl<PersonService>()),
        // ),
        BlocProvider(create: (_) => SearchPersonBloc(sl<PersonRepository>())),
      ],
      child: ErpContentWrapper(notifier: sl<AppNotifier>()),
    );
  } catch (e) {
    return Center(child: Text(e.toString()));
  }
}

/*

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  final appNotifier = PageCacheProvider();
  try {
    await Future.wait(<Future<void>>[InjectionContainer.init()]);
  } catch (e, stackTrace) {
    debugPrintStack(stackTrace: stackTrace);
  }
  // await InjectionContainer.init();

  sl.registerSingleton(appNotifier);
  // baseApp.BaseApp().initialiseRouting();
  // final apiClient = sl<ApiClient>();
  // final placeService = sl<PlaceService>();
  // final getCashierUseCase = sl<CashierService>();
  // final getCurrencyUseCase = sl<CurrencyService>();
  // final getYearUseCase = sl<YearService>();
  // final getLanguageUseCase = sl<LanguageService>();
  final storageService = sl<StorageService>();
  final lang = await storageService.loadLanguage();

  // runErp_App(lang);
  runApp(
    ChangeNotifierProvider.value(
      value: appNotifier,
      child: Consumer<PageCacheProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            title: 'App with Global Notifier',
            debugShowCheckedModeBanner: false,
            supportedLocales: <Locale>[const Locale('fa'), const Locale('en')],
            locale: Locale('fa'),
            localizationsDelegates: <LocalizationsDelegate<dynamic>>[
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            localeResolutionCallback:
                (Locale? locale, Iterable<Locale> supportedLocales) {
                  for (var supportedLocale in supportedLocales) {
                    if (supportedLocale.languageCode == locale?.languageCode) {
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: ThemeData().primaryColor,
              ),
              useMaterial3: true,
              fontFamily: 'Vazirani',
            ).copyWith(scaffoldBackgroundColor: Colors.white),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: ThemeData().primaryColor,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
              fontFamily: 'Vazirani',
            ).copyWith(scaffoldBackgroundColor: Colors.grey[900]),
            themeMode: ThemeMode.system,
            home: const MainAppScreen(),
          );
        },
      ),
    ),
  );
}

class MainAppScreen extends StatefulWidget {
  const MainAppScreen({super.key});

  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  @override
  Widget build(BuildContext context) {
    final notifier = Provider.of<PageCacheProvider>(context);
    // return Navigator(
    //   key: navigatorKey,
    //   onGenerateRoute: super.widget.generateRoute,
    //   initialRoute: Routes.signIn.value,
    // );
    return Directionality(
      textDirection: TextDirection.ltr,
      child: ErpContentWrapper(notifier: notifier),
    );
  }
}

// Widget runErp_App(LanguageModel lang) {
//   try {
//     final rootWidget = MultiBlocProvider(
//       providers: [
//         ChangeNotifierProvider(create: (_) => PageCacheProvider()),
//         Provider<LoginService>(create: (_) => LoginService(client: apiClient)),
//         Provider<PlaceBloc>(
//           create: (_) => PlaceBloc(getPlaceUseCase: sl<PlaceService>()),
//         ),
//         Provider<CashierBloc>(
//           create: (_) => CashierBloc(getCashierUseCase: sl<CashierService>()),
//         ),
//         Provider<CurrencyBloc>(
//           create: (_) =>
//               CurrencyBloc(getSelectCurrencyUseCase: sl<CurrencyService>()),
//         ),
//         Provider<YearBloc>(
//           create: (_) => YearBloc(getSelectYearUseCase: sl<YearService>()),
//         ),
//         BlocProvider(create: (_) => ProfileBloc()),
//         BlocProvider(
//           create: (_) =>
//               LanguageBloc(getLanguageUseCase: sl<LanguageService>()),
//         ),
//         BlocProvider(
//           create: (_) => PersonListBloc(personService: sl<PersonService>()),
//         ),
//         BlocProvider(create: (_) => SearchPersonBloc(sl<PersonRepository>())),
//         BlocProvider(create: (_) => sl<MenuBloc>()..add(LoadMenuEvent())),
//       ],
//       child: MainApp(
//         initialLanguage: lang,
//         messengerService: sl<ExceptionHelperService>(),
//       ),
//     );
//
//     AppErrorHandler.initializeErrorHandlers(rootWidget);
//     return rootWidget;
//   } catch (e) {
//     return Center(child: Text(e.toString()));
//   }
// }

// class MainApp extends StatelessWidget with baseApp.BaseApp {
//   final LanguageModel initialLanguage;
//   final bool invalidSession;
//   final ExceptionHelperService messengerService;
//
//   MainApp({
//     super.key,
//     required this.initialLanguage,
//     required this.messengerService,
//     this.invalidSession = false,
//   }) {
//     initialiseRouting();
//   }
//
//   MainAppScreen createState() => MainAppScreen();
//
//   @override
//   Map<String, WidgetBuilderArgs> get baseRoutes =>
//       <String, WidgetBuilderArgs>{};
//
//   @override
//   List<microApp.MicroApp> get microApps => <microApp.MicroApp>[ErpResolver()];
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       color: Colors.white,
//       navigatorKey: NavigatorAgent.navigatorKey,
//       debugShowCheckedModeBanner: false,
//       locale: Locale(initialLanguage.languageCode ?? 'fa'),
//       supportedLocales: AppLocalizations.supportedLocales,
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       theme: ThemeData(
//         scaffoldBackgroundColor: Colors.white,
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
//       ),
//       home: const MainAppScreen(),
//       scrollBehavior: ScrollBehavior(),
//     );
//   }
// }
//
// class MainAppScreen extends StatelessWidget {
//   const MainAppScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final isRTL = Localizations.localeOf(context).languageCode == 'fa';
//
//     return Consumer<PageCacheProvider>(
//       builder: (context, notifier, child) {
//         if (notifier.isSignOutNeed) {
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             Restart.restartApp();
//           });
//           return const Scaffold(
//             body: Center(
//               child: CircularProgressIndicator(backgroundColor: Colors.white),
//             ),
//           );
//         }
//         return
//         // textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
//         _buildContent(context, notifier);
//       },
//     );
//   }
//
//   Widget _buildContent(BuildContext context, PageCacheProvider notifier) {
//     if (notifier.isErrorState) {
//       return _buildErrorWidget(notifier);
//     }
//
//     // if (notifier.isErrorState) {
//     //   return _buildErrorWidget(notifier);
//     // }
//
//     if (notifier.isSkeletonActive) {
//       return notifier.getPage(NavButtonTabBarMode.erpDashboardTabMode);
//     }
//
//     switch (notifier.pageType) {
//       case PageType.listGenerator:
//         final isListGeneratorActive =
//             (notifier.isListGeneratorActive.values.last);
//         if (isListGeneratorActive) {
//           return _buildListGeneratorContent(notifier, context);
//         }
//         return ErpNotFound();
//       case PageType.formGenerator:
//         final isFormGeneratorActive =
//             notifier.isFormGeneratorActive.values.first;
//         if (isFormGeneratorActive) {
//           return _buildFormGeneratorContent();
//         }
//         return ErpNotFound();
//       case PageType.tabBar:
//         return _buildMainContent(context, notifier);
//     }
//
//     // حالت فرم جنریک فعال
//   }
//
//   Widget _buildListGeneratorContent(
//     PageCacheProvider notifier,
//     BuildContext context,
//   ) {
//     return AdvancedRouter.buildPage(
//       RouteData(
//         path: notifier.isListGeneratorActive.keys.last,
//         location: 'vsa',
//         queryParams: {},
//         pathParams: {},
//         arguments: [],
//         pathEndsWithSlash: false,
//         redirectedFrom: [],
//         subLocation: '',
//         navigatorKey: NavigatorAgent.navigatorKey,
//       ),
//       context,
//     ); // یا return YourListGeneratorWidget();
//   }
//
//   Widget _buildFormGeneratorContent() {
//     // محتوای فرم جنریک
//     return SizedBox(child: Text('Form Generator'));
//   }
//
//   Widget _buildMainContent(BuildContext context, PageCacheProvider notifier) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: notifier.appBarMode,
//       body: Column(
//         children: [
//           if (notifier.errorMessages.length > 1) _buildErrorWidget(notifier),
//
//           Expanded(
//             child: Consumer<PageCacheProvider>(
//               builder: (context, navNotifier, child) {
//                 return navNotifier.getPage(notifier.selectedTab);
//               },
//             ),
//           ),
//
//           AppNavigationButton(
//             selectedTab: notifier.selectedTab,
//             onTabSelected: (value) =>
//                 notifier.changePage(PageType.tabBar, route: null, tab: value),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildErrorWidget(PageCacheProvider notifier) {
//     return Scaffold(
//       backgroundColor: Colors.red.withAlpha(100),
//
//       body: Row(
//         children: [
//           const Icon(Icons.error, color: Colors.red),
//           const SizedBox(width: 8),
//           Expanded(child: Text(notifier.errorMessages.last)),
//           IconButton(
//             onPressed: notifier.clearError,
//             icon: const Icon(Icons.close),
//           ),
//         ],
//       ),
//     );
//   }
// }

Widget buildERPApp({required Map<String, dynamic> loginData}) {
  if (loginData.isEmpty) return const SizedBox();

  if (loginData[SessionKeysExt(SessionKeys.language).key] == null) {
    loginData[SessionKeysExt(SessionKeys.language).key] = LanguageModel(
      languageCode: 'fa',
      smallName: 'fa',
      id: 0,
      bigName: 'IR',
      completeName: 'fa_IR',
    );
  }

  usePathUrlStrategy();
  final loginModuleResult = LoginModuleResult.success(
    userDto: prefix0.UserDto(
      id: 0,
      refreshToken: '',
      firstName: 'a',
      fullName: 'a',
      lastName: 'a',
      token: '',
      type: 'user',
      password: '12',
      userName: '12',
    ),

    token: loginData[SessionKeysExt(SessionKeys.token).key],
    deviceToken: loginData[SessionKeysExt(SessionKeys.deviceToken).key],
    networkMode: loginData[SessionKeysExt(SessionKeys.networkType).key] ?? 0,
    cachedKey: 'a',
    language: LanguageModel(
      id: 0,
      bigName: 'fa',
      completeName: 'fa',
      languageCode: 'fa',
    ),
    managementAccount: [],
    success: loginData[SessionKeysExt(SessionKeys.success).key] ?? false,
    error: loginData[SessionKeysExt(SessionKeys.error).key] as String?,
    timestamp: loginData[SessionKeysExt(SessionKeys.timeStamp).key] != null
        ? DateTime.fromMillisecondsSinceEpoch(
            loginData[SessionKeysExt(SessionKeys.timeStamp).key] as int,
          )
        : DateTime.now(),
    selectedManagementAccount: prefix0.ManagementAccounts(
      packageId: 0,
      managementAccountDesc: 'AMIR',
      expireDate: '',
      inActive: true,
      credit: 0,
      managementAccountId: 0,
    ),
  );

  final storageService = sl<StorageService>();

  storageService.saveLoginSessionModel(loginModuleResult);

  final placeService = sl<PlaceService>();
  final getCashierUseCase = sl<CashierService>();
  final getCurrencyUseCase = sl<CurrencyService>();
  final getYearUseCase = sl<YearService>();
  final getLanguageUseCase = sl<LanguageService>();

  try {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sl<PageCacheProvider>()),
        Provider<LoginService>(
          create: (_) => LoginService(client: sl<ApiClient>()),
        ),
        Provider<PlaceBloc>(
          create: (_) => PlaceBloc(getPlaceUseCase: placeService),
        ),
        Provider<CashierBloc>(
          create: (_) => CashierBloc(getCashierUseCase: getCashierUseCase),
        ),
        Provider<CurrencyBloc>(
          create: (_) =>
              CurrencyBloc(getSelectCurrencyUseCase: getCurrencyUseCase),
        ),
        Provider<YearBloc>(
          create: (_) => YearBloc(getSelectYearUseCase: getYearUseCase),
        ),
        BlocProvider(
          create: (_) => LanguageBloc(getLanguageUseCase: getLanguageUseCase),
        ),
        BlocProvider(create: (_) => sl<MenuBloc>()..add(LoadMenuEvent())),
        BlocProvider(create: (_) => ProfileBloc()),
        // BlocProvider(
        //   create: (_) => PersonListBloc(personService: sl<PersonService>()),
        // ),
        BlocProvider(create: (_) => SearchPersonBloc(sl<PersonRepository>())),
      ],
      child: ErpContentWrapper(notifier: sl<PageCacheProvider>()),
      // MainAppScreen(
      //   // initialLanguage:
      //   //     loginModuleResult.language ?? LanguageModel(languageCode: 'fa'),
      //   // messengerService: sl<ExceptionHelperService>(),
      // ),
    );
  } catch (e) {
    return Center(child: Text(e.toString()));
  }
}
*/
