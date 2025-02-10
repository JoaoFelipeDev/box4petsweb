

// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:box4pets_web/pages/model/doenca_model.dart';
import 'package:box4pets_web/pages/model/racas_model.dart';
import 'package:box4pets_web/pages/model/tracos_model.dart';
import 'package:box4pets_web/pages/repositories/repository.dart';
import 'package:dart_airtable/dart_airtable.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart';

part 'doencas_event.dart';
part 'doencas_state.dart';

class DoencasBloc extends Bloc<DoencasEvent, DoencasState> {
  final _repository = Repository();
  int itemsPerPage = 12; // Número de itens por página

  DoencasBloc() : super(DoencasInitial()) {
    on<DoencasEvent>((event, emit) async {
      emit(DoencasLoading());

      ByteData conteudo_cachorro = await rootBundle.load('assets/json/data_racas_cao.json');
      ByteData conteudo_gato = await rootBundle.load('assets/json/data_raca_gato.json');
      List<dynamic> list_cachorro = json.decode(Utf8Decoder().convert(conteudo_cachorro.buffer.asUint8List()));
      List<dynamic> list_gato = json.decode(Utf8Decoder().convert(conteudo_gato.buffer.asUint8List()));
      
      List<RacasModel> racasDog = list_cachorro.map((e) => RacasModel.fromMap(e)).toList();
      racasDog.sort((RacasModel a, RacasModel b) => a.Nome.compareTo(b.Nome));
      
      List<RacasModel> racasCat = list_gato.map((e) => RacasModel.fromMap(e)).toList();
      racasCat.sort((RacasModel a, RacasModel b) => a.Nome.compareTo(b.Nome));

      if (event is GetDoencasEvent) {
        await _getDoencas(event, emit, racasDog, racasCat);
      } else if (event is GetDoencasByRacasEvent) {
        await _getDoencasByRacas(event, emit, racasDog, racasCat);
      } else if (event is GetDoencasByCategoryEvent) {
        await _getDoencasByCategory(event, emit, racasDog, racasCat);
      } else if (event is GetDoencasByNameEvent) {
        await _getDoencasByName(event, emit, racasDog, racasCat);
      }else if(event is GetTracos){
        Map<String, dynamic> tracoMap = {};
        List<Map<String, dynamic>> tracosMaps = [];
        final List<AirtableRecord> response = await _repository.getTracos(event.categoria, event.type);
        for (var item in response) {
          for (var field in item.fields) {
            tracoMap[field.fieldName] = field.value;
          }
          tracosMaps.add(tracoMap);
          tracoMap = {};
        }
        List<TracosModel> tracos = tracosMaps.map((record) => TracosModel.fromMap(record)).toList();
        print('tracos: ${tracos.length}');
        emit(DoencasTracos(tracos: tracos));
      }else if(event is GetRacas){
        emit(DoencasLoading());
        
        await _getRacas(event, emit, racasDog, racasCat);
      }
    });
  }

  Future<void> _getRacas(GetRacas event, Emitter<DoencasState> emit, List<RacasModel> racasDog, List<RacasModel> racasCat) async {

    try {
      int count = 0;
      int page = event.page ?? 1;
      int offset = (page - 1) * itemsPerPage;
      Map<String, dynamic> racasMap = {};
      List<Map<String, dynamic>> racasMaps = [];
      List<String> doencasRacas = [];
      Map<String, dynamic> doencasMap = {};
      List<Map<String, dynamic>> doencasMaps = [];
      final List<AirtableRecord> response = await _repository.getRacas(event.type, event.name);
      for (var item in response) {
        for (var field in item.fields) {
          racasMap[field.fieldName] = field.value;
        }
         
        var marcador = racasMap['Lista de Doenças'];
  if (marcador is List) {
    print('marcador: $marcador');
    // Se for uma lista, adicione cada item da lista à lista de doenças
    doencasRacas.addAll(marcador.map((e) => e.toString()));
  } else if (marcador is String) {
    // Se for uma string, adicione diretamente à lista de doenças
    doencasRacas.add(marcador);
  }
      }
      
    for (var element in doencasRacas) {
      print('doencas: $element');
      final AirtableRecord response = await _repository.getDoencasById(element,event.type);
      for (var field in response.fields) {
        doencasMap[field.fieldName] = field.value;
      }
      doencasMaps.add(doencasMap);
    }
    print('doencasMaps: ${doencasMaps.length}');
    List<DoencaModel> allDoencas = doencasMaps
          .where((record) => record.isNotEmpty && record['Categoria'] != 'Nenhuma Variante Identificada'  )
          .map((record) => DoencaModel.fromMap(record))
          .toList();
      // Paginação manual
      List<DoencaModel> doencas = allDoencas.skip(offset).take(itemsPerPage).toList();
      emit(DoencasLoaded(doencas, racasCat, racasDog, page, allDoencas.length, totalPage: (allDoencas.length / 12).ceil()));
      

    } catch (e) {
      print(e.toString());
      emit(DoencasError(e.toString()));
    }
  }

  Future<void> _getDoencas(
      GetDoencasEvent event, Emitter<DoencasState> emit, List<RacasModel> racasDog, List<RacasModel> racasCat) async {
    try {
      int count = 0;
      int page = event.page ?? 1;
      int offset = (page - 1) * itemsPerPage;
      Map<String, dynamic> doencasMap = {};
      List<Map<String, dynamic>> doencasMaps = [];

      final List<AirtableRecord> response = await _repository.getRecords(event.type);
      for (var item in response) {
        for (var field in item.fields) {
          
          doencasMap[field.fieldName] = field.value;
        }
        doencasMaps.add(doencasMap);
        doencasMap = {};
      }
      List<DoencaModel> allDoencas = doencasMaps
          .where((record) => record.isNotEmpty && record['Categoria'] != 'Nenhuma Variante Identificada'  )
          .map((record) => DoencaModel.fromMap(record))
          .toList();

      // Paginação manual
      List<DoencaModel> doencas = allDoencas.skip(offset).take(itemsPerPage).toList();

      emit(DoencasLoaded(doencas, racasCat, racasDog, page, allDoencas.length, totalPage: (allDoencas.length / 10).ceil()));
    } catch (e) {
      emit(DoencasError(e.toString()));
    }
  }

  Future<void> _getDoencasByRacas(
      GetDoencasByRacasEvent event, Emitter<DoencasState> emit, List<RacasModel> racasDog, List<RacasModel> racasCat) async {
    try {
      int count = 0;
      int page = event.page ?? 1;
      int offset = (page - 1) * itemsPerPage;

      Map<String, dynamic> doencasMap = {};
      List<Map<String, dynamic>> doencasMaps = [];

      final List<AirtableRecord> response = await _repository.getRecordsFilterByFormulaRacas(event.racas,event.type);
      for (var item in response) {
        for (var field in item.fields) {
          
          doencasMap[field.fieldName] = field.value;
        }
        doencasMaps.add(doencasMap);
        doencasMap = {};
      }
      
      List<DoencaModel> allDoencas = doencasMaps
          .where((record) => record.isNotEmpty && record['Categoria'] != 'Nenhuma Variante Identificada'  )
          .map((record) => DoencaModel.fromMap(record))
          .toList();

      // Paginação manual
      List<DoencaModel> doencas = allDoencas.skip(offset).take(itemsPerPage).toList();
      print('doencasMaps: ${doencas.length}');
      print('page $page');
      emit(DoencasLoaded(doencas, racasCat, racasDog, page, allDoencas.length, totalPage: (allDoencas.length / 12).ceil()));
    
    } catch (e) {
      emit(DoencasError(e.toString()));
    }
  }

  Future<void> _getDoencasByCategory(
      GetDoencasByCategoryEvent event, Emitter<DoencasState> emit, List<RacasModel> racasDog, List<RacasModel> racasCat) async {
    try {
      int count = 0;
      int page = event.page ?? 1;
      int offset = (page - 1) * itemsPerPage;
      Map<String, dynamic> doencasMap = {};
      List<Map<String, dynamic>> doencasMaps = [];

      final List<AirtableRecord> response = await _repository.getRecordsFilterByFormulaCat(event.categories,event.type);
      for (var item in response) {
        for (var field in item.fields) {
          
          doencasMap[field.fieldName] = field.value;
        }
        doencasMaps.add(doencasMap);
        doencasMap = {};
      }
      List<DoencaModel> allDoencas = doencasMaps
          .where((record) => record.isNotEmpty && record['Categoria'] != 'Nenhuma Variante Identificada'  )
          .map((record) => DoencaModel.fromMap(record))
          .toList();
     
      print('page $page');
      // Paginação manual
      List<DoencaModel> doencas = allDoencas.skip(offset).take(itemsPerPage).toList();
       print('doencasMaps: ${doencas.length}');
      emit(DoencasLoaded(doencas, racasCat, racasDog, page, allDoencas.length, totalPage: (allDoencas.length / 12).ceil()));
    } catch (e) {
      emit(DoencasError(e.toString()));
    }
  }

  Future<void> _getDoencasByName(
      GetDoencasByNameEvent event, Emitter<DoencasState> emit, List<RacasModel> racasDog, List<RacasModel> racasCat) async {
    try {
      int count = 0;
      int page = event.page ?? 1;
      int offset = (page - 1) * itemsPerPage;
      Map<String, dynamic> doencasMap = {};
      List<Map<String, dynamic>> doencasMaps = [];

      final List<AirtableRecord> response = await _repository.getRecordsFilterByFormulaName(event.name,event.type);
      for (var item in response) {
        for (var field in item.fields) {
          
          doencasMap[field.fieldName] = field.value;
        }
        doencasMaps.add(doencasMap);
        doencasMap = {};
      }
      List<DoencaModel> allDoencas = doencasMaps
          .where((record) => record.isNotEmpty && record['Categoria'] != 'Nenhuma Variante Identificada'  )
          .map((record) => DoencaModel.fromMap(record))
          .toList();
      // Paginação manual
      List<DoencaModel> doencas = allDoencas.skip(offset).take(itemsPerPage).toList();
    
      emit(DoencasLoaded(doencas, racasCat, racasDog, page, allDoencas.length));
    } catch (e) {
      emit(DoencasError(e.toString()));
    }
  }
}
