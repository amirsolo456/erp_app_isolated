// models/field_display_config.dart
import 'package:flutter/material.dart';

class FieldDisplayConfig<D>  {
  final String label; // عنوان فارسی فیلد
  final String Function(D items) valueGetter; // تابع برای گرفتن مقدار از مدل
  final Widget Function(String value)? cellBuilder; // ویجت سفارشی برای نمایش مقدار
  final double width; // عرض ستون (اختیاری)
  final bool isSortable; // قابل مرتب‌سازی بودن

  const FieldDisplayConfig({
    required this.label,
    required this.valueGetter,
    this.cellBuilder,
    this.width = 100,
    this.isSortable = false,
  });

  // متد ساده‌تر برای سلول پیش‌فرض
  Widget defaultCellBuilder(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        value,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget buildCell(D items  ) {
    final value = valueGetter(items);
    if (cellBuilder != null) {
      return cellBuilder!(value);
    }
    return defaultCellBuilder(value);
  }
}