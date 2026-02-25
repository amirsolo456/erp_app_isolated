import 'package:micro_app_core/index.dart';
import 'package:micro_app_core/services/routing/route_events.dart';

/// * Micro App Events
/// Register the micro app events here
/// so we provide them in [RouteEvents] to be fired from accross the micro apps.
/// The [initRouteListeners] method above will listen to the events listened here.
///

class ErpShownEvent extends RouteEvent {}

class ErpCloseEvent extends RouteEvent {}
class ErpUserInfoEvent extends RouteEvent {}

class ErpFormGeneratorEvent extends RouteEvent {
  final int repoId;
  final int systemId;
  final int type;

  ErpFormGeneratorEvent(this.repoId, this.systemId, this.type);
}

class ErpListGeneratorEvent extends RouteEvent {
  final int repoId;
  final int systemId;
  final int type;

  ErpListGeneratorEvent(this.repoId, this.systemId, this.type);
}

///
/// Exports the events in a class so we dont need to import
/// them from other micro apps. SignInEvents will be used by [RouteEvents]
///
class ErpCustomEvents extends RouteEvent {
  RouteEvent erpShownEvent = ErpShownEvent();
  RouteEvent erpCloseEvent = ErpCloseEvent();
}

class ErpEvents {
  static ErpShownEvent shown() => ErpShownEvent();

  static ErpFormGeneratorEvent erpFormGeneratorEvent(
    int repo,
    int sys,
    int type,
  ) => ErpFormGeneratorEvent(repo, sys, type);

  static ErpListGeneratorEvent erpListGeneratorEvent(
    int repo,
    int sys,
    int type,
  ) => ErpListGeneratorEvent(repo, sys, type);
  static  ErpUserInfoEvent erpUserInfoEvent() => ErpUserInfoEvent();

  static ErpCloseEvent close() => ErpCloseEvent();

  static OpenErpModuleEvent openModule({
    required ErpAppsCoreEnum module,
    dynamic payload,
  }) {
    return OpenErpModuleEvent(module: module, payload: payload);
  }
}

class OpenErpModuleEvent extends RouteEvent {
  final ErpAppsCoreEnum module;
  final dynamic payload;

  OpenErpModuleEvent({required this.module, this.payload});
}
