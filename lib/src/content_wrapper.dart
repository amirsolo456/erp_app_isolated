import 'package:erp_app/feature/dashboard_page/page/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:micro_app_core/index.dart';
import 'package:models_package/base/enums.dart';
import 'package:provider/provider.dart';
import 'package:services_package/index.dart';
import 'package:ui_components_package/erp_app_componenets/common/loadings/circle_loading.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Components/erp_appbar.dart';
import 'package:ui_components_package/extensions.dart';
import 'package:ui_components_package/index.dart';
import '../core/network/injection_container.dart';

import '../feature/navigation_button/presentation/widget/app_navigation_button.dart';
import '../micro_app/erp_events.dart';
import 'erp_notifier.dart';

class ErpContentWrapper extends StatefulWidget {
  final ErpAppNotifier notifier;

  const ErpContentWrapper({super.key, required this.notifier});

  @override
  State<ErpContentWrapper> createState() => _ErpContentWrapperState();
}

class _ErpContentWrapperState extends State<ErpContentWrapper>
    with SingleTickerProviderStateMixin {
  double menuWidth = 0;
  late AnimationController _animationController;

  // DrawerIndex _currentDrawerIndex = DrawerIndex.HOME;

  @override
  Widget build(BuildContext context) {
    return Consumer<ErpAppNotifier>(
      builder: (context, notifier, child) {
        if (notifier.isLoading) {
          return const Center(child: CircleLoading());
        }

        final dt = notifier.moduleState; // ه
        return Scaffold(
          backgroundColor: context.colors.main,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: ErpAppBar(mode: dt.selectedHeaderTab),
          ),
          body: notifier.getErpPage(dt, args: dt.args),
          bottomNavigationBar: AppNavigationButton(
            selectedTab: notifier.selectedTab,
            onTabSelected: (value) => notifier.changeErpPage(
              PageType.tabBar,
              route: null,
              tab: value,
            ),
            currentLocal: notifier.currentLocal(),
          ),
          drawer: const AppDrawer(),
          onDrawerChanged: (b) => {

          },
          drawerEdgeDragWidth: 0,
          endDrawerEnableOpenDragGesture: false,
          drawerScrimColor: Colors.grey,
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this, // this به‌عنوان TickerProvider عمل می‌کند
      duration: const Duration(milliseconds: 300),
    );

    CustomEventBus.on<ErpFormGeneratorEvent>((event) {
      // setState(() {
      sl<ErpAppNotifier>().setArguments(
        PageType.formGenerator,
        appBar: AppBarsMode.erpGenericForm,
        tab: NavButtonTabBarMode.erpGenericFormTabMode,
        route: 'form',
        args: <String, dynamic>{
          'systemId': event.systemId,
          'repoId': event.repoId,
          'type': event.type,
          'tittle': 'form',
        },
      );
      // });
    });
    CustomEventBus.on<ErpListGeneratorEvent>((event) {
      // setState(() {
      sl<ErpAppNotifier>().setArguments(
        PageType.listGenerator,
        appBar: AppBarsMode.erpGenericForm,
        tab: NavButtonTabBarMode.erpGenericListTabMode,
        route: 'list',
        args: <String, dynamic>{
          'systemId': event.systemId,
          'repoId': event.repoId,
          'type': event.type,
          'tittle': 'list',
        },
      );
      // });
    });
  }
}
