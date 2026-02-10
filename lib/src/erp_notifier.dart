import 'package:erp_app/feature/add_new/add-new_page.dart';
import 'package:erp_app/feature/default_page/pages/default_page.dart';
import 'package:erp_app/feature/form_generator/bloc/base_bloc/erp_form_generator_resolver.dart';
import 'package:erp_app/feature/form_generator/widgets/dynamic_form_generator.dart';
import 'package:erp_app/feature/list_generator/presentation/bloc/base_bloc/erp_list_generator_resolver.dart';
import 'package:erp_app/feature/profile/profile.dart';
import 'package:erp_app/micro_app/erp_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:micro_app_commons/features/not_found/presentation/not_found_page.dart';
import 'package:micro_app_core/index.dart';
import 'package:models_package/index.dart';
import '../feature/auth/menu/pages/menu_page.dart';
import '../feature/open_page/open_page.dart';
import '../micro_app/erp_resolver.dart';

bool _first = false;

class ErpAppNotifier
    extends MicroAppNotifier<CoreDto<ErpAppsCoreEnum>, ErpAppsCoreEnum> {
  ModuleState _moduleState;
  late final IErpPageResolver _pageResolver;

  ErpAppNotifier() : _moduleState = ModuleState(), super() {
    if (!_first) {
      _pageResolver = ErpResolver(() => getListRoute.toString());
      _registerErpEvents();
      _first = true;
    }
  }

  ModuleState get moduleState => _moduleState;

  ErpAppsCoreEnum? get activeModule => _moduleState.activeModule;

  dynamic get modulePayload => _moduleState.payload;

  Map<String, bool> get isListGeneratorActive =>
      Map.from(_moduleState.isListRoute);

  Map<String, bool> get isFormGeneratorActive =>
      Map.from(_moduleState.isFormRoute);

  // ErpAppNotifier() {
  //   _registerErpEvents();
  //   _pageBuilders = {
  //     NavButtonTabBarMode.erpProfileTabMode: (_) => ProfilePage(),
  //     NavButtonTabBarMode.erpNotFound: (_) => NotFoundPage(),
  //     NavButtonTabBarMode.erpMenuTabMode: (_) => MenuPage(),
  //     NavButtonTabBarMode.erpNewTabMode: (_) => AddNewPage(),
  //     NavButtonTabBarMode.erpOpenedTabMode: (_) => OpenedPage(items: []),
  //     NavButtonTabBarMode.erpDefaultTabMode: (_) => DefaultPage(),
  //     NavButtonTabBarMode.erpGenericListTabMode: (args) {
  //       if (args != null) {
  //         return ErpListGeneratorResolver(
  //           route: getListRoute.toString().toLowerCase(),
  //         ).getPage(args: args);
  //       }
  //       return Text('ERP parent nav: erpDashboardTabMode');
  //     },
  //     NavButtonTabBarMode.erpGenericFormTabMode: (args) {
  //       if (args != null) {
  //         return ErpFormGeneratorResolver(
  //           route: getListRoute.toString().toLowerCase(),
  //         ).getPage(args: args);
  //       }
  //       return Text('ERP parent nav: erpDashboardTabMode');
  //     },
  //     NavButtonTabBarMode.skeletion: (_) => Text('ERP parent nav: skeletion'),
  //     NavButtonTabBarMode.erpDashboardTabMode: (_) =>
  //         Text('ERP parent nav: erpDashboardTabMode'),
  //   };
  // }

  ErpAppsCoreEnum? _activeModule;
  dynamic _modulePayload;
  static final Map<String, bool> _defValue = {'first': false};

  // ignore: prefer_final_fields
  Map<String, bool> _isListRoute = _defValue;

  // ignore: prefer_final_fields
  Map<String, bool> _isFormRoute = _defValue;

  // Map<String, bool> get isListGeneratorActive => _isListRoute;
  //
  // Map<String, bool> get isFormGeneratorActive => Map.from(_isFormRoute);
  //
  // ErpAppsCoreEnum? get activeModule => _activeModule;
  //
  // dynamic get modulePayload => _modulePayload;

  // ErpAppNotifier() {
  //   _registerErpEvents();
  // }

  void _registerErpEvents() {
    final openModuleSubscription = CustomEventBus.on<OpenErpModuleEvent>((
      event,
    ) {
      openModule(event.module, payload: event.payload);
    });

    final closeModuleSubscription = CustomEventBus.on<ErpCloseEvent>((event) {
      closeModule();
    });

    // CustomEventBus.on<OpenErpModuleEvent>((event) {
    //   openModule(event.module, payload: event.payload);
    // });
    //
    // CustomEventBus.on<ErpCloseEvent>((event) {
    //   closeModule();
    // });
  }

  void setArguments(
    PageType pageType, {
    NavButtonTabBarMode? tab,
    ErpAppsCoreEnum? active,
    String? route,
    Map<String, dynamic>? args,
  }) {
    _moduleState = ModuleState(activeModule: active, args: args ?? {});
    notifyListeners();
  }

  AppBarsMode getMod() {
    return _mapTabToAppBarMode(selectedTab);
  }

  AppBarsMode _mapTabToAppBarMode(NavButtonTabBarMode tab) {
    final modeMap = <NavButtonTabBarMode, AppBarsMode>{
      NavButtonTabBarMode.erpGenericFormTabMode: AppBarsMode.erpGenericForm,
      NavButtonTabBarMode.erpMenuTabMode: AppBarsMode.erpMenuMode,
      NavButtonTabBarMode.erpNewTabMode: AppBarsMode.erpNewMode,
      NavButtonTabBarMode.erpOpenedTabMode: AppBarsMode.erpOpenedMode,
      NavButtonTabBarMode.erpDefaultTabMode: AppBarsMode.erpDefaultMode,
      NavButtonTabBarMode.erpProfileTabMode: AppBarsMode.erpProfileMode,
      NavButtonTabBarMode.erpGenericListTabMode: AppBarsMode.erpGenericList,
      NavButtonTabBarMode.erpNotFound: AppBarsMode.erpNotFound,
      NavButtonTabBarMode.skeletion: AppBarsMode.erpDashboardMode,
      NavButtonTabBarMode.erpDashboardTabMode: AppBarsMode.erpDashboardMode,
    };

    return modeMap[tab] ?? AppBarsMode.erpDashboardMode;
  }

  void openModule(ErpAppsCoreEnum module, {dynamic payload}) {
    _moduleState = _moduleState.copyWith(
      activeModule: module,
      payload: payload,
    );
    notifyListeners();
  }

  void closeModule() {
    _moduleState = _moduleState.copyWith(activeModule: null, payload: null);
    notifyListeners();
  }

  // Update route states
  void updateListRouteState(String key, bool value) {
    _moduleState = _moduleState.copyWith(
      isListRoute: {..._moduleState.isListRoute}..[key] = value,
    );
    notifyListeners();
  }

  void updateFormRouteState(String key, bool value) {
    _moduleState = _moduleState.copyWith(
      isFormRoute: {..._moduleState.isFormRoute}..[key] = value,
    );
    notifyListeners();
  }

  Widget getErpPage(
    NavButtonTabBarMode tab, {
    bool forceRefresh = false,
    Map<String, dynamic>? args,
  }) {
    // You could use forceRefresh here if needed
    return _pageResolver.resolvePage(tab, args: args);
  }

  // Optional: Add cleanup method
  void dispose() {
    // Dispose any subscriptions if stored
  }
  //
  // void openModule(ErpAppsCoreEnum module, {dynamic payload}) {
  //   _activeModule = module;
  //   _modulePayload = payload;
  //
  //   notifyListeners();
  // }
  // Widget getErpPage(
  //     NavButtonTabBarMode tab, {
  //       bool forceRefresh = false,
  //       Map<String, dynamic>? args,
  //     }) {
  //   final builder = _pageBuilders[tab];
  //   if (builder != null) {
  //     return builder(args);
  //   }
  //   return Text('No page found for $tab');
  // }
  /*
  Widget getErpPage(
    NavButtonTabBarMode tab, {
    bool forceRefresh = false,
    Map<String, dynamic>? args,
  }) {
    switch (tab) {
      case NavButtonTabBarMode.erpProfileTabMode:
        return ProfilePage();
      case NavButtonTabBarMode.erpNotFound:
        return NotFoundPage();
      case NavButtonTabBarMode.erpMenuTabMode:
        return MenuPage();
      case NavButtonTabBarMode.erpNewTabMode:
        return AddNewPage();
      case NavButtonTabBarMode.erpOpenedTabMode:
        return OpenedPage(items: []);
      case NavButtonTabBarMode.erpDefaultTabMode:
        return DefaultPage();
      case NavButtonTabBarMode.erpGenericListTabMode:
        if (args != null) {
          return ErpListGeneratorResolver(
            route: getListRoute.toString().toLowerCase(),
          ).getPage(args: args);
        }
        return Text('ERP parent nav: erpDashboardTabMode');
      case NavButtonTabBarMode.erpGenericFormTabMode:
        if (args != null) {
          return ErpFormGeneratorResolver(
            route: getListRoute.toString().toLowerCase(),
          ).getPage(args: args);
        }
        return Text('ERP parent nav: erpDashboardTabMode');
      case NavButtonTabBarMode.skeletion:
        return Text('ERP parent nav: skeletion');
      case NavButtonTabBarMode.erpDashboardTabMode:
        return Text('ERP parent nav: erpDashboardTabMode');
    }
  }*/

  // void closeModule() {
  //   _activeModule = null;
  //   _modulePayload = null;
  //
  //   notifyListeners();
  // }
}
