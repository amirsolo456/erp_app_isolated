import 'package:erp_app/feature/list_generator/data/models/field_display_config.dart';
import 'package:erp_app/feature/list_generator/presentation/pages/generic_list_page.dart';
import 'package:erp_app/src/advance_router.dart';
import 'package:erp_app/src/erp_notifier.dart';
import 'package:flutter/material.dart';
import 'package:micro_app_core/index.dart';
import 'package:navigation_builder/navigation_builder.dart';
import 'package:shared_core/data/com/person/response.dart';

import '../../../../com/person/presentation/widgets/person_list_nav.dart';

class ErpListGeneratorResolver extends ErpChildMicroApp {
  Map<String, WidgetBuilderArgs> get routes => {
    // routes should point to a bootstrap page that normalizes the incoming payload
    '/erp/list': (context, payload) => ErpListGenBootstrapPage(),
  };

  @override
  Widget build(BuildContext context, payload) {
    // simple default build that delegates to the route entry
    final builder = routes['/erp/list'];
    if (builder != null) return builder(context, payload);
    return ErpListGenBootstrapPage();
  }

  @override
  Widget getPage() {
    return PersonsScreen();
    // if your framework expects a root page for the micro app, return one here
    // return FutureBuilder<FieldDisplayConfig<Response>>(
    //   future: getFieldConfigs(),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return const Center(child: CircularProgressIndicator());
    //     }
    //
    //     if (snapshot.hasError) {
    //       return Center(child: Text(snapshot.error.toString()));
    //     }
    //
    //     final data = snapshot.data;
    //     if (data == null) {
    //       return const Center(child: Text('No field configuration provided'));
    //     }
    //
    //     return GenericListPage<D>(fieldConfigs: data);
    //   },
    // );
  }

  @override
  void injectionsRegister() {
    // register your dependencies here if necessary
  }

  @override
  // keep this unimplemented if you don't know the correct enum value yet;
  // implementing it incorrectly may produce a runtime/compile-time error.
  ErpAppsCoreEnum get key => throw UnimplementedError();
}

class ErpListGenBootstrapPage<D> extends StatelessWidget {
  // accept a dynamic payload from the router and normalize it in getFieldConfigs

  const ErpListGenBootstrapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FieldDisplayConfig<D>>(
      future: getFieldConfigs(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        final data = snapshot.data;
        if (data == null) {
          return const Center(child: Text('No field configuration provided'));
        }

        return GenericListPage<D>(fieldConfigs: data);
      },
    );
  }

  /// Normalize the incoming `payload` into a single `FieldDisplayConfig<D>`
  /// This function is intentionally defensive: the router may send a single
  /// config, a list of configs, or a map that contains `fieldConfigs`.
  Future<FieldDisplayConfig<D>> getFieldConfigs() async {
    // direct correct type
    // if (payload is FieldDisplayConfig<D>) return payload;

    Object payload = personFieldConfigs;
    // non-generic FieldDisplayConfig at runtime (try to cast)
    if (payload is FieldDisplayConfig) return payload as FieldDisplayConfig<D>;

    // a list containing one or more FieldDisplayConfig objects
    if (payload is List<FieldDisplayConfig<D>> && payload.isNotEmpty) {
      // common pattern: router may pass a list of configs; pick the first
      return payload.first;
    }

    if (payload is List &&
        payload.isNotEmpty &&
        payload.first is FieldDisplayConfig) {
      return payload.first as FieldDisplayConfig<D>;
    }

    // sometimes payload can be a Map that wraps the real configs
    if (payload is Map && payload['fieldConfigs'] != null) {
      final configs = payload['fieldConfigs'];
      if (configs is FieldDisplayConfig<D>) return configs;
      if (configs is List &&
          configs.isNotEmpty &&
          configs.first is FieldDisplayConfig) {
        return configs.first as FieldDisplayConfig<D>;
      }
    }

    // fallback: if nothing matches, throw a descriptive error so the caller
    // (and developer) know what went wrong at runtime.
    throw Exception(
      'Unsupported payload type for FieldDisplayConfig: ${payload?.runtimeType}',
    );
  }

  // helper functions you had in the original file
  Widget buildContent(BuildContext context, ErpAppNotifier notifier) {
    return _buildListGeneratorContent(notifier, context);
  }

  Widget _buildListGeneratorContent(
    ErpAppNotifier notifier,
    BuildContext context,
  ) {
    return AdvancedRouter.buildPage(
      RouteData(
        path: notifier.isListGeneratorActive.keys.last,
        location: 'vsa',
        queryParams: {},
        pathParams: {},
        arguments: [],
        pathEndsWithSlash: false,
        redirectedFrom: [],
        subLocation: '',
        navigatorKey: navigatorKey,
      ),
      context,
    );
  }
}
