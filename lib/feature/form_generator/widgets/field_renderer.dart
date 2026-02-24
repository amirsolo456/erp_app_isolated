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
import '../../../core/network/injection_container.dart';
import 'package:shared_core/data/base_data/base_data.dart';
import 'package:shared_core/data/auth/toolbar/toolbar.dart' as sel;

class FieldRenderer extends StatelessWidget {
  final FieldModel field;
  final ValueChanged<dynamic> onChanged;
  final Map<String, dynamic> initialValues;
  static final Map<int, Select> _treeOptionCache = {};

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
          onNodeExpand: (int repoId, bool? isForce) async {
            if ((_treeOptionCache[repoId] == null || _treeOptionCache[repoId] == []) ||
                (isForce != null && isForce == true)) {
              final items = await _loadChildrenForNode(
                context,
                field.selectEndpoint!,
              );
              _treeOptionCache[repoId] = items; // ذخیره در cache
              return items;
            } else if (_treeOptionCache[repoId] != null) {
              return _treeOptionCache[repoId]!;
            } else {
              return Select(selectData: []);
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
          onNodeExpand: (int repoId, bool? isForce) async {
            if ((_treeOptionCache[repoId] == null ||
                    _treeOptionCache[repoId] == []) ||
                (isForce != null && isForce == true)) {
              final items = await _loadChildrenForNode(
                context,
                field.selectEndpoint!,
              );
              _treeOptionCache[repoId] = items; // ذخیره در cache
              return items;
            } else if (_treeOptionCache[repoId] != null) {
              return _treeOptionCache[repoId]!;
            } else {
              return Select(selectData: []);
            }
          },
        );

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

  Future<Select> _loadChildrenForNode(
    BuildContext context,
    sel.SelectEndPoint arguments,
  ) async {
    try {
      // فرض: selectEndpoint ساختار دارد → repoViewId, endpoint و ...

      final endpoint = arguments;
      if (endpoint.endpoint == null) {
        return Select(selectData: []);
      }

      final requestBody = SelectRequest(
        defaults: sl<ApiSettings>().appDefaults,
        repoViewId: endpoint.repoViewId,
      );

      final items = await sl<SelectService>().createAsync(
        field.selectEndpoint!.endpoint!,
        requestBody,
      );

      return items;
    } catch (e) {
      ModernToast().showToast(
        context,
        Text('خطا در بارگذاری زیرمجموعه‌ها'),
        Text('a'),
        ToastificationType.error,
      );

      return Select(selectData: []);
    }
  }
}
