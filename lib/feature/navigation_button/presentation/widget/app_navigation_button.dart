// lib/core/navigation/custom_bottom_navigation.dart
import 'package:flutter/material.dart';
import 'package:models_package/base/enums.dart';


class AppNavigationButton extends StatelessWidget {
  final NavButtonTabBarMode selectedTab;
  final Locale currentLocal;
  final ValueChanged<NavButtonTabBarMode> onTabSelected;
  static const double iconSize = 40;

  const AppNavigationButton({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
    required this.currentLocal,
  });

  Widget _paddedIcon(String assetPath) {
    return Padding(
      padding: const EdgeInsets.only(top: 0),
      child: Image.asset(
        assetPath,
        width: iconSize + 10,
        height: iconSize + 10,
        package: 'resources_package',
      ),
    );
  }

  Widget _navItem({
    required Widget icon,
    required Widget activeIcon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: isActive
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(height: 2, width: 35, color: Colors.black),
                Container(
                  height: 80,
                  alignment: Alignment.center,
                  child: activeIcon,
                ),
              ],
            )
          : icon,
    );
  }

  @override
  Widget build(BuildContext context) {
     var  tabs = <NavButtonTabBarMode, dynamic>{
      NavButtonTabBarMode.erpProfileTabMode: {
        'icon': _paddedIcon('assets/images/account.png'),
        'activeIcon': _paddedIcon('assets/images/activeaccount.png'),
      },
      NavButtonTabBarMode.erpDefaultTabMode: {
        'icon': _paddedIcon('assets/images/defaults.png'),
        'activeIcon': _paddedIcon('assets/images/activedefaults.png'),
      },
      NavButtonTabBarMode.erpOpenedTabMode: {
        'icon': _paddedIcon('assets/images/opened.png'),
        'activeIcon': _paddedIcon('assets/images/activeopened.png'),
      },
      NavButtonTabBarMode.erpNewTabMode: {
        'icon': _paddedIcon('assets/images/new.png'),
        'activeIcon': _paddedIcon('assets/images/activenew.png'),
      },
      NavButtonTabBarMode.erpMenuTabMode: {
        'icon': _paddedIcon('assets/images/menu.png'),
        'activeIcon': _paddedIcon('assets/images/activemenu.png'),
      },
    };

    if (currentLocal.languageCode == 'en') {
      tabs = {
        NavButtonTabBarMode.erpProfileTabMode: {
          'icon': _paddedIcon('assets/images/account_en.png'),
          'activeIcon': _paddedIcon('assets/images/account_en.png'),
        },
        NavButtonTabBarMode.erpDefaultTabMode: {
          'icon': _paddedIcon('assets/images/default_en_selected.png'),
          'activeIcon': _paddedIcon('assets/images/default_en_selected.png'),
        },
        NavButtonTabBarMode.erpOpenedTabMode: {
          'icon': _paddedIcon('assets/images/opened_en.png'),
          'activeIcon': _paddedIcon('assets/images/opened_en.png'),
        },
        NavButtonTabBarMode.erpNewTabMode: {
          'icon': _paddedIcon('assets/images/new_en.png'),
          'activeIcon': _paddedIcon('assets/images/new_en.png'),
        },
        NavButtonTabBarMode.erpMenuTabMode: {
          'icon': _paddedIcon('assets/images/menu_en.png'),
          'activeIcon': _paddedIcon('assets/images/menu_en.png'),
        },
      };
    }
    final tabOrder = [
      NavButtonTabBarMode.erpMenuTabMode,
      NavButtonTabBarMode.erpNewTabMode,
      NavButtonTabBarMode.erpOpenedTabMode,
      NavButtonTabBarMode.erpDefaultTabMode,
      NavButtonTabBarMode.erpProfileTabMode,
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(10),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      height: 84,
      padding: EdgeInsetsGeometry.only(left: 15, right: 15),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: tabOrder.map((tab) {
          final icons = tabs[tab]!;
          return _navItem(
            icon: icons['icon'] as Widget,
            activeIcon: icons['activeIcon'] as Widget,
            isActive: selectedTab == tab,
            onTap: () => onTabSelected(tab),
          );
        }).toList(),
      ),
    );
  }
}
