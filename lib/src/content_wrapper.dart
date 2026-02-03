import 'package:flutter/material.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:micro_app_core/index.dart';
import 'package:micro_app_core/services/routing/routes.dart';
import 'package:models_package/base/enums.dart';
import 'package:provider/provider.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Components/erp_appbar.dart';

import '../feature/form_generator/bloc/base_bloc/erp_form_generator_events.dart';
import '../feature/navigation_button/presentation/widget/app_navigation_button.dart';
import 'erp_notifier.dart';

class ErpContentWrapper extends StatefulWidget {
  final ErpAppNotifier notifier;

  const ErpContentWrapper({super.key, required this.notifier});

  @override
  State<ErpContentWrapper> createState() => _ErpContentWrapperState();
}

class _ErpContentWrapperState extends State<ErpContentWrapper> {
  double menuWidth = 0;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Consumer<ErpAppNotifier>(
            builder: (context, notifier, child) {
              return _buildMainContent(context, notifier);
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    // CustomEventBus.on<ErpFormGeneratorShownEvent>((event) {
    //   navigatorKey.currentState?.pushNamed(Routes.erpApp.value);
    // });
  }

  Widget _buildMainContent(BuildContext context, ErpAppNotifier notifier) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ErpAppBar(mode: AppBarsMode.erpDefaultMode),
      body: Column(
        children: [
          // if (notifier.errorMessages.length > 1) _buildErrorWidget(notifier),
          Expanded(
            child: Consumer<ErpAppNotifier>(
              builder: (context, navNotifier, child) {
                return navNotifier.getErpPage(notifier.selectedTab);
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
