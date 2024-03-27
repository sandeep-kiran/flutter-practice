import 'package:first_app/users/source/model/gender_model.dart';

class GenderViewModel {
  final GenderModel gender;

  GenderViewModel({required this.gender});

  String get name {
    return gender.gender;
  }
}
