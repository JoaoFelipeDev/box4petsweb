import 'package:flutter/material.dart';

class CheckBoxComponent extends StatefulWidget {
  final String name;
  final Function(String categoria) categoryAdd;
  const CheckBoxComponent({
    super.key,
    required this.name,
    required this.categoryAdd,
  });

  @override
  State<CheckBoxComponent> createState() => _CheckBoxComponentState();
}

class _CheckBoxComponentState extends State<CheckBoxComponent> {
  
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(value: check, onChanged: (value) {
          setState(() {
            check = value!;
            widget.categoryAdd(widget.name);
          });
        }),
         Text(widget.name),
      ],
    );
  }
}