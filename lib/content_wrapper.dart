import 'package:erp_app/index.dart';
import 'package:erp_app/page_cache_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:micro_app_core/services/custom_event_bus/custom_event_bus.dart';
import 'package:micro_app_core/services/routing/routes.dart';
import 'package:micro_app_core/src/base_app.dart';
import 'package:micro_app_core/src/micro_app.dart';
import 'package:micro_app_core/src/micro_core_utils.dart';

class ContentWrapper extends StatefulWidget with BaseApp {
  final PageCacheProvider notifier;

  ContentWrapper({super.key, required this.notifier}) {
    initialiseRouting();
  }

  @override
  State<ContentWrapper> createState() => _WrapperTestState();

  @override
  Map<String, WidgetBuilderArgs> get baseRoutes =>
      <String, WidgetBuilderArgs>{};

  @override
  List<MicroApp> get microApps => <MicroApp>[ErpResolver()];
}

class _WrapperTestState extends State<ContentWrapper> {
  @override
  Widget build(BuildContext context) {
    // return const Center(child: Text('a'),);
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: super.widget.generateRoute,
      initialRoute: Routes.erpApp.value,
    );
  }

  @override
  void initState() {
    super.initState();

    CustomEventBus.on<ErpShownEvent>((event) {
      navigatorKey.currentState?.pushNamed(
        Routes.erpApp.value,
        arguments: event,
      );
    });

    CustomEventBus.on<ErpCloseEvent>((event) {
      navigatorKey.currentState?.pop();
    });
  }
}
