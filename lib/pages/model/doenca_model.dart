// ignore_for_file: collection_methods_unrelated_type

import 'dart:convert';

// ignore_for_file: non_constant_identifier_names

class DoencaModel {
    String marcador;
  String especie;
  String categoria;
  String doenca;
  String gene;
  String variante;
  String cromossomo;
  String heranca;
  String sobre_doenca;
  String manifesta;
  String recomendacoes;
  String referencias;
  String racas;
  DoencaModel({
    required this.marcador,
    required this.especie,
    required this.categoria,
    required this.doenca,
    required this.gene,
    required this.variante,
    required this.cromossomo,
    required this.heranca,
    required this.sobre_doenca,
    required this.manifesta,
    required this.recomendacoes,
    required this.referencias,
    required this.racas,
  });

  Map<String, dynamic> toMap() {
    return {
      'marcador': marcador,
      'especie': especie,
      'categoria': categoria,
      'doenca': doenca,
      'gene': gene,
      'variante': variante,
      'cromossomo': cromossomo,
      'heranca': heranca,
      'sobre_doenca': sobre_doenca,
      'manifesta': manifesta,
      'recomendacoes': recomendacoes,
      'referencias': referencias,
      'racas': racas,
    };
  }

    factory DoencaModel.fromMap( map) {
    

    return DoencaModel(
      categoria: map['Categoria']?? '',
      doenca: map['Doença']?? '',
      gene: map['Gene']?? '',
      variante:  map['Variante']?? '',
      cromossomo: map['Cromossomo']?? '',
      heranca: map['Herança']?? '',
      sobre_doenca: map['Sobre a Doença']?? '',
      manifesta: map['Manifestações']?? '',
      recomendacoes: map['Recomendações']?? '',
      racas: map['Raças']?? '',
      referencias: map['Referências']?? '',
      marcador: map['Marcador']?? '',
      especie: map['Espécie']?? '',
    );
  }
  String toJson() => json.encode(toMap());

  factory DoencaModel.fromJson(String source) => DoencaModel.fromMap(json.decode(source));
}
