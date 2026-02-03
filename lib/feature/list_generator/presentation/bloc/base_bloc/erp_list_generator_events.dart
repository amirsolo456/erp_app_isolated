import 'package:erp_app/micro_app/erp_events.dart';
import 'package:micro_app_core/services/routing/route_events.dart';

/// * Micro App Events
/// Register the micro app events here
/// so we provide them in [RouteEvents] to be fired from accross the micro apps.
/// The [initRouteListeners] method above will listen to the events listened here.
///

class ErpListGeneratorShownEvent extends ErpCustomEvents {}

class StartLoadingAction extends ErpCustomEvents {}

class EndLoadingAction extends ErpCustomEvents {}

///
/// Exports the events in a class so we dont need to import
/// them from other micro apps. SignInEvents will be used by [RouteEvents]
///
class ErpListGeneratorEvents extends ErpCustomEvents {
  RouteEvent erpListGeneratorShownEvent = ErpListGeneratorShownEvent();
}
