class GenderModel {
  final int id;
  final String gender;

  GenderModel({
    required this.id,
    required this.gender,
  });

  factory GenderModel.fromJson(Map map) => GenderModel.toMap(map);

  factory GenderModel.toMap(Map map) => GenderModel(
        id: map["id"],
        gender: map["gender"],
      );
}
