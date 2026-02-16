import 'package:flutter/material.dart';
import 'package:resources_package/Resources/Theme/theme_manager.dart';
import 'package:ui_components_package/extensions.dart';
import '../../validation/rule_mapper.dart';
import '../common/field_title.dart';
import 'package:shared_core/index.dart';

class CheckboxInputField extends StatefulWidget {
  final Field field;
  final ValueChanged<dynamic> onChanged;
  final Map<String, dynamic> initialValues;

  const CheckboxInputField({
    Key? key,
    required this.field,
    required this.onChanged,
    required this.initialValues,
  }) : super(key: key);

  @override
  _CheckboxInputFieldState createState() => _CheckboxInputFieldState();
}

class _CheckboxInputFieldState extends State<CheckboxInputField> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    _initializeValue();
  }

  void _initializeValue() {
    final initialValue = widget.initialValues[widget.field.name];
    if (initialValue != null) {
      _isChecked = _convertToBool(initialValue);
    } else if (widget.field.defaultValue != null) {
      _isChecked = _convertToBool(widget.field.defaultValue);
    }
  }

  bool _convertToBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value != 0;
    if (value is String) {
      final cleaned = value.replaceAll('\\', '');
      return cleaned.toLowerCase() == 'true' || cleaned == '1';
    }
    return false;
  }

  String _sanitizeText(String? text) {
    if (text == null) return '';
    return text.replaceAll('\\', '');
  }

  @override
  Widget build(BuildContext context) {
    final isRequired = RuleMapper.isRequired(widget.field.rules);

    final caption = _sanitizeText(widget.field.caption);

    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        textDirection: context.isRtl ? TextDirection.rtl : TextDirection.ltr,
        children: [
          Checkbox(
            value: _isChecked,
            onChanged: (bool? value) {
              if (value != null) {
                setState(() {
                  _isChecked = value;
                });
                widget.onChanged(value);
              }
            },
          ),
          if (caption.isNotEmpty)
            FieldTitle(
              caption: widget.field.caption ?? '',
              help: widget.field.help,
              isRequired: isRequired,
            ),

          // SizedBox(width: 8),
        ],
      ),
    );
  }
}
