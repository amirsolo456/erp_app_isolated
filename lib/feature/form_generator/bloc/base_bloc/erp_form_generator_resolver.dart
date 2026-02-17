import 'package:erp_app/src/advance_router.dart';
import 'package:erp_app/core/network/injection_container.dart';
import 'package:erp_app/feature/form_generator/widgets/dynamic_form_generator.dart';
import 'package:flutter/material.dart';
import 'package:micro_app_core/index.dart';
import 'package:services_package/api_client_service.dart';
import 'package:services_package/auth/toolbar/toolbar_service.dart';
import 'package:shared_core/data/auth/toolbar/toolbar.dart';
import 'package:toastification/toastification.dart';
import 'package:ui_components_package/erp_app_componenets/common/toast/toast.dart';
import 'package:shared_core/data/com/person/person.dart' as person;
import 'erp_form_generator_inject.dart';

class ErpFormGeneratorResolver extends ErpChildMicroApp {
  final String route;

  ErpFormGeneratorResolver({required this.route});

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
  Widget getPage({Map<String, dynamic>? args}) {
    injectionsRegister();
    return ErpGenBootstrapPage(args: args);
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

        return DynamicFormGenerator(
          jsonString: snapshot.data!,
          type: args?['type'] ?? -1,
          systemId: args?['systemId'] ?? 106,
          repoId: args?['repoId'] ?? 106045,
          onSubmit: (value) async {
            await onSubmitNewData(value, context);
          },
        );
      },
    );
  }

  Future<String> openErpForm() async {
    final toolbarService = sl<ToolbarService>();

    final request = Request(
      type: args?['type'] ?? -1,
      systemId: args?['systemId'] ?? 106,
      repoId: args?['repoId'] ?? 106045,
    );

    final result = await toolbarService.get(
      request,
      (json) => Response.fromJson(json),
    );

    return result!.toJson((value) => value.toJson()).toString();
  }

  Future<bool> onSubmitNewData(
    Map<String, dynamic> values,
    BuildContext context,
  ) async {
    var b = false;
    try {
      values['RepoViewId'] = 30044;
      values['SystemId'] = 106;
      values['ShowMode'] = 10;
      final result = await sl<ApiClient>().sendObjectRequestAsync<person.Response,person.Request>(
       url:  'api/com/select/person',
      method:    HttpMethods.post,
      data:    values,
      setToken:    true,
      fallbackMessage:    null,
       fromJsonD:   person.Response.fromJson,
      );
      if (result!.customResult) {
        ModernToast().showToast(
          context,
          Text('موفق'),
          Text('عملیات با موفقیت انجام شد.'),
          ToastificationType.success,
        );
      } else {
        ModernToast().showToast(
          context,
          Text('خطا'),
          Text(result.error ?? '...'),
          ToastificationType.error,
        );
      }
    } catch (e) {
      ModernToast().showToast(
        context,
        Text('خطا'),
        Text(e.toString()),
        ToastificationType.error,
      );
    }
    return b;
  }
}
