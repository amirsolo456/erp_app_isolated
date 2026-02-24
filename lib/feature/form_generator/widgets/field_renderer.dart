import 'package:flutter/material.dart';
import 'package:micro_app_core/index.dart';
import 'package:micro_app_core/services/routing/routes.dart';
import 'package:models_package/base/api_settings.dart';
import 'package:models_package/base/field_model.dart';
import 'package:models_package/base/select_response_data_model.dart'; // ← مهم: اضافه کردن
import 'package:services_package/index.dart';
import 'package:services_package/select_service/select_service.dart';
import 'package:toastification/toastification.dart';
import 'package:ui_components_package/erp_app_componenets/common/toast/toast.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Inputs/date_input_field.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Inputs/select_input_field.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Inputs/select_option_field.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Inputs/text_input_field.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/selection_box/check_box_Input_field.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/tree_view/tree_option_field.dart';
import '../../../core/network/injection_container.dart';
import 'package:shared_core/data/base_data/base_data.dart';
import 'package:shared_core/data/auth/toolbar/toolbar.dart' as sel;

class FieldRenderer extends StatelessWidget {
  final FieldModel field;
  final ValueChanged<dynamic> onChanged;
  final Map<String, dynamic> initialValues;

  static final Map<int, Select> _treeOptionCache = {};

  const FieldRenderer({
    super.key,
    required this.field,
    required this.onChanged,
    required this.initialValues,
  });

  @override
  Widget build(BuildContext context) {
    switch (field.type?.toLowerCase()) {
      case 'text':
      case 'textarea':
      case 'number':
      case 'password':
        return TextInputField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
        );

      case 'dropdown':
      case 'select':
        return SelectInputField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
        );

      case 'date':
      case 'datetime':
        return DateInputField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
        );

      case 'treeoption':
        return TreeOptionField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
          onNodeExpand: (int repoId, bool? isForce) async {
            if ((_treeOptionCache[repoId] == null ||
                    _treeOptionCache[repoId] == []) ||
                (isForce != null && isForce == true)) {
              final items = await _loadChildrenForNode(
                context,
                field.selectEndpoint!,
              );
              _treeOptionCache[repoId] = items; // ذخیره در cache
              return await _mapToSelectResponseDataModel(items.data ?? []);
            } else if (_treeOptionCache[repoId] != null) {
              return await _mapToSelectResponseDataModel(
                _treeOptionCache[repoId]?.data ?? [],
              );
              ;
            } else {
              return _mapToSelectResponseDataModel([]);
            }
          },
        );

      case 'checkbox':
        return CheckboxInputField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
        );

      case 'selectoption':
        return SelectOptionField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
          onNodeExpand: (int repoId, bool? isForce) async {
            if ((_treeOptionCache[repoId] == null ||
                    _treeOptionCache[repoId] == []) ||
                (isForce != null && isForce == true)) {
              final items = await _loadChildrenForNode(
                context,
                field.selectEndpoint!,
              );
              _treeOptionCache[repoId] = items; // ذخیره در cache
              return await _mapToSelectResponseDataModel(items.data ?? []);
            } else if (_treeOptionCache[repoId] != null) {
              return await _mapToSelectResponseDataModel(
                _treeOptionCache[repoId]?.data ?? [],
              );
              ;
            } else {
              return _mapToSelectResponseDataModel([]);
            }
          },
        );

      case 'email':
      case 'phone':
        return TextInputField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
        );

      case 'info':
        return const SizedBox.shrink();

      default:
        return Container(
          padding: const EdgeInsets.all(8),
          child: Text(
            'نوع فیلد ناشناخته: ${field.type} - نام: ${field.name}',
            style: const TextStyle(color: Colors.red),
          ),
        );
    }
  }

  // متد کمکی برای ساخت callback سازگار با SelectResponseDataModel
  Future<Future<List<SelectResponseDataModel>> Function(int, bool?)>
  _buildTreeNodeExpandCallback(
    BuildContext context,
    int repoid,
    bool? force,
  ) async {
    try {
      return (int repoId, bool? isForce) async {
        if ((_treeOptionCache[repoId] == null ||
                _treeOptionCache[repoId]!.selectData == null) ||
            (isForce == true)) {
          final selectObj = await _loadChildrenForNode(
            context,
            field.selectEndpoint!,
          );

          _treeOptionCache[repoId] = selectObj;

          return _mapToSelectResponseDataModel(selectObj.selectData ?? []);
        }

        return _mapToSelectResponseDataModel(
          _treeOptionCache[repoId]!.selectData ?? [],
        );
      };
    } catch (e) {
      ModernToast().showToast(
        context,
        const Text('خطا در بارگذاری داده‌ها'),
        Text(e.toString()),
        ToastificationType.error,
      );
      return (int repoId, bool? isForce) async =>
          _mapToSelectResponseDataModel([]);
    }
  }

  // تابع تبدیل – اینجا نوع مدل را می‌سازیم
  List<SelectResponseDataModel> _mapToSelectResponseDataModel(
    List<SelectResponseData> items,
  ) {
    return items.map((item) {
      return SelectResponseDataModel(
        id: item.id ?? 0,
        title: item.title,
        displayTitle: item.displayTitle ?? item.title,
        subItems: item.subItems != null
            ? _mapToSelectResponseDataModel(item.subItems!) // بازگشتی
            : null,
      );
    }).toList();
  }

  Future<Select> _loadChildrenForNode(
    BuildContext context,
    sel.SelectEndPoint endpoint,
  ) async {
    try {
      if (endpoint.endpoint == null) {
        return Select(selectData: []);
      }

      final requestBody = SelectRequest(
        defaults: sl<ApiSettings>().appDefaults,
        repoViewId: endpoint.repoViewId,
      );

      final response = await sl<SelectService>().createAsync(
        endpoint.endpoint!,
        requestBody,
      );

      if (response.error != null) {
        if (context.mounted) {
          ModernToast().showToast(
            context,
            const Text('خطا در بارگذاری داده‌ها'),
            Text(response.error.toString()),
            ToastificationType.error,
          );
        }

        CustomEventBus.emit(
          RouteEvents.loginEvents.loginModuleUserLoggedOutEvent(),
        );
      }

      return response;
    } catch (e, stack) {
      debugPrint('Error loading tree nodes: $e\n$stack');
      if (context.mounted) {
        ModernToast().showToast(
          context,
          const Text('خطا در بارگذاری زیرمجموعه‌ها'),
          Text(e.toString()),
          ToastificationType.error,
        );
      }
      return Select(selectData: []);
    }
  }
}
