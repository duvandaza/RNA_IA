import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:perceptron/models/models.dart';

import 'package:perceptron/page/entrenamiento_page.dart';
import 'package:perceptron/widget/MostrarCsv.dart';
import 'package:perceptron/widget/widget.dart';


class CsvDataPage extends StatefulWidget {
  CsvDataPage({Key? key}) : super(key: key);

  @override
  _CsvDataPageState createState() => _CsvDataPageState();
}

class _CsvDataPageState extends State<CsvDataPage> {

  String _opcionSeleccionada = 'Rampa';
  String peso1 = '';
  String peso2 = '';
  String pesoP = '';

  List pesoPruba = [];
  List<List> pesoMatriz =[];

  List<String> _fActivacion = ['Rampa', 'Escalon' ];

  final datosRna = DatosRNA();

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
            DatosCsv(neuronaEntrada: datosRna.nEntrada, neuronaSalida: datosRna.nSalida, nPatrones: datosRna.numeroPatrones),
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
                                datosRna.iteraciones = value;
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
                                datosRna.rata = value;
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
                                datosRna.erms = value;
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
                    SizedBox(height: 20,),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            onChanged: (value) {
                              setState(() {
                                pesoP = value;
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
                        Container(
                          padding: EdgeInsets.only(bottom: 18),
                          child: MaterialButton(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            disabledColor: Colors.grey,
                            elevation: 0,
                            color: Colors.blue,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                              child: Text('Agregar peso', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                            ),
                            onPressed: (){
                              if(pesoP != ''){
                                if(pesoPruba.length <= datosRna.nEntrada-1){
                                  print('paso');
                                  setState(() {
                                    pesoPruba.add(double.tryParse(pesoP));
                                    print('$pesoPruba');
                                  });

                                }
                              }
                            },
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    (pesoPruba.isNotEmpty) ? Table(
                      border: TableBorder.all(width: 1.0),
                      children: [
                        TableRow(
                          children: pesoPruba.map((e) {
                            return Center(
                              child: Text(e.toStringAsFixed(3), style: TextStyle(fontSize: 20),)
                            );
                          }).toList()
                        )
                      ],
                    ) : Container(),
                  ]
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          datosRna.peso = [];
          datosRna.peso.add(double.tryParse(peso1));
          datosRna.peso.add(double.tryParse(peso2));
          Navigator.push(context, MaterialPageRoute( builder: (context) => EntrenamientoPage( datosRNA: datosRna, ))); 
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
    

    datosRna.nEntrada = 0;
    datosRna.nSalida = 0;
    tipoValor = entrada[0];
    entrada.removeAt(0);
    datosRna.patrones = entrada;
    print('entrada $tipoValor');
    print('patrones ${datosRna.patrones.length}');
    datosRna.numeroPatrones = datosRna.patrones.length;

    int x = tipoValor.length;
    print(x);
    for(int j = 0; j <= x-1; j++){
      String dato = tipoValor[j];
      if(dato[0] == 'x'){
        datosRna.nEntrada++;
      }else if(dato[0] == 'y'){
        datosRna.nSalida++;
      }
    }

    setState(() {
      datosRna.nEntrada;
      datosRna.nSalida;
      datosRna.patrones;
    });

    print('Numero de entrada $datosRna.nEntrada');
    print('Numero de salida $datosRna.nSalida');

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
                datosRna.activacion = false;
              }else if( _opcionSeleccionada == 'Escalon' ){
                datosRna.activacion = true;
              }
              setState(() {});
            },
          ),
        )

      ],
    );
  }



}





    

