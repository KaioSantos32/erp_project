import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/functions/funcoes_excel/relatorio_por_mes.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RelatorioPorMes extends StatefulWidget {
  RelatorioPorMes({super.key});

  int tipoEntidade = 0;

  @override
  State<RelatorioPorMes> createState() => _RelatorioPorMesState();
}

class _RelatorioPorMesState extends State<RelatorioPorMes> {
  final dataInicial = TextEditingController();
  final dataFinal = TextEditingController();

  TextEditingValue test = const TextEditingValue();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: dataInicial,
          decoration: const InputDecoration(
            fillColor: white,
            filled: true,
            border: OutlineInputBorder(),
            labelText: 'Data Inicial',
            prefix: Text("De: "),
          ),
          onChanged: (dataInicialInterna) {
            var dataAnalisada = dataInicial.text.replaceAll("/", "");
            if (dataAnalisada.length >= 8) {
              var dia = dataAnalisada.substring(0, 2);
              var mes = dataAnalisada.substring(2, 4);
              var ano = dataAnalisada.substring(4, 8);
              dataInicial.text = "$dia/$mes/$ano";
              setState(() {});
            } else {
              dataInicial.text = dataInicial.text;
            }
          },
        ),
        PersonalizedSpacer(amountSpaceHorizontal: 10),
        TextField(
          controller: dataFinal,
          decoration: const InputDecoration(
            fillColor: white,
            filled: true,
            border: OutlineInputBorder(),
            labelText: 'Data Final',
            prefix: Text("Até: "),
          ),
          onChanged: (dataFinalInterna) {
            var dataAnalisada = dataFinal.text.replaceAll("/", "");
            if (dataAnalisada.length >= 8) {
              var dia = dataAnalisada.substring(0, 2);
              var mes = dataAnalisada.substring(2, 4);
              var ano = dataAnalisada.substring(4, 8);
              dataFinal.text = "$dia/$mes/$ano";
              setState(() {});
            } else {
              dataInicial.text = dataInicial.text;
            }
          },
        ),
        PersonalizedSpacer(amountSpaceHorizontal: 30),
        Row(
          children: [
            const Text("Entrada"),
            Radio(
              value: 0,
              groupValue: widget.tipoEntidade,
              onChanged: (value) {
                widget.tipoEntidade = 0;
                setState(() {});
              },
            ),
            PersonalizedSpacer(amountSpaceHorizontal: 20),
            const Text("Saida"),
            Radio(
              value: 1,
              groupValue: widget.tipoEntidade,
              onChanged: (value) {
                widget.tipoEntidade = 1;
                setState(() {});
              },
            ),
          ],
        ),
        PersonalizedSpacer(amountSpaceHorizontal: 30),
        TextButton(
            onPressed: () {
              if (dataInicial.text.isNotEmpty && dataFinal.text.isNotEmpty) {
                criarXlsxPorMes(dataInicial.text, dataFinal.text, widget.tipoEntidade);
              }
            },
            child: Text(
              "Gerar relatório",
              style: textMidImportance(color: darkGreen),
            ))
      ],
    );
  }
}
