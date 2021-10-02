import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:perceptron/page/entrenamiento_page.dart';
import 'package:perceptron/widget/MostrarCsv.dart';

class CsvDataPage extends StatefulWidget {
  CsvDataPage({Key? key}) : super(key: key);

  @override
  _CsvDataPageState createState() => _CsvDataPageState();
}

class _CsvDataPageState extends State<CsvDataPage> {

  int neuronaEntrada = 0;
  int neuronaSalida = 0;
  int nPatrones = 0;
  String rata = '';
  String iteraciones = '';
  String erms = '';
  String peso1 = '';
  String peso2 = '';
  List patrones = [];
  List peso = [];
  bool activacion = false;
  String _opcionSeleccionada = 'Rampa';

  List<String> _fActivacion = ['Rampa', 'Escalon' ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Datos Entrenamiento', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
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
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                peso1 = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              hintText: 'Valor de peso 1',
                              labelText: 'Peso 1',
                              helperText: 'Valor de -1 a 1',
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
                                peso2 = value;
                              });
                            },
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)
                              ),
                              hintText: 'valor del peso 2',
                              labelText: 'Peso 2',
                              helperText: 'Valor de -1 a 1',
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
          peso = [];
          peso.add(double.tryParse(peso1));
          peso.add(double.tryParse(peso2));
          Navigator.push(context, MaterialPageRoute( builder: (context) => EntrenamientoPage(
            erms: erms, iteraciones: iteraciones, nPatrones: nPatrones, neuronaEntrada: neuronaEntrada, neuronaSalida: neuronaSalida,
            patron: patrones, peso: peso, rata: rata, activacion: activacion,
          ))); 
        },
        child: Icon(Icons.play_arrow),
      ),
    );
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
      neuronaEntrada;
      neuronaSalida;
      nPatrones;
    });

    print('Numero de entrada $neuronaEntrada');
    print('Numero de salida $neuronaSalida');

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





    

