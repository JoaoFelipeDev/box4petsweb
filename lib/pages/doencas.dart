import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:box4pets_web/pages/bloc/doencas_bloc.dart';
import 'package:box4pets_web/pages/model/doenca_model.dart';

class Doencas extends StatefulWidget {
  final String tipoDeBusca;
  final String filtroRacas;
  final String filtroCategoria;
  final Function(int index) tapPaginator;
  List<DoencaModel> doencas;
  final int totalPage;
  final String selectedAnimal;
  final Function(String doenca, String sobreDoenca) openModal;
  Doencas({
    Key? key,
    required this.tipoDeBusca,
    required this.filtroRacas,
    required this.filtroCategoria,
    required this.tapPaginator,
    required this.doencas,
    required this.totalPage,
    required this.selectedAnimal,
    required this.openModal,
  }) : super(key: key);

  @override
  State<Doencas> createState() => _DoencasState();
}

class _DoencasState extends State<Doencas> {
  bool isLoading = false;
  late final DoencasBloc _doencasBloc;
  int indexPage = 0;
  @override
  void initState() {
    _doencasBloc = DoencasBloc();
    super.initState();
  }

  _tapTypeSearch(int page){
    print('tipo de busca: ${widget.tipoDeBusca}');
    if(widget.tipoDeBusca == 'categoria'){
      _doencasBloc.add(GetDoencasByCategoryEvent(type: widget.selectedAnimal, categories: widget.filtroCategoria, page: page));
    }else if(widget.tipoDeBusca == 'raça'){
      setState(() {
        isLoading = true;
      });
      _doencasBloc.add(GetRacas(widget.selectedAnimal, page, widget.filtroRacas));
    }else{
      _doencasBloc.add(GetDoencasEvent(widget.selectedAnimal));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<DoencasBloc, DoencasState>(
      bloc: _doencasBloc,
      listener: (context, state) {
        if(state is DoencasLoaded){
          setState(() {
            isLoading = false;
            widget.doencas = state.doencas;
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
              return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 800,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.totalPage.isNegative
                          ? []
                          : List.generate(widget.totalPage, (index) {
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    indexPage = index;
                                  });
                                  _tapTypeSearch(index + 1);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: indexPage == index ? const Color(0xff3F2873) : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style:  TextStyle(
                                      color: indexPage == index ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }),
                    ),
                  ),
                  isLoading ? const Text('Aguarde...') : Container(),
                 isLoading ? const Center(child:  CircularProgressIndicator(),) : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: GridView.count(
                              mainAxisSpacing: 7,
                              crossAxisSpacing: 2,
                              crossAxisCount: 1,
                              shrinkWrap: true,
                              children:
                                  List.generate(widget.doencas.length, (index) {
                                final e = widget.doencas[index];
                                return InkWell(
                                  onTap: () {
                                    widget.openModal(e.doenca, e.sobre_doenca);
                                  },
                                  hoverColor: Colors.transparent,
                                  child: Card(
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Doença: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.doenca,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Categoria: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.categoria,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Gene: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.gene,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Variante: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.variante,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Cromossomo: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.cromossomo,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Herança: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.heranca,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Raças: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.racas,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

            }else {
              return Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    width: 800,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: widget.totalPage.isNegative
                          ? []
                          : List.generate(widget.totalPage, 
                          growable: false,
                          (index) {

                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    indexPage = index;
                                  });
                                  _tapTypeSearch(index + 1);
                                },
                                child: Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: indexPage == index ? const Color(0xff3F2873) : Colors.grey[200],
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    '${index + 1}',
                                    style:  TextStyle(
                                      color: indexPage == index ? Colors.white : Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            }),
                    ),
                  ),
                  isLoading ? const Text('Aguarde...') : Container(),
                 isLoading ? const Center(child:  CircularProgressIndicator(),) : Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          SizedBox(
                            height: MediaQuery.of(context).size.height,
                            child: GridView.count(
                              mainAxisSpacing: 7,
                              crossAxisSpacing: 2,
                              crossAxisCount: 3,
                              shrinkWrap: true,
                              children:
                                  List.generate(widget.doencas.length, (index) {
                                final e = widget.doencas[index];
                                return InkWell(
                                  onTap: () {
                                    widget.openModal(e.doenca, e.sobre_doenca);
                                  },
                                  hoverColor: Colors.transparent,
                                  child: Card(
                                    elevation: 10,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Doença: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.doenca,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Categoria: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.categoria,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Gene: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.gene,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Variante: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.variante,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Cromossomo: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.cromossomo,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Herança: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.heranca,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      const TextSpan(
                                                        text: 'Raças: ',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: e.racas,
                                                        style: const TextStyle(
                                                          color: Color(0xff3F2873),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
            }
          },
        ),
      ),
    );
  }
}
