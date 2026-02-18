// ignore_for_file: library_prefixes, unused_local_variable

import 'dart:io';

import 'package:erp_app/feature/default_page/pages/default_bloc.dart';
import 'package:erp_app/index.dart';
import 'package:erp_app/src/content_wrapper.dart';
import 'package:erp_app/src/erp_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:models_package/index.dart' hide SessionKeysExt, SessionKeys;
import 'package:provider/provider.dart';
import 'package:resources_package/Resources/Theme/theme_manager.dart';
import 'package:resources_package/l10n/app_localizations.dart';
import 'package:services_package/api_client_service.dart';
import 'package:services_package/auth/menu/menu_service.dart';
import 'package:services_package/com/person/person_service.dart';
import 'package:services_package/default/com/select/currency_service.dart';
import 'package:services_package/default/com/select/year_service.dart';
import 'package:services_package/default/mng/select/place_service.dart';
import 'package:services_package/default/trh/select/cashier_service.dart';
import 'package:services_package/index.dart';
import 'package:services_package/login_service.dart';
import 'package:services_package/storage/domain/usecases/storage_service.dart';
import 'package:toastification/toastification.dart';
import 'package:ui_components_package/erp_app_componenets/common/Buttons/language_button_standalone/language_button_stand_alone_cubit.dart';
import 'package:ui_components_package/erp_app_componenets/common/toast/toast.dart';

import 'feature/auth/menu/bloc/menu_bloc.dart';
import 'feature/auth/menu/bloc/menu_event.dart';
import 'feature/com/person/domain/repositories/person_repository.dart';
import 'feature/com/person/presentation/blocs/person_bloc/person_list_bloc.dart';
import 'feature/com/person/presentation/blocs/search_person_bloc/search_person_bloc.dart';
import 'feature/com/person/presentation/widgets/person_list_nav.dart';
import 'feature/default_page/cashier/bloc/cashier_bloc.dart';
import 'feature/default_page/cashier/bloc/cashier_event.dart';
import 'feature/default_page/currency/bloc/currency_bloc.dart';
import 'feature/default_page/currency/bloc/currency_event.dart';
import 'feature/default_page/place/bloc/place_bloc.dart';
import 'feature/default_page/place/bloc/place_event.dart';
import 'feature/default_page/year/bloc/year_bloc.dart';
import 'feature/default_page/year/bloc/year_event.dart';
import 'feature/list_generator/data/models/generic_list_entity_state.dart';
import 'feature/profile/profile_bloc.dart';

final apiClient = sl<ApiClient>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();

  await InjectionContainer.init();

  usePathUrlStrategy(); // برای وب

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sl<AppNotifier>()),
        ChangeNotifierProvider.value(value: sl<ErpAppNotifier>()),
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
        // BlocProvider(
        //   create: (_) =>
        //       LanguageBloc(getLanguageUseCase: sl<LanguageService>()),
        // ),
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
        locale: AppTheme.local.value,
        supportedLocales: AppLocalizations.supportedLocales,
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

void drawerRegister(){
  // final PermissionService permissionService = router.register('/accounting', (c, p, a) => const DashboardPage());
  // DrawerRegistry.instance.registerProvider(DashboardDrawerProvider());

  // final routeService = DrawerRouteHandler();
  // Map<String, RouteHandler> getRoutes() {
  //   return {
  //     '/accounting':  (a,b,c) => DashboardPage(),
  //   };
  // }
  // IDrawerItemProvider getProvider() => DashboardDrawerProvider();
  // final routeService = DrawerRegistry;
  // DrawerRegistry.instance.registerProvider(DashboardDrawerProvider( ));
  // routeService.register('/home', (c, p, a) => DashboardPage(
  //   onNavigate: (ctx, routeKey, {params, args}) =>
  //       routeService.navigateTo(ctx, routeKey, params: params, args: args),
  // ));

}

Widget buildERPApp({required Map<String, dynamic> loginData}) {
  if (loginData.isEmpty) return const SizedBox();
  drawerRegister();
  if (loginData[SessionKeysExt(SessionKeys.language).key] == null) {
    loginData[SessionKeysExt(SessionKeys.language).key] = LanguageModel(
      languageCode: 'fa',
      smallName: 'fa',
      id: 0,
      bigName: 'IR',
      completeName: 'fa_IR',
    );
  }
  if (!sl.isRegistered<MenuBloc>()) {
    sl.registerFactory(
      () => MenuBloc(
        getMenuUseCase: sl<MenuService>(),
        onErrorEven: loginBlocOnError,
      ),
    );
  }
  usePathUrlStrategy();
  final loginModuleResult = LoginModuleResult.fromJson(loginData);

  final storageService = sl<StorageService>();

  storageService.saveLoginSessionModel(loginModuleResult);
  try {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sl<ErpAppNotifier>()),
        ChangeNotifierProvider<
          GenericListEntityState<BaseResponse<Person>, Person, BaseRequest>
        >(
          create: (_) =>
              GenericListEntityState<BaseResponse<Person>, Person, BaseRequest>(
                request: BaseRequest(),
                response: BaseResponse(),
                fields: [],
              ),
        ),
        Provider<LoginService>(
          create: (_) => LoginService(client: sl<ApiClient>()),
        ),
        BlocProvider<LanguageButtonStandAloneCubit>(
          create: (_) => LanguageButtonStandAloneCubit(
            initialLocale: AppTheme.local.value,
            storage: storageService,
            onLocalChange: (s) async {
              await storageService.saveLanguage(LanguageModel(languageCode: s));
            },
          ),
        ),
        // BlocProvider<LanguageBloc>(
        //   create: (_) => sl<LanguageBloc>()..add(LoadLanguageEvent()),
        // ),
        BlocProvider<DefaultBloc>(create: (_) => sl<DefaultBloc>()),
        BlocProvider<YearBloc>(
          create: (_) => sl<YearBloc>()..add(LoadYearEvent()),
        ),
        BlocProvider<CurrencyBloc>(
          create: (_) => sl<CurrencyBloc>()..add(LoadCurrencyEvent()),
        ),
        BlocProvider<CashierBloc>(
          create: (_) => sl<CashierBloc>()..add(LoadCashierEvent()),
        ),
        BlocProvider<PlaceBloc>(
          create: (_) => sl<PlaceBloc>()..add(LoadPlaceEvent()),
        ),
        // BlocProvider<LanguageBloc>(create: (_) => sl<LanguageBloc>()..add(LoadLanguageEvent())),
        // context.read<CurrencyBloc>().add(const LoadCurrencyEvent());
        // context.read<CashierBloc>().add(const LoadCashierEvent());
        // context.read<PlaceBloc>().add(const LoadPlaceEvent());
        // context.read<LanguageBloc>().add(const LoadLanguageEvent());
        BlocProvider<MenuBloc>(
          create: (_) => sl<MenuBloc>()..add(LoadMenuEvent()),
        ),

        BlocProvider(create: (_) => ProfileBloc()),
        BlocProvider(
          create: (_) => PersonListBloc(personService: sl<PersonService>()),
        ),
        BlocProvider(create: (_) => SearchPersonBloc(sl<PersonRepository>())),
      ],
      child: ErpContentWrapper(notifier: sl<ErpAppNotifier>()),
    );
  } catch (e) {
    return Center(child: Text(e.toString()));
  }
}

void loginBlocOnError(
  BuildContext context,
  String? title,
  String? description,
) {
  ModernToast().showToast(
    context,
    Text(title ?? 'خطا'),
    Text(description ?? 'مشکلی رخ داده'),
    ToastificationType.warning,
  );
}
