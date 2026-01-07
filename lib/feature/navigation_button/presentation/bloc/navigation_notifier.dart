// // lib/core/navigation/navigation_notifier.dart
// import 'package:erp_app/page_cache_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:models_package/Base/enums.dart';
//
// import '../../../dashboard_page/page/dashboard.dart';
//
// class NavigationNotifier extends ChangeNotifier {
//   NavButtonTabBarMode _selectedTab = NavButtonTabBarMode.erpMenuTabMode;
//
//   int _currentIndex = 0;
//
//   NavButtonTabBarMode get selectedTab => _selectedTab;
//   int get currentIndex => _currentIndex;
//
//   // نگاشت بین index و tab
//   final Map<int, NavButtonTabBarMode> _indexToTab = {
//     0: NavButtonTabBarMode.erpMenuTabMode,
//     1: NavButtonTabBarMode.erpNewTabMode,
//     2: NavButtonTabBarMode.erpOpenedTabMode,
//     3: NavButtonTabBarMode.erpDefaultTabMode,
//     4: NavButtonTabBarMode.erpProfileTabMode,
//   };
//
//   final Map<NavButtonTabBarMode, int> _tabToIndex = {
//     NavButtonTabBarMode.erpMenuTabMode: 0,
//     NavButtonTabBarMode.erpNewTabMode: 1,
//     NavButtonTabBarMode.erpOpenedTabMode: 2,
//     NavButtonTabBarMode.erpDefaultTabMode: 3,
//     NavButtonTabBarMode.erpProfileTabMode: 4,
//   };
//
//   void changeTab(NavButtonTabBarMode tab) {
//     if (_selectedTab != tab) {
//       _selectedTab = tab;
//       _currentIndex = _tabToIndex[tab] ?? 0;
//       notifyListeners();
//     }
//   }
//
//   void changeTabByIndex(int index) {
//     final tab = _indexToTab[index];
//     if (tab != null && _selectedTab != tab) {
//       _selectedTab = tab;
//       _currentIndex = index;
//       notifyListeners();
//     }
//   }
//
//   void reset() {
//     _selectedTab = NavButtonTabBarMode.erpMenuTabMode;
//     _currentIndex = 0;
//     notifyListeners();
//   }
//
//
// }