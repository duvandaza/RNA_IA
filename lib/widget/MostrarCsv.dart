import 'package:flutter/material.dart';

class DatosCsv extends StatelessWidget {
  const DatosCsv({
    Key? key,
    required this.neuronaEntrada,
    required this.neuronaSalida,
    required this.nPatrones,
  }) : super(key: key);

  final int neuronaEntrada;
  final int neuronaSalida;
  final int nPatrones;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.black)
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('No entrada = $neuronaEntrada', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18 )),
          SizedBox(width: 14,),
          Text('No salida = $neuronaSalida', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18 )),
          SizedBox(width: 14,),
          Text('Patrones = $nPatrones', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18 )),    
        ],
      ),
    );
  }
  
}