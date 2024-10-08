import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyChartPage extends StatefulWidget {
  MyChartPage({
    super.key,
    required this.valoresAnoEntrada,
    required this.valoresAnoSaida,
    required this.valoresAnoLiquido,
    required this.mostraValor,
  });

  List valoresAnoEntrada;
  List valoresAnoSaida;
  List valoresAnoLiquido;
  bool mostraValor;

  @override
  MyChartPageState createState() => MyChartPageState();
}

class MyChartPageState extends State<MyChartPage> {
  @override
  Widget build(BuildContext context) {
    List<SalesData> compras = [
      SalesData('Jan', 154),
      SalesData('Feb', 124),
      SalesData('Mar', 86),
      SalesData('Apr', 266),
      SalesData('May', 500),
      SalesData('Jun', 700),
      SalesData('Jul', 70),
      SalesData('Ago', 854),
      SalesData('Set', 865),
      SalesData('Oct', 1200),
      SalesData('Nov', 1568),
      SalesData('Dec', 2876),
    ];

    /* exemplo de como deve ficar
     List<SalesData> compras = [
        SalesData('Jan', widget.valoresAnoEntrada[0]),
        SalesData('Feb', widget.valoresAnoEntrada[1]),
        SalesData('Mar', widget.valoresAnoEntrada[2]),
        SalesData('Apr', widget.valoresAnoEntrada[3]),
        SalesData('May', widget.valoresAnoEntrada[4]),
        SalesData('Jun', widget.valoresAnoEntrada[5]),
        SalesData('Jul', widget.valoresAnoEntrada[6]),
        SalesData('Ago', widget.valoresAnoEntrada[7]),
        SalesData('Set', widget.valoresAnoEntrada[8]),
        SalesData('Oct', widget.valoresAnoEntrada[9]),
        SalesData('Nov', widget.valoresAnoEntrada[10]),
        SalesData('Dec', widget.valoresAnoEntrada[11]),
      ];
    */
    List<SalesData> vendas = [
      SalesData('Jan', 265),
      SalesData('Feb', 364),
      SalesData('Mar', 1545),
      SalesData('Apr', 280),
      SalesData('May', 654),
      SalesData("Jun", 799),
      SalesData("Jul", 321),
      SalesData("Ago", 1243),
      SalesData("Set", 1224),
      SalesData("Oct", 1579),
      SalesData("Nov", 2655),
      SalesData("Dec", 3546),
    ];
    /*
     List<SalesData> vendas = [
      SalesData('Jan', widget.valoresAnoSaida[0]),
      SalesData('Feb', widget.valoresAnoSaida[1]),
      SalesData('Mar', widget.valoresAnoSaida[2]),
      SalesData('Apr', widget.valoresAnoSaida[3]),
      SalesData('May', widget.valoresAnoSaida[4]),
      SalesData("Jun", widget.valoresAnoSaida[5]),
      SalesData("Jul", widget.valoresAnoSaida[6]),
      SalesData("Ago", widget.valoresAnoSaida[7]),
      SalesData("Set", widget.valoresAnoSaida[8]),
      SalesData("Oct", widget.valoresAnoSaida[9]),
      SalesData("Nov", widget.valoresAnoSaida[10]),
      SalesData("Dec", widget.valoresAnoSaida[11]),
    ]; */
    List<SalesData> liquido = [
      SalesData('Jan', 265 - 154),
      SalesData('Feb', 364 - 124),
      SalesData('Mar', 1545 - 86),
      SalesData('Apr', 280 - 266),
      SalesData('May', 654 - 500),
      SalesData("Jun", 799 - 700),
      SalesData("Jul", 321 - 70),
      SalesData("Ago", 1243 - 854),
      SalesData("Set", 1224 - 865),
      SalesData("Oct", 1579 - 1200),
      SalesData("Nov", 2655 - 1568),
      SalesData("Dec", 3546 - 2876),
    ];
    /* 
   List<SalesData> liquido = [
      SalesData('Jan', widget.valoresAnoLiquido[0]),
      SalesData('Feb', widget.valoresAnoLiquido[1]),
      SalesData('Mar', widget.valoresAnoLiquido[2]),
      SalesData('Apr', widget.valoresAnoLiquido[3]),
      SalesData('May', widget.valoresAnoLiquido[4]),
      SalesData("Jun", widget.valoresAnoLiquido[5]),
      SalesData("Jul", widget.valoresAnoLiquido[6]),
      SalesData("Ago", widget.valoresAnoLiquido[7]),
      SalesData("Set", widget.valoresAnoLiquido[8]),
      SalesData("Oct", widget.valoresAnoLiquido[9]),
      SalesData("Nov", widget.valoresAnoLiquido[10]),
      SalesData("Dec", widget.valoresAnoLiquido[11]),
    ];
  */

    return Scaffold(
      body: Column(children: [
        SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          title: const ChartTitle(text: 'Valores no ano'),
          legend: const Legend(isVisible: true),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<SalesData, String>>[
            LineSeries<SalesData, String>(
              animationDuration: 200,
              color: Colors.green[600],
              dataSource: vendas,
              name: 'Venda',
              width: 5,
              xValueMapper: (SalesData sales, _) => sales.month,
              yValueMapper: (SalesData sales, _) => sales.sales,
              dataLabelSettings: DataLabelSettings(
                  isVisible: widget.mostraValor,
                  color: Colors.green,
                  textStyle: const TextStyle(color: Colors.white)),
            ),
            LineSeries<SalesData, String>(
              animationDuration: 200,
              color: Colors.red[600],
              dataSource: compras,
              name: 'Compra',
              width: 5,
              xValueMapper: (SalesData sales, _) => sales.month,
              yValueMapper: (SalesData sales, _) => sales.sales,
              dataLabelSettings: DataLabelSettings(
                  isVisible: widget.mostraValor,
                  color: Colors.red.withOpacity(.1)),
            ),
            LineSeries<SalesData, String>(
              animationDuration: 200,
              color: Colors.blue[600],
              dataSource: liquido,
              dataLabelSettings: DataLabelSettings(
                  isVisible: widget.mostraValor, color: Colors.blue),
              name: 'Líquido',
              width: 5,
              xValueMapper: (SalesData sales, _) => sales.month,
              yValueMapper: (SalesData sales, _) => sales.sales,
            ),
          ],
        ),
      ]),
    );
  }
}

class SalesData {
  SalesData(this.month, this.sales);

  final String month;
  final double sales;
}
