// ignore_for_file: library_prefixes, unused_local_variable

import 'dart:io';

import 'package:erp_app/index.dart';
import 'package:erp_app/src/content_wrapper.dart';
import 'package:erp_app/src/erp_notifier.dart';
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
import 'package:services_package/auth/menu/menu_service.dart';
import 'package:services_package/default/com/select/currency_service.dart';
import 'package:services_package/default/com/select/year_service.dart';
import 'package:services_package/default/mng/select/language_service.dart';
import 'package:services_package/default/mng/select/place_service.dart';
import 'package:services_package/default/trh/select/cashier_service.dart';
import 'package:services_package/login_service.dart';
import 'package:services_package/storage/domain/usecases/storage_service.dart';
import 'package:shared_core/index.dart'  ;
import 'package:toastification/toastification.dart';
import 'package:ui_components_package/erp_app_componenets/common/toast/toast.dart';


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


import 'package:shared_core/index.dart';
import 'package:services_package/api_service.dart';

import '../../../../core/network/injection_container.dart';





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
  if (!sl.isRegistered<MenuBloc>()) {
    sl.registerFactory(() => MenuBloc(getMenuUseCase: sl<MenuService>(),onErrorEven: loginBlocOnError));
  }
  usePathUrlStrategy();
  final loginModuleResult = LoginModuleResult.fromJson(loginData);

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
        ChangeNotifierProvider.value(value: sl<ErpAppNotifier>()),
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
      child: ErpContentWrapper(notifier: sl<ErpAppNotifier>()),
    );
  } catch (e) {
    return Center(child: Text(e.toString()));
  }

}

void loginBlocOnError(BuildContext context,String? title, String? description) {


  ModernToast().showToast(
    context,
    Text(title ?? 'خطا'),
    Text(description ?? 'مشکلی رخ داده'),
            ToastificationType.warning ,
  );
}
