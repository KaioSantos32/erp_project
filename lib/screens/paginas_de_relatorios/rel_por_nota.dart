import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/functions/funcoes_excel/relatorio_por_nota.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:flutter/material.dart';

class RelatorioPorNota extends StatefulWidget {
  const RelatorioPorNota({super.key});

  @override
  State<RelatorioPorNota> createState() => _RelatorioPorNotaState();
}

class _RelatorioPorNotaState extends State<RelatorioPorNota> {
  final notaInicial = TextEditingController();

  final notaFinal = TextEditingController();
  int tipoEntidade = 0;


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: notaInicial,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(),
            labelText: 'Nota Inicial',
            prefix: Text("De: "),
          ),
        ),
        PersonalizedSpacer(amountSpaceHorizontal: 10),
        TextField(
          controller: notaFinal,
          decoration: const InputDecoration(
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(),
            labelText: 'Nota Final',
            prefix: Text("Até: "),
          ),
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
            if (notaInicial.text.isNotEmpty && notaFinal.text.isNotEmpty) {
              criarXlsxPorNota(notaInicial.text, notaFinal.text, tipoEntidade);
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
