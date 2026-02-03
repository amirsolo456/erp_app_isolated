import 'package:erp_app/feature/default_page/pages/default_page.dart';
import 'package:erp_app/feature/form_generator/bloc/base_bloc/erp_form_generator_resolver.dart';
import 'package:erp_app/feature/list_generator/presentation/bloc/base_bloc/erp_list_generator_resolver.dart';
import 'package:erp_app/feature/profile/profile.dart';
import 'package:erp_app/micro_app/erp_events.dart';
import 'package:flutter/cupertino.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:micro_app_commons/features/not_found/presentation/not_found_page.dart';
import 'package:micro_app_core/index.dart';
import 'package:models_package/index.dart';
import '../feature/auth/menu/pages/menu_page.dart';
import '../feature/open_page/open_page.dart';

class ErpAppNotifier
    extends MicroAppNotifier<CoreDto<ErpAppsCoreEnum>, ErpAppsCoreEnum> {
  ErpAppsCoreEnum? _activeModule;
  dynamic _modulePayload;
  static final Map<String, bool> _defValue = {'first': false};
  Map<String, bool> _isListRoute = _defValue;
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
        return ErpFormGeneratorResolver().getPage();
      case NavButtonTabBarMode.erpOpenedTabMode:
        return OpenedPage(items: []);
      case NavButtonTabBarMode.erpDefaultTabMode:
        return DefaultPage();
      case NavButtonTabBarMode.erpGenericListTabMode:
        return ErpListGeneratorResolver().getPage();
      case NavButtonTabBarMode.erpGenericFormTabMode:
        return ErpFormGeneratorResolver().getPage();
      case NavButtonTabBarMode.skeletion:
        return Text('ERP parent nav: skeletion');
      case NavButtonTabBarMode.erpDashboardTabMode:
        return Text('ERP parent nav: erpDashboardTabMode');
    }
  }

  void closeModule() {
    _activeModule = null;
    _modulePayload = null;

    notifyListeners();
  }
}
