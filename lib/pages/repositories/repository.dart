import 'package:dart_airtable/dart_airtable.dart';

class Repository{
final Airtable airtable = Airtable(apiKey: 'pataR6zyoQBKdPuio.d384b4f08f8ec16215dc856596852cb422946b071fea415f49a9ada1e97548b3', projectBase: 'appFtyAXSYJQ0UhNV');

Future getRecords(String type) async {
  // final response = await airtable.getRecordsFilterByFormula('app_lista_doenca', 'FIND(  "Epilepsia benigna familiar", {fldyCweurxbamF4AN})');
  final response = await airtable.getAllRecords('app_lista_doenca$type', pageSize: 100,);
  return response;
}

Future getDoencasById(String id, String type) async {
  final response = await airtable.getRecord('app_lista_doenca$type', id);
  return response;
}

Future getTracos(String categoria, String type) async{
  String campo = '';
  if(type.isEmpty){
    campo =  'fldZhpgvAmSgcSbuR';
  }else{
    campo = 'fldeZ5PfcXmqfwedT';
  }
  try {
    final response = await airtable.getRecordsFilterByFormula('app_lista_tracos$type', 'FIND(  "$categoria", {$campo})');
    return response;
  } catch (e) {
    print('Erro ao buscar traços: $e');
  }
}

Future getRecordsFilterByFormulaCat(String categories, String type) async {
  String campo = '';
  if(type.isEmpty){
    campo =  'fld2Db1sReikzH8Lp';
  }else{
    campo = 'fldBunOhPUJvfzMwJ';
  }
  String formula = 'OR(';
     formula += 'FIND("$categories", {$campo})';
    formula += ')';
 
  final response = await airtable.getRecordsFilterByFormula('app_lista_doenca$type', formula);

  return response;
}

Future getRecordsFilterByFormulaName(String name, String type) async {
   String campo = '';
  if(type.isEmpty){
    campo =  'fldyCweurxbamF4AN';
  }else{
    campo = 'fld7tI1jpdCl2xIl7';
  }
  final response = await airtable.getRecordsFilterByFormula('app_lista_doenca$type', 'FIND(  "$name", {$campo})');
 
  return response;
}
Future getRecordsFilterByFormulaRacas(String racas, String type) async{
   String campo = '';
  if(type.isEmpty){
    campo =  'fldaUoYE4cPNQrCpy';
  }else{
    campo = 'fldN1I19VnzG40yeg';
  }
  String formula = 'OR(';
    formula += 'FIND("$racas", {$campo})';
    
    formula += ')';

  final response = await airtable.getRecordsFilterByFormula('app_lista_doenca$type', formula);


  return response;
}
Future getRacas(String type, String name) async{
  String campo = 'fldSD9aXg1I5FD3Nz';
  // if(type.isEmpty){
  //   campo =  'fldSD9aXg1I5FD3Nz';
  // }else{
  //   campo = 'fldBunOhPUJvfzMwJ';
  // }
  String formula = '$campo="$name"';
  final response = await airtable.getRecordsFilterByFormula('lista_de_racas$type',formula);
  return response;
}
}

