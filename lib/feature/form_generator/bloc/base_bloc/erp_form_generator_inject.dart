import 'package:erp_app/core/network/injection_container.dart';
import 'package:services_package/api_client_service.dart';
import 'package:services_package/auth/toolbar/toolbar_service.dart';

class Inject {
  static void initialize() {
    if( !sl.isRegistered<ToolbarService>()){
      sl.registerLazySingleton<ToolbarService>(() => ToolbarService(sl<ApiClient>()));
    }
  }
}
