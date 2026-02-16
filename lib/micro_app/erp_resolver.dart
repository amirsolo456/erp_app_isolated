// ignore_for_file: unused_element, unused_local_variable

import 'dart:async';

import 'package:erp_app/feature/form_generator/bloc/base_bloc/erp_form_generator_events.dart';
import 'package:erp_app/feature/form_generator/bloc/base_bloc/erp_form_generator_resolver.dart';
import 'package:erp_app/feature/profile/profile_page.dart';
import 'package:erp_app/main.dart';
import 'package:erp_app/micro_app/erp_events.dart';
import 'package:flutter/material.dart';
import 'package:micro_app_commons/features/not_found/presentation/not_found_page.dart';
import 'package:micro_app_commons/features/popup/domain/entities/enum.dart';
import 'package:micro_app_commons/features/popup/presentation/bloc/base_bloc/popup_events.dart';
import 'package:micro_app_core/index.dart';
import 'package:models_package/index.dart';
import 'package:services_package/storage/domain/usecases/storage_service.dart';
import '../feature/add_new/add-new_page.dart';
import '../feature/auth/menu/pages/menu_page.dart';
import '../feature/default_page/pages/default_page.dart';
import '../feature/list_generator/presentation/bloc/base_bloc/erp_list_generator_resolver.dart';
import '../feature/open_page/open_page.dart';
import '../src/advance_router.dart';
import '../core/network/injection_container.dart';
import 'erp_inject.dart';

abstract class IErpPageResolver {
  Widget resolvePage(NavButtonTabBarMode tab, {Map<String, dynamic>? args});
}

class ErpResolver extends MicroApp<ErpCoreModel, ErpAppsCoreEnum>
    implements IErpPageResolver {
  final Map<ErpAppsCoreEnum, MicroAppAction> callbacks;

  final String Function() routeProvider;

  ErpResolver(this.routeProvider)
    : callbacks = {
        ErpAppsCoreEnum.erpDashboard: () {},
        ErpAppsCoreEnum.erpMenu: () {},
        ErpAppsCoreEnum.erpForm: () {},
        ErpAppsCoreEnum.erpList: () {},
        ErpAppsCoreEnum.erpLoad: () {},
        ErpAppsCoreEnum.erpOpened: () {},
        ErpAppsCoreEnum.erpError: () {},
      },
      super(
        ErpCoreModel(
          functions: {
            ErpAppsCoreEnum.erpDashboard: () {},
            ErpAppsCoreEnum.erpMenu: () {},
            ErpAppsCoreEnum.erpForm: () {},
            ErpAppsCoreEnum.erpList: () {},
            ErpAppsCoreEnum.erpLoad: () {},
            ErpAppsCoreEnum.erpOpened: () {},
            ErpAppsCoreEnum.erpError: () {},
          },
          name: MicroAppsName.erpApp,
        ),
      );

  @override
  Widget resolvePage(NavButtonTabBarMode tab, {Map<String, dynamic>? args}) {
    return _resolvePage(tab, args);
  }

  Widget _resolvePage(NavButtonTabBarMode tab, Map<String, dynamic>? args) {
    switch (tab) {
      case NavButtonTabBarMode.erpProfileTabMode:
        return const ProfilePage();
      case NavButtonTabBarMode.erpNotFound:
        return const NotFoundPage();
      case NavButtonTabBarMode.erpMenuTabMode:
        return const MenuPage();
      case NavButtonTabBarMode.erpNewTabMode:
        return const AddNewPage();
      case NavButtonTabBarMode.erpOpenedTabMode:
        return const OpenedPage(items: []);
      case NavButtonTabBarMode.erpDefaultTabMode:
        return const DefaultPage();
      case NavButtonTabBarMode.erpGenericListTabMode:
        return _resolveListPage(args);
      case NavButtonTabBarMode.erpGenericFormTabMode:
        return _resolveFormPage(args);
      case NavButtonTabBarMode.skeletion:
      case NavButtonTabBarMode.erpDashboardTabMode:
        return _buildPlaceholder(tab);
    }
  }

  Widget _resolveListPage(Map<String, dynamic>? args) {
    if (args != null) {
      return ErpListGeneratorResolver(
        route: routeProvider().toLowerCase(),
      ).getPage(args: args);
    }
    return _buildPlaceholder(NavButtonTabBarMode.erpGenericListTabMode);
  }

  Widget _resolveFormPage(Map<String, dynamic>? args) {
    if (args != null) {
      return ErpFormGeneratorResolver(
        route: routeProvider().toLowerCase(),
      ).getPage(args: args);
    }
    return _buildPlaceholder(NavButtonTabBarMode.erpGenericFormTabMode);
  }

  Widget _buildPlaceholder(NavButtonTabBarMode tab) {
    return Text('ERP parent nav: ${tab.name}');
  }


  @override
  void injectionsRegister() => Inject.initialize();

  @override
  String get microAppName => '/${MicroAppsName.erpApp.name}';

  @override
  Map<String, WidgetBuilderArgs> get routes => {
    microAppName: (BuildContext context, Object? args) {
      if (args == null || !(args is LoginModuleResult)) {
        return ErpBootstrapPage(args: args);
      } else {
        return buildERPApp(loginData: (args).toJson());
      }
    },
  };

  void _onErpShown(ErpShownEvent event) async {
    // 1. Sync / init
    // sl<MenuBloc>().add(LoadMenuEvent());

    // 2. Check auth
    final storage = sl<StorageService>();
    // final isLoggedIn = await storage.loadToken();

    // 3. Optional: welcome popup
    CustomEventBus.emit(
      ShowPopupEvent(message: 'خوش آمدید', type: PopupType.info),
    );
  }

  @override
  void initEventListeners() {
    CustomEventBus.on<ErpShownEvent>((event) {
      _handleErpShownEvent(event);
    });
    CustomEventBus.on<ErpFormGeneratorEvents>((event) {
      // CustomEventBus.emit(ErpFormGeneratorShownEvent());
      OpenErpModuleEvent(
        module: ErpAppsCoreEnum.erpForm,
        payload: {'customerId': 42},
      );
    });
  }

  void _handleErpShownEvent(ErpShownEvent event) {
    print('🚀 ERP App Shown - Event triggered');

    try {
      // این event زمانی اجرا می‌شود که ERP باز می‌شود
      // می‌توانید اینجا کارهای زیر را انجام دهید:

      // 1. لاگ کردن رویداد
      print('📊 ERP App shown with data: ');

      // 2. بارگذاری داده‌های مورد نیاز
      _loadRequiredData();

      // 3. ارسال رویداد به بلوک‌ها (مثلاً برای refresh)
      _triggerBlocEvents();

      // 4. ثبت فعالیت کاربر
      _logUserActivity();

      // اجرای تابع erpOpened از طریق CoreModel
      //  initDatas.executeFunction(ErpAppsCoreEnum.erpOpened);
    } catch (e) {
      print('⚠️ Error in ErpShownEvent handler: $e');
    }
  }

  void _handleErpCloseEvent(ErpCloseEvent event) {
    print('🔒 ERP App Closed - Event triggered');

    try {
      // این event زمانی اجرا می‌شود که ERP بسته می‌شود

      // 1. ذخیره آخرین وضعیت
      _saveLastState();

      // 2. پاکسازی منابع
      _cleanupResources();

      // 3. لاگ کردن خروج
      _logAppClose();
    } catch (e) {
      print('⚠️ Error in ErpCloseEvent handler: $e');
    }
  }

  void _loadRequiredData() {
    // _languageFuture = loadLanguage();
    print('📥 Loading required data for ERP...');
  }

  void _triggerBlocEvents() {
    print('🔄 Triggering bloc events...');
  }

  void _logUserActivity() {
    print('👤 Logging user activity...');
  }

  void _saveLastState() {
    print('💾 Saving last app state...');
  }

  void _cleanupResources() {
    print('🧹 Cleaning up resources...');
  }

  void _logAppClose() {
    print('📝 Logging app close...');
  }

  @override
  Widget? microAppWidget() => null;

  @override
  TransitionType? get transitionType => TransitionType.fade;

  @override
  ErpCustomEvents microAppEvents() => ErpCustomEvents();

  Future<void> openErpMenu([dynamic payload]) async {}

  Future<void> openErpDashboard([dynamic payload]) async {}

  Widget openErpForm([dynamic payload]) {
    return Text('a');
  }

  Future<void> openErpList([dynamic payload]) async {}
}

class ErpBootstrapPage extends StatelessWidget {
  final Object? args;

  ErpBootstrapPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<LoginModuleResult>(
      future: _resolveLoginResult(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final result = snapshot.data!;

        return buildERPApp(loginData: result.toJson());
      },
    );
  }

  Future<LoginModuleResult> _resolveLoginResult() async {
    if (args is LoginModuleResult) {
      return args as LoginModuleResult;
    }

    return await sl<StorageService>().loadLoginSessionModel();
  }

  final Map<ErpAppsCoreEnum, ErpChildMicroApp> _children = {};

  void _registerChildren() {
    _children[ErpAppsCoreEnum.erpForm] = ErpFormGeneratorResolver(route: '');
    _children[ErpAppsCoreEnum.erpList] = ErpFormGeneratorResolver(route: '');
  }
}
