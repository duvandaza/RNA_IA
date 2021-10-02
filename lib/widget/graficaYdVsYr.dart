import 'package:flutter/material.dart';
import 'package:perceptron/models/YrvVsYd_models.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraficaYdVsYr extends StatefulWidget {
  const GraficaYdVsYr({
    Key? key,
    required List<PerceptronYd> charYd,
    required List<PerceptronYr> charYr,
  }) : listacharYd = charYd, listacharYr = charYr, super(key: key);

  final List<PerceptronYd> listacharYd;
  final List<PerceptronYr> listacharYr;

  @override
  _GraficaYdVsYrState createState() => _GraficaYdVsYrState();
}

class _GraficaYdVsYrState extends State<GraficaYdVsYr> {

  List<PerceptronYr> _charYr = [];
  List<PerceptronYd> _charYd = [];

  @override
  void initState() {
    _charYd = getChartYd();
    _charYr = getChartYr();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 400,
      child: SfCartesianChart(
        title: ChartTitle(
          text: 'Grafica YD VS YR'
        ),
        legend: Legend(isVisible: true),
        series: <LineSeries>[
          LineSeries<PerceptronYr, double>(
            dataSource: _charYr,
            xValueMapper: (PerceptronYr data, _) => data.inter.toDouble(),
            yValueMapper: (PerceptronYr data, _) => data.data,
            dataLabelSettings: DataLabelSettings(isVisible: true,),
            name: 'YR',
          ),
          LineSeries<PerceptronYd, double>(
            dataSource: _charYd,
            xValueMapper: (PerceptronYd data, _) => data.interacion.toDouble(),
            yValueMapper: (PerceptronYd data, _) => data.dato,
            dataLabelSettings: DataLabelSettings(isVisible: true,),
            name: 'YD',
          ),
        ],
        primaryXAxis: CategoryAxis(),
      )
    );
  }

  List<PerceptronYr> getChartYr(){
    final List<PerceptronYr> chartYr = widget.listacharYr;
    return chartYr;
  }

  List<PerceptronYd> getChartYd(){
    final List<PerceptronYd> chartYd = widget.listacharYd;
    return chartYd;
  }

}

