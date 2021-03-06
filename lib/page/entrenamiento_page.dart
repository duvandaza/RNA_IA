import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:path_provider/path_provider.dart';
import 'package:perceptron/models/models.dart';

import 'package:perceptron/widget/graficaYdVsYr.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class EntrenamientoPage extends StatefulWidget {
  
  final DatosRNA datosRNA;

  const EntrenamientoPage({Key? key, 
    required this.datosRNA
  }) : super(key: key);

  @override
  _EntrenamientoPageState createState() => _EntrenamientoPageState();
}

class _EntrenamientoPageState extends State<EntrenamientoPage> {

  List<PerceptronData> errorLineal = [];
  List <PerceptronYr>listaYr = [];
  List <PerceptronYd>listaYd = [];
  
  List epatron = [];
  List<PerceptronData> _charData = [];
  

  final storage = FlutterSecureStorage();

  @override
  void initState() {
    _charData = getChartData();
    super.initState();
  }
  

  @override
  Widget build(BuildContext context) {

    entrenamiento();

    return Scaffold(
      appBar: AppBar(
        title: Text('Entrenamiento', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu_open, size: 32,),
            onPressed: () {
              Navigator.pushNamed(context, 'home');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 20,),
              Text('Grafica Error de la iteracion', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 22 ),),
              SizedBox(height: 5,),
              Grafica(charData: _charData),
              SizedBox(height: 10,),
              Text('ULTIMOS PESOS', style: TextStyle( fontWeight: FontWeight.bold, fontSize: 18 ),),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('VAN LOS PESOS')
                ],
              ),
              SizedBox(height: 20,),
              GraficaYdVsYr(charYd: listaYd, charYr: listaYr)
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          List<List> data = [
            widget.datosRNA.peso
          ];
          String csvData = ListToCsvConverter().convert(data);
          final String directorio = (await getExternalStorageDirectory())!.path;
          final path = "$directorio/csv-${DateTime.now()}.csv";
          print(path);
          final File file = File(path);
          await file.writeAsString(csvData);
        },
        child: Icon(Icons.save_outlined),
      )
    );
  }



  void entrenamiento() {
    int go = 1;

    List pruebayr = [];

    listaYd = [];

    for(int p = 0; p<= widget.datosRNA.numeroPatrones-1; p++ ){
      listaYd.add(PerceptronYd(p+1, widget.datosRNA.patrones[p][widget.datosRNA.nEntrada].toDouble()));
    }
    
    setState(() {
      
    });
    
    while( go <= int.parse(widget.datosRNA.iteraciones) ){
      epatron = [];
      listaYr = [];
      for(int j = 0; j <= widget.datosRNA.numeroPatrones-1; j++ ){
        double soma = 0;
        for(int x = 0; x <= widget.datosRNA.nEntrada-1; x++ ){
          soma += widget.datosRNA.patrones[j][x] * widget.datosRNA.peso[x];
        }
        print('soma = $soma');
        double valorYr = 0;
        if(widget.datosRNA.activacion == false){
          if(soma < 0 ){
            valorYr = 0;
          }else if(soma >= 0 || soma <= 1){
            valorYr = soma;
          }else if(soma > 1){
            valorYr = 1;
          }
        }else if(widget.datosRNA.activacion == true){
          if(soma >= 0){
            valorYr = 1;
          }else if(soma < 0 ){
            valorYr = 0;
          }
        }
        print('yr = $valorYr');
        setState(() {
          listaYr.add(PerceptronYr(j+1, valorYr));
          pruebayr.add([j+1, valorYr]);
        });
        
        double elineal = widget.datosRNA.patrones[j][widget.datosRNA.nEntrada].toDouble() - valorYr;
        print('el = $elineal');
        double ep = elineal / widget.datosRNA.nSalida;
        epatron.add(ep);
        print('ep = $ep');
        for(int p = 0; p <= widget.datosRNA.peso.length-1; p++){
          widget.datosRNA.peso[p] = widget.datosRNA.peso[p] + double.tryParse(widget.datosRNA.rata)! * elineal * widget.datosRNA.patrones[j][p];
        }
        print('peso = ${widget.datosRNA.peso}');
      }
      print('ep = $epatron');
      double sumaEp = 0;
      for(int e = 0; e <= epatron.length-1;e++){
        sumaEp += epatron[e];
      }
      double errorIte = 0;
      errorIte = sumaEp / widget.datosRNA.numeroPatrones;
      setState(() {
        errorLineal.add(PerceptronData(go, errorIte));
        Duration(seconds: 5);
      });
      print('ERMS = $errorIte');
      if(errorIte <= double.tryParse(widget.datosRNA.erms)!){
        go = int.parse(widget.datosRNA.iteraciones);
      }
      go++;
    }
    print('ERMS =  $errorLineal' );
    print('Yr = $listaYr');
    print('yd = $listaYd');
    print('PRUEBA = $pruebayr');
  }

  List<PerceptronData> getChartData(){
    final List<PerceptronData> chartData = errorLineal;
    return chartData;
  }

  

}



class TrearPeso extends StatelessWidget {
  const TrearPeso({
    Key? key,
    required this.peso,
    required this.numero
  }) : super(key: key);

  final double peso;
  final int numero;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black)
          ),
          child: Center(child: Text('W$numero')),
        ),
        Container(
          width: 50,
          height: 30,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black)
          ),
          child: Center(child: Text('${peso.toStringAsFixed(3)}')),
        ),
      ],
    );
  }
}

class PerceptronData{
  
  PerceptronData(this.interacion, this.dato);

  final int interacion;
  final double dato;

}




class Grafica extends StatelessWidget {
  const Grafica({
    Key? key,
    required List<PerceptronData> charData,
  }) : _charData = charData, super(key: key);

  final List<PerceptronData> _charData;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      child: SfCartesianChart(
        series: <ChartSeries>[
          LineSeries<PerceptronData, double>(
            dataSource: _charData,
            xValueMapper: (PerceptronData sales, _) => sales.interacion.toDouble(),
            yValueMapper: (PerceptronData sales, _) => sales.dato,
            dataLabelSettings: DataLabelSettings(isVisible: true,),
          )
        ],
        primaryXAxis: CategoryAxis(),
      ),
    );
  }
}
