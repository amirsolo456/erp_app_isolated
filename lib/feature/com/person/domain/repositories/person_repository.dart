import 'package:shared_core/data/com/person/response.dart' as prefix0;
import 'package:shared_core/data/com/person/response_data.dart' as prefix0;
import 'package:shared_core/data/com/person/request.dart' as prefix0;

class PersonRepository {
  Future<prefix0.Response> getAllUsers() async {
    await Future.delayed(const Duration(seconds: 2));
    return prefix0.Response(
      personData: [prefix0.ResponseData(displayName: '', birthDate: 'sfaf')],
    );
  }

  Future<prefix0.Response> searchUsers(prefix0.Request params) async {
    return await getAllUsers();
  }
}
