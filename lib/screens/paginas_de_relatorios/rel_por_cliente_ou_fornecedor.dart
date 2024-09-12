import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/functions/funcoes_excel/relatorio_por_cliente.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:flutter/material.dart';

class RelatorioPorCompraOuVenda extends StatefulWidget {
  const RelatorioPorCompraOuVenda({super.key});

  @override
  State<RelatorioPorCompraOuVenda> createState() =>
      _RelatorioPorCompraOuVendaState();
}

class _RelatorioPorCompraOuVendaState extends State<RelatorioPorCompraOuVenda> {
  final nomeCliente = TextEditingController();
  final dataInicial = TextEditingController();
  final dataFinal = TextEditingController();
  int tipoEntidade = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nomeCliente,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(),
            labelText: 'Nome do Cliente',
          ),
        ),
        PersonalizedSpacer(amountSpaceHorizontal: 30),
        TextField(
          controller: dataInicial,
          decoration: const InputDecoration(
            fillColor: Colors.white,
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
            fillColor: Colors.white,
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
              dataFinal.text = dataFinal.text;
            }
          },
        ),
        PersonalizedSpacer(amountSpaceHorizontal: 30),
        Row(
          children: [
            const Text("Entrada"),
            Radio(
              value: 0,
              groupValue: tipoEntidade,
              onChanged: (value) {
                tipoEntidade = 0;
                setState(() {});
              },
            ),
            PersonalizedSpacer(amountSpaceHorizontal: 20),
            const Text("Saida"),
            Radio(
              value: 1,
              groupValue: tipoEntidade,
              onChanged: (value) {
                tipoEntidade = 1;
                setState(() {});
              },
            ),
          ],
        ),
        PersonalizedSpacer(amountSpaceHorizontal: 30),
        TextButton(
          onPressed: () {
            if (nomeCliente.text.isNotEmpty) {
              criarXlsxPorCliente(nomeCliente.text, dataInicial.text,
                  dataFinal.text, tipoEntidade);
            }
          },
          child: Text(
            "Gerar relatório",
            style: textMidImportance(color: darkGreen),
          ),
        )
      ],
    );
  }
}
