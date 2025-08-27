class BiographyModel {
  final String id;
  final String birth;
  final String death;
  final String biography;

  BiographyModel({
    required this.id,
    required this.birth,
    required this.death,
    required this.biography,
  });

  factory BiographyModel.fromJson(Map<String, dynamic> json) {
    return BiographyModel(
      id: json['id'],
      birth: json['birth'],
      death: json['death'],
      biography: json['biography'],
    );
  }
}
