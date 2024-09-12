import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/functions/busca_nota.dart';
import 'package:erp/functions/ler_xml.dart';
import 'package:erp/functions/funcoes_mongo/mongodb_actions.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:flutter/material.dart';

class EntraNotaEntradaScreen extends StatefulWidget {
  const EntraNotaEntradaScreen({super.key});

  @override
  State<EntraNotaEntradaScreen> createState() => _EntraNotaEntradaScreenState();
}

class _EntraNotaEntradaScreenState extends State<EntraNotaEntradaScreen> {
  var notas = mongoPegaTodasNotas(
      tipoNota: 0, limite: 30, cancelada: false, despesa: false);

  final txtEditNumeroNota = TextEditingController();
  final nomeFornecedor = TextEditingController();
  final dataInicial = TextEditingController();
  final nomeProduto = TextEditingController();
  final dataFinal = TextEditingController();

  bool switchDespesa = false;
  bool switchCancelada = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 200,
                child: TextField(
                  controller: txtEditNumeroNota,
                  onChanged: (value) {
                    setState(() {
                      notas = atualizaTabela(notas);
                    });
                  },
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Número de Nota',
                    prefix: Text("NF "),
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  controller: nomeFornecedor,
                  onChanged: (value) {
                    setState(() {
                      notas = atualizaTabela(notas);
                    });
                  },
                  decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Nome do Fornecedor'),
                ),
              ),
              SizedBox(
                width: 150,
                child: TextField(
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
                      setState(() {
                        notas = atualizaTabela(notas);
                      });
                    } else {
                      dataInicial.text = dataInicial.text;
                    }
                  },
                ),
              ),
              SizedBox(
                width: 150,
                child: TextField(
                  controller: dataFinal,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Data Final',
                    prefix: Text("Até: "),
                  ),
                  onChanged: (dataInicialInterna) {
                    var dataAnalisada = dataFinal.text.replaceAll("/", "");
                    if (dataAnalisada.length >= 8) {
                      var dia = dataAnalisada.substring(0, 2);
                      var mes = dataAnalisada.substring(2, 4);
                      var ano = dataAnalisada.substring(4, 8);
                      dataFinal.text = "$dia/$mes/$ano";
                      setState(() {
                        notas = atualizaTabela(notas);
                      });
                    }
                  },
                ),
              ),
              FilledButton(
                onPressed: () {
                  setState(() {
                    notas = mongoPesquisaNota(
                      tipoNota: 0,
                      numeroNota: txtEditNumeroNota.text,
                      nomeFornecedor: nomeFornecedor.text,
                      dataInicial: dataInicial.text,
                      dataFinal: dataFinal.text,
                      nomeProduto: nomeProduto.text,
                      despesa: switchDespesa,
                      cancelada: switchCancelada,
                    );
                  });
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                  backgroundColor: darkGreen,
                  shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                ),
                child: const Icon(Icons.search),
              ),
              FilledButton(
                onPressed: () {
                  lerXml(0, context);
                  setState(() {
                    notas = atualizaTabela(notas);
                  });
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                  backgroundColor: darkGreen,
                  shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                ),
                child: const Text("Entrar nota"),
              ),
            ],
          ),
          PersonalizedSpacer(amountSpaceHorizontal: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 500,
                child: TextField(
                  controller: nomeProduto,
                  onChanged: (value) {
                    setState(() {
                      notas = atualizaTabela(notas);
                    });
                  },
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Nome do Produto',
                  ),
                ),
              ),
              SizedBox(
                width: 400,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Despesa?",
                      style: textLowImportance(),
                    ),
                    Switch(
                      value: switchDespesa,
                      inactiveThumbColor: darkYellow,
                      activeColor: darkYellow,
                      onChanged: (bool value) {
                        setState(() {
                          switchDespesa = value;
                          notas = atualizaTabela(notas);
                        });
                      },
                    ),
                    Text("Cancelada?", style: textLowImportance()),
                    Switch(
                      value: switchCancelada,
                      inactiveThumbColor: darkRed,
                      activeColor: defaultRed,
                      onChanged: (bool value) {
                        setState(() {
                          switchCancelada = value;
                          notas = atualizaTabela(notas);
                        });
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
          PersonalizedSpacer(amountSpaceHorizontal: 20),
          SizedBox(
            width: 1300,
            height: MediaQuery.sizeOf(context).height / 1.5,
            child: SingleChildScrollView(
              child: MontaTabelaDeNotas(
                notas: notas,
                tipoNota: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  atualizaTabela(notas) {
    if (txtEditNumeroNota.text != "" ||
        nomeFornecedor.text != "" ||
        dataInicial.text != "" ||
        dataFinal.text != "" ||
        nomeProduto.text != "") {
      notas = mongoPesquisaNota(
        tipoNota: 0,
        numeroNota: txtEditNumeroNota.text,
        nomeFornecedor: nomeFornecedor.text,
        dataInicial: dataInicial.text,
        dataFinal: dataFinal.text,
        nomeProduto: nomeProduto.text,
        despesa: switchDespesa,
        cancelada: switchCancelada,
      );
      return notas;
    } else {
      notas = mongoPegaTodasNotas(
          tipoNota: 0,
          limite: 30,
          cancelada: switchCancelada,
          despesa: switchDespesa);
      return notas;
    }
  }
}
