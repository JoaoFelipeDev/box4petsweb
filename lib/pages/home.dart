import 'package:box4pets_web/pages/bloc/doencas_bloc.dart';
import 'package:box4pets_web/pages/components/check_box_component.dart';
import 'package:box4pets_web/pages/doencas.dart';
import 'package:box4pets_web/pages/model/doenca_model.dart';
import 'package:box4pets_web/pages/model/racas_model.dart';
import 'package:box4pets_web/pages/model/tracos_model.dart';
import 'package:box4pets_web/pages/tracos.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
    bool isLoading = false;
  List <DoencaModel> doencas = [];
  String filtroRacas = '';
  String primeiraEscolha = '';
  bool racasScreen = false;
  int totalPage = 10;
  bool exibirDoencas = false;
  List <TracosModel> tracos = [];
  List<RacasModel> _listRacaCao = [];
  List<RacasModel> _listRacaGato = [];
  List<String> categorias = [
    'Auditivo',
    "Cardiorrespiratório",
    "Dermatológico",
    "Endócrino",
    "Gastrointestinal e Hepático",
    "Hematológico",
    "Imunológico",
    "Metabólico",
    "Neurológico",
    "Odontológico",
    "Oftalmológico",
    "Ossos e Músculos",
    "Renal",
    "Reprodutivo",
  ];

  List <String> categoriasTracos = [
    "Cor da camada da base dos pelos",
    "Modificadores da coloração",
    "Características da pelagem",
    "Características físicas",

  ];

  _returnTypeSearch(){
    if(categiriasSearch.isNotEmpty){
      return 'categoria';
    }else if(filtroRacas.isNotEmpty){
      return 'raça';
    }else{
      return 'todos';
    }
  }

  bool escolhaCategoria = false;
  bool escolhaRacas = false;
  _tapPaginator(int index) {
   
    _doencasBloc.add(GetDoencasEvent(_selectedAnimal, page: index));
  }
  late final _doencasBloc = DoencasBloc();
  String categiriasSearch = '';
  String categiriasTracosSearch = '';
  String racasSerch = '';
  String _selectedAnimal = '';

  _openModal(String title, String content) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Fechar'),
            ),
          ],
        );
      },
    );
  }

  _searchTracosCategory(String categoria){
    setState(() {
      categiriasTracosSearch = categiriasTracosSearch == categoria ? '' : categoria;
    });
    _doencasBloc.add(GetTracos(categoria, _selectedAnimal));
  }

  _searchByCategory(String category) {
    setState(() {
      categiriasSearch = categiriasSearch == category ? '' : category;
    });

    if (categiriasSearch.isEmpty) {
      _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
    } else {
      _doencasBloc.add(GetDoencasByCategoryEvent(
          categories: categiriasSearch, type: _selectedAnimal));
    }
  }



  _searchByRacas(String raca) {
    print('Começo');
    setState(() {
      isLoading = true;
      filtroRacas = filtroRacas == raca? '' : raca;
    });
    

   
    if (filtroRacas.isEmpty) {
      _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
    } else {
     _doencasBloc.add(GetRacas(_selectedAnimal, 1, raca));
    }
    
  }

  filterName(String name) {
    _doencasBloc.add(GetDoencasByNameEvent(name: name, type: _selectedAnimal));
  }

  @override
  void initState() {
   
    _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoencasBloc, DoencasState>(
      bloc: _doencasBloc,
      listener: (context, state) {
       if (state is DoencasError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
            ),
          );
        }else if(state is DoencasLoaded){
          print('Fim');
         setState(() {
          isLoading = false;
          _listRacaCao = state.racasDog;
          _listRacaGato = state.racasCat;
          totalPage = state.totalPage;
          doencas = state.doencas;
         });
        
        }else if(state is DoencasTracos){
          setState(() {
            tracos = state.tracos;
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          title: Image.asset('assets/images/logo_app_bar.png', height: 50),
          centerTitle: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            if(constraints.maxWidth < 800){
              if(primeiraEscolha.isEmpty && !racasScreen && !escolhaCategoria && !escolhaRacas){
                return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Está buscando por:', style: TextStyle(color: Colors.black, fontSize: 20),),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        InkWell(
                          onTap: (){
                            setState(() {
                              primeiraEscolha = 'doenças';
                            });
                          },
                          child: Card(
                            elevation: 10,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xff3F2873),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children:  [
                                   Image.asset('assets/images/dog_desenho.png', height: 75),
                                  const Text('Doenças', style: TextStyle(color: Colors.white),),
                                ],
                              ),
                              ),
                          ),
                        ),
                       const SizedBox(width: 20),
                         InkWell(
                            onTap: (){
                              setState(() {
                                primeiraEscolha = 'traços';
                              });
                            },
                           child: Card(
                              elevation: 10,
                             child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              child:  Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children:  [
                                     Image.asset('assets/images/dog_desenho_1.png', height: 75),
                                    const Text('Traços', style: TextStyle(color: Colors.black),),
                                  ],
                                ),
                              ),
                           ),
                         ),
                      ],
                  ),
                ],
              );
              }else if(primeiraEscolha == 'doenças' && !racasScreen){
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                     const Text('Está buscando por:', style: TextStyle(color: Colors.black, fontSize: 20),),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 800,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff3F2873),
                              ),
                              onPressed: (){
                                setState(() {
                                  escolhaCategoria = true;
                                  escolhaRacas = false;
                                  primeiraEscolha = '';

                                });
                              }, child: const Text('Categoria da doença', style: TextStyle(color: Colors.white),),),
                        
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff3F2873),
                              ),
                              onPressed: (){
                                 setState(() {
                                  escolhaCategoria = false;
                                  escolhaRacas = true;
                                  primeiraEscolha = '';
                                  
                                });
                              }, child: const Text('Raças', style: TextStyle(color: Colors.white),),),
                          ],
                        ),
                      ),
                      
                    
                    ],
                  ),
                );

              } else if(escolhaCategoria){
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        SizedBox(
                          width: 800,
                          child: Wrap(
                                      spacing: 16.0, // Espaçamento horizontal entre os itens
                                      runSpacing: 16.0,
                                      
                                      children: categorias
                                              .map((e) => InkWell(
                                                onTap: (){
                                                  setState(() {
                                                filtroRacas = '';
                                                
                                              });
                                                  _searchByCategory(e);
                                                  print(e);
                                                },
                                                child: Container(
                                                   margin: const EdgeInsets.only(bottom: 10),
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: categiriasSearch == e ? const Color(
                                                                        0xff3F2873) : Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(e, style: TextStyle(color: categiriasSearch == e ? Colors.white: Colors.black),),
                                                ),
                                              ))
                                              .toList(),
                                        ),
                        ),
                        const SizedBox(height: 20),
                       SizedBox(
                          width: 800,
                         child:  Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  primeiraEscolha = '';
                                  escolhaCategoria = false;
                                  escolhaRacas = false;
                                });
                              },
                              child: const Row(
                                
                                children: [
                                  Icon(Icons.arrow_back_ios),
                                  Text('Voltarr', style: TextStyle(color: Colors.black, fontSize: 20),),
                                  
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Doencas(selectedAnimal: _selectedAnimal ,tapPaginator: _tapPaginator, openModal: _openModal, doencas: doencas, totalPage: totalPage, tipoDeBusca: _returnTypeSearch(),filtroCategoria: categiriasSearch, filtroRacas: filtroRacas,)));
                              },
                              child: Row(
                                children: [
                                  Text( categiriasSearch.isEmpty ? 'Prosseguir com todas as categorias' : 'Prosseguir com $categiriasSearch', style: const TextStyle(color: Colors.black, fontSize: 20),),
                                  const Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            )
                  
                          ],
                          ),
                       )
                    ],
                  ),
                );
              } else if(escolhaRacas ){
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                       Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: '',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Canino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      Radio(
                        value: '_gato',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Felino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 800,
                         child:  Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  racasScreen = false;
                                  primeiraEscolha = '';
                                  escolhaCategoria = false;
                                  escolhaRacas = false;
                                });
                              },
                              child: const Row(
                                
                                children: [
                                  Icon(Icons.arrow_back_ios),
                                  Text('Voltar', style: TextStyle(color: Colors.black, fontSize: 20),),
                                  
                                ],
                              ),
                            ),
                           isLoading ?  const Text('Aguarde...', style: const TextStyle(color: Colors.black, fontSize: 20),) : InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Doencas(selectedAnimal: _selectedAnimal ,tapPaginator: _tapPaginator, openModal: _openModal, doencas: doencas, totalPage: totalPage, tipoDeBusca: _returnTypeSearch(),filtroCategoria: categiriasSearch, filtroRacas: filtroRacas,)));
                              },
                              child:  Row(
                                children: [
                                  Text( filtroRacas.isEmpty ? 'Prosseguir com todas as raças' : 'Prosseguir com $filtroRacas', style: const TextStyle(color: Colors.black, fontSize: 20),),
                                  const Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            )
                    
                          ],
                          ),
                       ),
                        const SizedBox(height: 20),
                       _selectedAnimal == '' ? SizedBox(
                          width: 800,
                          child: Wrap(
                                      spacing: 16.0, // Espaçamento horizontal entre os itens
                                      runSpacing: 16.0,
                                      direction: Axis.horizontal,
                                      children:  _listRacaCao
                                              .map((e) => InkWell(
                                                onTap: (){
                                                  setState(() {
                                                filtroRacas = '';
                                                
                                              });
                                              
                                                  _searchByRacas(e.Nome);
                                                  
                                                 
                                                },
                                                child: Container(
                                                   margin: const EdgeInsets.only(bottom: 10),
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: filtroRacas == e.Nome ? const Color(
                                                                        0xff3F2873) : Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(e.Nome, style: TextStyle(color: filtroRacas == e.Nome ? Colors.white: Colors.black),),
                                                ),
                                              ))
                                              .toList(),
                                        ),
                        ):
                        SizedBox(
                          width: 800,
                          child: Wrap(
                                      spacing: 16.0, // Espaçamento horizontal entre os itens
                                      runSpacing: 16.0,
                                      direction: Axis.horizontal,
                                      children:  _listRacaGato
                                              .map((e) => InkWell(
                                                onTap: (){
                                                  setState(() {
                                                filtroRacas = '';
                                                
                                              });
                                                  _searchByRacas(e.Nome);
                                                 
                                                },
                                                child: Container(
                                                   margin: const EdgeInsets.only(bottom: 10),
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: filtroRacas == e.Nome ? const Color(
                                                                        0xff3F2873) : Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(e.Nome, style: TextStyle(color: filtroRacas == e.Nome ? Colors.white: Colors.black),),
                                                ),
                                              ))
                                              .toList(),
                                        ),
                        ),
                        const SizedBox(height: 20),
                       SizedBox(
                          width: 800,
                         child:  Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                               setState(() {
                                  racasScreen = false;
                                  primeiraEscolha = '';
                                  escolhaCategoria = false;
                                  escolhaRacas = false;
                                });
                              },
                              child: const Row(
                                
                                children: [
                                  Icon(Icons.arrow_back_ios),
                                  Text('Voltar', style: TextStyle(color: Colors.black, fontSize: 20),),
                                  
                                ],
                              ),
                            ),
                           isLoading ?  const Text('Aguarde...', style: const TextStyle(color: Colors.black, fontSize: 20),) : InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Doencas(selectedAnimal: _selectedAnimal ,tapPaginator: _tapPaginator, openModal: _openModal, doencas: doencas, totalPage: totalPage, tipoDeBusca: _returnTypeSearch(),filtroCategoria: categiriasSearch, filtroRacas: filtroRacas,)));
                              },
                              child:  Row(
                                children: [
                                  Text( filtroRacas.isEmpty ? 'Prosseguir com todas as raças' : 'Prosseguir com $filtroRacas', style: const TextStyle(color: Colors.black, fontSize: 20),),
                                  const Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            )
                    
                          ],
                          ),
                       )
                      ],
                    ),
                  ),
                );
              }else if(exibirDoencas && !racasScreen){
                return Container(
                  child: const Text('exibir as doenças'),
                );
              }else {
               return   Center(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Escolha a espécie', style: TextStyle(color: Colors.black, fontSize: 20),),
                       const SizedBox(height: 20),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Radio(
                        value: '',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Canino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      Radio(
                        value: '_gato',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Felino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                      const Text('Escolha a categoria do traço', style: TextStyle(color: Colors.black, fontSize: 20),),
                       const SizedBox(height: 20),
                      SizedBox(
                        width: 800,
                        child: Wrap(
                          spacing: 16.0, // Espaçamento horizontal entre os itens
                          runSpacing: 16.0,
                          children: categoriasTracos
                                  .map((e) => InkWell(
                                    onTap: (){
                                      setState(() {
                                    categiriasTracosSearch = '';
                                    
                                  });
                                      _searchTracosCategory(e);
                                      print(e);
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: categiriasTracosSearch == e ? const Color(
                                                            0xff3F2873) : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(e, style: TextStyle(color: categiriasTracosSearch == e ? Colors.white: Colors.black),),
                                    ),
                                  ))
                                  .toList(),
                                      ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                primeiraEscolha = '';
                              });
                            },
                            child: const Row(
                              
                              children: [
                                Icon(Icons.arrow_back_ios),
                                Text('Voltar', style: TextStyle(color: Colors.black, fontSize: 14),),
                              ],
                            ),
                          ),
                         categiriasTracosSearch.isEmpty ? Container() : InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Tracos(tracos: tracos, openModal: _openModal,)));
                            },
                            child: Row(
                              children: [
                                Text( maxLines: 2, categiriasTracosSearch.isEmpty ? 'Prosseguir com todas as categorias' : 'Prosseguir com $categiriasTracosSearch', style: const TextStyle(color: Colors.black, fontSize: 14),),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          )
                        ],
                      )

                    
                  ],
                ));
              }
            }else{
              if(primeiraEscolha.isEmpty && !racasScreen && !escolhaCategoria && !escolhaRacas){
                return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Está buscando por:', style: TextStyle(color: Colors.black, fontSize: 20),),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children:  [
                        InkWell(
                          onTap: (){
                            setState(() {
                              primeiraEscolha = 'doenças';
                            });
                          },
                          child: Card(
                            elevation: 10,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: const Color(0xff3F2873),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children:  [
                                   Image.asset('assets/images/dog_desenho.png', height: 75),
                                  const Text('Doenças', style: TextStyle(color: Colors.white),),
                                ],
                              ),
                              ),
                          ),
                        ),
                       const SizedBox(width: 20),
                         InkWell(
                            onTap: (){
                              setState(() {
                                primeiraEscolha = 'traços';
                              });
                            },
                           child: Card(
                              elevation: 10,
                             child: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              child:  Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children:  [
                                     Image.asset('assets/images/dog_desenho_1.png', height: 75),
                                    const Text('Traços', style: TextStyle(color: Colors.black),),
                                  ],
                                ),
                              ),
                           ),
                         ),
                      ],
                  ),
                ],
              );
              }else if(primeiraEscolha == 'doenças' && !racasScreen){
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                     const Text('Está buscando por:', style: TextStyle(color: Colors.black, fontSize: 20),),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: 800,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff3F2873),
                              ),
                              onPressed: (){
                                setState(() {
                                  escolhaCategoria = true;
                                  escolhaRacas = false;
                                  primeiraEscolha = '';

                                });
                              }, child: const Text('Categoria da doença', style: TextStyle(color: Colors.white),),),
                              const SizedBox(width: 20),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff3F2873),
                              ),
                              onPressed: (){
                                 setState(() {
                                  escolhaCategoria = false;
                                  escolhaRacas = true;
                                  primeiraEscolha = '';

                                });
                              }, child: const Text('Raças', style: TextStyle(color: Colors.white),),),
                          ],
                        ),
                      ),
                      
                    
                    ],
                  ),
                );

              } else if(escolhaCategoria){
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        SizedBox(
                          width: 800,
                          child: Wrap(
                                      spacing: 16.0, // Espaçamento horizontal entre os itens
                                      runSpacing: 16.0,
                                      
                                      children: categorias
                                              .map((e) => InkWell(
                                                onTap: (){
                                                  setState(() {
                                                filtroRacas = '';
                                                
                                              });
                                                  _searchByCategory(e);
                                                  print(e);
                                                },
                                                child: Container(
                                                   margin: const EdgeInsets.only(bottom: 10),
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: categiriasSearch == e ? const Color(
                                                                        0xff3F2873) : Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(e, style: TextStyle(color: categiriasSearch == e ? Colors.white: Colors.black),),
                                                ),
                                              ))
                                              .toList(),
                                        ),
                        ),
                        const SizedBox(height: 20),
                       SizedBox(
                          width: 800,
                         child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  primeiraEscolha = '';
                                  escolhaCategoria = false;
                                  escolhaRacas = false;
                                });
                              },
                              child: const Row(
                                
                                children: [
                                  Icon(Icons.arrow_back_ios),
                                  Text('Voltar', style: TextStyle(color: Colors.black, fontSize: 20),),
                                  
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Doencas(selectedAnimal: _selectedAnimal ,tapPaginator: _tapPaginator, openModal: _openModal, doencas: doencas, totalPage: totalPage, tipoDeBusca: _returnTypeSearch(),filtroCategoria: categiriasSearch, filtroRacas: filtroRacas,)));
                              },
                              child: Row(
                                children: [
                                  Text( categiriasSearch.isEmpty ? 'Prosseguir com todas as categorias' : 'Prosseguir com $categiriasSearch', style: const TextStyle(color: Colors.black, fontSize: 20),),
                                  const Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            )
                  
                          ],
                          ),
                       )
                    ],
                  ),
                );
              } else if(escolhaRacas ){
                return Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                       Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: '',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Canino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      Radio(
                        value: '_gato',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Felino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 800,
                         child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  racasScreen = false;
                                  primeiraEscolha = '';
                                  escolhaCategoria = false;
                                  escolhaRacas = false;

                                });
                              },
                              child: const Row(
                                
                                children: [
                                  Icon(Icons.arrow_back_ios),
                                  Text('Voltar', style: TextStyle(color: Colors.black, fontSize: 20),),
                                  
                                ],
                              ),
                            ),
                           isLoading ?  const Text('Aguarde...', style: const TextStyle(color: Colors.black, fontSize: 20),) : InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Doencas(selectedAnimal: _selectedAnimal ,tapPaginator: _tapPaginator, openModal: _openModal, doencas: doencas, totalPage: totalPage, tipoDeBusca: _returnTypeSearch(),filtroCategoria: categiriasSearch, filtroRacas: filtroRacas,)));
                              },
                              child: Row(
                                children: [
                                  Text( filtroRacas.isEmpty ? 'Prosseguir com todas as raças' : 'Prosseguir com $filtroRacas', style: const TextStyle(color: Colors.black, fontSize: 20),),
                                  const Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            )
                    
                          ],
                          ),
                       ),
                        const SizedBox(height: 20),
                       _selectedAnimal == '' ? SizedBox(
                          width: 800,
                          child: Wrap(
                                      spacing: 16.0, // Espaçamento horizontal entre os itens
                                      runSpacing: 16.0,
                                      direction: Axis.horizontal,
                                      children:  _listRacaCao
                                              .map((e) => InkWell(
                                                onTap: (){
                                                  setState(() {
                                                filtroRacas = '';
                                                
                                              });
                                              
                                                  _searchByRacas(e.Nome);
                                                 
                                                },
                                                child: Container(
                                                   margin: const EdgeInsets.only(bottom: 10),
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: filtroRacas == e.Nome ? const Color(
                                                                        0xff3F2873) : Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(e.Nome, style: TextStyle(color: filtroRacas == e.Nome ? Colors.white: Colors.black),),
                                                ),
                                              ))
                                              .toList(),
                                        ),
                        ):
                        SizedBox(
                          width: 800,
                          child: Wrap(
                                      spacing: 16.0, // Espaçamento horizontal entre os itens
                                      runSpacing: 16.0,
                                      direction: Axis.horizontal,
                                      children:  _listRacaGato
                                              .map((e) => InkWell(
                                                onTap: (){
                                                  setState(() {
                                                filtroRacas = '';
                                                
                                              });
                                                  _searchByRacas(e.Nome);
                                                 
                                                },
                                                child: Container(
                                                   margin: const EdgeInsets.only(bottom: 10),
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: filtroRacas == e.Nome ? const Color(
                                                                        0xff3F2873) : Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(e.Nome, style: TextStyle(color: filtroRacas == e.Nome ? Colors.white: Colors.black),),
                                                ),
                                              ))
                                              .toList(),
                                        ),
                        ),
                        const SizedBox(height: 20),
                       SizedBox(
                          width: 800,
                         child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  racasScreen = false;
                                });
                              },
                              child: const Row(
                                
                                children: [
                                  Icon(Icons.arrow_back_ios),
                                  Text('Voltar', style: TextStyle(color: Colors.black, fontSize: 20),),
                                  
                                ],
                              ),
                            ),
                          isLoading ?  const Text('Aguarde...', style: const TextStyle(color: Colors.black, fontSize: 20),) :  InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Doencas(selectedAnimal: _selectedAnimal ,tapPaginator: _tapPaginator, openModal: _openModal, doencas: doencas, totalPage: totalPage, tipoDeBusca: _returnTypeSearch(),filtroCategoria: categiriasSearch, filtroRacas: filtroRacas,)));
                              },
                              child: Row(
                                children: [
                                  Text( filtroRacas.isEmpty ? 'Prosseguir com todas as raças' : 'Prosseguir com $filtroRacas', style: const TextStyle(color: Colors.black, fontSize: 20),),
                                  const Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            )
                    
                          ],
                          ),
                       )
                      ],
                    ),
                  ),
                );

              } else if(primeiraEscolha == 'traços' && !racasScreen){
                return   Center(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Escolha a espécie', style: TextStyle(color: Colors.black, fontSize: 20),),
                       const SizedBox(height: 20),
                    Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      
                      Radio(
                        value: '',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Canino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      Radio(
                        value: '_gato',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Felino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                      const Text('Escolha a categoria do traço', style: TextStyle(color: Colors.black, fontSize: 20),),
                       const SizedBox(height: 20),
                      SizedBox(
                        width: 800,
                        child: Wrap(
                          spacing: 16.0, // Espaçamento horizontal entre os itens
                          runSpacing: 16.0,
                          children: categoriasTracos
                                  .map((e) => InkWell(
                                    onTap: (){
                                      setState(() {
                                    categiriasTracosSearch = '';
                                    
                                  });
                                      _searchTracosCategory(e);
                                      print(e);
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: categiriasTracosSearch == e ? const Color(
                                                            0xff3F2873) : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(e, style: TextStyle(color: categiriasTracosSearch == e ? Colors.white: Colors.black),),
                                    ),
                                  ))
                                  .toList(),
                                      ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: (){
                              setState(() {
                                primeiraEscolha = '';
                              });
                            },
                            child: const Row(
                              
                              children: [
                                Icon(Icons.arrow_back_ios),
                                Text('Voltar', style: TextStyle(color: Colors.black, fontSize: 20),),
                              ],
                            ),
                          ),
                         categiriasTracosSearch.isEmpty ? Container() : InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => Tracos(tracos: tracos, openModal: _openModal,)));
                            },
                            child: Row(
                              children: [
                                Text( categiriasTracosSearch.isEmpty ? 'Prosseguir com todas as categorias' : 'Prosseguir com $categiriasTracosSearch', style: const TextStyle(color: Colors.black, fontSize: 20),),
                                const Icon(Icons.arrow_forward_ios)
                              ],
                            ),
                          )
                        ],
                      )

                    
                  ],
                ));

              }else if(racasScreen && !exibirDoencas){
                // TODO : fazer a busca por raças
                return  Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                       Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: '',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Canino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      Radio(
                        value: '_gato',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Felino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 800,
                         child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  racasScreen = false;
                                });
                              },
                              child: const Row(
                                
                                children: [
                                  Icon(Icons.arrow_back_ios),
                                  Text('Voltar', style: TextStyle(color: Colors.black, fontSize: 20),),
                                  
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Doencas(selectedAnimal: _selectedAnimal ,tapPaginator: _tapPaginator, openModal: _openModal, doencas: doencas, totalPage: totalPage, tipoDeBusca: _returnTypeSearch(),filtroCategoria: categiriasSearch, filtroRacas: filtroRacas,)));
                              },
                              child: Row(
                                children: [
                                  Text( filtroRacas.isEmpty ? 'Prosseguir com todas as raças' : 'Prosseguir com $filtroRacas', style: const TextStyle(color: Colors.black, fontSize: 20),),
                                  const Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            )
                    
                          ],
                          ),
                       ),
                        const SizedBox(height: 20),
                       _selectedAnimal == '' ? SizedBox(
                          width: 800,
                          child: Wrap(
                                      spacing: 16.0, // Espaçamento horizontal entre os itens
                                      runSpacing: 16.0,
                                      direction: Axis.horizontal,
                                      children:  _listRacaCao
                                              .map((e) => InkWell(
                                                onTap: (){
                                                  setState(() {
                                                filtroRacas = '';
                                                
                                              });
                                              
                                                  _searchByRacas(e.Nome);
                                                 
                                                },
                                                child: Container(
                                                   margin: const EdgeInsets.only(bottom: 10),
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: filtroRacas == e.Nome ? const Color(
                                                                        0xff3F2873) : Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(e.Nome, style: TextStyle(color: filtroRacas == e.Nome ? Colors.white: Colors.black),),
                                                ),
                                              ))
                                              .toList(),
                                        ),
                        ):
                        SizedBox(
                          width: 800,
                          child: Wrap(
                                      spacing: 16.0, // Espaçamento horizontal entre os itens
                                      runSpacing: 16.0,
                                      direction: Axis.horizontal,
                                      children:  _listRacaGato
                                              .map((e) => InkWell(
                                                onTap: (){
                                                  setState(() {
                                                filtroRacas = '';
                                                
                                              });
                                                  _searchByRacas(e.Nome);
                                                 
                                                },
                                                child: Container(
                                                   margin: const EdgeInsets.only(bottom: 10),
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  color: filtroRacas == e.Nome ? const Color(
                                                                        0xff3F2873) : Colors.grey[200],
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(e.Nome, style: TextStyle(color: filtroRacas == e.Nome ? Colors.white: Colors.black),),
                                                ),
                                              ))
                                              .toList(),
                                        ),
                        ),
                        const SizedBox(height: 20),
                       SizedBox(
                          width: 800,
                         child:  Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: (){
                                setState(() {
                                  racasScreen = false;
                                });
                              },
                              child: const Row(
                                
                                children: [
                                  Icon(Icons.arrow_back_ios),
                                  Text('Voltar', style: TextStyle(color: Colors.black, fontSize: 20),),
                                  
                                ],
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Doencas(selectedAnimal: _selectedAnimal ,tapPaginator: _tapPaginator, openModal: _openModal, doencas: doencas, totalPage: totalPage, tipoDeBusca: _returnTypeSearch(),filtroCategoria: categiriasSearch, filtroRacas: filtroRacas,)));
                              },
                              child: Row(
                                children: [
                                  Text( filtroRacas.isEmpty ? 'Prosseguir com todas as raças' : 'Prosseguir com $filtroRacas', style: const TextStyle(color: Colors.black, fontSize: 20),),
                                  const Icon(Icons.arrow_forward_ios)
                                ],
                              ),
                            )
                    
                          ],
                          ),
                       )
                      ],
                    ),
                  ),
                );
              }else if(exibirDoencas && !racasScreen){
                return Container(
                  child: const Text('exibir as doenças'),
                );
              }else {
               return Container();
              }
              
              
            }
            
          }
          
        ),
      ),
    );
  }

  Padding DoencasDesktop(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Pesquisar pelo nome da doença!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
          
                          blurRadius: 7,
                          offset:
                              const Offset(8, 8), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (value.length > 2) {
                            filterName(value);
                          } else if (value.isEmpty) {
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          }
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        hintText: '',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 21,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: '',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Canino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      Radio(
                        value: '_gato',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Felino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  //Paginator
                  SizedBox(
                    width: 800,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: totalPage.isNegative
                          ? []
                          : List.generate(totalPage, (index) {
                              return InkWell(
                                onTap: () {
                                  _doencasBloc.add(GetDoencasEvent(
                                      _selectedAnimal, page: index + 1));
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }),
                    ),
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Categorias',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: categorias
                                    .map((e) => InkWell(
                                      onTap: (){
                                        setState(() {
                                      filtroRacas = '';
                                    });
                                        _searchByCategory(e);
                                      },
                                      child: Container(
                                         margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: categiriasSearch == e ? const Color(
                                                              0xff3F2873) : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(e, style: TextStyle(color: categiriasSearch == e ? Colors.white: Colors.black),),
                                      ),
                                    ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: 2,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Raças',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _selectedAnimal == '' ? _listRacaCao.map((e) => InkWell(
                                  onTap: (){
                                    setState(() {
                                      categiriasSearch = '';
                                    });
                                    _searchByRacas(e.Nome);
                                  },
                                  child: Container(
                                  
                                    margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: filtroRacas == e.Nome ? const Color(
                                                              0xff3F2873) : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(e.Nome, style: TextStyle(color: filtroRacas == e.Nome ? Colors.white: Colors.black)),
                                  
                                  ),
                                )).toList() : _listRacaGato.map((e) => InkWell(
                                  onTap: (){
                                    setState(() {
                                      categiriasSearch = '';
                                    });
                                    _searchByRacas(e.Nome);
                                  },
                                  child: Container(
                                  
                                    margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: filtroRacas == e.Nome ? const Color(
                                                              0xff3F2873) : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(e.Nome, style: TextStyle(color: filtroRacas == e.Nome ? Colors.white: Colors.black)),
                                  
                                  ),
                                )).toList(),
                                    
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(height: 20),
                              BlocBuilder<DoencasBloc, DoencasState>(
                                bloc: _doencasBloc,
                                builder: (context, state) {
                                  if (state is DoencasLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is DoencasLoaded) {
                                    return SizedBox(
                                      height: MediaQuery.of(context).size.height, 
                                      child: GridView.count(
                                        mainAxisSpacing: 7,
                                        crossAxisSpacing: 2,
                                        crossAxisCount: 3,
                                        shrinkWrap: true,
                                        children: List.generate(
                                            state.doencas.length, (index) {
                                          final e = state.doencas[index];
                                          return InkWell(
                                            onTap: () {
                                              _openModal(
                                                  e.doenca, e.sobre_doenca);
                                            },
                                            child: Container(
                                              
                                              height: 50,
                                              color: Colors.grey[200],
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: <Widget>[
                                                      Text('Doença: ${e.doenca}',
                                                          style: const TextStyle(
                                                              fontWeight:
                                                                  FontWeight.bold,
                                                              color: Color(
                                                                  0xff3F2873))),
                                                      Text(
                                                          'Categoria: ${e.categoria}',
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xff3F2873))),
                                                      Text('Gene: ${e.gene}',
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xff3F2873))),
                                                      Text(
                                                          'Variante: ${e.variante}',
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xff3F2873))),
                                                      Text(
                                                          'Cromossomo: ${e.cromossomo}',
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xff3F2873))),
                                                      Text(
                                                          'Herança: ${e.heranca}',
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xff3F2873))),
                                                      Text('Raças: ${e.racas}',
                                                          style: const TextStyle(
                                                              color: Color(
                                                                  0xff3F2873))),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                      ),
                                    );
                                  } else if (state is DoencasError) {
                                    return Center(
                                      child: Text(state.message),
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      
                    ],
                  )
                ],
              ),
            ),
          );
  }

  Padding DoencasMobile(BuildContext context) {
    return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Pesquisar pelo nome da doença!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
          
                          blurRadius: 7,
                          offset:
                              const Offset(8, 8), // changes position of shadow
                        ),
                      ],
                    ),
                    child: TextFormField(
                      onChanged: (value) {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          if (value.length > 2) {
                            filterName(value);
                          } else if (value.isEmpty) {
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          }
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        isDense: true,
                        hintText: '',
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                          size: 21,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(60),
                          borderSide: const BorderSide(
                            width: 0,
                            style: BorderStyle.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Radio(
                        value: '',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Canino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 20),
                      Radio(
                        value: '_gato',
                        groupValue: _selectedAnimal,
                        onChanged: (value) {
                          setState(() {
                            _selectedAnimal = value.toString();
                            _doencasBloc.add(GetDoencasEvent(_selectedAnimal));
                          });
                        },
                      ),
                      const Text(
                        'Felino',
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 40),
                      SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Categorias',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: categorias
                                    .map((e) => InkWell(
                                      onTap: (){
                                        setState(() {
                                      filtroRacas = '';
                                    });
                                        _searchByCategory(e);
                                      },
                                      child: Container(
                                         margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: categiriasSearch == e ? const Color(
                                                              0xff3F2873) : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(e, style: TextStyle(color: categiriasSearch == e ? Colors.white: Colors.black),),
                                      ),
                                    ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                           SizedBox(
                        height: MediaQuery.of(context).size.height,
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Raças',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: _selectedAnimal == '' ? _listRacaCao.map((e) => InkWell(
                                  onTap: (){
                                    setState(() {
                                      categiriasSearch = '';
                                    });
                                    _searchByRacas(e.Nome);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: filtroRacas == e.Nome ? const Color(
                                                            0xff3F2873) : Colors.grey[200],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(e.Nome, style: TextStyle(color: filtroRacas == e.Nome ? Colors.white: Colors.black),),
                                  ),
                                )).toList() : _listRacaGato.map((e) => InkWell(
                                  onTap: (){
                                    setState(() {
                                      categiriasSearch = '';
                                    });
                                    _searchByRacas(e.Nome);
                                  },
                                  child: Container(
                                  
                                    margin: const EdgeInsets.only(bottom: 10),
                                      padding: const EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        color: filtroRacas == e.Nome ? const Color(
                                                              0xff3F2873) : Colors.grey[200],
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(e.Nome,style: TextStyle(color: filtroRacas == e.Nome ? Colors.white: Colors.black)),
                                  
                                  ),
                                )).toList(),
                                    
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                  //Paginator
                  SizedBox(
                    width: 800,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: totalPage.isNegative
                          ? []
                          : List.generate(totalPage, (index) {
                              return InkWell(
                                onTap: () {
                                  _doencasBloc.add(GetDoencasEvent(
                                      _selectedAnimal, page: index + 1));
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }),
                    ),
                  ),
                      const SizedBox(height: 40),
                      BlocBuilder<DoencasBloc, DoencasState>(
                        bloc: _doencasBloc,
                        builder: (context, state) {
                          if (state is DoencasLoading) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is DoencasLoaded) {
                            return SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: List.generate(
                                      state.doencas.length, (index) {
                                    final e = state.doencas[index];
                                    return InkWell(
                                      onTap: () {
                                        _openModal(
                                            e.doenca, e.sobre_doenca);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        width: double.infinity,
                                        color: Colors.grey[200],
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.all(16.0),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize:
                                                  MainAxisSize.min,
                                              children: <Widget>[
                                                Text('Doença: ${e.doenca}',
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Color(
                                                            0xff3F2873))),
                                                Text(
                                                    'Categoria: ${e.categoria}',
                                                    style: const TextStyle(
                                                        color: Color(
                                                            0xff3F2873))),
                                                Text('Gene: ${e.gene}',
                                                    style: const TextStyle(
                                                        color: Color(
                                                            0xff3F2873))),
                                                Text(
                                                    'Variante: ${e.variante}',
                                                    style: const TextStyle(
                                                        color: Color(
                                                            0xff3F2873))),
                                                Text(
                                                    'Cromossomo: ${e.cromossomo}',
                                                    style: const TextStyle(
                                                        color: Color(
                                                            0xff3F2873))),
                                                Text(
                                                    'Herança: ${e.heranca}',
                                                    style: const TextStyle(
                                                        color: Color(
                                                            0xff3F2873))),
                                                Text('Raças: ${e.racas}',
                                                    style: const TextStyle(
                                                        color: Color(
                                                            0xff3F2873))),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                                ),
                              )
                            );
                          } else if (state is DoencasError) {
                            return Center(
                              child: Text(state.message),
                            );
                          }
                          return Container();
                        },
                      ),
                ],
              ),
            ),
          );
  }
}
