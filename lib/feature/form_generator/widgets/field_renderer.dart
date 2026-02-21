import 'package:flutter/material.dart';
import 'package:models_package/base/api_settings.dart';
import 'package:models_package/base/field_model.dart';
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
import 'package:shared_core/data/base_data/select_request.dart';
import '../../../core/network/injection_container.dart';
import 'package:shared_core/data/base_data/base_data.dart';
import 'package:shared_core/data/auth/toolbar/toolbar.dart' as sel;

class FieldRenderer extends StatelessWidget {
  final FieldModel field;
  final ValueChanged<dynamic> onChanged;
  final Map<String, dynamic> initialValues;
  static final Map<int, List<SelectResponseData>> _treeOptionCache = {};

  const FieldRenderer({
    Key? key,
    required this.field,
    required this.onChanged,
    required this.initialValues,
  }) : super(key: key);

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
          onNodeExpand: (int repoId) async {
            if (_treeOptionCache.containsKey((int c) => c == repoId)) {
              return _treeOptionCache[repoId]!;
            } else {
              final items = await _loadChildrenForNode(
                context,
                field.selectEndpoint!,
              );
              _treeOptionCache[repoId] = items; // ذخیره در cache
              return items;
            }
          },
        );

      case 'checkbox':
        return CheckboxInputField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
        );

      case 'selectoption': // اضافه کردن case جدید
        return SelectOptionField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
          onNodeExpand: (int repoId) async {
            if (_treeOptionCache.containsKey((int c) => c == repoId)) {
              return _treeOptionCache[repoId]!;
            } else {
              final items = await _loadChildrenForNode(
                context,
                field.selectEndpoint!,
              );
              _treeOptionCache[repoId] = items; // ذخیره در cache
              return items;
            }
          },
          // onNodeExpand: () =>
          //     _loadChildrenForNode(
          //       context,
          //       field.selectEndpoint ?? sel.SelectEndPoint(0, '', '', ''),
          //     ),
        );

      // انواع فیلدهای دیگر
      case 'email':
        return TextInputField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
        );

      case 'phone':
        return TextInputField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
        );

      case 'info':
        return SizedBox();
      default:
        return Container(
          padding: EdgeInsets.all(8),
          child: Text(
            'نوع فیلد ناشناخته: ${field.type} - نام: ${field.name}',
            style: TextStyle(color: Colors.red),
          ),
        );
    }
  }

  String _buildCacheKey(String fieldName, int parentId) {
    return '$fieldName::${parentId ?? 'root'}';
  }

  Future<List<SelectResponseData>> _loadChildrenForNode(
    BuildContext context,
    sel.SelectEndPoint arguments,
  ) async {
    try {
      // فرض: selectEndpoint ساختار دارد → repoViewId, endpoint و ...

      final endpoint = arguments;
      if (endpoint == null || endpoint.endpoint == null) {
        return [];
      }

      final requestBody = SelectRequest(
        defaults: sl<ApiSettings>().appDefaults,
        repoViewId: endpoint.repoViewId as int,
      );

      final items = await sl<SelectService>().createAsync(
        field.selectEndpoint!.endpoint!,
        requestBody,
      );

      return items;
    } catch (e) {
      ModernToast().showToast(
        context,
        Text("خطا در بارگذاری زیرمجموعه‌ها"),
        Text('a'),
        ToastificationType.error,
      );

      return [];
    }
  }
}
