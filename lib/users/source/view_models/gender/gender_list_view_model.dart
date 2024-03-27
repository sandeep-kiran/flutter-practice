import 'package:first_app/users/source/services/gender/gender_service.dart';
import 'package:first_app/users/source/view_models/gender/gender_view_model.dart';
import 'package:flutter/material.dart';

class GenderListViewModel extends ChangeNotifier {
  List<GenderViewModel> gender = [];

  Future<void> fetchGender() async {
    final result = await GenderService().fetchGender();
    gender = result.map((e) => GenderViewModel(gender: e)).toList();
    notifyListeners();
  }
}
