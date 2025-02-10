import 'dart:convert';

class RacasModel {
  String Nome;
  RacasModel({
    required this.Nome,
  });

  Map<String, dynamic> toMap() {
    return {
      'Nome': Nome,
    };
  }

  factory RacasModel.fromMap(Map<String, dynamic> map) {
    return RacasModel(
      Nome: map['Name'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory RacasModel.fromJson(String source) => RacasModel.fromMap(json.decode(source));
}
