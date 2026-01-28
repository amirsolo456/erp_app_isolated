import 'package:flutter/material.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:models_package/base/enums.dart';
import 'package:provider/provider.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Components/erp_appbar.dart';

import 'feature/navigation_button/presentation/widget/app_navigation_button.dart';

class ErpContentWrapper extends StatefulWidget {
  final AppNotifier notifier;

  const ErpContentWrapper({super.key, required this.notifier});

  @override
  State<ErpContentWrapper> createState() => _ErpContentWrapperState();
}

class _ErpContentWrapperState extends State<ErpContentWrapper> {
  double menuWidth = 0;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Consumer<AppNotifier>(
        builder: (context, notifier, child) {
          return _buildMainContent(context, notifier);
        },
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, AppNotifier notifier) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ErpAppBar(mode: AppBarsMode.erpDefaultMode),
      body: Column(
        children: [
          // if (notifier.errorMessages.length > 1) _buildErrorWidget(notifier),
          Expanded(
            child: Consumer<AppNotifier>(
              builder: (context, navNotifier, child) {
                return navNotifier.getPage(notifier.selectedTab);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppNavigationButton(
        selectedTab: notifier.selectedTab,
        onTabSelected: (value) =>
            notifier.changePage(PageType.tabBar, route: null, tab: value),
      ),
    );
  }
}
