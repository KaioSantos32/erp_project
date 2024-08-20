import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/functions/funcoes_excel/relatorio_por_produto.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:flutter/material.dart';

class RelatorioPorProduto extends StatefulWidget {
  RelatorioPorProduto({super.key});

  @override
  State<RelatorioPorProduto> createState() => _RelatorioPorProdutoState();
}

class _RelatorioPorProdutoState extends State<RelatorioPorProduto> {
  TextEditingController nomeProduto = TextEditingController();

  TextEditingController dataInicial = TextEditingController();

  TextEditingController dataFinal = TextEditingController();
  int tipoEntidade = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: nomeProduto,
          decoration: const InputDecoration(
            fillColor: white,
            filled: true,
            border: OutlineInputBorder(),
            labelText: 'Nome do Produto',
          ),
        ),
        PersonalizedSpacer(amountSpaceHorizontal: 30),
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
        PersonalizedSpacer(amountSpaceHorizontal: 10),
        TextButton(
          onPressed: () {
            if (nomeProduto.text.isNotEmpty) {
              criarXlsxPorProduto(nomeProduto.text, dataInicial.text,
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
