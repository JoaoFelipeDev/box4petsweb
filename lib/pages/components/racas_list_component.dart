import 'package:flutter/material.dart';

import '../model/racas_model.dart';

class RacasListComponent extends StatefulWidget {
  final List<RacasModel> racas;
  final Function(String) onSelect;

  const RacasListComponent({required this.racas, required this.onSelect, super.key});

  @override
  State<RacasListComponent> createState() => _RacasListComponentState();
}

class _RacasListComponentState extends State<RacasListComponent> {
  String searchQuery = '';
  String selectedLetter = 'A';

  @override
  Widget build(BuildContext context) {
    final filtered = widget.racas.where((raca) {
      final matchesSearch = raca.Nome.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesLetter = raca.Nome.toUpperCase().startsWith(selectedLetter.toUpperCase());
      return matchesSearch && matchesLetter;
    }).toList()
      ..sort((a, b) => a.Nome.compareTo(b.Nome));

    return Column(
      children: [
        TextField(
          decoration: const InputDecoration(
            hintText: 'Pesquise pelo nome da raça',
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) => setState(() => searchQuery = value),
        ),
        Wrap(
          spacing: 8,
          children: List.generate(26, (index) {
            final letra = String.fromCharCode(65 + index);
            return ChoiceChip(
              label: Text(letra),
              selected: selectedLetter == letra,
              onSelected: (_) => setState(() => selectedLetter = letra),
            );
          }),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filtered.length,
            itemBuilder: (_, index) {
              final raca = filtered[index];
              return ListTile(
                title: Text(raca.Nome),
                onTap: () => widget.onSelect(raca.Nome),
              );
            },
          ),
        ),
      ],
    );
  }
}