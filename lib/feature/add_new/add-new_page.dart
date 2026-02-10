// ignore: file_names
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:micro_app_core/index.dart';
import 'package:shared_core/data/auth/menu/response_data.dart' as prefix0;

import '../../micro_app/erp_events.dart';
import '../auth/menu/bloc/menu_bloc.dart';
import '../auth/menu/bloc/menu_event.dart';
import '../auth/menu/bloc/menu_state.dart';

class AddNewPage extends StatefulWidget {
  const AddNewPage({super.key});

  @override
  State<AddNewPage> createState() => _AddNewPageState();
}

class _AddNewPageState extends State<AddNewPage> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  List<prefix0.ResponseData> _leafMenus = [];
  List<prefix0.ResponseData> _filteredMenus = [];

  bool isFocused = false;

  @override
  void initState() {
    super.initState();

    context.read<MenuBloc>().add(const LoadMenuEvent());

    searchFocusNode.addListener(() {
      setState(() => isFocused = searchFocusNode.hasFocus);
    });
  }

  /// 🔹 استخراج فقط منوهای انتهایی (Leaf)
  List<prefix0.ResponseData> _extractLeafMenus(
    List<prefix0.ResponseData> menus,
  ) {
    final result = <prefix0.ResponseData>[];

    void traverse(prefix0.ResponseData menu) {
      if (menu.subMenus.isEmpty) {
        result.add(menu);
      } else {
        for (final sub in menu.subMenus) {
          traverse(sub);
        }
      }
    }

    for (final menu in menus) {
      traverse(menu);
    }

    return result;
  }

  /// 🔹 جستجو فقط روی Leaf‌ها
  void _onSearch(String query) {
    if (query.isEmpty) {
      _filteredMenus = _leafMenus;
    } else {
      _filteredMenus = _leafMenus
          .where((e) => (e.menuDesc ?? '').contains(query))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text("جدید"),),
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuTokenNeedState) {
            context.read<MenuBloc>().add(const MenuTokenNeedEvent());
            return const Center(child: Text('لطفاً دوباره وارد شوید'));
          }

          if (state is MenuLoadingState) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          if (state is MenuErrorState) {
            return const Center(child: Text('خطا در دریافت منو'));
          }

          if (state is MenuLoadedState) {
            /// فقط یک بار Leaf ها ساخته می‌شوند
            _leafMenus = _extractLeafMenus(state.menus);

            /// اگر سرچ خالی است، کل Leaf ها را نشان بده
            if (searchController.text.isEmpty) {
              _filteredMenus = _leafMenus;
            }

            return Column(
              children: [
                _SearchBox(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  isFocused: isFocused,
                  onChanged: _onSearch,
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _filteredMenus.length,
                    itemBuilder: (context, index) {
                      return _LeafMenuTile(_filteredMenus[index]);
                    },
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}

class _LeafMenuTile extends StatelessWidget {
  final prefix0.ResponseData item;

  const _LeafMenuTile(this.item);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF4F4F4),
          borderRadius: BorderRadius.all(Radius.circular(4)),
        ),
        margin: const EdgeInsets.symmetric(vertical: 2),
        child: ListTile(
          dense: true,
          visualDensity: const VisualDensity(vertical: -3),
          title: Text(
            item.menuDesc ?? '',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          onTap: () {
            CustomEventBus.emit(
              ErpFormGeneratorEvent(item.safeRepoId, item.safeSystemId, 1),
            );
          },

          // await NavigatorAgent().navigatorAssist.to(
          //   ((item.appLink ?? item.webLink) ?? '/notFound'),
          // );
        ),
      ),
    );
  }
}

class _SearchBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isFocused;
  final ValueChanged<String> onChanged;

  const _SearchBox({
    required this.controller,
    required this.focusNode,
    required this.isFocused,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Container(
        decoration: BoxDecoration(
          color: isFocused ? Colors.white : Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isFocused ? Colors.black12 : Colors.transparent,
          ),
        ),
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          textDirection: TextDirection.rtl,
          decoration: const InputDecoration(
            hintText: 'جستجو',
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
