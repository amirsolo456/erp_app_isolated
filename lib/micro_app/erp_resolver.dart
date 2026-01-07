import 'package:erp_app/main.dart';
import 'package:erp_app/micro_app/erp_events.dart';
import 'package:flutter/material.dart';
import 'package:micro_app_commons/features/popup/domain/entities/enum.dart';
import 'package:micro_app_commons/features/popup/presentation/bloc/base_bloc/popup_events.dart';
import 'package:micro_app_core/services/custom_event_bus/custom_event_bus.dart';
import 'package:micro_app_core/services/routing/routing.dart';
import 'package:micro_app_core/src/micro_app.dart' as microapp;
import 'package:micro_app_core/src/micro_core_utils.dart';
import 'package:models_package/Base/login_module.dart';
import 'package:models_package/base/language_model.dart';
import 'package:services_package/api_client_service.dart';
import 'package:services_package/storage/domain/usecases/storage_service.dart';

import '../core/network/injection_container.dart';
import '../feature/auth/menu/bloc/menu_bloc.dart';
import '../feature/auth/menu/bloc/menu_event.dart';
import 'erp_inject.dart';

class ErpResolver implements microapp.MicroApp {
  Future<LanguageModel?>? _languageFuture;

  @override
  String get microAppName => '/erpApp';

  @override
  Map<String, WidgetBuilderArgs> get routes => <String, WidgetBuilderArgs>{
    microAppName: (BuildContext context, Object? args) {
      // اگر languageFuture null است، یک Future جدید ایجاد نکنید، بلکه از یک Future که قبلاً ایجاد شده استفاده کنید.
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
      return buildERPApp(
        loginDatas: login.toJson(),
      ); // return buildERPApp(language);
      /* return FutureBuilder<LanguageModel?>(
        future: _languageFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            print('❌ Error loading language: ${snapshot.error}');
            Routing.pushNamed(Routes.popupPage);
            return Center(
              child: Text('خطا در بارگذاری زبان: ${snapshot.error}'),
            );
          }

          final language =
              snapshot.data ??
              LanguageModel(
                languageCode: 'fa',
                id: 0,
                smallName: 'fa',
                countryCode: 'IR',
                completeName: 'fa_Ir',
                bigName: 'IRAN',
              );

          return MainApp(
            initialLanguage: language,
            messengerService: sl<ExceptionHelperService>(),
          );
        },
      );*/
    },
  };

  void _onErpShown(ErpShownEvent event) async {
    // 1. Sync / init
    sl<MenuBloc>().add(LoadMenuEvent());

    // 2. Check auth
    final storage = sl<StorageService>();
    // final isLoggedIn = await storage.loadToken();
    //
    // if (!isLoggedIn) {
    //   WidgetsBinding.instance.addPostFrameCallback((_) {
    //     Routing.pushNamed(
    //       Routes.loginPage,
    //           (_) => false,
    //     );
    //   });
    //   return;
    // }

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

  Future<LanguageModel?> loadLanguage() async {
    try {
      final language = await sl<StorageService>().loadLanguage();

      return language;
    } catch (e) {
      print('Error loading language: $e');
    }
    return null;
  }

  void _loadRequiredData() {
    // اینجا می‌توانید داده‌های مورد نیاز را بارگذاری کنید
    // مثلاً از SharedPreferences یا API
    _languageFuture = loadLanguage();
    print('📥 Loading required data for ERP...');

    // مثال: بارگذاری تنظیمات کاربر
    // final storageService = sl<StorageService>();
    // storageService.loadUserSettings();
  }

  void _triggerBlocEvents() {
    // اینجا می‌توانید رویدادهایی به بلوک‌ها ارسال کنید
    // مثلاً برای refresh داده‌ها

    print('🔄 Triggering bloc events...');

    // توجه: برای دسترسی به بلوک‌ها باید از context استفاده کنید
    // اما چون اینجا context نداریم، می‌توانید از event bus استفاده کنید
    // یا مستقیماً از sl<...>() برای دسترسی به سرویس‌ها
  }

  void _logUserActivity() {
    // ثبت فعالیت کاربر
    print('👤 Logging user activity...');
  }

  void _saveLastState() {
    // ذخیره آخرین وضعیت برنامه
    print('💾 Saving last app state...');
  }

  void _cleanupResources() {
    // پاکسازی منابع
    print('🧹 Cleaning up resources...');
  }

  void _logAppClose() {
    // ثبت لاگ خروج
    print('📝 Logging app close...');
  }

  @override
  Widget? microAppWidget() => null;

  @override
  void injectionsRegister() {
    // این متد توسط میکرواپ فریمورک فراخوانی می‌شود
    // اما از آنجایی که در main ما قبلاً InjectionContainer.init() را فراخوانی کردیم
    // می‌توانیم بررسی کنیم که اگر قبلاً ثبت نشده، ثبت کنیم

    print('🔧 Registering ERP injections...');

    try {
      // اگر InjectionContainer هنوز init نشده، آن را init کنیم
      // البته با توجه به کد main شما، این کار قبلاً انجام شده

      // برای جلوگیری از duplicate registration، می‌توانیم چک کنیم:
      if (!sl.isRegistered<ApiClient>()) {
        print('⚠️ Dependencies not registered yet, initializing...');
        Inject.initialize();
      } else {
        print('✅ Dependencies already registered');
      }
      _languageFuture = sl<StorageService>().loadLanguage();
    } catch (e) {
      print('❌ Error in injectionsRegister: $e');
      throw e; // یا handle کنید
    }
  }

  @override
  TransitionType? get transitionType => TransitionType.fade;

  @override
  ErpCustomEvents microAppEvents() => ErpCustomEvents();
}
