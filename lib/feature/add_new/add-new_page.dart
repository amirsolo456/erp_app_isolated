import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_core/data/auth/menu/response_data.dart' as prefix0;
import 'package:ui_components_package/navigator.dart';

import '../auth/menu/bloc/menu_bloc.dart';
import '../auth/menu/bloc/menu_event.dart';
import '../auth/menu/bloc/menu_state.dart';
import '../form_generator/widgets/dynamic_form_generator.dart';

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

            return Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
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
              ),
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

//           onTap: () {
//             // JSON با فرمت صحیح (بدون escape اضافی)
//             final jsonString = r'''
//
//
//
// {
//     "Data": {
//         "GroupMenu": [
//             {
//                 "MenuId": 6,
//                 "ActionType": 1,
//                 "Icon": "<svg width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\r\n<path d=\"M15 13V9M15 9H11M15 9L9 15M21 12C21 7.02944 16.9706 3 12 3C7.02944 3 3 7.02944 3 12C3 16.9706 7.02944 21 12 21C16.9706 21 21 16.9706 21 12Z\" stroke=\"#676767\" stroke-linecap=\"round\" stroke-linejoin=\"round\"/>\r\n</svg>\r\n",
//                 "IconUrl": "https://file.ariansystem.net/icons/",
//                 "ActionId": 269,
//                 "MenuDesc": "ارسال به اکسل",
//                 "FatherId": 4,
//                 "MenuType": 2,
//                 "loggedInUserId": 0,
//                 "SubMenus": []
//             },
//             {
//                 "MenuId": 17,
//                 "ActionType": 1,
//                 "Icon": "<svg width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\r\n<path d=\"M20.5001 6H3.5\" stroke=\"#676767\" stroke-linecap=\"round\"/>\r\n<path d=\"M18.8332 8.5L18.3732 15.3991C18.1962 18.054 18.1077 19.3815 17.2427 20.1907C16.3777 21 15.0473 21 12.3865 21H11.6132C8.95235 21 7.62195 21 6.75694 20.1907C5.89194 19.3815 5.80344 18.054 5.62644 15.3991L5.1665 8.5\" stroke=\"#676767\" stroke-linecap=\"round\"/>\r\n<path opacity=\"0.5\" d=\"M6.5 6C6.55588 6 6.58382 6 6.60915 5.99936C7.43259 5.97849 8.15902 5.45491 8.43922 4.68032C8.44784 4.65649 8.45667 4.62999 8.47434 4.57697L8.57143 4.28571C8.65431 4.03708 8.69575 3.91276 8.75071 3.8072C8.97001 3.38607 9.37574 3.09364 9.84461 3.01877C9.96213 3 10.0932 3 10.3553 3H13.6447C13.9068 3 14.0379 3 14.1554 3.01877C14.6243 3.09364 15.03 3.38607 15.2493 3.8072C15.3043 3.91276 15.3457 4.03708 15.4286 4.28571L15.5257 4.57697C15.5433 4.62992 15.5522 4.65651 15.5608 4.68032C15.841 5.45491 16.5674 5.97849 17.3909 5.99936C17.4162 6 17.4441 6 17.5 6\" stroke=\"#676767\"/>\r\n</svg>\r\n",
//                 "IconUrl": "https://file.ariansystem.net/icons/Delete.png",
//                 "ActionId": 269,
//                 "MenuDesc": "حذف",
//                 "FatherId": 4,
//                 "MenuType": 2,
//                 "WebLink": "com/delete/person",
//                 "loggedInUserId": 0,
//                 "SubMenus": []
//             },
//             {
//                 "MenuId": 60,
//                 "ActionType": 1,
//                 "Icon": "<svg width=\"24\" height=\"24\" viewBox=\"0 0 24 24\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\r\n<circle cx=\"1.5\" cy=\"1.5\" r=\"1.5\" transform=\"matrix(1 0 0 -1 16 8.00024)\" stroke=\"#848484\" stroke-width=\"1.5\" stroke-linecap=\"round\" stroke-linejoin=\"round\"/>\r\n<path d=\"M2.77423 11.1439C1.77108 12.2643 1.7495 13.9546 2.67016 15.1437C4.49711 17.5033 6.49674 19.5029 8.85633 21.3298C10.0454 22.2505 11.7357 22.2289 12.8561 21.2258C15.8979 18.5022 18.6835 15.6559 21.3719 12.5279C21.6377 12.2187 21.8039 11.8397 21.8412 11.4336C22.0062 9.63798 22.3452 4.46467 20.9403 3.05974C19.5353 1.65481 14.362 1.99377 12.5664 2.15876C12.1603 2.19608 11.7813 2.36233 11.472 2.62811C8.34412 5.31646 5.49781 8.10211 2.77423 11.1439Z\" stroke=\"#848484\"/>\r\n<path d=\"M7 14.0002L10 17.0002\" stroke=\"#848484\" stroke-width=\"1.5\" stroke-linecap=\"round\" stroke-linejoin=\"round\"/>\r\n<path d=\"M23 18C23 15.7909 21.2091 14 19 14C16.7909 14 15 15.7909 15 18C15 20.2091 16.7909 22 19 22C21.2091 22 23 20.2091 23 18Z\" fill=\"white\" stroke=\"#848484\" stroke-width=\"0.8\"/>\r\n<path d=\"M19 16V20M21 18L17 18\" stroke=\"#848484\" stroke-width=\"0.8\" stroke-linecap=\"round\" stroke-linejoin=\"round\"/>\r\n</svg>\r\n",
//                 "IconUrl": "https://file.ariansystem.net/icons/",
//                 "ActionId": 269,
//                 "MenuDesc": "افزودن برچسب",
//                 "FatherId": 4,
//                 "MenuType": 2,
//                 "loggedInUserId": 0,
//                 "SubMenus": []
//             }
//         ],
//         "GridMenu": [
//             {
//                 "MenuId": 9,
//                 "ActionType": 3,
//                 "Icon": " <svg\r\n      xmlns=\"http://www.w3.org/2000/svg\"\r\n      width=\"18\"\r\n      height=\"18\"\r\n      viewBox=\"0 0 15 15\"\r\n      fill=\"none\"\r\n    >\r\n      <path\r\n        d=\"M5.50015 2H3.40015C2.56007 2 2.13972 2 1.81885 2.16349C1.5366 2.3073 1.3073 2.5366 1.16349 2.81885C1 3.13972 1 3.56007 1 4.40015V11.6001C1 12.4402 1 12.86 1.16349 13.1809C1.3073 13.4632 1.5366 13.6929 1.81885 13.8367C2.1394 14 2.55925 14 3.39768 14H10.6023C11.4408 14 11.86 14 12.1805 13.8367C12.4628 13.6929 12.6929 13.4629 12.8367 13.1807C13 12.8601 13 12.4408 13 11.6023V9.5M10 2.75L5.5 7.25V9.5H7.75L12.25 5M10 2.75L12.25 0.5L14.5 2.75L12.25 5M10 2.75L12.25 5\"\r\n        stroke=\"#585858\"\r\n        strokeLinecap=\"round\"\r\n        strokeLinejoin=\"round\"\r\n      />\r\n    </svg>",
//                 "IconUrl": "https://file.ariansystem.net/icons/Edit.png",
//                 "ActionId": 271,
//                 "MenuDesc": "ویرایش",
//                 "FatherId": 4,
//                 "MenuType": 4,
//                 "loggedInUserId": 0,
//                 "SubMenus": []
//             },
//             {
//                 "MenuId": 10,
//                 "ActionType": 4,
//                 "Icon": "<svg\r\n      xmlns=\"http://www.w3.org/2000/svg\"\r\n      width=\"18\"\r\n      height=\"18\"\r\n      viewBox=\"0 0 18 18\"\r\n      fill=\"none\"\r\n    >\r\n      <path\r\n        d=\"M15.3751 4.5H2.625\"\r\n        stroke=\"#585858\"\r\n        strokeLinecap=\"round\"\r\n      />\r\n      <path\r\n        d=\"M14.125 6.375L13.78 11.5493C13.6473 13.5405 13.5809 14.5361 12.9322 15.1431C12.2834 15.75 11.2856 15.75 9.29001 15.75H8.70999C6.71439 15.75 5.71659 15.75 5.06783 15.1431C4.41907 14.5361 4.3527 13.5405 4.21996 11.5493L3.875 6.375\"\r\n        stroke=\"#585858\"\r\n        strokeLinecap=\"round\"\r\n      />\r\n      <path\r\n        opacity=\"0.5\"\r\n        d=\"M4.875 4.5C4.91691 4.5 4.93786 4.5 4.95686 4.49952C5.57444 4.48387 6.11927 4.09118 6.32941 3.51024C6.33588 3.49237 6.3425 3.47249 6.35576 3.43273L6.42857 3.21429C6.49073 3.02781 6.52181 2.93457 6.56304 2.8554C6.72751 2.53955 7.03181 2.32023 7.38346 2.26407C7.4716 2.25 7.56988 2.25 7.76645 2.25H10.2336C10.4301 2.25 10.5284 2.25 10.6165 2.26407C10.9682 2.32023 11.2725 2.53955 11.437 2.8554C11.4782 2.93457 11.5093 3.02781 11.5714 3.21429L11.6442 3.43273C11.6575 3.47244 11.6641 3.49238 11.6706 3.51024C11.8807 4.09118 12.4256 4.48387 13.0431 4.49952C13.0621 4.5 13.0831 4.5 13.125 4.5\"\r\n        stroke=\"#585858\"\r\n      />\r\n    </svg>",
//                 "IconUrl": "https://file.ariansystem.net/icons/Delete.png",
//                 "ActionId": 272,
//                 "MenuDesc": "حذف",
//                 "FatherId": 4,
//                 "MenuType": 4,
//                 "WebLink": "com/delete/person",
//                 "loggedInUserId": 0,
//                 "SubMenus": []
//             },
//             {
//                 "MenuId": 11,
//                 "ActionType": 1,
//                 "Icon": "<svg\r\n      xmlns=\"http://www.w3.org/2000/svg\"\r\n      width=\"18\"\r\n      height=\"18\"\r\n      viewBox=\"0 0 18 18\"\r\n      fill=\"none\"\r\n    >\r\n      <path\r\n        d=\"M7.52819 3.98713L8.01495 4.85933C8.45423 5.64644 8.27789 6.67899 7.58604 7.37085C7.58603 7.37085 7.58603 7.37085 7.58603 7.37085C7.58592 7.37097 6.74694 8.21016 8.26839 9.73161C9.78918 11.2524 10.6283 10.4148 10.6291 10.414C10.6292 10.4139 10.6292 10.414 10.6292 10.4139C11.321 9.72211 12.3536 9.54578 13.1407 9.98505L14.0129 10.4718C15.2014 11.1351 15.3418 12.8019 14.2971 13.8466C13.6693 14.4744 12.9003 14.9629 12.0502 14.9951C10.6191 15.0493 8.18871 14.6872 5.75078 12.2492C3.31285 9.81129 2.95066 7.38092 3.00491 5.94982C3.03714 5.0997 3.5256 4.33068 4.15335 3.70292C5.19807 2.65821 6.86488 2.79858 7.52819 3.98713Z\"\r\n        stroke=\"#585858\"\r\n        strokeLinecap=\"round\"\r\n      />\r\n    </svg>",
//                 "IconUrl": "https://file.ariansystem.net/icons/ContactInfo.png",
//                 "ActionId": 269,
//                 "MenuDesc": "اطلاعات تماس",
//                 "FatherId": 4,
//                 "MenuType": 4,
//                 "loggedInUserId": 0,
//                 "SubMenus": []
//             },
//             {
//                 "MenuId": 12,
//                 "Config": "{\r\n  \"fieldKey\": \"PersonRelatedId\",\r\n  \"staticKey\": \"RelatedPersonName\",\r\n  \"deleteUrl\": \"/api/com/delete/personRelated\",\r\n  \"createUrl\": \"/api/com/insert/personRelated\",\r\n  \"updateUrl\": \"/api/com/update/personRelated\",\r\n  \"listConfig\": {\r\n    \"repoViewId\": 30046,\r\n    \"selectUrl\": \"/api/com/select/personRelated\",\r\n    \"column\": [\r\n      {\r\n        \"fieldName\": \"RelatedPersonName\",\r\n        \"fieldCaption\": \"نام\",\r\n        \"fieldType\": \"number\"\r\n      },\r\n      {\r\n        \"fieldName\": \"PositionName\",\r\n        \"fieldCaption\": \"سمت\",\r\n        \"fieldType\": \"string\"\r\n      },\r\n      {\r\n        \"fieldName\": \"RelatedDesc\",\r\n        \"fieldCaption\": \"توضیحات\",\r\n        \"fieldType\": \"string\"\r\n      }\r\n    ],\r\n    \"IsDefault\": true,\r\n    \"IsDisableAutoRefresh\": false,\r\n    \"IsDisableCommentCount\": false,\r\n    \"IsDisableSidebarStats\": false,\r\n    \"IsDisableCount\": false\r\n  },\r\n  \"formConfig\": {\r\n    \"fields\": [\r\n      {\r\n        \"name\": \"RelatedPersonId\",\r\n        \"caption\": \"نام\",\r\n        \"help\": \"این فیلد برای انتخاب کردن نام می باشد\",\r\n        \"type\": \"selectOption\",\r\n        \"rules\": [\r\n          {\r\n            \"required\": true,\r\n            \"message\": \"این فیلد الزامی است.\",\r\n            \"type\": \"number\"\r\n          }\r\n        ],\r\n        \"selectEndpoint\": {\r\n          \"endpoint\": \"api/com/select/person\",\r\n          \"repoViewId\": 30064,\r\n          \"addAppUrl\": \"string\",\r\n          \"addWebUrl\": \"string\"\r\n        },\r\n        \"placeHolder\": \"\",\r\n        \"order\": 1\r\n      },\r\n      {\r\n        \"name\": \"PositionId\",\r\n        \"caption\": \"سمت\",\r\n        \"help\": \"این فیلد برای انتخاب کردن سمت می باشد\",\r\n        \"type\": \"selectOption\",\r\n        \"rules\": [\r\n          {\r\n            \"required\": true,\r\n            \"message\": \"این فیلد الزامی است.\",\r\n            \"type\": \"number\"\r\n          }\r\n        ],\r\n        \"selectEndpoint\": {\r\n          \"endpoint\": \"api/com/select/commonInfo/position\",\r\n          \"repoViewId\": null,\r\n          \"addAppUrl\": \"string\",\r\n          \"addWebUrl\": \"string\"\r\n        },\r\n        \"placeHolder\": \"\",\r\n        \"order\": 2\r\n      },\r\n      {\r\n        \"name\": \"RelatedDesc\",\r\n        \"caption\": \"توضیحات\",\r\n        \"help\": \"این فیلد برای وارد کردن توضیحات می باشد\",\r\n        \"type\": \"text\",\r\n        \"rules\": [\r\n          {\r\n            \"required\": true,\r\n            \"message\": \"این فیلد الزامی است\",\r\n            \"type\": \"string\"\r\n          }\r\n        ],\r\n        \"selectEndpoint\": {},\r\n        \"placeHolder\": \"\",\r\n        \"order\": 3\r\n      }\r\n    ]\r\n  },\r\n  \"actions\": [\r\n    {\r\n      \"MenuId\": null,\r\n      \"Icon\": \"<svg xmlns=\\\"http://www.w3.org/2000/svg\\\" width=\\\"18\\\" height=\\\"18\\\" viewBox=\\\"0 0 15 15\\\" fill=\\\"none\\\"><path d=\\\"M5.50015 2H3.40015C2.56007 2 2.13972 2 1.81885 2.16349C1.5366 2.3073 1.3073 2.5366 1.16349 2.81885C1 3.13972 1 3.56007 1 4.40015V11.6001C1 12.4402 1 12.86 1.16349 13.1809C1.3073 13.4632 1.5366 13.6929 1.81885 13.8367C2.1394 14 2.55925 14 3.39768 14H10.6023C11.4408 14 11.86 14 12.1805 13.8367C12.4628 13.6929 12.6929 13.4629 12.8367 13.1807C13 12.8601 13 12.4408 13 11.6023V9.5M10 2.75L5.5 7.25V9.5H7.75L12.25 5M10 2.75L12.25 0.5L14.5 2.75L12.25 5M10 2.75L12.25 5\\\" stroke=\\\"#585858\\\" stroke-linecap=\\\"round\\\" stroke-linejoin=\\\"round\\\"/></svg>\",\r\n      \"ActionId\": null,\r\n      \"MenuDesc\": \"ویرایش\",\r\n      \"key\": \"ویرایش\",\r\n      \"FatherId\": null,\r\n      \"MenuType\": null,\r\n      \"loggedInUserId\": null\r\n    },\r\n    {\r\n      \"MenuId\": null,\r\n      \"Icon\": \"<svg xmlns=\\\"http://www.w3.org/2000/svg\\\" width=\\\"18\\\" height=\\\"18\\\" viewBox=\\\"0 0 18 18\\\" fill=\\\"none\\\"><path d=\\\"M15.3751 4.5H2.625\\\" stroke=\\\"#585858\\\" stroke-linecap=\\\"round\\\"/><path d=\\\"M14.125 6.375L13.78 11.5493C13.6473 13.5405 13.5809 14.5361 12.9322 15.1431C12.2834 15.75 11.2856 15.75 9.29001 15.75H8.70999C6.71439 15.75 5.71659 15.75 5.06783 15.1431C4.41907 14.5361 4.3527 13.5405 4.21996 11.5493L3.875 6.375\\\" stroke=\\\"#585858\\\" stroke-linecap=\\\"round\\\"/><path opacity=\\\"0.5\\\" d=\\\"M4.875 4.5C4.91691 4.5 4.93786 4.5 4.95686 4.49952C5.57444 4.48387 6.11927 4.09118 6.32941 3.51024C6.33588 3.49237 6.3425 3.47249 6.35576 3.43273L6.42857 3.21429C6.49073 3.02781 6.52181 2.93457 6.56304 2.8554C6.72751 2.53955 7.03181 2.32023 7.38346 2.26407C7.4716 2.25 7.56988 2.25 7.76645 2.25H10.2336C10.4301 2.25 10.5284 2.25 10.6165 2.26407C10.9682 2.32023 11.2725 2.53955 11.437 2.8554C11.4782 2.93457 11.5093 3.02781 11.5714 3.21429L11.6442 3.43273C11.6575 3.47244 11.6641 3.49238 11.6706 3.51024C11.8807 4.09118 12.4256 4.48387 13.0431 4.49952C13.0621 4.5 13.0831 4.5 13.125 4.5\\\" stroke=\\\"#585858\\\"/></svg>\",\r\n      \"ActionId\": null,\r\n      \"MenuDesc\": \"حذف\",\r\n      \"key\": \"حذف\",\r\n      \"FatherId\": null,\r\n      \"MenuType\": null,\r\n      \"WebLink\": \"\",\r\n      \"loggedInUserId\": null\r\n    }\r\n  ]\r\n}\r\n",
//                 "ActionType": 1,
//                 "Icon": "<svg\r\n      xmlns=\"http://www.w3.org/2000/svg\"\r\n      width=\"18\"\r\n      height=\"18\"\r\n      viewBox=\"0 0 18 18\"\r\n      fill=\"none\"\r\n    >\r\n      <circle\r\n        cx=\"6.75\"\r\n        cy=\"4.5\"\r\n        r=\"3\"\r\n        stroke=\"#585858\"\r\n      />\r\n      <path\r\n        d=\"M11.25 6.75C12.4926 6.75 13.5 5.74264 13.5 4.5C13.5 3.25736 12.4926 2.25 11.25 2.25\"\r\n        stroke=\"#585858\"\r\n        strokeLinecap=\"round\"\r\n      />\r\n      <ellipse\r\n        cx=\"6.75\"\r\n        cy=\"12.75\"\r\n        rx=\"5.25\"\r\n        ry=\"3\"\r\n        stroke=\"#585858\"\r\n      />\r\n      <path\r\n        d=\"M13.5 10.5C14.8157 10.7885 15.75 11.5192 15.75 12.375C15.75 13.147 14.9897 13.8172 13.875 14.1528\"\r\n        stroke=\"#585858\"\r\n        strokeLinecap=\"round\"\r\n      />\r\n    </svg>",
//                 "IconUrl": "https://file.ariansystem.net/icons/",
//                 "ActionId": 265,
//                 "MenuDesc": "اشخاص مرتبط",
//                 "FatherId": 4,
//                 "MenuType": 4,
//                 "loggedInUserId": 0,
//                 "SubMenus": []
//             }
//         ],
//         "MoreMenu": [
//             {
//                 "MenuId": 15,
//                 "ActionType": 1,
//                 "Icon": "<svg width=\"10\" height=\"10\" viewBox=\"0 0 24 24\" fill=\"none\" xmlns=\"http://www.w3.org/2000/svg\">\r\n<g id=\"vuesax/linear/calendar\">\r\n<g id=\"calendar\">\r\n<path id=\"Vector\" d=\"M8 2V5\" stroke=\"#454545\" strokeWidth=\"1.5\" stroke-miterlimit=\"10\" strokeLinecap=\"round\" strokeLinejoin=\"round\"/>\r\n<path id=\"Vector_2\" d=\"M16 2V5\" stroke=\"#454545\" strokeWidth=\"1.5\" stroke-miterlimit=\"10\" strokeLinecap=\"round\" strokeLinejoin=\"round\"/>\r\n<path id=\"Vector_3\" d=\"M16 3.5C19.33 3.68 21 4.95 21 9.65V15.83C21 19.95 20 22.01 15 22.01H9C4 22.01 3 19.95 3 15.83V9.65C3 4.95 4.67 3.69 8 3.5H16Z\" stroke=\"#454545\" strokeWidth=\"1.5\" stroke-miterlimit=\"10\" strokeLinecap=\"round\" strokeLinejoin=\"round\"/>\r\n<path id=\"Vector_4\" d=\"M20.75 17.6H3.25\" stroke=\"#454545\" strokeWidth=\"1.5\" stroke-miterlimit=\"10\" strokeLinecap=\"round\" strokeLinejoin=\"round\"/>\r\n<path id=\"Vector_5\" d=\"M12 8.25C10.77 8.25 9.73 8.92 9.73 10.22C9.73 10.84 10.02 11.31 10.46 11.61C9.85 11.97 9.5 12.55 9.5 13.23C9.5 14.47 10.45 15.24 12 15.24C13.54 15.24 14.5 14.47 14.5 13.23C14.5 12.55 14.15 11.96 13.53 11.61C13.98 11.3 14.26 10.84 14.26 10.22C14.26 8.92 13.23 8.25 12 8.25ZM12 11.09C11.48 11.09 11.1 10.78 11.1 10.29C11.1 9.79 11.48 9.5 12 9.5C12.52 9.5 12.9 9.79 12.9 10.29C12.9 10.78 12.52 11.09 12 11.09ZM12 14C11.34 14 10.86 13.67 10.86 13.07C10.86 12.47 11.34 12.15 12 12.15C12.66 12.15 13.14 12.48 13.14 13.07C13.14 13.67 12.66 14 12 14Z\" fill=\"#454545\"/>\r\n</g>\r\n</g>\r\n</svg>\r\n",
//                 "IconUrl": "https://file.ariansystem.net/icons/",
//                 "ActionId": 422,
//                 "MenuDesc": "برچسب",
//                 "FatherId": 4,
//                 "MenuType": 5,
//                 "loggedInUserId": 0,
//                 "SubMenus": []
//             }
//         ],
//         "List": {
//             "Config": "[\r\n  {\r\n    \"fieldName\": \"PersonType\",\r\n    \"fieldCaption\": \"نوع\",\r\n    \"fieldType\": \"radio\",\r\n    \"inFilter\": true,\r\n    \"inQuickFilter\": true,\r\n    \"inSort\": true,\r\n    \"valueOption\": {\r\n      \"Options\": [\r\n        {\r\n          \"caption\": \"شرکت\",\r\n          \"value\": 1\r\n        },\r\n        {\r\n          \"caption\": \"شخص\",\r\n          \"value\": 2\r\n        },\r\n        {\r\n          \"caption\": \"اتباع\",\r\n          \"value\": 3\r\n        },\r\n        {\r\n          \"caption\": \"مشارکت مدنی\",\r\n          \"value\": 4\r\n        }\r\n      ]\r\n    }\r\n  },\r\n  {\r\n    \"fieldName\": \"DisplayName\",\r\n    \"fieldCaption\": \"نام نمایشی\",\r\n    \"fieldType\": \"string\",\r\n    \"inQuickFilter\": true,\r\n    \"inFilter\": true,\r\n    \"inSort\": true,\r\n    \"valueOption\": {}\r\n  },\r\n  {\r\n    \"fieldName\": \"FirstName\",\r\n    \"fieldCaption\": \"نام / نام شرکت\",\r\n    \"fieldType\": \"string\",\r\n    \"inFilter\": true,\r\n    \"inQuickFilter\": true,\r\n    \"inSort\": true,\r\n    \"valueOption\": {}\r\n  },\r\n  {\r\n    \"fieldName\": \"LastName\",\r\n    \"fieldCaption\": \"نام خانوادگی\",\r\n    \"fieldType\": \"string\",\r\n    \"inQuickFilter\": true,\r\n    \"inFilter\": true,\r\n    \"inSort\": true,\r\n    \"valueOption\": {}\r\n  },\r\n  {\r\n    \"fieldName\": \"NationalCode\",\r\n    \"fieldCaption\": \"شناسه ملی / کد ملی \",\r\n    \"fieldType\": \"string\",\r\n    \"inQuickFilter\": true,\r\n    \"inFilter\": true,\r\n    \"inSort\": true,\r\n    \"valueOption\": {}\r\n  },\r\n  {\r\n    \"fieldName\": \"EconomicCode\",\r\n    \"fieldCaption\": \"شماره اقتصادی \",\r\n    \"fieldType\": \"string\",\r\n    \"inFilter\": true,\r\n    \"inQuickFilter\": true,\r\n    \"inSort\": true,\r\n    \"valueOption\": {}\r\n  },\r\n  {\r\n    \"fieldName\": \"PassportNumber\",\r\n    \"fieldCaption\": \"شماره پاسپورت \",\r\n    \"fieldType\": \"string\",\r\n    \"inFilter\": true,\r\n    \"inQuickFilter\": true,\r\n    \"inSort\": true,\r\n    \"valueOption\": {}\r\n  }\r\n]",
//             "ListProp": [
//                 {
//                     "Id": 30002,
//                     "Desc": "فرم پیشرفته",
//                     "Config": "{\n  \"addEndpoint\": \"api/com/insert/person\",\n  \"updateEndpoint\": \"api/com/update/person\",\n  \"deleteEndpoint\": \"api/com/delete/person\",\n  \"formIdField\": \"PersonId\",\n  \"repoViewId\" : 30044,\n  \"fields\": [\n    {\n      \"name\": \"PersonType\",\n      \"caption\": \"نوع\",\n      \"help\": \"این فیلد برای انتخاب نوع شخص می باشد\",\n      \"type\": \"radio\",\n      \"radioValues\": [\n        {\n          \"caption\": \"حقوقی\",\n          \"value\": 1\n        },\n        {\n          \"caption\": \"حقیقی\",\n          \"value\": 2\n        },\n        {\n          \"caption\": \"اتباع\",\n          \"value\": 3\n        },\n        {\n          \"caption\": \"مشارکت مدنی\",\n          \"value\": 4\n        }\n      ],\n      \"rules\": [],\n      \"placeHolder\": \"\",\n      \"order\": 1\n    },\n    {\n      \"name\": \"noShow\",\n      \"caption\": \" \",\n      \"type\": \"noShow\",\n      \"placeHolder\": \"\",\n      \"order\": 2\n    },\n\t{\n      \"name\": \"Sex\",\n      \"caption\": \"جنسیت\",\n      \"help\": \"این فیلد برای انتخاب جنسیت می باشد\",\n      \"type\": \"radio\",\n      \"radioValues\": [\n        {\n          \"caption\": \"مرد\",\n          \"value\": false\n        },\n        {\n          \"caption\": \"زن\",\n          \"value\": true\n        }\n      ],\n      \"rules\": [],\n      \"placeHolder\": \"\",\n      \"order\": 3\n    },\n    {\n      \"name\": \"DisplayName\",\n      \"caption\": \"نام نمایشی\",\n      \"help\": \"این فیلد برای وارد کردن نام نمایشی می باشد\",\n      \"type\": \"text\",\n      \"rules\": [\n        {\n          \"rule\": \"required\",\n          \"condition\": null,\n          \"message\": \"این فیلدالزامی می باشد\"\n        }\n      ],\n      \"placeHolder\": \"\",\n      \"order\": 4\n    },\n    {\n      \"name\": \"FirstName\",\n      \"caption\": \"نام /نام شرکت\",\n      \"help\": \"این فیلد برای وارد کردن نام می باشد\",\n      \"type\": \"text\",\n      \"rules\": [\n\t  {\n          \"rule\": \"required\",\n          \"condition\": null,\n          \"message\": \"این فیلدالزامی می باشد\"\n        }\n\t  ],\n      \"placeHolder\": \"\",\n      \"order\": 5\n    },\n    {\n      \"name\": \"LastName\",\n      \"caption\": \"نام خانوادگی\",\n      \"help\": \"این فیلد برای وارد کردن نام خانوادگی می باشد\",\n      \"type\": \"text\",\n      \"rules\": [],\n      \"placeHolder\": \"\",\n      \"order\": 6\n    },\n    {\n      \"name\": \"NationalCode\",\n      \"caption\": \"کد ملی /شناسه شرکت\",\n      \"help\": \"این فیلد برای وارد کردن کد ملی می باشد\",\n      \"type\": \"text\",\n      \"rules\": \t  [],\n      \"placeHolder\": \"\",\n      \"order\": 7\n    },\n    {\n      \"name\": \"BirthDate\",\n      \"caption\": \"تاریخ تولد\",\n      \"help\": \"این فیلد برای وارد کردن تاریخ تولد می باشد\",\n      \"type\": \"date\",\n      \"rules\": \t  [],\n      \"placeHolder\": \"\",\n      \"order\": 8\n    },\n    {\n      \"name\": \"BirthLocationId\",\n      \"caption\": \"محل تولد\",\n      \"help\": \"این فیلد برای انتخاب کردن محل تولد می باشد\",\n      \"type\": \"treeOption\",\n      \"rules\": \t  [],\n\t  \"selectEndpoint\": {\r\n                \"endpoint\": \"api/com/Select/Location4selectoption\",\r\n\t\t\t\t\"repoViewId\": 30040,\r\n                \"addAppUrl\": \"string\",\r\n                \"addWebUrl\": \"string\"\r\n            },\n      \"placeHolder\": \"\",\n      \"order\": 9\n    },\n    {\n      \"name\": \"ForeignLocationId\",\n      \"caption\": \"کشور\",\n      \"help\": \"این فیلد برای انتخاب کردن کشور می باشد\",\n      \"type\": \"selectOption\",\n      \"rules\": \t  [],\n\t  \"selectEndpoint\": {\r\n                \"endpoint\": \"api/com/Select/Location4Foreign\",\r\n\t\t\t\t\"repoViewId\": 30099,\r\n                \"addAppUrl\": \"string\",\r\n                \"addWebUrl\": \"string\"\r\n            },\n      \"placeHolder\": \"\",\n      \"order\": 10\n    },\n    {\n      \"name\": \"EconomicCode\",\n      \"caption\": \"شماره اقتصادی\",\n      \"help\": \"این فیلد برای وارد کردن شماره اقتصادی می باشد\",\n      \"type\": \"text\",\n      \"rules\": [],\n      \"placeHolder\": \"\",\n      \"order\": 11\n    },\n    {\n      \"name\": \"PassportNumber\",\n      \"caption\": \"شماره پاسپورت\",\n      \"help\": \"این فیلد برای وارد کردن شماره پاسپورت می باشد\",\n      \"type\": \"text\",\n      \"rules\": [],\n      \"placeHolder\": \"\",\n      \"order\": 12\n    }\n  ]\n}",
//                     "Type": 1
//                 },
//                 {
//                     "Id": 30003,
//                     "Desc": "فرم ساده",
//                     "Config": "{\r\n  \"addEndpoint\": \"api/com/insert/person\",\r\n  \"updateEndpoint\": \"api/com/update/person\",\r\n  \"deleteEndpoint\": \"api/com/delete/person\",\r\n  \"repoViewId\" : 30044,\r\n  \"fields\": [\r\n    {\r\n      \"name\": \"LastName\",\r\n      \"caption\": \"نام خانوادگی\",\r\n      \"help\": \"این فیلد برای وارد کردن نام خانوادگی می باشد\",\r\n      \"type\": \"text\",\r\n      \"rules\": [],\r\n      \"selectEndpoint\": {},\r\n      \"placeHolder\": \"\",\r\n      \"order\": 2\r\n    },\r\n    {\r\n      \"name\": \"FirstName\",\r\n      \"caption\": \"نام\",\r\n      \"help\": \"این فیلد برای وارد کردن نام  می باشد\",\r\n      \"type\": \"text\",\r\n      \"rules\": [],\r\n      \"selectEndpoint\": {},\r\n      \"placeHolder\": \"\",\r\n      \"order\": 1\r\n    },\r\n     {\r\n      \"name\": \"HasBookMark\",\r\n      \"caption\": \"نشان شده\",\r\n      \"help\": \"\",\r\n      \"type\": \"info\",\r\n      \"rules\": [\r\n       \r\n      ],\r\n      \"selectEndpoint\": {},\r\n      \"radioValues\": [\r\n      \r\n      ], \r\n      \"placeHolder\": \"\",\r\n      \"order\": 5000\r\n    },\r\n    {\r\n      \"name\": \"DisplayName\",\r\n      \"caption\": \"نام نمایشی\",\r\n      \"help\": \"این فیلد برای وارد کردن نام نمایشی می باشد\",\r\n      \"type\": \"text\",\r\n      \"rules\": [],\r\n      \"selectEndpoint\": {},\r\n      \"placeHolder\": \"\",\r\n      \"order\": 3\r\n    }\r\n\r\n  ]\r\n}  ",
//                     "Type": 1
//                 }
//             ]
//         },
//         "ReportPosition": [
//             {
//                 "Id": 6,
//                 "ReportId": 3,
//                 "FromViewId": 30002,
//                 "FormViewName": "ایست 2",
//                 "Type": 1
//             }
//         ]
//     },
//     "Result": true,
//     "StatusCode": "Success"
// }
//
//
//
//   ''';
//
//             print('📏 طول JSON ارسالی: ${jsonString.length}');
//             print('🔍 نمونه JSON: ${jsonString.substring(0, 200)}...');
//
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                 builder: (context) => DynamicFormGenerator(
//                   jsonString: jsonString,
//                   onSubmit: (values) {
//                     print('📋 فرم ثبت شد: $values');
//                   },
//                   initialValues: {},
//                 ),
//               ),
//             );
//           },



          onTap: () async {
            await NavigatorAgent().navigatorAssist.to(
              ((item.appLink ?? item.webLink) ?? '/notFound'),
            );





          },
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
