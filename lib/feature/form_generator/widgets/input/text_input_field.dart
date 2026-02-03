import 'package:flutter/material.dart';
import 'package:shared_core/index.dart';

import '../../validation/rule_mapper.dart';
import '../common/field_title.dart';

class TextInputField extends StatefulWidget {
  final Field field;
  final void Function(dynamic value) onChanged;
  final Map<String, dynamic>? initialValues;

  const TextInputField({
    super.key,
    required this.field,
    required this.onChanged,
    this.initialValues,
  });

  @override
  State<TextInputField> createState() => _TextInputFieldState();
}

class _TextInputFieldState extends State<TextInputField> {
  late TextEditingController _controller;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();

    final initialValue = widget.initialValues?[widget.field.name] ?? widget.field.defaultValue;
    if (initialValue != null) {
      _controller.text = initialValue.toString();

      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onChanged(initialValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRequired = RuleMapper.isRequired(widget.field.rules);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          FieldTitle(
            caption: widget.field.caption ?? '',
            help: widget.field.help,
            isRequired: isRequired,
          ),
          TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: widget.field.placeHolder,
              errorText: _errorText,

              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),

              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                  width: 2,
                ),
              ),

              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 1,
                ),
              ),

              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.red,
                  width: 2,
                ),
              ),

              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),

              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            validator: (value) {
              final error = RuleMapper.validate(widget.field.rules, value);
              setState(() {
                _errorText = error;
              });
              return error;
            },
            onChanged: (value) {
              if (_errorText != null && value.isNotEmpty) {
                setState(() {
                  _errorText = null;
                });
              }
              widget.onChanged(value);
            },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}