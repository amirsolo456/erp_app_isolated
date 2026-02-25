
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:micro_app_commons/app_notifier.dart';
import 'package:models_package/index.dart';
import 'package:provider/provider.dart';
import 'package:shared_core/data/auth/menu/response_data.dart';
import 'package:ui_components_package/erp_app_componenets/common/loadings/circle_loading.dart';
import 'package:ui_components_package/erp_app_componenets/mobile/Inputs/search_box.dart';

import '../../../../index.dart';
import '../bloc/menu_bloc.dart';
import '../bloc/menu_event.dart';
import '../bloc/menu_state.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  TextEditingController searchController = TextEditingController();
  List<ResponseData> filteredMenus = [];

  bool isFocused = false;
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    searchFocusNode.addListener(() {
      setState(() {
        super.initState();
        context.read<MenuBloc>().add(LoadMenuEvent());
        isFocused = searchFocusNode.hasFocus;
      });
    });
  }

  void filterMenus(List<ResponseData> menus, String query) {
    filteredMenus = menus
        .map((menu) => _filterMenu(menu, query))
        .where((e) => e != null)
        .cast<ResponseData>()
        .toList();
    setState(() {});
  }

  ResponseData? _filterMenu(ResponseData menu, String query) {
    final matches = menu.menuDesc!.contains(query);
    final subMenusFiltered = menu.subMenus
        .map((e) => _filterMenu(e, query))
        .where((e) => e != null)
        .cast<ResponseData>()
        .toList();

    if (matches || subMenusFiltered.isNotEmpty) {
      return ResponseData().copyWith(subMenus: subMenusFiltered);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuTokenNeedState) {
            final notifier = sl<ErpAppNotifier>();
            notifier.signOut(context, force: true);

            return const Center(child: Text('لطفا دوباره وارد شوید!'));
          }
          if (state is MenuLoadingState) {
            return const Center(child: CircleLoading());
          }
          if (state is MenuErrorState) {
            return const Center(child: Text('خطا در بارگذاری'));
          }
          if (state is MenuLoadedState) {
            if (searchController.text.isEmpty) {
              filteredMenus = state.menus;
            }

            return Directionality(
              textDirection:
                  sl<AppNotifier>().currentLocal().languageCode == 'en'
                  ? TextDirection.ltr
                  : TextDirection.rtl,
              child: Column(
                children: [
                  SearchBox(


                    controller: searchController,
                    focusNode: searchFocusNode,

                    onChanged: (value) => filterMenus(state.menus, value),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredMenus.length,
                      itemBuilder: (context, index) {
                        return _MenuTile(filteredMenus[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}

class _MenuTile extends StatefulWidget {
  final ResponseData item;
  final double level;

  const _MenuTile(this.item, {this.level = 0});

  @override
  State<_MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<_MenuTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final hasChildren = widget.item.subMenus.isNotEmpty;
    final notifier = Provider.of<ErpAppNotifier>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            if (hasChildren) {
              setState(() {
                isExpanded = !isExpanded;
              });
            } else {
              final link =
                  widget.item.appLink ?? widget.item.webLink ?? '';
              notifier.changePage(
                PageType.listGenerator,
                route: '/GenericList/$link',
                tab: null,
              );
            }
          },
          child: Container(
            // color: Colors.red,
            height: 40,
            padding: EdgeInsets.only(
              left: 8 ,
              right: 8+ (widget.level * 12),
            ),
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  if (widget.item.icon?.isNotEmpty == true)
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: SvgPicture.string(
                        widget.item.icon!,
                        width: 21,
                        height: 21,
                      ),
                    ),
                  // SizedBox(width: 5,),

                  Expanded(
                    child: Text(
                      widget.item.menuDesc ?? '',
                      style:  TextStyle(
                        fontFamily: 'IRANSansX',
                        fontSize: 15,
                        height: 1.0,
                        color: Color(0xff585858),
                        fontWeight: FontWeight.w600
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (hasChildren)
                    Icon(
                      isExpanded
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_left,
                      size: 16,
                    ),
                ],
              ),
            ),
          ),
        ),

        /// 🔽 زیرمنوها
        if (hasChildren && isExpanded)
          Column(
            children: widget.item.subMenus
                .map(
                  (e) => _MenuTile(
                e,
                level: widget.level + 1,
              ),
            )
                .toList(),
          ),
      ],
    );
  }
}
String addQueryParams(String url, Map<String, String>? extraParams) {
  if (extraParams == null || extraParams.isEmpty) {
    return url;
  }

  final uri = Uri.parse(url);
  final params = Map<String, String>.from(uri.queryParameters);
  params.addAll(extraParams);

  return Uri(
    path: uri.path,
    queryParameters: params.isNotEmpty ? params : null,
  ).toString();
}
