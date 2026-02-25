

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/data/auth/menu/response_data.dart' as prefix0;
import 'package:ui_components_package/erp_app_componenets/common/loadings/circle_loading.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Inputs/search_box.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/list_scroll/list_scroll.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Lists/menu_Item/menu_Item.dart';
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
  final ScrollController _scrollController = ScrollController();

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

          if (state is MenuInitial) {
            return const Center(child: CircleLoading());
          }

          if (state is MenuErrorState) {
            return const Center(child: Text('خطا در دریافت منو'));
          }

          if (state is MenuLoadedState) {
            _leafMenus = _extractLeafMenus(state.menus);

            if (searchController.text.isEmpty) {
              _filteredMenus = _leafMenus;
            }

            return Column(
              children: [
                SearchBox(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  onChanged: _onSearch,
                ),

                Expanded(
                  child: ListScroll(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      itemCount: _filteredMenus.length,
                      itemBuilder: (context, index) {
                        return MenuItem(_filteredMenus[index]);
                      },
                    ),
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


