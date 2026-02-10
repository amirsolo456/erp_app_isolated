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
import '../../../../src/erp_notifier.dart';
import '../bloc/menu_bloc.dart';
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
    final matches = (menu.menuDesc ?? '').contains(query);
    final subMenusFiltered = (menu.subMenus ?? [])
        .map((e) => _filterMenu(e, query))
        .where((e) => e != null)
        .cast<ResponseData>()
        .toList();

    if (matches || subMenusFiltered.isNotEmpty) {
      return ResponseData().copyWith(
        subMenus: subMenusFiltered,
        menuDesc: menu.menuDesc,
        icon: menu.icon,
        appLink: menu.appLink,
        webLink: menu.webLink,
      );
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<MenuBloc, MenuState>(
        builder: (context, state) {
          if (state is MenuTokenNeedState) {
            final notifier = sl<AppNotifier>();
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
                isFocused: isFocused,
                onChanged: (value) => filterMenus(state.menus, value),
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontFamily: 'IRanSans',
                ),
                hintStyle: const TextStyle(color: Colors.black54),
                textDirection: null, // یا TextDirection.rtl اگه میخواید اجباری باشه
              ),

                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
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

class _MenuTile extends StatelessWidget {
  final ResponseData item;

  const _MenuTile(this.item);

  @override
  Widget build(BuildContext context) {
    final hasChildren = (item.subMenus ?? []).isNotEmpty;
    final notifier = Provider.of<ErpAppNotifier>(context);
    final iconWidget = (item.icon != null && item.icon!.isNotEmpty)
        ? SvgPicture.string(item.icon!, width: 18, height: 18)
        : const SizedBox(width: 18, height: 18);

    final Widget titleWidget = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        iconWidget,
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            item.menuDesc ?? '',
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );


    if (!hasChildren) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: ListTile(
          splashColor: Colors.transparent,
          dense: true,
          visualDensity: const VisualDensity(vertical: -3),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
          title: titleWidget,
          onTap: () {
            final link = item.appLink ?? item.webLink ?? '';
            // final cleanLink = link.startsWith('/') ? link.substring(1) : link;
            notifier.changePage(
              PageType.listGenerator,
              route: '/GenericList/${link}',
              tab: null,
            );
          },
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: const EdgeInsets.symmetric(horizontal: 12),
            childrenPadding: const EdgeInsets.only(right: 20, bottom: 2),
            splashColor: Colors.transparent,
            controlAffinity: ListTileControlAffinity.trailing,
            collapsedIconColor: Colors.black,
            iconColor: Colors.black,
            dense: true,
            visualDensity: const VisualDensity(vertical: -3),
            title: Row(
              children: [
                Expanded(child: titleWidget),
                const SizedBox(width: 10),
              ],
            ),
            children: item.subMenus.map((e) => _MenuTile(e)).toList(),
          ),
        ),
      );
    }

    /// -------------------------
    /// با زیرمنو
    /// -------------------------
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
