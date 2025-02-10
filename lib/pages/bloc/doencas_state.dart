part of 'doencas_bloc.dart';

@immutable
sealed class DoencasState {}

final class DoencasInitial extends DoencasState {}

final class DoencasLoading extends DoencasState {}

class DoencasLoaded extends DoencasState {
  final List<DoencaModel> doencas;
  final List<RacasModel> racasCat;
  final List<RacasModel> racasDog;
  final int page;
  final int totalItems;
  final int totalPage;

  DoencasLoaded(this.doencas, this.racasCat, this.racasDog, this.page, this.totalItems, {this.totalPage = 1});
}

final class DoencasError extends DoencasState {
  final String message;

  DoencasError(this.message);
}

final class DoencasRacas extends DoencasState {
  final List<RacasModel> racasCat;
  final List<RacasModel> racasDog;
  DoencasRacas({
    required this.racasCat,
    required this.racasDog,
  });

  
}

final class DoencasTracos extends DoencasState {
  final List<TracosModel> tracos;
  DoencasTracos({
    required this.tracos,
  });

  
}
