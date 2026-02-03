


import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_core/index.dart';
import '../../validation/rule_mapper.dart';
import '../common/field_title.dart';

class DateInputField extends StatefulWidget {
  final Field field;
  final void Function(dynamic value) onChanged;
  final Map<String, dynamic>? initialValues;

  const DateInputField({
    super.key,
    required this.field,
    required this.onChanged,
    this.initialValues,
  });

  @override
  State<DateInputField> createState() => _DateInputFieldState();
}

class _DateInputFieldState extends State<DateInputField> {
  final TextEditingController _controller = TextEditingController();
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _initializeValue();
  }

  void _initializeValue() {
    final initialValue = widget.initialValues?[widget.field.name] ??
        widget.field.defaultValue;
    if (initialValue != null) {
      _controller.text = _convertToJalali(initialValue.toString());
      widget.onChanged(initialValue);
    }
  }

  String _convertToJalali(String gregorianDate) {
    try {
      final dateParts = gregorianDate.split('/');
      if (dateParts.length == 3) {
        final year = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final day = int.parse(dateParts[2]);

        final gDate = Gregorian(year, month, day);
        final jDate = gDate.toJalali();

        return '${jDate.year}/${jDate.month.toString().padLeft(2, '0')}/${jDate.day.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      print('Error converting date: $e');
    }
    return gregorianDate;
  }

  String _convertToGregorian(String jalaliDate) {
    try {
      final dateParts = jalaliDate.split('/');
      if (dateParts.length == 3) {
        final year = int.parse(dateParts[0]);
        final month = int.parse(dateParts[1]);
        final day = int.parse(dateParts[2]);

        final jDate = Jalali(year, month, day);
        final gDate = jDate.toGregorian();

        return '${gDate.year}/${gDate.month.toString().padLeft(2, '0')}/${gDate.day.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      print('Error converting date: $e');
    }
    return jalaliDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      initialDatePickerMode: DatePickerMode.year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.grey[800]!,
              onPrimary: Colors.white,
              onSurface: Colors.grey[800]!,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.grey[800]!,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final jDate = Jalali.fromDateTime(picked);

      final formattedJalaliDate = '${jDate.year}/${jDate.month.toString().padLeft(2, '0')}/${jDate.day.toString().padLeft(2, '0')}';

      setState(() {
        _controller.text = formattedJalaliDate;
        _errorText = null;
      });

      final gregorianDate = _convertToGregorian(formattedJalaliDate);
      widget.onChanged(gregorianDate);
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
            textAlign: _controller.text.isEmpty ? TextAlign.left : TextAlign.right,
            style: TextStyle(
              color: Colors.grey[800],
            ),
            decoration: InputDecoration(
              hintText: _controller.text.isEmpty
                  ? ( 'انتخاب تاریخ')
                  : null,
              hintStyle: TextStyle(
                color: Colors.grey[600],
              ),
              errorText: _errorText,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Icon(
                  Icons.calendar_today,
                  color: Colors.grey[700],
                ),
              ),
              prefixIconConstraints: BoxConstraints(
                minWidth: 40,
                minHeight: 40,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[300]!,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                  color: Colors.grey[500]!,
                ),
              ),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: const EdgeInsets.only(
                left: 16,
                right: 16,
                top: 12,
                bottom: 12,
              ),
            ),
            validator: (value) {
              final error = RuleMapper.validate(widget.field.rules, value);
              setState(() {
                _errorText = error;
              });
              return error;
            },
            onTap: () => _selectDate(context),
            readOnly: true,
          ),
        ],
      ),
    );
  }
}