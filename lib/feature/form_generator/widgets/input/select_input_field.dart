


import 'package:shared_core/index.dart';
import 'package:flutter/material.dart';


class SelectInputField extends StatefulWidget {
  final Field field;
  final ValueChanged<dynamic> onChanged;
  final Map<String, dynamic> initialValues;

  const SelectInputField({
    Key? key,
    required this.field,
    required this.onChanged,
    required this.initialValues,
  }) : super(key: key);

  @override
  _SelectInputFieldState createState() => _SelectInputFieldState();
}

class _SelectInputFieldState extends State<SelectInputField> {
  dynamic _selectedValue;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeValue();
  }

  void _initializeValue() {
    final initialValue = widget.initialValues[widget.field.name] ?? widget.field.defaultValue;


    if (initialValue == null || initialValue.toString().isEmpty) {
      if (widget.field.options.isNotEmpty) {
        _selectedValue = widget.field.options.first.value;
        _controller.text = widget.field.options.first.caption;


        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onChanged(_selectedValue);
        });
      }
    } else {

      _selectedValue = initialValue;


      final selectedOption = widget.field.options.firstWhere(
            (option) => option.value == initialValue,
        orElse: () => Select(caption: '', value: null),
      );

      _controller.text = selectedOption.caption ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final options = widget.field.options ?? [];

    // اگر گزینه‌ای وجود ندارد، یک TextField نشان بده
    if (options.isEmpty) {
      return TextFormField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: widget.field.caption,
          hintText: widget.field.placeHolder,
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          widget.onChanged(value);
        },
      );
    }

    // تبدیل گزینه‌ها به DropdownMenuItem
    final dropdownItems = options.map((option) {
      final value = option.value;
      final caption = option.caption ;

      return DropdownMenuItem<dynamic>(
        value: value,
        child: Text(caption),
      );
    }).toList();

    // اضافه کردن یک گزینه خالی اگر مقدار انتخابی خالی است
    if (_selectedValue == null || _selectedValue.toString().isEmpty) {
      dropdownItems.insert(0, DropdownMenuItem<dynamic>(
        value: null,
        child: Text(widget.field.placeHolder ?? 'انتخاب کنید...'),
      ));
    }

    return DropdownButtonFormField<dynamic>(
      initialValue: _selectedValue,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          _selectedValue = value;


          final selectedOption = options.firstWhere(
                (option) => option.value == value,
            orElse: () => Select(caption: '', value: null),
          );

          _controller.text = selectedOption.caption;
        });

        widget.onChanged(value);
      },
      decoration: InputDecoration(
        labelText: widget.field.caption,
        hintText: widget.field.placeHolder,
        border: OutlineInputBorder(),
      ),
      validator: (value) {

        if (widget.field.rules.any((rule) => rule.required == true) == true) {
          if (value == null || value.toString().isEmpty) {
            final rule = widget.field.rules.firstWhere(
                  (rule) => rule.required == true,
              orElse: () => Rule(message: 'این فیلد الزامی است'),
            );
            return rule.message;
          }
        }
        return null;
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}