import 'package:flutter/material.dart';
import 'package:perceptron/page/entrenamiento/csvData_page.dart';
import 'package:perceptron/page/simulacion/csvWard_page.dart';


final pageRoute = <Rutas> [
  
  Rutas( icon: Icons.document_scanner_outlined, titulo: 'Entrenamiento', color: Colors.blue, page: CsvDataPage()),
  Rutas( icon: Icons.download_rounded, titulo: 'CSV Data', color: Colors.green, page: CsvWardPage())


];


class Rutas {

  final IconData icon;
  final String titulo;
  final Color color;
  final Widget page;

  Rutas({required this.icon, required this.titulo, required this.color, required this.page});

}