// import 'package:erp_app/components/mainlayout/main_layout.dart';
// import 'package:erp_app/feature/person/presentation/features/person_list_page.dart';
// import 'package:flutter/material.dart';
// import 'package:models_package/Base/enums.dart';
// import 'package:navigation_builder/navigation_builder.dart';
// import 'package:ui_components_package/erp_app_componenets/mobile/Components/erp_appbar.dart';
// import 'package:ui_components_package/erp_app_componenets/mobile/Components/erp_not_found.dart';
//
// final erpNavigator = NavigationBuilder.create(
//
//   routes: {
//     '/': (RouteData data) => const MainLayoutPage(tab:NavButtonTabBarMode.erpDashboardTabMode ,),
//     '/:erpMenuTabBarId': (RouteData data) {
//       final id = data.pathParams['erpMenuTabBarId'];  // دسترسی به پارامترها
//       NavButtonTabBarMode tab = NavButtonTabBarMode.values.firstWhere(
//             (e) => e.value == id,
//         orElse: () => NavButtonTabBarMode.erpNotFound,  // اگر پیدا نشد، erpNotFound
//       );
//       return MainLayoutPage(tab: tab);
//     },
//     '/Com/PersonList':(RouteData data){
//       return PersonListPage(refreshData: true);
//     },
//     '/notFound' : (RouteData data){
//       return ErpNotFound();
//     },
//
//     // '/page2/:id': (RouteData data) {
//     //
//     //   final id = data.pathParams['id']; // دسترسی به پارامترها
//     //   return MainLayoutPage();
//     // },
//     // '/page3/(all|popular|favorite)': (RouteData data) {
//     //
//     //   final kind = data.pathParams['0']; // گروه regex
//     //   return MainLayoutPage();
//     // },
//     '/home/*': (RouteData data) => data.redirectTo('/'),
//     // wildcard برای همه زیرمسیرها
//     '/page6': (RouteData data) => RouteWidget(
//       // مسیر تو در تو (nested)
//       // builder: (routerOutlet) => MyParentWidget(child: routerOutlet),  // ویجت والد
//
//     ),
//   },
//
//   // // کال‌بک اختیاری برای redirection جهانی
//   // onNavigate: (RouteData data) {
//   //   if (data.location == '/home' && !userSignedIn) {  // مثلاً اگر کاربر لاگین نکرده
//   //     return data.redirectTo('/signIn');  // تغییر مسیر بده
//   //   }
//   // },
//   //
//   // // کال‌بک برای جلوگیری از back
//   // onNavigateBack: (RouteData data) {
//   //   if (data?.location == '/form' && formIsDirty) {  // اگر فرم تغییر کرده
//   //     // مثلاً دیالوگ نشون بده و false برگردون تا back کنسل بشه
//   //     return false;
//   //   }
//   // },
//
//   // تنظیمات اختیاری
//   initialLocation: '/',
//   // مسیر اولیه (پیش‌فرض '/')
//   unknownRoute: (route) => Scaffold(appBar: AppBar(), body: SizedBox()),
//   // صفحه برای مسیر نامعلوم
//   builder: (Widget outlet) => Scaffold(
//     appBar: ErpAppBar(mode: AppBarsMode.erpNotFound),
//     body: outlet,
//   ),
//   transitionsBuilder:
//       (context, anim, secAnim, child) => // انیمیشن جهانی
//           FadeTransition(opacity: anim, child: child),
//   transitionDuration: const Duration(milliseconds: 1000),
//   debugPrintWhenRouted: true, // لاگ برای دیباگ
// );
