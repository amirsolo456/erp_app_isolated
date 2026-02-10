import 'package:erp_app/feature/list_generator/data/models/generic_list_entity_state.dart';
import 'package:flutter/material.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:micro_app_core/index.dart';
import 'package:models_package/base/enums.dart';
import 'package:models_package/base/form_generic_model.dart';
import 'package:models_package/base/list_generic_model.dart';
import 'package:provider/provider.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Components/erp_appbar.dart';

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

class _ErpContentWrapperState extends State<ErpContentWrapper> {
  double menuWidth = 0;

  @override
  Widget build(BuildContext context) {
    final dt = sl<ErpAppNotifier>().moduleState  ;
    return Stack(
      children: [
        Positioned.fill(
          child: Consumer<ErpAppNotifier>(
            builder: (context, notifier, child) {
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: PreferredSize(
                  preferredSize: const Size.fromHeight(kToolbarHeight),
                  child: Consumer<ErpAppNotifier>(
                    builder: (context, notifier, child) {
                      return ErpAppBar(mode: notifier.getMod());
                    },
                  ),
                ),
                body: Column(
                  children: [
                    Expanded(
                      child: Consumer<ErpAppNotifier>(
                        builder: (context, navNotifier, child) {
                          return navNotifier.getErpPage(
                            notifier.selectedTab,
                            args: dt.args,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                bottomNavigationBar: AppNavigationButton(
                  selectedTab: notifier.selectedTab,
                  onTabSelected: (value) => notifier.changePage(
                    PageType.tabBar,
                    route: null,
                    tab: value,
                  ),
                  currentLocal: sl<AppNotifier>().currentLocal(),
                ),
              );
              // return _buildMainContent(context, notifier,);
            },
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    CustomEventBus.on<ErpFormGeneratorEvent>((event) {
      // setState(() {
      sl<ErpAppNotifier>().setArguments(
        PageType.formGenerator,
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
    //
    //   CustomEventBus.on<ErpFormGeneratorEvent>((event) {
    //     setState(() {
    //       sl<ErpAppNotifier>().changePage(
    //         PageType.formGenerator,
    //         tab: NavButtonTabBarMode.erpGenericFormTabMode,
    //         route: 'form',
    //       );
    //     });
    //   });
    //
    //   CustomEventBus.on<ErpListGeneratorEvent>((event) {
    //     setState(() {
    //       sl<ErpAppNotifier>().changePage(
    //         PageType.listGenerator,
    //         tab: NavButtonTabBarMode.erpGenericListTabMode,
    //         route: 'list',
    //       );
    //     });
    //   });
    // }

    // Widget _buildMainContent(BuildContext context, ErpAppNotifier notifier) {
    //   return Scaffold(
    //     backgroundColor: Colors.white,
    //     appBar: PreferredSize(
    //       preferredSize: const Size.fromHeight(kToolbarHeight),
    //       child: Consumer<ErpAppNotifier>(
    //         builder: (context, notifier, child) {
    //           return ErpAppBar(
    //             mode: notifier.getMod(),
    //           );
    //         },
    //       ),
    //     ),
    //     body: Column(
    //       children: [
    //
    //         Expanded(
    //           child: Consumer<ErpAppNotifier>(
    //             builder: (context, navNotifier, child) {
    //               return navNotifier.getErpPage(notifier.selectedTab, args:);
    //             },
    //           ),
    //         ),
    //       ],
    //     ),
    //     bottomNavigationBar: AppNavigationButton(
    //       selectedTab: notifier.selectedTab,
    //       onTabSelected: (value) =>
    //           notifier.changePage(PageType.tabBar, route: null, tab: value),
    //       currentLocal: sl<AppNotifier>().currentLocal(),
    //     ),
    //   );
    // }
  }
}
