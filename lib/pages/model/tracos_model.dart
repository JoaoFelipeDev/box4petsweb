import 'dart:convert';


class TracosModel {
  String marcador;
  String categoria;
  String gene;
  String traco;
  String cromossomo;
  String sobre_traco;
  String variante;
  String racas;
  String referencias;
  String especie;
  TracosModel({
    required this.marcador,
    required this.categoria,
    required this.gene,
    required this.traco,
    required this.cromossomo,
    required this.sobre_traco,
    required this.variante,
    required this.racas,
    required this.referencias,
    required this.especie,
  });

  

  Map<String, dynamic> toMap() {
    return {
      'marcador': marcador,
      'categoria': categoria,
      'gene': gene,
      'traco': traco,
      'cromossomo': cromossomo,
      'sobre_traco': sobre_traco,
      'variante': variante,
      'racas': racas,
      'referencias': referencias,
      'especie': especie,
    };
  }

  factory TracosModel.fromMap(Map<String, dynamic> map) {
    return TracosModel(
      marcador: map ['Marcador'] ?? '',
      categoria: map ['Categoria'] ?? '',
      gene: map ['Gene1'] ?? '',
      traco: map ['Traço'] ?? '',
      cromossomo: map ['Cromossomo'] ?? '',
      sobre_traco: map ['Sobre o Traço'] ?? '',
      variante: map ['Variante'] ?? '',
      racas: map ['Raças'] ?? '',
      referencias: map ['Referências'] ?? '',
      especie: map ['Espécie'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TracosModel.fromJson(String source) => TracosModel.fromMap(json.decode(source));
}
