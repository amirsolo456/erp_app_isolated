import 'package:services_package/com/person/person_service.dart';
import 'package:shared_core/data/com/person/request.dart' as prefix0;
import 'package:shared_core/data/com/person/response.dart' as prefix0;

class PersonServiceDataSource extends PersonService {
  PersonServiceDataSource(super.apiClient);

  Future<prefix0.Response?> getAllPersons() async {
    return await super.get(
      prefix0.Request(repoViewId: 1),
      (json) => prefix0.Response.fromJson(json),
    );
  }
}
