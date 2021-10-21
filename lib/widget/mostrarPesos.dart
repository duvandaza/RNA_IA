import 'package:flutter/material.dart';

class MostrarPeso extends StatelessWidget {
  const MostrarPeso({
    Key? key,
    required this.peso,
  }) : super(key: key);

  final List<List> peso;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      child: Table(
        border: TableBorder.all(width: 1.0),
        children: peso.map((item) {
          return TableRow(
            children: item.map((row) {
              return Center(
                child: Text(row.toStringAsFixed(3), style: TextStyle(fontSize: 20),)
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }
}