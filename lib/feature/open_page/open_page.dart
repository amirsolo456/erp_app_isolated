// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:shared_core/data/auth/menu/response_data.dart' as prefix0;
import 'package:shared_core/data/auth/menu/response.dart' as prefix0;
import 'package:shared_core/data/auth/menu/request.dart' as prefix0;

class OpenedPage extends StatefulWidget {
  final List<prefix0.ResponseData> items;

  const OpenedPage({super.key, required this.items});

  @override
  State<OpenedPage> createState() => _OpenedPageState();
}

class _OpenedPageState extends State<OpenedPage> {
  late List<prefix0.ResponseData> _items;

  @override
  void initState() {
    super.initState();
    // تبدیل ساختار سلسله مراتبی به لیست مسطح
    _items = _flattenItems(widget.items);
  }

  // تابع برای باز کردن تمام سطوح
  List<prefix0.ResponseData> _flattenItems(List<prefix0.ResponseData> items) {
    var flattened = <prefix0.ResponseData>[];

    for (var item in items) {
      // فقط آیتم‌هایی را اضافه کن که actionType == 1 دارند (منوهای قابل کلیک)
      if (item.actionType == 1) {
        flattened.add(item);
      }

      // زیرمنوها را هم باز کن
      if (item.subMenus.isNotEmpty) {
        flattened.addAll(_flattenItems(item.subMenus));
      }
    }

    return flattened;
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _clearAll() {
    setState(() {
      _items.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            if (_items.isNotEmpty)
              Container(
                width: double.infinity,
                color: Color(0xffECECEC),
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'بستن همه',
                      style: TextStyle(fontSize: 12, color: Color(0xff292929)),
                    ),
                    const SizedBox(width: 4),
                    InkWell(
                      onTap: _clearAll,
                      child: Image.asset(
                        'assets/images/Close.png',
                        package: 'resources_package',
                      ),
                    ),
                  ],
                ),
              ),
            if (_items.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'موردی وجود ندارد',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    final item = _items[index];

                    final title = item.menuDesc ?? 'بدون عنوان';
                    final route = item.appLink ?? item.webLink ?? '';

                    return InkWell(
                      onTap: () {
                        if (route.isNotEmpty) {
                          Navigator.pushNamed(context, route);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/pluse.png',
                              package: 'resources_package',
                            ),
                            const Expanded(child: SizedBox()),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.black,
                              ),
                            ),

                            InkWell(
                              onTap: () => _removeItem(index),
                              child: Image.asset(
                                'assets/images/Close.png',
                                package: 'resources_package',
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
