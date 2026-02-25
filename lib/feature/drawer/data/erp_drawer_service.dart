import 'package:flutter/material.dart';

import 'package:services_package/Interfaces/front_helper_services/drawer/drawer_route_handler.dart';

import 'drawer_service.dart';
import 'permission_service.dart';

class AppServices extends InheritedWidget {
  final DrawerRouteHandler routeService;
  final DrawerService drawerService;
  final PermissionService permissionService;

  const AppServices({
    required this.routeService,
    required this.drawerService,
    required this.permissionService,
    required Widget child,
    Key? key,
  }) : super(key: key, child: child);

  static AppServices of(BuildContext context) {
    final s = context.dependOnInheritedWidgetOfExactType<AppServices>();
    if (s == null) throw Exception('AppServices not found in context');
    return s;
  }

  @override
  bool updateShouldNotify(AppServices oldWidget) {
    // در این نمونه ساده همیشه false. اگر میخوای وقتی permission تغییر کرد رفرش بشه،
    // میشه منطق به‌روز‌رسانی رو اینجا پیچوند یا از Provider استفاده کرد.
    return false;
  }
}
