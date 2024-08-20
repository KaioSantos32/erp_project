// ignore_for_file: must_be_immutable
import 'package:erp/functions/busca_valores_home_screen.dart';
import 'package:erp/widgets/chart.dart';
import 'package:erp/widgets/home_screen_info_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  var totalMesEntrada = 0.0;
  var totalMesSaida = 0.0;
  var totalMesLiquido = 0.0;

  List<dynamic> valoresAnoEntrada = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ];
  List<dynamic> valoresAnoSaida = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ];
  List<dynamic> valoresAnoLiquido = [
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Toda vez que entrar na tela "HomeScreen" os valores são zerados para serem atualizados
  // Deixar fora do state não zera

  var continuar = 0;

  @override
  Widget build(BuildContext context) {
    var notasDeEntrada = buscaValoresHomeScreen();
    DateTime dataAtual = DateTime.now();
    var mes = dataAtual.month;

    notasDeEntrada.then((value) {
      // atualizando os valores da homescreen
      try {
        if (continuar == 0) {
          setState(() {});
          widget.totalMesEntrada = value[0][mes - 1];
          widget.totalMesSaida = value[1][mes - 1];
          widget.totalMesLiquido = value[2][mes - 1];

          widget.valoresAnoEntrada = value[0];
          widget.valoresAnoSaida = value[1];
          widget.valoresAnoLiquido = value[2];

          // Fazendo com que os valores sejam atualizados apenas 1 vez (ou poucas vezes)
          // NAO RETIRAR ESSE CAP

          continuar = 1;
        }
      } catch (e){debugPrint("$e");}
    });

    return HomePage(
      totalMesEntrada: widget.totalMesEntrada,
      totalMesSaida: widget.totalMesSaida,
      totalMesLiquido: widget.totalMesLiquido,
      valoresAnoEntrada: widget.valoresAnoEntrada,
      valoresAnoSaida: widget.valoresAnoSaida,
      valoresAnoLiquido: widget.valoresAnoLiquido,
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
    required this.totalMesEntrada,
    required this.totalMesSaida,
    required this.totalMesLiquido,
    required this.valoresAnoEntrada,
    required this.valoresAnoSaida,
    required this.valoresAnoLiquido,
  });

  double totalMesEntrada;
  double totalMesSaida;
  double totalMesLiquido;

  List valoresAnoEntrada;
  List valoresAnoSaida;
  List valoresAnoLiquido;

  bool mostraValor = false;
  Icon mostraValorIcon = const Icon(Icons.remove_red_eye);
  String tooltipText = "Mostrar Valores";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            WidgetInfo(
                label: "Compra",
                total: (widget.totalMesEntrada).toStringAsFixed(2)),
            WidgetInfo(
                label: "Venda",
                total: (widget.totalMesSaida).toStringAsFixed(2)),
            WidgetInfo(
                label: "Líquido",
                total: (widget.totalMesLiquido).toStringAsFixed(2)),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      widget.mostraValor = !widget.mostraValor;
                      if (widget.mostraValor) {
                        widget.mostraValorIcon = const Icon(Icons.close);
                        widget.tooltipText = "Esconder Valores";
                      } else {
                        widget.mostraValorIcon =
                            const Icon(Icons.remove_red_eye);
                        widget.tooltipText = "Mostrar Valores";
                      }
                    });
                  },
                  tooltip: widget.tooltipText,
                  icon: widget.mostraValorIcon),
              SizedBox(
                height: 450,
                child: MyChartPage(
                  valoresAnoEntrada: widget.valoresAnoEntrada,
                  valoresAnoSaida: widget.valoresAnoSaida,
                  valoresAnoLiquido: widget.valoresAnoLiquido,
                  mostraValor: widget.mostraValor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
