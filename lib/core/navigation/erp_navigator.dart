// // erp_navigator.dart
// import 'package:navigation_builder/navigation_builder.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:models_package/base/base_request.dart';
// import 'package:models_package/base/base_response.dart';
// import 'package:models_package/data/com/person/dto.dart' as person;
// import 'package:redux/redux.dart';
// import 'package:services_package/api_client_service.dart';
// import 'package:get_it/get_it.dart';
// import 'package:provider/provider.dart';
// import '../../components/mainlayout/main_layout.dart';
// import '../../feature/redux/generic_lists/erp_store/actions/generic_list_entity_actions.dart';
// import '../../feature/redux/generic_lists/erp_store/middleware/api_middleware.dart';
// import '../../feature/redux/generic_lists/erp_store/models/generic_list_entity_state.dart';
// import '../../feature/redux/generic_lists/erp_store/reducers/list_reducer.dart';
// import '../../feature/redux/generic_lists/ui/generic_list_page.dart';
// import 'package:ui_components_package/erp_app_componenets/mobile/Components/erp_appbar.dart';
// import 'package:ui_components_package/erp_app_componenets/mobile/Components/erp_not_found.dart';
// import 'package:restart_app/restart_app.dart';
// import 'package:models_package/base/enums.dart';
//
// class ErpNavigator {
//   static final ErpNavigator _instance = ErpNavigator._internal();
//   factory ErpNavigator() => _instance;
//   ErpNavigator._internal();
//
//   final Map<String, RouteWidgetBuilder> _routes = {};
//   final Map<String, Map<String, dynamic>> _routeParams = {};
//   final Map<String, dynamic> _globalParams = {};
//   NavigationBuilder? _navigationBuilder;
//
//   /// اضافه کردن Route جدید
//   void addRoute(String path, RouteWidgetBuilder builder, {Map<String, dynamic>? defaultParams}) {
//     _routes[path] = builder;
//     if (defaultParams != null) {
//       _routeParams[path] = defaultParams;
//     }
//   }
//
//   /// اضافه کردن پارامتر پیش‌فرض برای یک Route
//   void addRouteParams(String path, Map<String, dynamic> params) {
//     _routeParams[path] = {..._routeParams[path] ?? {}, ...params};
//   }
//
//   /// اضافه کردن پارامترهای عمومی برای همه Routeها
//   void addGlobalParams(Map<String, dynamic> params) {
//     _globalParams.addAll(params);
//   }
//
//   /// اضافه کردن Route با پارامترهای داینامیک
//   void addRouteWithParams(
//       String path,
//       Widget Function(RouteData data, Map<String, dynamic> params) builder,
//       {Map<String, dynamic>? defaultParams}
//       ) {
//     addRoute(path, (data) {
//       final allParams = {
//         ..._globalParams,
//         ..._routeParams[path] ?? {},
//         ...defaultParams ?? {},
//         ...data.queryParams,
//         ...data.pathParams,
//       };
//       return builder(data, allParams);
//     }, defaultParams: defaultParams);
//   }
//
//   /// اضافه کردن چندین Route به صورت همزمان
//   void addRoutes(Map<String, RouteWidgetBuilder> routes, {Map<String, Map<String, dynamic>>? params}) {
//     _routes.addAll(routes);
//     if (params != null) {
//       _routeParams.addAll(params);
//     }
//   }
//
//   /// ساخت NavigationBuilder با Routeهای اضافه شده
//   NavigationBuilder build({
//     String initialLocation = '/',
//     UnknownRouteBuilder? unknownRoute,
//     TransitionBuilder? builder,
//     TransitionDelegate? transitionDelegate,
//     Duration? transitionDuration,
//     bool debugPrintWhenRouted = false,
//     Map<String, dynamic>? initialParams,
//   }) {
//     // اضافه کردن Routeهای پیش‌فرض
//     final defaultRoutes = _getDefaultRoutes();
//     _routes.addAll(defaultRoutes);
//
//     _navigationBuilder = NavigationBuilder.create(
//       routes: _routes,
//       initialLocation: initialLocation,
//       unknownRoute: unknownRoute ?? (route) => Scaffold(appBar: AppBar(), body: const SizedBox()),
//       builder: builder ?? (outlet) => Scaffold(
//         appBar: ErpAppBar(mode: AppBarsMode.erpNotFound),
//         body: outlet,
//       ),
//       transitionsBuilder: (context, anim, secAnim, child) =>
//           FadeTransition(opacity: anim, child: child),
//       transitionDuration: transitionDuration ?? const Duration(milliseconds: 1000),
//       debugPrintWhenRouted: debugPrintWhenRouted,
//     );
//
//     return _navigationBuilder!;
//   }
//
//   /// گرفتن NavigationBuilder ساخته شده
//   NavigationBuilder? get navigator => _navigationBuilder;
//
//   /// گرفتن Routeهای ثبت شده
//   Map<String, RouteWidgetBuilder> get routes => Map.unmodifiable(_routes);
//
//   /// گرفتن پارامترهای یک Route خاص
//   Map<String, dynamic>? getRouteParams(String path) => _routeParams[path];
//
//   /// پاک کردن تمام Routeها
//   void clearRoutes() {
//     _routes.clear();
//     _routeParams.clear();
//     _navigationBuilder = null;
//   }
//
//   /// حذف یک Route خاص
//   void removeRoute(String path) {
//     _routes.remove(path);
//     _routeParams.remove(path);
//   }
//
//   // Routeهای پیش‌فرض سیستم
//   Map<String, RouteWidgetBuilder> _getDefaultRoutes() {
//     return {
//       '/signOut': (RouteData data) {
//         Restart.restartApp(
//           notificationTitle: 'Restarting App',
//           notificationBody: 'Please tap here to open the app again.',
//         );
//         return const SizedBox();
//       },
//       '/': (RouteData data) =>
//       const MainLayoutPage(tab: NavButtonTabBarMode.erpDashboardTabMode),
//       '/notFound': (RouteData data) => const ErpNotFound(),
//       '/home/*': (RouteData data) => data.redirectTo('/'),
//       '/:erpMenuTabBarsId': (RouteData data) {
//         final id = data.pathParams['erpMenuTabBarsId'];
//         final tab = NavButtonTabBarMode.values.firstWhere(
//               (e) => e.value == id,
//           orElse: () => NavButtonTabBarMode.erpNotFound,
//         );
//         return MainLayoutPage(tab: tab);
//       },
//     };
//   }
//
//   /// ساخت Route برای لیست entityها
//   static RouteWidgetBuilder createEntityListRoute<T extends BaseResponse<D>, D, C extends BaseRequest>({
//     required C Function() requestFactory,
//     required T Function(Map<String, dynamic>) fromJsonD,
//     required String screenTitle,
//     required Map<String, dynamic> fieldConfigs,
//     bool enableSearch = true,
//     bool enableSorting = true,
//     bool enablePagination = true,
//     Widget Function(D item)? customItemBuilder,
//   }) {
//     return (RouteData data) {
//       final store = _createStore<T, D, C>(
//         requestFactory: requestFactory,
//         fromJsonD: fromJsonD,
//       );
//
//       return StoreProvider(
//         store: store,
//         child: GenericEntityScreen<D>(
//           screenTitle: screenTitle,
//           fieldConfigs: fieldConfigs,
//           enableSearch: enableSearch,
//           enableSorting: enableSorting,
//           enablePagination: enablePagination,
//           customItemBuilder: customItemBuilder,
//         ),
//       );
//     };
//   }
//
//   static Store<ErpStoreState<T, D, C>> _createStore<T extends BaseResponse<D>, D, C extends BaseRequest>({
//     required C Function() requestFactory,
//     required T Function(Map<String, dynamic>) fromJsonD,
//   }) {
//     ErpStoreState<T, D, C> reducer(ErpStoreState<T, D, C> state, dynamic action) {
//       if (action is GenericEntityAction) {
//         return GenericEntityReducer.reduce<T, D, C>(state, action);
//       }
//       return state;
//     }
//
//     final apiClient = GetIt.instance<ApiClient>();
//     final middleware = ErpApiMiddleware<T, D, C>(
//       api: apiClient,
//       requestFactory: requestFactory,
//       fromJsonD: fromJsonD,
//       request: null,
//     );
//
//     return Store<ErpStoreState<T, D, C>>(
//       reducer,
//       initialState: ErpStoreState<T, D, C>(),
//       middleware: [middleware],
//       distinct: true,
//       syncStream: true,
//     );
//   }
// }
