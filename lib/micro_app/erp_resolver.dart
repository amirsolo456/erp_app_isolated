// ignore_for_file: unused_element, unused_local_variable

import 'dart:async';

import 'package:erp_app/main.dart';
import 'package:erp_app/micro_app/erp_events.dart';
import 'package:flutter/material.dart';
import 'package:micro_app_commons/features/popup/domain/entities/enum.dart';
import 'package:micro_app_commons/features/popup/presentation/bloc/base_bloc/popup_events.dart';
import 'package:micro_app_core/index.dart';
import 'package:micro_app_core/utils/models/core_dto.dart';
import 'package:models_package/base/language_model.dart' as langmodel;
import 'package:models_package/index.dart';
import 'package:services_package/api_client_service.dart';
import 'package:services_package/storage/domain/usecases/storage_service.dart';

import '../core/network/injection_container.dart';
import '../feature/auth/menu/bloc/menu_bloc.dart';
import '../feature/auth/menu/bloc/menu_event.dart';

class ErpResolver extends MicroApp<ErpCoreModel, ErpAppsCoreEnum> {
  Future<langmodel.LanguageModel?>? _languageFuture;
  final Map<ErpAppsCoreEnum, MicroAppAction> callbacks;

  ErpResolver()
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
          customFunctions: {
            ErpAppsCoreEnum.erpDashboard: () {},
            ErpAppsCoreEnum.erpMenu: () {},
            ErpAppsCoreEnum.erpForm: () {},
            ErpAppsCoreEnum.erpList: () {},
            ErpAppsCoreEnum.erpLoad: () {},
            ErpAppsCoreEnum.erpOpened: () {},
            ErpAppsCoreEnum.erpError: () {},
          },
        ),
      );

  // ErpResolver() : super(ErpCoreModel()) {
  //   initDatas = ErpCoreModel(
  //     customFunctions: {
  //       ErpAppsCoreEnum.erpOpened: _onErpOpened,
  //       ErpAppsCoreEnum.erpError: _onErpError,
  //       ErpAppsCoreEnum.erpLoad: _onErpLoad,
  //       ErpAppsCoreEnum.erpList: _onErpList,
  //       ErpAppsCoreEnum.erpForm: _onErpForm,
  //       ErpAppsCoreEnum.erpMenu: _onErpMenu,
  //       ErpAppsCoreEnum.erpDashboard: _onErpDashboard,
  //     },
  //   );
  // }

  @override
  String get microAppName => '/erpApp';

  @override
  Map<String, WidgetBuilderArgs> get routes => <String, WidgetBuilderArgs>{
    microAppName: (BuildContext context, Object? args) {
      try {
        _languageFuture ??= sl<StorageService>().loadLanguage();
        final login = LoginModuleResult.success(
          token: '',
          deviceToken: '',
          networkMode: 0,
          language: null,
          managementAccount: [],
          timestamp: DateTime.now(),
          success: true,
          error: '',
          selectedManagementAccount: null,
        );
        return buildERPApp(loginData: login.toJson());
      } catch (e) {
        return Center(child: Text(e.toString()));
      }
    },
  };

  /*
  Future<void> _onErpOpened([dynamic payload]) async {
    debugPrint('ERP: App opened');
  }

  Future<void> _onErpError([dynamic payload]) async {
    debugPrint('ERP: Error occurred');
  }

  Future<void> _onErpLoad([dynamic payload]) async {
    debugPrint('ERP: Loading data');
  }

  Future<void> _onErpList([dynamic payload]) async {
    debugPrint('ERP: Showing list');
  }

  Future<void> _onErpForm([dynamic payload]) async {
    debugPrint('ERP: Showing form');
  }

  Future<void> _onErpMenu([dynamic payload]) async {
    debugPrint('ERP: Opening menu');
  }

  Future<void> _onErpDashboard([dynamic payload]) async {
    debugPrint('ERP: Opening dashboard');
  }*/

  void _onErpShown(ErpShownEvent event) async {
    // 1. Sync / init
    sl<MenuBloc>().add(LoadMenuEvent());

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

    CustomEventBus.on<ErpCloseEvent>((event) {
      _handleErpCloseEvent(event);
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

  Future<langmodel.LanguageModel?> loadLanguage() async {
    try {
      final language = await sl<StorageService>().loadLanguage();
      return language;
    } catch (e) {
      print('Error loading language: $e');
    }
    return null;
  }

  void _loadRequiredData() {
    _languageFuture = loadLanguage();
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
  void injectionsRegister() {
    print('🔧 Registering ERP injections...');

    try {
      if (!sl.isRegistered<ApiClient>()) {
        print('⚠️ Dependencies not registered yet, initializing...');
        // Inject.initialize();
      } else {
        print('✅ Dependencies already registered');
      }
      _languageFuture = sl<StorageService>().loadLanguage();
    } catch (e) {
      print('❌ Error in injectionsRegister: $e');
      rethrow;
    }
  }

  @override
  TransitionType? get transitionType => TransitionType.fade;

  @override
  ErpCustomEvents microAppEvents() => ErpCustomEvents();

  Future<void> openErpMenu([dynamic payload]) async {}

  Future<void> openErpDashboard([dynamic payload]) async {}

  Future<void> openErpForm([dynamic payload]) async {}

  Future<void> openErpList([dynamic payload]) async {}
}
