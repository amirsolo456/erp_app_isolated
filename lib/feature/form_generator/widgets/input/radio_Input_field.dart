
import 'package:flutter/material.dart';
import '../common/field_title.dart';

class RadioInputField extends StatefulWidget {
  final String caption;
  final String help;
  final String fieldName;
  final List<Map<String, dynamic>> options;
  final ValueChanged<dynamic> onChanged;
  final dynamic initialValue;
  final bool isRequired;

  const RadioInputField({
    required this.caption,
    required this.help,
    required this.fieldName,
    required this.options,
    required this.onChanged,
    required this.initialValue,
    this.isRequired = false,
  });

  @override
  _RadioInputFieldState createState() => _RadioInputFieldState();
}

class _RadioInputFieldState extends State<RadioInputField> {
  dynamic _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.initialValue;
    for (var i = 0; i < widget.options.length; i++) {
      final option = widget.options[i];
      print('   ${i + 1}. ${option['caption']}: ${option['value']} (type: ${option['value']?.runtimeType})');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        if (widget.caption.isNotEmpty)
          FieldTitle(
            caption: widget.caption,
            help: widget.help,
            isRequired: widget.isRequired,
          ),

        Wrap(
          textDirection: TextDirection.rtl,
          spacing: 15,
          runSpacing: 8,
          children: widget.options.map((option) {
            final caption = option['caption']?.toString() ?? '';
            final value = option['value'];
            final isSelected = _selectedValue == value;

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedValue = value;
                });
                widget.onChanged(value);
              },
              child: Container(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    //Ehsan
                    Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:isSelected
                                ?  Colors.grey[400]! :
                            Colors.white,
                            width: 1.2,
                          ),
                          color: Colors.white,
                        ),
                        child: Center(
                          child: Container(
                            width: 15,
                            height: 15,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:isSelected
                                  ?  Colors.black
                                  : Colors.grey[400],
                            ),
                          ),
                        )
                    ),
                    //Ehsan


                    SizedBox(width: 8),
                    Text(
                      caption,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}