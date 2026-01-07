import 'package:bloc/bloc.dart';
import 'package:erp_app/feature/default_page/place/bloc/place_event.dart';
import 'package:erp_app/feature/default_page/place/bloc/place_state.dart';
import 'package:services_package/Repo_ViewId/repo_view_id.dart';
import 'package:services_package/default/mng/select/place_service.dart';
import 'package:shared_core/data/default/mng/select/place/request.dart'
    as prefix0;
import 'package:shared_core/data/default/mng/select/place/response.dart'
    as prefix0;
import 'package:shared_core/data/default/mng/select/place/response_data.dart'
    as prefix0;

class PlaceBloc extends Bloc<PlaceEvent, PlaceState> {
  final PlaceService getPlaceUseCase;

  PlaceBloc({required this.getPlaceUseCase}) : super(const PlaceInitial()) {
    on<LoadPlaceEvent>(_onLoadPlace);
  }

  Future<void> _onLoadPlace(
    LoadPlaceEvent event,
    Emitter<PlaceState> emit,
  ) async {
    emit(const PlaceLoading());
    try {
      final places = await getPlaceUseCase.get(
        prefix0.Request(repoViewId: AppConstants().PlaceRepoViewId),
        (json) => prefix0.Response.fromJson(json),
      );

      if (places == null || places.data == null) {
        emit(PlaceError('Place Is Null'));
        return;
      }
      emit(PlaceLoaded(places.data ?? <prefix0.ResponseData>[]));
    } catch (e) {
      emit(PlaceError(e.toString()));
    }
  }
}
