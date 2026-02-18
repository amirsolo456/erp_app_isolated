import 'package:models_package/index.dart';
import 'package:services_package/index.dart';


List<DrawerItem> _items = [];

/// ---------- پیاده‌سازی چند ماژول نمونه ----------
class DashboardDrawerProvider implements IDrawerItemProvider {
  DashboardDrawerProvider() {
    _items = [];
  }


  @override
  List<DrawerItem> getItems() => _items;

  void addNEWItems<T extends DrawerItem>(List<T> items) {
    _items.addAll(items);
  }

  void addNEWItem<T extends DrawerItem>(T items) {
    _items.add(items);
  }
}
