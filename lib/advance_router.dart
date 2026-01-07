// lib/core/router/advanced_router.dart
// ignore_for_file: unused_element, unused_local_variable

import 'package:erp_app/page_cache_provider.dart';
import 'package:flutter/material.dart';
import 'package:models_package/base/enums.dart';
import 'package:navigation_builder/navigation_builder.dart';
import 'package:provider/provider.dart';
import 'package:restart_app/restart_app.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Components/erp_appbar.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Components/erp_not_found.dart';

import 'components/mainlayout/main_layout.dart';
import 'feature/com/person/presentation/features/person_list_page.dart';

class AdvancedRouter {
  static final Map<String, RouteHandler> _routes = {
    '/signOut': _handleSignOut,
    '/': _handleHome,
    '/GenericList/Com/PersonList': _handlePersonList,
    '/notFound': _handleNotFound,
  };

  static Widget buildPage(RouteData data, BuildContext context) {
    final route = data.location;

    // جستجو در routes دقیق
    if (_routes.containsKey(data.path)) {
      return _routes[data.path]!(data, context);
    }

    // Route ناشناخته
    return _handleNotFound(data, context);
  }

  static Widget _handleSignOut(RouteData data, BuildContext context) {
    Restart.restartApp().then((_) => print('App restarted'));
    return const SizedBox();
  }

  static Widget _handleHome(RouteData data, BuildContext context) {
    final tab =
        (data.queryParams['tab'] ?? NavButtonTabBarMode.erpOpenedTabMode)
            as NavButtonTabBarMode;
    return MainLayoutPage(initialTab: tab);
  }

  static Widget _handlePersonList(RouteData data, BuildContext context) {
    // اگر می‌خواهید navigation notifier را به‌روز کنید
    final notifier = Provider.of<PageCacheProvider>(context, listen: false);
    notifier.changePage(
      PageType.tabBar,
      route: null,
      tab: NavButtonTabBarMode.erpGenericListTabMode,
    );

    return const PersonListPage(refreshData: false);
  }

  static Widget _handleGenericList(RouteData data, BuildContext context) {
    final segments = data.location
        .split('/')
        .where((s) => s.isNotEmpty)
        .toList();
    // segments: ['GenericList', 'Com', 'PersonList']

    if (segments.length >= 3) {
      final module = segments[1];
      final entity = segments[2];

      // به‌روزرسانی navigation notifier
      final notifier = Provider.of<PageCacheProvider>(context, listen: false);
      notifier.changePage(PageType.listGenerator, route: data.path, tab: null);

      // بازگشت صفحه مناسب
      return _getGenericListPage(module, entity, data);
    }

    return _handleNotFound(data, context);
  }

  static Widget _getGenericListPage(
    String module,
    String entity,
    RouteData data,
  ) {
    switch ('$module/$entity') {
      case 'Com/PersonList':
        return const PersonListPage(refreshData: false);
      // سایر entity ها
      default:
        return Center(child: Text('لیست $entity در ماژول $module'));
    }
  }

  static Widget _handleNotFound(RouteData data, BuildContext context) {
    return const ErpNotFound();
  }
}

typedef RouteHandler = Widget Function(RouteData data, BuildContext context);

// Router با قابلیت دسترسی به context
// final erpNavigator = NavigationBuilder.create(
//   routes: {
//
//     '/*': (RouteData data) {
//       return Builder(
//         builder: (context) {
//           return AdvancedRouter.buildPage(data, context);
//         },
//       );
//     },
//   },
//   ignoreUnknownRoutes: true,
//   initialLocation: '/',
//   shouldUseCupertinoPage: true,
//   unknownRoute: (route) =>
//       Scaffold(
//         appBar: AppBar(),
//         body: const Center(child: Text('صفحه مورد نظر یافت نشد')),
//       ),
//   builder: (Widget outlet) {
//     return Scaffold(appBar: _getDynamicAppBar(outlet), body: outlet);
//   },
//   transitionsBuilder: (context, anim, secAnim, child) =>
//       FadeTransition(opacity: anim, child: child),
//   transitionDuration: const Duration(milliseconds: 500),
//   debugPrintWhenRouted: true,
// );

PreferredSizeWidget _getDynamicAppBar(Widget outlet) {
  // منطق تشخیص نوع AppBar براساس صفحه فعلی
  // می‌توانید از یک provider مخصوص برای این کار استفاده کنید
  return ErpAppBar(mode: AppBarsMode.erpGenericList);
}
