// main_layout_page.dart
import 'package:flutter/material.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:models_package/base/enums.dart';
import 'package:provider/provider.dart';

import '../../core/network/injection_container.dart';
import '../../feature/navigation_button/presentation/widget/app_navigation_button.dart';

class MainLayoutPage extends StatefulWidget {
  final NavButtonTabBarMode initialTab;

  const MainLayoutPage({super.key, required this.initialTab});

  @override
  State<MainLayoutPage> createState() => _MainLayoutPageState();
}

class _MainLayoutPageState extends State<MainLayoutPage> {
  @override
  void initState() {
    super.initState();
    // مقداردهی اولیه notifier با تب اولیه
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = context.read<AppNotifier>();
      notifier.changePage(
        PageType.tabBar,
        route: null,
        tab: NavButtonTabBarMode.erpDashboardTabMode,
      );
    });
  }

  void _onTabSelected(NavButtonTabBarMode tab, AppNotifier notifier) {
    notifier.changePage(PageType.tabBar, route: null, tab: tab);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AppNotifier())],
      child: Consumer<AppNotifier>(
        builder: (context, cacheProvider, child) {
          return Scaffold(
            body: SafeArea(
              child: cacheProvider.createRawPage(cacheProvider.selectedTab),
            ),
            bottomNavigationBar: AppNavigationButton(
              selectedTab: cacheProvider.selectedTab,
              onTabSelected: (tab) => _onTabSelected(tab, cacheProvider),
              currentLocal: sl<AppNotifier>().currentLocal(),
            ),
          );
        },
      ),
    );
  }
}
