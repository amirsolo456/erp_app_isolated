import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:micro_app_core/services/custom_event_bus/custom_event_bus.dart';
import 'package:micro_app_core/services/routing/routes.dart';
import 'package:services_package/auth/menu/menu_service.dart';
import 'package:services_package/storage/domain/usecases/storage_service.dart';
import 'package:shared_core/data/auth/menu/request.dart' as prefix0;
import 'package:shared_core/data/auth/menu/response.dart' as prefix0;
import 'package:ui_components_package/navigator.dart';

import '../../../../core/network/injection_container.dart';
import 'menu_event.dart';
import 'menu_state.dart';

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  final MenuService getMenuUseCase;

  MenuBloc({required this.getMenuUseCase}) : super(const MenuInitial()) {
    on<LoadMenuEvent>(_onLoadMenu);
    on<MenuTokenNeedEvent>(_onMenuNeedToken);
  }

  Future<void> _onLoadMenu(LoadMenuEvent event, Emitter<MenuState> emit) async {
    emit(const MenuLoadingState());
    try {
      final menus = await getMenuUseCase.get(
        prefix0.Request(menuType: 1),
        (json) => prefix0.Response.fromJson(json),
      );

      if (menus == null || menus.data == null) {
        emit(MenuErrorState('Menu Is Null'));
        return;
      }
      if (menus.status == null ||
          menus.status == HttpStatus.unauthorized ||
          menus.status == HttpStatus.internalServerError) {
        CustomEventBus.emit(
          RouteEvents.loginEvents.loginModuleUserLoggedOutEvent(),
        );
        // emit(MenuTokenNeedState());
        return;
      }

      emit(MenuLoadedState(menus.data ?? []));
    } catch (e) {
      emit(MenuErrorState(e.toString()));
    }
  }

  Future<void> _onMenuNeedToken(
    MenuTokenNeedEvent event,
    Emitter<MenuState> emit,
  ) async {
    emit(const MenuLoadingState());
    try {
      var storage = sl<StorageService>();
      await storage.signOut();
      await NavigatorAgent().navigatorAssist.to('/signOut');
    } catch (e) {
      emit(MenuErrorState(e.toString()));
    }
  }
}
