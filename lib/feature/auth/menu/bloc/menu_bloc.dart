import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:micro_app_core/services/custom_event_bus/custom_event_bus.dart';
import 'package:micro_app_core/services/routing/routes.dart';
import 'package:models_package/base/api_settings.dart';
import 'package:services_package/auth/menu/menu_service.dart';
import 'package:shared_core/data/auth/menu/request.dart';
import 'package:shared_core/data/auth/menu/response.dart';

import '../../../../core/network/injection_container.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final Function onErrorEven;
  final MenuService getMenuUseCase;

  MenuBloc({required this.getMenuUseCase, required this.onErrorEven})
      : super(const MenuInitial()) {
    print('[MenuBloc] constructor called, initial state = MenuInitial');
    on<LoadMenuEvent>(_onLoadMenu);
    on<MenuTokenNeedEvent>(_onMenuNeedToken);
  }

  Future<void> _onLoadMenu(LoadMenuEvent event, Emitter<MenuState> emit) async {
    print('[MenuBloc] LoadMenuEvent received');

    emit(const MenuLoadingState());
    print('[MenuBloc] state -> MenuLoadingState');

    try {
      print('[MenuBloc] calling getMenuUseCase.get');
      final menus = await getMenuUseCase.get(
        Request(menuType: 1, defaults: sl<ApiSettings>().appDefaults),
            (json) => Response.fromJson(json),
      );

      print('[MenuBloc] response received: $menus');

      if (menus == null) {
        print('[MenuBloc][ERROR] menus is null');
        emit(MenuErrorState('Menu Is Null'));
        return;
      }

      if (menus.data == null) {
        print('[MenuBloc][ERROR] menus.data is null');
        emit(MenuErrorState('Menu Data Is Null'));
        CustomEventBus.emit(
          RouteEvents.loginEvents.loginModuleUserLoggedOutEvent(),
        );
        return;
      }

      if (menus.status != null && menus.status == HttpStatus.unauthorized) {
        print('[MenuBloc][AUTH] unauthorized -> emitting logout event');
        CustomEventBus.emit(
          RouteEvents.loginEvents.loginModuleUserLoggedOutEvent(),
        );
        return;
      }

      print('[MenuBloc] success -> emitting MenuLoadedState, itemCount = ${menus.data!.length}');
      emit(MenuLoadedState(menus.data ?? []));
    } catch (e, s) {
      print('[MenuBloc][EXCEPTION] $e');
      print('[MenuBloc][STACKTRACE] $s');
      emit(MenuErrorState(e.toString()));
    }
  }

  Future<void> _onMenuNeedToken(
      MenuTokenNeedEvent event,
      Emitter<MenuState> emit,
      ) async {
    print('[MenuBloc] MenuTokenNeedEvent received');

    emit(const MenuLoadingState());
    print('[MenuBloc] state -> MenuLoadingState (token need)');

    try {
      print('[MenuBloc] resolving StorageService from DI');
      // var storage = sl<StorageService>();
      //
      // print('[MenuBloc] calling storage.signOut()');
      // await storage.signOut();
      //
      // print('[MenuBloc] navigation -> /signOut');
      final menus = await getMenuUseCase.get(
        Request(menuType: 1, defaults: sl<ApiSettings>().appDefaults),
            (json) => Response.fromJson(json),
      );

      print('[MenuBloc] response received: $menus');

      if (menus == null) {
        print('[MenuBloc][ERROR] menus is null');
        emit(MenuErrorState('Menu Is Null'));
        return;
      }

      if (menus.data == null) {
        print('[MenuBloc][ERROR] menus.data is null');
        emit(MenuErrorState('Menu Data Is Null'));
        return;
      }

      if (menus.status != null && menus.status == HttpStatus.unauthorized) {
        print('[MenuBloc][AUTH] unauthorized -> emitting logout event');
        CustomEventBus.emit(
          RouteEvents.loginEvents.loginModuleUserLoggedOutEvent(),
        );
        return;
      }

      print('[MenuBloc] success -> emitting MenuLoadedState, itemCount = ${menus.data!.length}');
      emit(MenuLoadedState(menus.data ?? []));
      // await NavigatorAgent().navigatorAssist.to('/signOut');
    } catch (e, s) {
      print('[MenuBloc][EXCEPTION] $e');
      print('[MenuBloc][STACKTRACE] $s');
      emit(MenuErrorState(e.toString()));
    }
  }
}
