/*
import 'package:flutter/material.dart';
import 'package:models_package/base/drawer_item_model.dart';

class AppConstants {
  final List<DrawerItem> _formDrawerItems = [
    DrawerDivider(
      title: 'نمایش',
      icon: Icons.visibility,
      routeKey: 'show_section',
      permission: null,
      order: 0,
      defaultParams: null,
    ),
    DrawerItem(
      title: 'فرم پیشرفته',
      icon: Icons.assignment,
      routeKey: 'form_advanced',
      permission: null,
      order: 1,
      defaultParams: null,
    ),
    DrawerItem(
      title: 'فرم ساده',
      icon: Icons.assignment_turned_in,
      routeKey: 'form_simple',
      permission: null,
      order: 2,
      defaultParams: null,
    ),

    // گروه "منو بیشتر"
    DrawerDivider(
      title: 'منو بیشتر',
      icon: Icons.more_horiz,
      routeKey: 'more_section',
      permission: null,
      order: 3,
      defaultParams: null,
    ),
    DrawerItem(
      title: 'برچسب',
      icon: Icons.calendar_today,
      routeKey: 'label',
      permission: null,
      order: 4,
      defaultParams: null,
    ),

    DrawerDivider(
      title: 'چاپ',
      icon: Icons.print,
      routeKey: 'print_section',
      permission: null,
      order: 5,
      defaultParams: null,
    ),

    // آیتم‌های بدون عنوان گروه
    DrawerItem(
      title: 'باز نشانی',
      icon: Icons.refresh,
      routeKey: 'reset',
      permission: null,
      order: 6,
      defaultParams: null,
    ),
    DrawerItem(
      title: 'جدید',
      icon: Icons.add,
      routeKey: 'new',
      permission: null,
      order: 7,
      defaultParams: null,
    ),
    DrawerItem(
      title: 'ذخیره و جدید',
      icon: Icons.save,
      routeKey: 'save_new',
      permission: null,
      order: 8,
      defaultParams: null,
    ),
  ];

  List<DrawerItem> get drawerStaticItems => _formDrawerItems;

  List<dynamic> addItem<T extends DrawerItem>(List<T> newItems) {
    List items = <T>[];
    for (var i = 0; i < _formDrawerItems.length; i++) {
      items.add(_formDrawerItems[i]);
    }
    for (var i = 0; i < newItems.length; i++) {
      items.add(newItems[i]);
    }

    return items;
  }
}
*/
