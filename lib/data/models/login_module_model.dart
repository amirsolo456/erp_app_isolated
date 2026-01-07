// ignore_for_file: unused_field, constant_pattern_never_matches_value_type, duplicate_ignore

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:models_package/base/enums.dart';
import 'package:models_package/base/login_module.dart';
import 'package:navigation_builder/navigation_builder.dart';

class LoginModuleModel extends LoginModuleResult {
  final GuardedNavigationBuilder loginNavigator;
  final bool? isLoginModuleLogin;

  LoginModuleModel({
    required super.token,
    required super.selectedManagementAccount,
    required user,
    required language,
    required networkMode,
    required error,
    required cachedKey,
    required super.managementAccount,
    required super.success,
    required super.resultType,
    required this.loginNavigator,
    this.isLoginModuleLogin,
  });
}

enum LoginRouter { isLoginModuleModel, loginNavigator }

extension SessionKeysByLoginRouter on SessionKeys {
  String get key {
    switch (this) {
      // ignore: constant_pattern_never_matches_value_type
      case LoginRouter.isLoginModuleModel:
        return 'IsLoginModuleLogin';
      case LoginRouter.loginNavigator:
        return 'LoginNavigator';
      case SessionKeys.user:
        return 'User';
      case SessionKeys.token:
        return 'Token';
      case SessionKeys.managementAccount:
        return 'ManagementAccount';
      case SessionKeys.success:
        return 'Success';
      case SessionKeys.resultType:
        return 'ResultType';
      case SessionKeys.error:
        return 'Error';
      case SessionKeys.networkType:
        return 'NetworkType';
      case SessionKeys.timeStamp:
        return 'Timestamp';
      case SessionKeys.selectedManagement:
        return 'SelectedManagementAccount';
      case SessionKeys.loginResult:
        return 'loginResult';
      case SessionKeys.language:
        return 'Language';
      case SessionKeys.deviceToken:
        return 'DeviceToken';
    }
  }
}

class GuardedNavigationBuilder {
  final Map<String, Widget Function(RouteData, Map<String, dynamic>?)> _routes =
      {};
  final Map<String, dynamic> _requiredParams = {};
  final Map<String, dynamic> _optionalParams = {};

  String _initialLocation = '/';
  Widget Function(RouteData)? _unknownRoute;
  Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
  _transitionsBuilder;
  Duration? _transitionDuration;
  bool _debugPrintWhenRouted = false;
  Widget Function(Widget)? _builder;

  NavigationBuilder? _navigationBuilder;

  // Flag برای پیگیری وضعیت پارامترهای مورد نیاز
  final Set<String> _missingRequiredParams = {};

  GuardedNavigationBuilder();

  // متدهای تنظیم پارامترهای ضروری
  GuardedNavigationBuilder requireParam(String key, {dynamic defaultValue}) {
    if (defaultValue != null) {
      _optionalParams[key] = defaultValue;
    } else {
      _requiredParams[key] = null;
      _missingRequiredParams.add(key);
    }
    return this;
  }

  // تنظیم پارامترهای اختیاری
  GuardedNavigationBuilder setOptionalParam(String key, dynamic value) {
    _optionalParams[key] = value;
    return this;
  }

  // تنظیم route
  GuardedNavigationBuilder addRoute(
    String path,
    Widget Function(RouteData, Map<String, dynamic>?) builder,
  ) {
    _routes[path] = builder;
    return this;
  }

  // دیگر متدهای تنظیم کننده
  GuardedNavigationBuilder setInitialLocation(String location) {
    _initialLocation = location;
    return this;
  }

  GuardedNavigationBuilder setUnknownRoute(Widget Function(RouteData) builder) {
    _unknownRoute = builder;
    return this;
  }

  GuardedNavigationBuilder setTransitionsBuilder(
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)
    builder,
  ) {
    _transitionsBuilder = builder;
    return this;
  }

  GuardedNavigationBuilder setTransitionDuration(Duration duration) {
    _transitionDuration = duration;
    return this;
  }

  GuardedNavigationBuilder setDebugPrintWhenRouted(bool debug) {
    _debugPrintWhenRouted = debug;
    return this;
  }

  GuardedNavigationBuilder setBuilder(Widget Function(Widget) builder) {
    _builder = builder;
    return this;
  }

  // پر کردن پارامترهای مورد نیاز
  GuardedNavigationBuilder provideParam(String key, dynamic value) {
    if (_requiredParams.containsKey(key)) {
      _requiredParams[key] = value;
      _missingRequiredParams.remove(key);
    } else if (_optionalParams.containsKey(key)) {
      _optionalParams[key] = value;
    }
    return this;
  }

  // بررسی آمادگی برای ساخت
  bool get isReady => _missingRequiredParams.isEmpty;

  // دریافت لیست پارامترهای ضروری که هنوز تنظیم نشده‌اند
  List<String> get missingParams => _missingRequiredParams.toList();

  // ساخت NavigationBuilder نهایی
  NavigationBuilder build() {
    if (!isReady) {
      throw StateError(
        'Cannot build NavigationBuilder. Missing required parameters: ${missingParams.join(', ')}',
      );
    }

    // ادغام پارامترهای ضروری و اختیاری
    final allParams = {..._requiredParams, ..._optionalParams};

    // تبدیل routes به فرمت مورد نیاز NavigationBuilder
    final finalRoutes = <String, Widget Function(RouteData)>{};

    _routes.forEach((path, builder) {
      finalRoutes[path] = (RouteData data) {
        return builder(data, allParams);
      };
    });

    // ساخت NavigationBuilder
    final config = NavigationBuilder.create(
      routes: finalRoutes,
      initialLocation: _initialLocation,
      unknownRoute: _unknownRoute,
      transitionsBuilder: _transitionsBuilder,
      transitionDuration: _transitionDuration,
      debugPrintWhenRouted: _debugPrintWhenRouted,
    );

    // if (_builder != null) {
    // = _builder;
    // }

    _navigationBuilder = config;

    return _navigationBuilder!;
  }

  // ساخت سریع با تمام پارامترها
  static GuardedNavigationBuilder create({
    required Map<String, Widget Function(RouteData, Map<String, dynamic>?)>
    routes,
    String initialLocation = '/',
    Widget Function(RouteData)? unknownRoute,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
    transitionsBuilder,
    Duration? transitionDuration,
    bool debugPrintWhenRouted = false,
    Widget Function(Widget)? builder,
    Map<String, dynamic>? params,
  }) {
    final guardedBuilder = GuardedNavigationBuilder()
      .._routes.addAll(routes)
      .._initialLocation = initialLocation
      .._unknownRoute = unknownRoute
      .._transitionsBuilder = transitionsBuilder
      .._transitionDuration = transitionDuration
      .._debugPrintWhenRouted = debugPrintWhenRouted
      .._builder = builder;

    if (params != null) {
      params.forEach((key, value) {
        guardedBuilder.setOptionalParam(key, value);
      });
    }

    return guardedBuilder;
  }
}
