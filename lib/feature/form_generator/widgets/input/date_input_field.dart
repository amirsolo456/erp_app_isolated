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

  Jalali _focusedMonth = Jalali.now();
  Jalali? _selectedDay;

  @override
  void initState() {
    super.initState();
    _initializeValue();
  }

  // ---------- Utils ----------
  String toPersianNumber(String input) {
    const en = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
    const fa = ['۰', '۱', '۲', '۳', '۴', '۵', '۶', '۷', '۸', '۹'];
    for (int i = 0; i < 10; i++) {
      input = input.replaceAll(en[i], fa[i]);
    }
    return input;
  }

  bool isSameJalali(Jalali a, Jalali b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Jalali? _gregorianStringToJalali(String value) {
    try {
      final p = value.split('/');
      return Gregorian(
        int.parse(p[0]),
        int.parse(p[1]),
        int.parse(p[2]),
      ).toJalali();
    } catch (_) {
      return null;
    }
  }

  String _formatJalali(Jalali j) =>
      '${toPersianNumber(j.year.toString())}/'
      '${toPersianNumber(j.month.toString().padLeft(2, '0'))}/'
      '${toPersianNumber(j.day.toString().padLeft(2, '0'))}';

  String _jalaliToGregorianString(Jalali j) {
    final g = j.toGregorian();
    return '${g.year}/${g.month.toString().padLeft(2, '0')}/${g.day.toString().padLeft(2, '0')}';
  }

  void _initializeValue() {
    final initial =
        widget.initialValues?[widget.field.name] ?? widget.field.defaultValue;

    if (initial != null) {
      final j = _gregorianStringToJalali(initial.toString());
      if (j != null) {
        _selectedDay = j;
        _focusedMonth = Jalali(j.year, j.month, 1);
        _controller.text = _formatJalali(j);
        widget.onChanged(initial);
      }
    }
  }

  // ---------- Calendar ----------
  void _openCalendar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: StatefulBuilder(
            builder: (context, setStateDialog) {
              final today = Jalali.now();
              final daysInMonth = _focusedMonth.monthLength;
              const weekDays = ['ش', 'ی', 'د', 'س', 'چ', 'پ', 'ج'];

              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          onPressed: () => setStateDialog(
                            () => _focusedMonth = _focusedMonth.addMonths(-1),
                          ),
                        ),
                        Text(
                          '${_focusedMonth.formatter.mN} ${toPersianNumber(_focusedMonth.year.toString())}',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          onPressed: () => setStateDialog(
                            () => _focusedMonth = _focusedMonth.addMonths(1),
                          ),
                        ),
                      ],
                    ),


                    // const SizedBox(height: 8),

                    Divider(
                      color: Color(0xff939393),
                      // height: 2,
                      thickness: 2,
                    ),

                    const SizedBox(height: 8),

                    // Week days
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: weekDays
                          .map(
                            (e) => SizedBox(
                              width: 34,
                              child: Center(
                                child: Text(
                                  e,
                                  style: const TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),

                    const SizedBox(height: 8),

                    // Days grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: daysInMonth,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 7,
                            mainAxisSpacing: 4,
                            crossAxisSpacing: 4,
                          ),
                      itemBuilder: (_, index) {
                        final day = Jalali(
                          _focusedMonth.year,
                          _focusedMonth.month,
                          index + 1,
                        );

                        final isToday = isSameJalali(day, today);
                        final isSelected =
                            _selectedDay != null &&
                            isSameJalali(day, _selectedDay!);

                        return GestureDetector(
                          onTap: () {
                            setStateDialog(() => _selectedDay = day);
                            setState(() {
                              _controller.text = _formatJalali(day);
                              _errorText = null;
                            });
                            widget.onChanged(_jalaliToGregorianString(day));
                            Navigator.pop(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Color(0xff939393)
                                  : Colors.transparent,
                              border: isToday
                                  ? Border.all(color: Colors.black, width: 2)
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              toPersianNumber(day.day.toString()),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : (isToday
                                          ? Color(0xff939393)
                                          : Color(0xff939393)),
                                fontSize: 16,
                                fontWeight: FontWeight.w700

                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 12),

                    GestureDetector(
                      onTap: () {
                        final today = Jalali.now();

                        setStateDialog(() {
                          _selectedDay = today;
                          _focusedMonth = Jalali(today.year, today.month, 1);
                        });

                        setState(() {
                          _controller.text = _formatJalali(today);
                          _errorText = null;
                        });

                        widget.onChanged(_jalaliToGregorianString(today));
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(
                          'انتخاب امروز',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),


                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ---------- UI ----------
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
            readOnly: true,
            textAlign: _controller.text.isEmpty
                ? TextAlign.left
                : TextAlign.right,
            decoration: InputDecoration(
              hintText: 'انتخاب تاریخ',
              errorText: _errorText,
              prefixIcon: const Icon(Icons.calendar_today),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            validator: (v) {
              final error = RuleMapper.validate(widget.field.rules, v);
              setState(() => _errorText = error);
              return error;
            },
            onTap: () => _openCalendar(context),
          ),
        ],
      ),
    );
  }
}
