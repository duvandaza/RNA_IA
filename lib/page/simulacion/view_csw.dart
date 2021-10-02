import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:perceptron/page/entrenamiento_page.dart';
import 'package:perceptron/widget/MostrarCsv.dart';

class ViewCsvPage extends StatefulWidget {

  ViewCsvPage({Key? key, required this.path  }) : super(key: key);

  String path;

  @override
  _ViewCsvPageState createState() => _ViewCsvPageState();
}

class _ViewCsvPageState extends State<ViewCsvPage> {

  List<List<dynamic>> peso = [];
  int neuronaEntrada = 0;
  int neuronaSalida = 0;
  int nPatrones = 0;
  String rata = '';
  String iteraciones = '';
  String erms = '';
  bool activacion = false;
  String _opcionSeleccionada = 'Rampa';
  List patrones = [];

  List<String> _fActivacion = ['Rampa', 'Escalon' ];

  @override
  Widget build(BuildContext context) {

    convertirCsv();

    return Scaffold(
      appBar: AppBar(
        title: Text('SIMULACION DATOS', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
        actions: [
          IconButton(
            icon: Icon(Icons.file_present_rounded, size: 32,),
            onPressed: () => pickerCvs(),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20,),
            Text('PESOS', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
            SizedBox(height: 10,),
            MostrarPeso(peso: peso),
            SizedBox(height: 20,),
            DatosCsv(neuronaEntrada: neuronaEntrada, neuronaSalida: neuronaSalida, nPatrones: nPatrones),
            SizedBox(height: 20,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: double.infinity,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                iteraciones = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              hintText: 'Numero de iteraciones',
                              labelText: 'Iteraciones',
                              helperText: 'Numero entero'
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                rata = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              hintText: 'Rata de aprendizaje',
                              labelText: 'Rata',
                              helperText: 'Numero de 0 a 1'
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                erms = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              hintText: 'Error maximo permitido',
                              labelText: 'IRMS',
                              helperText: 'Valor de 0 a 1',
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                         Expanded(
                         child:  _crearDropdown(),
                        ),
                      ],
                    ),
                  ]
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          List wpeso = peso[0];
          print(wpeso);
          Navigator.push(context, MaterialPageRoute( builder: (context) => EntrenamientoPage(
            erms: erms, iteraciones: iteraciones, nPatrones: nPatrones, neuronaEntrada: neuronaEntrada, neuronaSalida: neuronaSalida,
            patron: patrones, peso: wpeso, rata: rata, activacion: activacion,
          ))); 
        },
        child: Icon(Icons.play_arrow),
      ),
    );
  }

    convertirCsv() async{
    final csvFile = new File(widget.path).openRead();
    final data = await csvFile
    .transform(utf8.decoder)
    .transform(CsvToListConverter()).toList();
    setState(() {
      peso = data;
    });
  }


  pickerCvs() async{
    final FilePickerResult? picked = await FilePicker.platform.pickFiles(
      allowedExtensions: ['csv'],
      type: FileType.custom
    );

    if( picked == null ) {
      print('no selecciono nada');
      return;
    }
    print('Tenemos datos ${ picked.paths }');
              
    PlatformFile file = picked.files.first;

    final csvFile = new File(file.path!).openRead();
              
    final fields = await csvFile
    .transform(utf8.decoder)
    .transform(new CsvToListConverter())
    .toList();

    print(fields);

    entrada(fields);

  }

  entrada(List entrada){
    
    List tipoValor = [];
    

    neuronaEntrada = 0;
    neuronaSalida = 0;
    tipoValor = entrada[0];
    entrada.removeAt(0);
    patrones = entrada;
    print('entrada $tipoValor');
    print('patrones ${patrones.length}');
    nPatrones = patrones.length;

    int x = tipoValor.length;
    print(x);
    for(int j = 0; j <= x-1; j++){
      String dato = tipoValor[j];
      if(dato[0] == 'x'){
        neuronaEntrada++;
      }else if(dato[0] == 'y'){
        neuronaSalida++;
      }
    }
    setState(() {
      
    });
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {

      List<DropdownMenuItem<String>> lista = [];

      _fActivacion.forEach( (activacion){

        lista.add( DropdownMenuItem(
          child: Text(activacion),
          value: activacion,
        ));
      });

    return lista;
  }

   Widget _crearDropdown() {

    return Row(
      children: <Widget>[
        Icon(Icons.select_all),
        SizedBox(width: 30.0),   
        Expanded(
          child: DropdownButton(
            value: _opcionSeleccionada,
            items: getOpcionesDropdown(),
            onChanged: (opt) {
              setState(() {
                _opcionSeleccionada = opt.toString();
              });
              if( _opcionSeleccionada == 'Rampa' ){
                activacion = false;
              }else if( _opcionSeleccionada == 'Escalon' ){
                activacion = true;
              }
              setState(() {});
            },
          ),
        )

      ],
    );
  }

}

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

