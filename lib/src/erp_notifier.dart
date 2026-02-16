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
import '../feature/auth/user_info/pages/user_info.dart';
import '../feature/open_page/open_page.dart';

class ErpAppNotifier
    extends MicroAppNotifier<CoreDto<ErpAppsCoreEnum>, ErpAppsCoreEnum> {
  ErpAppsCoreEnum? _activeModule;
  dynamic _modulePayload;
  static final Map<String, bool> _defValue = {'first': false};

  // ignore: prefer_final_fields
  Map<String, bool> _isListRoute = _defValue;

  // ignore: prefer_final_fields
  Map<String, bool> _isFormRoute = _defValue;

  Map<String, bool> get isListGeneratorActive => _isListRoute;

  Map<String, bool> get isFormGeneratorActive => Map.from(_isFormRoute);

  ErpAppsCoreEnum? get activeModule => _activeModule;

  dynamic get modulePayload => _modulePayload;

  ErpAppNotifier() {
    _registerErpEvents();
  }

  void _registerErpEvents() {
    CustomEventBus.on<OpenErpModuleEvent>((event) {
      openModule(event.module, payload: event.payload);
    });

    CustomEventBus.on<ErpCloseEvent>((event) {
      closeModule();
    });
  }


  AppBarsMode getMod(){
    switch(selectedTab){
      case NavButtonTabBarMode.erpGenericFormTabMode:
        return AppBarsMode.erpGenericForm;
      case NavButtonTabBarMode.erpMenuTabMode:
        return AppBarsMode.erpMenuMode;

      case NavButtonTabBarMode.erpNewTabMode:
        return AppBarsMode.erpNewMode;
      case NavButtonTabBarMode.erpOpenedTabMode:
        return AppBarsMode.erpOpenedMode;
      case NavButtonTabBarMode.erpDefaultTabMode:
        return AppBarsMode.erpDefaultMode;
      case NavButtonTabBarMode.erpProfileTabMode:
        return AppBarsMode.erpProfileMode;
      case NavButtonTabBarMode.erpGenericListTabMode:
        return AppBarsMode.erpGenericList;
      case NavButtonTabBarMode.erpNotFound:
        return AppBarsMode.erpNotFound;
      case NavButtonTabBarMode.skeletion:
        return AppBarsMode.erpDashboardMode;
      case NavButtonTabBarMode.erpDashboardTabMode:
        return AppBarsMode.erpDashboardMode;


      case NavButtonTabBarMode.erpUserInfo:
        return AppBarsMode.erpUserInfo;
    }
  }

  void openModule(ErpAppsCoreEnum module, {dynamic payload}) {
    _activeModule = module;
    _modulePayload = payload;

    notifyListeners();
  }

  Widget getErpPage(NavButtonTabBarMode tab, {bool forceRefresh = false}) {
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
        return ErpListGeneratorResolver(
          route: getListRoute.toString().toLowerCase(),
        ).getPage();


      case NavButtonTabBarMode.erpGenericFormTabMode:
        return DynamicFormGenerator(jsonString: '');

        return ErpFormGeneratorResolver().getPage();
      case NavButtonTabBarMode.skeletion:
        return Text('ERP parent nav: skeletion');
      case NavButtonTabBarMode.erpDashboardTabMode:
        return Text('ERP parent nav: erpDashboardTabMode');
      case NavButtonTabBarMode.erpUserInfo:
        return UserInfo();

    }
  }

  void closeModule() {
    _activeModule = null;
    _modulePayload = null;

    notifyListeners();
  }
}
