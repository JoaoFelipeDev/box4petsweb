import 'package:flutter/material.dart';

import 'package:box4pets_web/pages/model/tracos_model.dart';

class Tracos extends StatefulWidget {
  final List<TracosModel> tracos;
  final Function(String traco, String sobreTraco) openModal;
  const Tracos({
    Key? key,
    required this.tracos,
    required this.openModal,
  }) : super(key: key);

  @override
  State<Tracos> createState() => _TracosState();
}

class _TracosState extends State<Tracos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  
                  Expanded(
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
                                  List.generate(widget.tracos.length, (index) {
                                final e = widget.tracos[index];
                                return InkWell(
                                  onTap: () {
                                    widget.openModal(e.traco, e.sobre_traco);
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
                                                          text: 'Traço: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xff3F2873),
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: e.traco,
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
                  
                  Expanded(
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
                                  List.generate(widget.tracos.length, (index) {
                                final e = widget.tracos[index];
                                return InkWell(
                                  onTap: () {
                                    widget.openModal(e.traco, e.sobre_traco);
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
                                                          text: 'Traço: ',
                                                          style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            color: Color(0xff3F2873),
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: e.traco,
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
    );
  }
}