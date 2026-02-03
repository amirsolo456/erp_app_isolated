
import 'package:erp_app/src/advance_router.dart';
import 'package:erp_app/core/network/injection_container.dart';
import 'package:erp_app/feature/form_generator/widgets/dynamic_form_generator.dart';
import 'package:flutter/material.dart';
import 'package:micro_app_core/index.dart';
import 'package:services_package/auth/toolbar/toolbar_service.dart';
import 'package:shared_core/data/auth/toolbar/toolbar.dart';

import 'erp_form_generator_inject.dart';

class ErpFormGeneratorResolver extends ErpChildMicroApp {
  @override
  ErpAppsCoreEnum get key => ErpAppsCoreEnum.erpForm;

  @override
  void onOpen(payload) {
    debugPrint('📄 ERP Form Generator opened with payload: $payload');
  }

  @override
  Widget build(BuildContext context, payload) {
    assert(payload is Map<String, dynamic>);

    return ErpGenBootstrapPage(args: payload as Map<String, dynamic>);
  }

  Map<String, WidgetBuilderArgs> get routes => {
    '/erp/form': (context, payload) => ErpGenBootstrapPage(
      args: payload is Map<String, dynamic> ? payload : null,
    ),
  };

  @override
  Widget getPage() {
    injectionsRegister();
    return const ErpGenBootstrapPage();
  }

  @override
  void injectionsRegister() => Inject.initialize();
}

class ErpGenBootstrapPage extends StatelessWidget {
  final Map<String, dynamic>? args;

  const ErpGenBootstrapPage({super.key, this.args});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: openErpForm(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        }

        return DynamicFormGenerator(jsonString: snapshot.data!);
      },
    );
  }

  Future<String> openErpForm() async {
    final toolbarService = sl<ToolbarService>();

    final request = Request(
      type: 2,
      systemId: args?['systemId'] ?? 106,
      repoId: args?['repoId'] ?? 106045,
    );

    final result = await toolbarService.get(
      request,
      (json) => Response.fromJson(json),
    );

    return result!.toJson((value) => value.toJson()).toString() ;
  }
}
