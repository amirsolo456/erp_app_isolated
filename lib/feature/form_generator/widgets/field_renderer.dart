import 'package:flutter/material.dart';
import 'input/check_box_Input_field.dart';
import 'input/text_input_field.dart';
import 'input/select_input_field.dart';
import 'input/date_input_field.dart';
import 'input/select_option_field.dart';
import 'input/tree_option_field.dart';
import 'package:shared_core/index.dart';

class FieldRenderer extends StatelessWidget {
  final Field field;
  final ValueChanged<dynamic> onChanged;
  final Map<String, dynamic> initialValues;

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

      case 'select':
      case 'dropdown':
        return SelectInputField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
        );

      // case 'radio':
      //   return RadioInputField(
      //     field: field,
      //     onChanged: onChanged,
      //     initialValues: initialValues,
      //   );

      case 'date':
      case 'datetime':
        return DateInputField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
        );

      case 'treeoption': // اضافه کردن case جدید
        return TreeOptionField(
          field: field,
          onChanged: onChanged,
          initialValues: initialValues,
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
}
