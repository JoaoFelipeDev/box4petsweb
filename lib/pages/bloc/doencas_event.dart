part of 'doencas_bloc.dart';

@immutable
sealed class DoencasEvent {}

class GetDoencasEvent extends DoencasEvent {
  final String type;
  final int page; // Nova página

  GetDoencasEvent(this.type, {this.page = 1});
}

class GetDoencasByCategoryEvent extends DoencasEvent {
  final String type;
  String categories;
  int page;

  GetDoencasByCategoryEvent({
    required this.type,
    required this.categories,
    this.page = 1
  });
}
class GetDoencasByRacasEvent extends DoencasEvent {
  final String type;
  String racas;
  int page;

  GetDoencasByRacasEvent({
    required this.type,
    required this.racas,
    this.page = 1
  });
}

class GetDoencasByNameEvent extends DoencasEvent {
  final String type;
  final String name;
  int page;
  GetDoencasByNameEvent({
    required this.type,
    required this.name,
    this.page = 1
  });
}

class GetRacas extends DoencasEvent {
  final String type;
  final String name;
  int page;
  GetRacas(
    this.type,
    this.page,
    this.name,
  );
}

class GetTracos extends DoencasEvent {
  final String categoria;
  final String type;
  GetTracos(
    this.categoria,
    this.type,
  );
}

