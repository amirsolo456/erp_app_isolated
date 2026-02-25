import 'package:models_package/index.dart';
import 'package:services_package/Interfaces/front_helper_services/drawer/i_drawer_item_provider.dart';
import 'package:services_package/index.dart';




/// ---------- پیاده‌سازی چند ماژول نمونه ----------
class DashboardDrawerProvider implements IDrawerItemProvider {
  List<DrawerItem> _items = [];
  DashboardDrawerProvider() {
    _items = [];
  }


  void clear(){
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
