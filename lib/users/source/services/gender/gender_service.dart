import 'package:first_app/users/profile/apis/api_urls.dart';
import 'package:first_app/users/source/model/gender_model.dart';
import 'package:first_app/users/utils/api_class.dart';

class GenderService {
  Future<List<GenderModel>> fetchGender() async {
    ApiClient client = await ApiCall.get(
      apiUrl: getGenderUrl,
      printLog: false,
    );
    if (client.responseStatus == ApiResponseStatus.success) {
      final Iterable gender = client.data["data"];
      return gender.map((e) => GenderModel.fromJson(e)).toList();
    } else {
      return [];
    }
  }
}
