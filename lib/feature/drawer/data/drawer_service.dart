import 'package:flutter/material.dart';
import 'package:models_package/index.dart';
import 'package:services_package/index.dart';

import 'permission_service.dart';

/// ---------- Drawer Service مرکزی ----------
class DrawerService {
  final List<IDrawerItemProvider> providers;
  final PermissionService permissionService;

  DrawerService({
    required this.providers,
    required this.permissionService,
  });

  List<DrawerItem> getDrawerItems() {
    final items = providers
        .expand((p) => p.getItems())
        .where((it) =>
    it.permission == null || permissionService.has(it.permission!))
        .toList();

    items.sort((a, b) => a.order.compareTo(b.order));
    return items;
  }
}