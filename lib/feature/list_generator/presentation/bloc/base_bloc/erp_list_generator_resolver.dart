import 'package:erp_app/core/network/injection_container.dart';
import 'package:erp_app/feature/list_generator/data/models/field_display_config.dart';
import 'package:erp_app/feature/list_generator/presentation/pages/generic_list_page.dart';
import 'package:erp_app/src/advance_router.dart';
import 'package:erp_app/src/erp_notifier.dart';
import 'package:flutter/material.dart';
import 'package:micro_app_core/index.dart';
import 'package:navigation_builder/navigation_builder.dart';

class ErpListGeneratorResolver extends ErpChildMicroApp {
  Map<String, WidgetBuilderArgs> get routes => {
    '/erp/list': (context, payload) => GenericListPage(
      fieldConfigs: payload != null && payload is List<FieldDisplayConfig>
          ? payload
          : [],
    ),
  };

  @override
  Widget build(BuildContext context, payload) {
    // TODO: implement build
    throw UnimplementedError();
  }

  @override
  Widget getPage() {
    // TODO: implement getPage
    throw UnimplementedError();
  }

  @override
  void injectionsRegister() {
    // TODO: implement injectionsRegister
  }

  @override
  // TODO: implement key
  ErpAppsCoreEnum get key => throw UnimplementedError();
}

class ErpListGenBootstrapPage<D> extends StatelessWidget {
  final FieldDisplayConfig<dynamic> payload;

  const ErpListGenBootstrapPage({super.key, required this.payload});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FieldDisplayConfig>>(
      future: getFieldConfigs(payload),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        return GenericListPage(fieldConfigs: snapshot!.data!);
      },
    );
  }

  // List<FieldDisplayConfig<D>> getFieldConfigs(FieldDisplayConfig<dynamic> payload) {
  //   if (payload == null) return [];
  //   if (payload is List) {
  //     // چک کنیم که همه عناصر از نوع FieldDisplayConfig هستند
  //     if (payload.every((element) => element is FieldDisplayConfig)) {
  //       return payload.cast<FieldDisplayConfig>();
  //     }
  //   }
  //   // اگر payload یک Map باشد و کلیدی به نام 'fieldConfigs' داشته باشد
  //   if (payload is Map && payload.containsKey('fieldConfigs')) {
  //     final configs = payload['fieldConfigs'];
  //     if (configs is List &&
  //         configs.every((element) => element is FieldDisplayConfig)) {
  //       return configs.cast<FieldDisplayConfig>();
  //     }
  //   }
  //   return [];
  // }

  // سپس در routes:
  Map<String, WidgetBuilderArgs> get routes => {
    '/erp/form': (context, payload) => GenericListPage(
      fieldConfigs: buildContent(context, sl<ErpAppNotifier>()),
    ),
  };

  Widget buildContent(BuildContext context, ErpAppNotifier notifier) {
    // if (notifier.isErrorState) {
    //   return _buildErrorWidget(notifier);
    // }
    //
    // if (notifier.isSkeletonActive) {
    //   return notifier.getPage(NavButtonTabBarMode.skeletion);
    // }
    return _buildListGeneratorContent(notifier, context);
    // switch (notifier.pageType  ) {
    //   case PageType.listGenerator:
    //     final isListGeneratorActive =
    //         (notifier.isListGeneratorActive?.values.last) ?? false;
    //     if (isListGeneratorActive) {
    //       return _buildListGeneratorContent(notifier, context);
    //     }
    //     return ErpNotFound();
    //   case PageType.formGenerator:
    //     final isFormGeneratorActive =
    //         notifier.isFormGeneratorActive?.values.first ?? false;
    //     if (isFormGeneratorActive) {
    //       return _buildFormGeneratorContent();
    //     }
    //     return ErpNotFound();
    //   case PageType.tabBar:
    //     return _buildMainContent(context, notifier);
    //   default:
    //     return ErpNotFound();
    // }

    // حالت فرم جنریک فعال
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
    ); // یا return YourListGeneratorWidget();
  }

  Widget _buildFormGeneratorContent() {
    // محتوای فرم جنریک
    return SizedBox(child: Text('Form Generator'));
  }

  Widget _buildErrorWidget(ErpAppNotifier notifier) {
    return Scaffold(
      backgroundColor: Colors.red.withOpacity(0.1),

      body: Row(
        children: [
          const Icon(Icons.error, color: Colors.red),
          const SizedBox(width: 8),
          // Expanded(child: Text(notifier.errorMessages.last ?? 'a')),
          // IconButton(
          //   onPressed: notifier.clearError,
          //   icon: const Icon(Icons.close),
          // ),
        ],
      ),
    );
  }
}
