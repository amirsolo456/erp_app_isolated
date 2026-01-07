// ignore_for_file: dead_code, unused_element

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:models_package/base/enums.dart';
import 'package:services_package/page_cache_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:ui_components_package/erp_app_componenets/common/loadings/circle_loading.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Components/erp_appbar.dart';

// Import your app notifier

import 'feature/add_new/add-new_page.dart';
import 'feature/auth/menu/pages/menu_page.dart';
import 'feature/dashboard_page/page/dashboard.dart';
import 'feature/default_page/pages/default_page.dart';
import 'feature/open_page/open_page.dart';
import 'feature/profile/profile.dart';

enum PageType { listGenerator, formGenerator, tabBar }

class PageCacheProvider extends ChangeNotifier {
  late final PageCacheManager _cacheManager = PageCacheManager(
    maxAge: const Duration(minutes: 5),
  );

  final Map<int, Widget> _pageCache = {};
  final Map<int, bool> _showSkeleton = {};
  final Map<int, Timer> _skeletonTimers = {};
  NavButtonTabBarMode _selectedTab = NavButtonTabBarMode.erpDashboardTabMode;
  final List<String> _errors = [];
  bool _isErrorsState = false;
  PageType _pageType = PageType.tabBar;
  bool _isSignOut = false;
  bool _isProcessingSignOut = false;
  static final Map<String, bool> _defValue = {'first': false};

  final List<Completer<void>> _pendingOperations = [];
  final List<Timer> _activeTimers = [];
  final List<StreamSubscription> _activeSubscriptions = [];

  // UI List Generator State

  Map<String, bool> _isListRoute = _defValue;

  // UI From Generator State
  Map<String, bool> _isFormRoute = _defValue;

  // UI Navigation Bar State
  final Map<NavButtonTabBarMode, Widget> _tabPage = {};

  // UI Skeletion
  bool _isSkeletion = false;

  // صفحات تعریف شده
  static final Map<NavButtonTabBarMode, Widget Function()> _pageBuilders = {
    NavButtonTabBarMode.erpDashboardTabMode: () => const DashboardPage(),
    NavButtonTabBarMode.erpMenuTabMode: () => const MenuPage(),
    NavButtonTabBarMode.erpNewTabMode: () => const AddNewPage(),
    NavButtonTabBarMode.erpOpenedTabMode: () => const OpenedPage(items: []),
    NavButtonTabBarMode.erpDefaultTabMode: () => const DefaultPage(),
    NavButtonTabBarMode.erpProfileTabMode: () => const ProfilePage(),
  };

  PageCacheProvider({NavButtonTabBarMode? initialTab}) {
    _selectedTab = initialTab ?? NavButtonTabBarMode.erpDashboardTabMode;
  }

  // Getters جدید برای عملیات
  bool get isProcessingSignOut => _isProcessingSignOut;

  int get pendingOperationsCount => _pendingOperations.length;

  int get activeTimersCount => _activeTimers.length;

  int get activeSubscriptionsCount => _activeSubscriptions.length;

  PageType get pageType => _pageType;

  PreferredSizeWidget _getAppBar(NavButtonTabBarMode tab) {
    switch (tab) {
      case NavButtonTabBarMode.erpMenuTabMode:
        return ErpAppBar(mode: AppBarsMode.erpMenuMode);

      case NavButtonTabBarMode.erpNewTabMode:
        return ErpAppBar(mode: AppBarsMode.erpNewMode);

      case NavButtonTabBarMode.erpOpenedTabMode:
        return ErpAppBar(mode: AppBarsMode.erpOpenedMode);

      case NavButtonTabBarMode.erpDefaultTabMode:
        return ErpAppBar(mode: AppBarsMode.erpDefaultMode);

      case NavButtonTabBarMode.erpProfileTabMode:
        return ErpAppBar(mode: AppBarsMode.erpProfileMode);

      case NavButtonTabBarMode.erpGenericListTabMode:
        return ErpAppBar(mode: AppBarsMode.erpGenericList);

      case NavButtonTabBarMode.erpGenericFormTabMode:
        return ErpAppBar(mode: AppBarsMode.erpGenericForm);
      case NavButtonTabBarMode.erpDashboardTabMode:
      default:
        return ErpAppBar(mode: AppBarsMode.erpDashboardMode);
    }
  }

  // Getters
  PageCacheManager get cacheManager => _cacheManager;

  PreferredSizeWidget get appBarMode => _getAppBar(_selectedTab);

  Map<int, Widget> get pageCache => Map.from(_pageCache);

  Map<int, bool> get showSkeleton => Map.from(_showSkeleton);

  Map<String, bool> get isListGeneratorActive => _isListRoute;

  Map<String, bool> get isFormGeneratorActive => Map.from(_isFormRoute);

  bool get isErrorState => _isErrorsState;

  bool get isSkeletonActive => _isSkeletion;

  List<String> get errorMessages => _errors;

  NavButtonTabBarMode get selectedTab => _selectedTab;

  bool get isSignOutNeed => _isSignOut;

  void clearError() {
    _errors.clear();
    _isErrorsState = false;
    notifyListeners();
  }

  void changePage(
    PageType pageType, {
    String? route,
    NavButtonTabBarMode? tab,
  }) {
    _pageType = pageType;
    if (pageType == PageType.tabBar) {
      if (tab != null) {
        _selectedTab = tab;
      }
    } else if (route != null &&
        route != '' &&
        pageType == PageType.listGenerator) {
      _isListRoute[route] = true;
    } else if (route != null &&
        route != '' &&
        pageType == PageType.formGenerator) {
      _isFormRoute[route] = true;
    } else {
      setErrorState('route is Null');
    }
    notifyListeners();
  }

  // فعال کردن اسکلتون
  void _activateSkeleton(int tabValue) {
    _showSkeleton[tabValue] = true;

    // کنسل کردن تایمر قبلی
    _skeletonTimers[tabValue]?.cancel();

    // تنظیم تایمر برای غیرفعال کردن اسکلتون
    final timer = Timer(const Duration(milliseconds: 400), () {
      if (!_isProcessingSignOut) {
        // فقط اگر در حال خروج نیستیم
        _showSkeleton[tabValue] = false;
        notifyListeners();
      }
    });

    _skeletonTimers[tabValue] = timer;
    /*    _registerTimer(timer); // ثبت برای کنسل کردن در خروج*/
  }

  void setSkeletion() {
    if (_isProcessingSignOut) return;
    _isSkeletion = true;
    notifyListeners();
  }

  void setErrorState(String msg) {
    if (_isProcessingSignOut) return;
    _isErrorsState = true;
    _errors.add(msg);
    notifyListeners();
  }

  // گرفتن صفحه با کش
  Widget getPage(NavButtonTabBarMode tab, {bool forceRefresh = false}) {
    if (_isProcessingSignOut) {
      return _buildSignOutScreen();
    }

    if (tab == NavButtonTabBarMode.erpDashboardTabMode) {
      return _pageBuilders[tab]?.call() ?? _defaultPage(tab);
    }

    if (tab == NavButtonTabBarMode.skeletion ||
        (_pageCache.containsKey(tab.value) && !forceRefresh)) {
      _showSkeleton[tab.value] = _showSkeleton[tab.value] ?? false;

      return _wrapWithSkeleton(
        _pageCache[tab.value]!,
        tab.value,
        showSkeleton: _showSkeleton[tab.value]!,
      );
    }

    // ایجاد یا بازیابی از کش
    final rawPage = _cacheManager.getOrCreate(tab.value, () {
      final pageBuilder = _pageBuilders[tab];
      return pageBuilder?.call() ?? _defaultPage(tab);
    });

    // ذخیره در کش محلی
    _pageCache[tab.value] = rawPage;

    // فعال کردن اسکلتون
    _activateSkeleton(tab.value);

    return _wrapWithSkeleton(rawPage, tab.value, showSkeleton: true);
  }

  // بسته‌بندی با اسکلتون
  Widget _wrapWithSkeleton(
    Widget page,
    int tabValue, {
    required bool showSkeleton,
  }) {
    return Skeletonizer(
      containersColor: Colors.white,
      enabled: showSkeleton && !_isProcessingSignOut,
      child: page,
    );
  }

  // صفحه پیش‌فرض
  Widget _defaultPage(NavButtonTabBarMode tab) {
    return Center(child: Text('صفحه ${(tab.value)}'));
  }

  // صفحه خروج
  Widget _buildSignOutScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleLoading(),
            const SizedBox(height: 20),
            const Text(
              'در حال خروج از برنامه...',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'لغو ${_pendingOperations.length} عملیات در حال اجرا',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  // ریفرش صفحه خاص
  void refreshPage(NavButtonTabBarMode tab) {
    if (_isProcessingSignOut) return;

    _cacheManager.cleanCacheExcept(tab.value);
    _pageCache.remove(tab.value);
    _showSkeleton.remove(tab.value);
    notifyListeners();
  }

  // متدهای برای ثبت عملیات قابل کنسل
  void registerPendingOperation(Completer<void> completer) {
    if (_isProcessingSignOut) {
      completer.completeError('Operation cancelled due to sign out');
      return;
    }
    _pendingOperations.add(completer);
  }

  void unregisterPendingOperation(Completer<void> completer) {
    _pendingOperations.remove(completer);
  }

  void registerTimer(Timer timer) {
    if (_isProcessingSignOut) {
      timer.cancel();
      return;
    }
    _activeTimers.add(timer);
  }

  void unregisterTimer(Timer timer) {
    _activeTimers.remove(timer);
  }

  void registerSubscription(StreamSubscription subscription) {
    if (_isProcessingSignOut) {
      subscription.cancel();
      return;
    }
    _activeSubscriptions.add(subscription);
  }

  void unregisterSubscription(StreamSubscription subscription) {
    _activeSubscriptions.remove(subscription);
  }

  void showError(BuildContext context, String error) {
    // // یک خط برای ارسال خطا
    // NotifService().error( context,error, toParent: true);
  }

  Future<void> signOut(BuildContext context, {bool force = false}) async {
    if (_isProcessingSignOut) return;

    _isProcessingSignOut = true;

    // NotifService().signOut(context, reason: 'خروج از ERP', toParent: true);

    _isSignOut = true;
    notifyListeners();
  }

  Future<void> _cancelAllPendingOperations() async {
    if (_pendingOperations.isEmpty) return;

    final cancellationFutures = <Future<void>>[];

    for (final completer in _pendingOperations) {
      if (!completer.isCompleted) {
        completer.completeError('Operation cancelled due to sign out');
        cancellationFutures.add(completer.future);
      }
    }

    try {
      await Future.wait(cancellationFutures, eagerError: true);
    } catch (e) {
      // خطاهای کنسل کردن را نادیده می‌گیریم
      if (e is! String || e != 'Operation cancelled due to sign out') {
        print('Error during operation cancellation: $e');
      }
    }

    _pendingOperations.clear();
  }

  void _cancelAllTimers() {
    if (_activeTimers.isEmpty) return;

    for (final timer in _activeTimers) {
      timer.cancel();
    }

    // همچنین تایمرهای اسکلتون
    for (final timer in _skeletonTimers.values) {
      timer.cancel();
    }

    _activeTimers.clear();
    _skeletonTimers.clear();
  }

  void _cancelAllSubscriptions() {
    if (_activeSubscriptions.isEmpty) return;

    /*    GetIt.instance<AppNotifier>().notifyInfo(
      'Cancelling ${_activeSubscriptions.length} active subscriptions',
    );*/

    for (final subscription in _activeSubscriptions) {
      subscription.cancel();
    }

    _activeSubscriptions.clear();
  }

  void _clearAllCaches() {
    _cacheManager.cleanAll();
    _pageCache.clear();
    _showSkeleton.clear();
    _tabPage.clear();
  }

  void _resetAllStates() {
    _selectedTab = NavButtonTabBarMode.erpDashboardTabMode;
    _errors.clear();
    _isErrorsState = false;
    _isListRoute = {'first': false};
    _isFormRoute = {'first': false};
    _isSkeletion = false;
  }

  // متد لغو خروج (برای مواردی که کاربر منصرف می‌شود)
  void cancelSignOut() {
    if (!_isProcessingSignOut) return;

    _isProcessingSignOut = false;
    _isSignOut = false;

    notifyListeners();
  }

  // ریفرش همه صفحات
  void refreshAllPages() {
    if (_isProcessingSignOut) return;

    _cacheManager.cleanAll();
    _pageCache.clear();
    _showSkeleton.clear();

    // کنسل کردن همه تایمرها
    for (var timer in _skeletonTimers.values) {
      timer.cancel();
    }
    _skeletonTimers.clear();

    notifyListeners();
  }

  // گرفتن صفحه بدون اسکلتون
  Widget getRawPage(NavButtonTabBarMode tab) {
    if (_isProcessingSignOut) {
      return _buildSignOutScreen();
    }

    return _pageCache[tab.value] ??
        _pageBuilders[tab]?.call() ??
        _defaultPage(tab);
  }

  // ثبت صفحه جدید
  void registerPage(NavButtonTabBarMode tab, Widget Function() builder) {
    if (_isProcessingSignOut) return;

    // اضافه کردن به بیلدرها
    _pageBuilders[tab] = builder;

    // اگر صفحه در کش است، آن را به‌روز کن
    if (_pageCache.containsKey(tab.value)) {
      _pageCache[tab.value] = builder();
      notifyListeners();
    }
  }

  // پاک کردن کش یک صفحه
  void clearPageCache(NavButtonTabBarMode tab) {
    if (_isProcessingSignOut) return;

    _cacheManager.cleanCacheExcept(tab.value);
    _pageCache.remove(tab.value);
    _showSkeleton.remove(tab.value);
    notifyListeners();
  }

  // گرفتن حجم کش
  int get cacheSize => _pageCache.length;

  // گرفتن صفحات کش شده
  List<NavButtonTabBarMode> get cachedPages {
    return _pageCache.keys
        .map(
          (key) => NavButtonTabBarMode.values.firstWhere(
            (tab) => tab.value == key,
            orElse: () => NavButtonTabBarMode.erpDashboardTabMode,
          ),
        )
        .toList();
  }

  @override
  void dispose() {
    // کنسل کردن همه تایمرها
    for (var timer in _skeletonTimers.values) {
      timer.cancel();
    }

    // کنسل کردن تمام subscriptionها
    for (var subscription in _activeSubscriptions) {
      subscription.cancel();
    }

    // کنسل کردن تمام عملیات در حال اجرا
    for (var completer in _pendingOperations) {
      if (!completer.isCompleted) {
        completer.completeError('PageCacheProvider disposed');
      }
    }

    super.dispose();
  }
}
