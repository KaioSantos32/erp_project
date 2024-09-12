import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/functions/funcoes_mongo/excluir_nota.dart';
import 'package:erp/functions/nota_cancelada.dart';
import 'package:erp/functions/nota_despesa.dart';
import 'package:erp/functions/funcoes_mongo/mongodb_actions.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VerTodaNota extends StatelessWidget {
  VerTodaNota({super.key, required this.infoParaNota, required this.tipoNota});

  Map<String, dynamic> infoParaNota;
  int tipoNota;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: mostraNotaPesquisada(infoParaNota),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MostrarNotaFiscal(
              notaFiscal: snapshot.data[0],
              tipoNota: tipoNota,
              autoEntrada: infoParaNota["autoEntrada"]);
        } else {
          return const Scaffold(
            backgroundColor: scaffoldBackgroundColor,
            body: Center(child: SelectableText("ERRO AO PROCURAR NOTA")),
          );
        }
      },
    );
  }

  Future mostraNotaPesquisada(notaAPesquisar) async {
    var notaPesquisada = await mongoPesquisaNota(
        numeroNota: notaAPesquisar["nNf"]!,
        cnpj: notaAPesquisar["cnpj"],
        tipoNota: tipoNota,
        autoEntrada: notaAPesquisar["autoEntrada"]);
    return notaPesquisada;
  }
}

// ignore: must_be_immutable
class MostrarNotaFiscal extends StatelessWidget {
  MostrarNotaFiscal(
      {super.key,
      required this.notaFiscal,
      required this.tipoNota,
      required this.autoEntrada});

  final Map<String, dynamic> notaFiscal;
  final int tipoNota;
  final bool autoEntrada;
  // Se nota for entrada: Checar se é autoEntrada
  // se autoEntrada, usar empresaDestinataria
  // se não for, usar empresaEmissora
  // Se saida: usar EmpresaDestinataria

  var corTabela = Colors.white.withOpacity(.5);

  @override
  Widget build(BuildContext context) {
    List produtos = notaFiscal["produtos"];
    int quantidadeProdutos = produtos.length;
    Map vencimentos = notaFiscal["vencimentos"];
    int quantidadeVencimentos = vencimentos.length;
    var dia = DateTime.parse(notaFiscal["dhEmissao"]).day;
    var mes = DateTime.parse(notaFiscal["dhEmissao"]).month;
    var ano = DateTime.parse(notaFiscal["dhEmissao"]).year;

    if (notaFiscal["cancelada"]) {
      corTabela = Colors.red.withOpacity(.4);
    } else if (notaFiscal["despesa"]) {
      corTabela = Colors.yellow.withOpacity(.4);
    }

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.9),
      appBar: AppBar(
        backgroundColor: defaultGreen,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 32,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Center(
            child: SelectableText(
          "Nota de ${tipoNota == 0 ? "entrada" : "saida"} - ${notaFiscal["nf"]} ${notaFiscal["cancelada"] ? ""
              " - Cancelada" : ""} ${notaFiscal["despesa"] ? " - Despesa" : ""}",
          style: textHighImportance(font: 42, color: Colors.white),
        )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(children: [
            BotoesNotaFiscal(
              tipoNota: tipoNota,
              numeroNotaFiscal: notaFiscal['nf'],
              cnpj: tipoNota == 0
                  ? autoEntrada
                      ? notaFiscal["empresaDestinataria"]["cnpj"]
                      : notaFiscal["empresaEmissora"]["cnpj"]
                  : notaFiscal["empresaDestinataria"]["cnpj"],
              notaCancelada: notaFiscal["cancelada"],
              notaDespesa: notaFiscal["despesa"],
            ),
            PersonalizedSpacer(amountSpaceHorizontal: 40),
            Container(
              width: 1000,
              color: corTabela,
              child: Table(border: TableBorder.all(), children: [
                primeiraLinhaEmpresa(dia, mes, ano),
                segundaLinhaEndereco(),
                terceiraLinhaProdutos(quantidadeProdutos),
                const TableRow(children: [
                  Padding(padding: EdgeInsets.all(30)),
                ]),
                quartaLinhaTributos(),
                quintaLinhaVencimentos(quantidadeVencimentos),
              ]),
            ),
          ]),
        ),
      ),
    );
  }

  TableRow primeiraLinhaEmpresa(dynamic dia, int mes, int ano) {
    if (dia < 10) {
      dia = "0$dia";
    }

    return TableRow(
      children: [
        TableCell(
          child: Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tipoNota == 0
                              ? autoEntrada
                                  ? "Cliente"
                                  : "Fornecedor"
                              : "Cliente",
                          style: textLowImportance(),
                        ),
                        SelectionArea(
                            child: Text(
                          tipoNota == 0
                              ? autoEntrada
                                  ? notaFiscal["empresaDestinataria"]["nome"]
                                  : notaFiscal["empresaEmissora"]["nome"]
                              : notaFiscal["empresaDestinataria"]["nome"],
                          style: textLowImportance(),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CNPJ",
                          style: textLowImportance(),
                        ),
                        SelectionArea(
                            child: Text(
                          "${tipoNota == 0 // Nota é de entrada?
                              ? autoEntrada // Nota é autoEntrada?
                                  ? notaFiscal["empresaDestinataria"]["cnpj"] // se for autoEntrada
                                  : notaFiscal["empresaEmissora"]["cnpj"]     // se não for autoEntrada
                              : notaFiscal["empresaDestinataria"]["cnpj"]}",
                          style: textLowImportance(),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Emissão",
                          style: textLowImportance(),
                        ),
                        SelectionArea(
                            child: Text(
                          "$dia/${mes < 10 ? "0$mes" : mes}/$ano",
                          style: textLowImportance(),
                        )),
                      ],
                    ),
                  ),
                ]),
              ]),
        )
      ],
    );
  }

  TableRow segundaLinhaEndereco() {
    return TableRow(
      children: [
        TableCell(
          child: Table(
              columnWidths: const {
                0: FlexColumnWidth(3),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
              },
              border: TableBorder.all(),
              children: [
                TableRow(children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SelectionArea(
                            child: Text(
                          "Endereço: ${tipoNota == 0 ? autoEntrada ? notaFiscal["empresaDestinataria"]["endereco"]["rua"] : notaFiscal["empresaEmissora"]["endereco"]["rua"] : notaFiscal["empresaDestinataria"]["endereco"]["rua"]}, ${tipoNota == 0 ? autoEntrada ? notaFiscal["empresaDestinataria"]["endereco"]["numero"] : notaFiscal["empresaEmissora"]["endereco"]["numero"] : notaFiscal["empresaDestinataria"]["endereco"]["numero"]}",
                          style: textLowImportance(),
                        )),
                        SelectionArea(
                          child: Text(
                            "Bairro: ${tipoNota == 0 ? autoEntrada ? notaFiscal["empresaDestinataria"]["endereco"]["bairro"] : notaFiscal["empresaEmissora"]["endereco"]["bairro"] : notaFiscal["empresaDestinataria"]["endereco"]["bairro"]}",
                            style: textLowImportance(),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "CEP",
                          style: textLowImportance(),
                        ),
                        SelectionArea(
                            child: Text(
                          tipoNota == 0
                              ? autoEntrada
                                  ? notaFiscal["empresaDestinataria"]
                                      ["endereco"]["cep"]
                                  : notaFiscal["empresaEmissora"]["endereco"]
                                      ["cep"]
                              : notaFiscal["empresaDestinataria"]["endereco"]
                                  ["cep"],
                          style: textLowImportance(),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cidade:",
                          style: textLowImportance(),
                        ),
                        SelectionArea(
                            child: Text(
                          tipoNota == 0
                              ? autoEntrada
                                  ? notaFiscal["empresaDestinataria"]
                                      ["endereco"]["municipio"]
                                  : notaFiscal["empresaEmissora"]["endereco"]
                                      ["municipio"]
                              : notaFiscal["empresaDestinataria"]["endereco"]
                                  ["municipio"],
                          style: textLowImportance(),
                        )),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Estado:",
                          style: textLowImportance(),
                        ),
                        SelectionArea(
                            child: Text(
                          tipoNota == 0
                              ? autoEntrada
                                  ? notaFiscal["empresaEmissora"]["endereco"]
                                      ["uf"]
                                  : notaFiscal["empresaEmissora"]["endereco"]
                                      ["uf"]
                              : notaFiscal["empresaDestinataria"]["endereco"]
                                  ["uf"],
                          style: textLowImportance(),
                        )),
                      ],
                    ),
                  ),
                ]),
              ]),
        )
      ],
    );
  }

  TableRow terceiraLinhaProdutos(int quantidadeProdutos) {
    return TableRow(children: [
      TableCell(
          child: Table(children: [
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              "Produto(s)",
              style: textHighImportance(),
            ),
          ),
        ]),
        //Produtos -->
        for (var produto = 0; produto < quantidadeProdutos; produto++)
          TableRow(children: [
            Table(
                columnWidths: const {
                  0: FlexColumnWidth(4),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1),
                },
                // border: TableBorder.all(),
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: SelectionArea(
                          child: Text(
                        notaFiscal['produtos'][produto]["nome_produto"],
                        style: textLowImportance(font: 20),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            "Qntd.:",
                            style: textLowImportance(),
                          ),
                          SelectionArea(
                              child: Text(
                            double.parse(
                                    notaFiscal['produtos'][produto]["qTrib"])
                                .toStringAsFixed(2),
                            style: textLowImportance(),
                          )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            "Uni.:",
                            style: textLowImportance(),
                          ),
                          SelectionArea(
                              child: Text(
                            "${notaFiscal['produtos'][produto]["uTrib"]}",
                            style: textLowImportance(),
                          )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            "Total:",
                            style: textLowImportance(),
                          ),
                          SelectionArea(
                              child: Text(
                            "R\$ ${double.parse(notaFiscal['produtos'][produto]["vProd"]).toStringAsFixed(2)}",
                            style: textLowImportance(),
                          )),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          Text(
                            "\$/Uni.:",
                            style: textLowImportance(),
                          ),
                          SelectionArea(
                              child: Text(
                            "R\$ ${double.parse(notaFiscal['produtos'][produto]["vUnTrib"]).toStringAsFixed(2)}",
                            style: textLowImportance(),
                          )),
                        ],
                      ),
                    )
                  ])
                ])
          ])
      ]))
    ]);
  }

  TableRow quartaLinhaTributos() {
    return TableRow(children: [
      Table(children: [
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Valores e Tributos",
              style: textHighImportance(),
            ),
          )
        ]),
        TableRow(children: [
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(1),
              2: FlexColumnWidth(1),
              3: FlexColumnWidth(1),
              4: FlexColumnWidth(1),
              5: FlexColumnWidth(1),
              6: FlexColumnWidth(1),
            },
            border: TableBorder.all(),
            children: [
              TableRow(children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Base de Calculo ICMS",
                          style: textLowImportance(),
                        ),
                        SelectionArea(
                            child: Text(
                          "R\$ ${notaFiscal["valores"]["valorBaseCalculo"]}",
                          style: textLowImportance(),
                        )),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "ICMS",
                          style: textLowImportance(),
                        ),
                        SelectionArea(
                            child: Text(
                          "R\$ ${notaFiscal["valores"]["valorIcms"]}",
                          style: textLowImportance(),
                        )),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "ST",
                          style: textLowImportance(),
                        ),
                        SelectionArea(
                            child: Text(
                          "R\$ ${notaFiscal["valores"]["valorSt"]}",
                          style: textLowImportance(),
                        )),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "PIS",
                          style: textLowImportance(),
                        ),
                        SelectionArea(
                            child: Text(
                          "R\$ ${notaFiscal["valores"]["valorPis"]}",
                          style: textLowImportance(),
                        )),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "IPI",
                          style: textLowImportance(),
                        ),
                        SelectionArea(
                            child: Text(
                          "R\$ ${notaFiscal["valores"]["valorIpi"]}",
                          style: textLowImportance(),
                        )),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "COFINS",
                          style: textLowImportance(),
                        ),
                        SelectionArea(
                            child: Text(
                          "R\$ ${notaFiscal["valores"]["valorCofins"]}",
                          style: textLowImportance(),
                        )),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Total Nota",
                          style: textLowImportance(),
                        ),
                        SelectionArea(
                            child: Text(
                          "R\$ ${notaFiscal["valores"]["valorNf"]}",
                          style: textLowImportance(),
                        )),
                      ],
                    )),
              ]),
            ],
          ),
        ]),
      ]),
    ]);
  }

  TableRow quintaLinhaVencimentos(int quantidadeVencimentos) {
    return TableRow(children: [
      Table(children: [
        TableRow(children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Vencimentos",
              style: textHighImportance(),
            ),
          )
        ]),
        TableRow(children: [
          Table(columnWidths: const {
            0: FlexColumnWidth(2),
            1: FlexColumnWidth(1),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
            4: FlexColumnWidth(1),
            5: FlexColumnWidth(1),
            6: FlexColumnWidth(1),
          }, children: [
            TableRow(children: [
              Column(children: [
                for (var numeroVencimento = 1;
                    numeroVencimento <= quantidadeVencimentos;
                    numeroVencimento++)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Column(
                              children: [
                                Text(
                                  "Data",
                                  style: textMidImportance(),
                                ),
                                SelectionArea(
                                    child: Text(
                                        "${(notaFiscal["vencimentos"]["00$numeroVencimento"]["data_vencimento"]).substring(8, 10)}/"
                                        "${(notaFiscal["vencimentos"]["00$numeroVencimento"]["data_vencimento"]).substring(5, 7)}/"
                                        "${(notaFiscal["vencimentos"]["00$numeroVencimento"]["data_vencimento"]).substring(0, 4)}",
                                        style: textMidImportance()))
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: Column(
                              children: [
                                Text(
                                  "Valor",
                                  style: textMidImportance(),
                                ),
                                SelectionArea(
                                  child: Text(
                                      "R\$ ${notaFiscal["vencimentos"]["00$numeroVencimento"]["valor"]}",
                                      style: textMidImportance()),
                                ),
                              ],
                            )),
                      ]),
              ]),
            ]),
          ])
        ])
      ]),
    ]);
  }
}

class BotoesNotaFiscal extends StatelessWidget {
  const BotoesNotaFiscal({
    required this.numeroNotaFiscal,
    required this.cnpj,
    required this.tipoNota,
    required this.notaCancelada,
    required this.notaDespesa,
    super.key,
  });

  final String numeroNotaFiscal;
  final String cnpj;
  final int tipoNota;
  final bool notaCancelada;
  final bool notaDespesa;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 1000,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => Dialog(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.8),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(24))),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Deseja cancelar nota $numeroNotaFiscal?",
                            style: textMidImportance(),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: notaCancelada == true
                                      ? Text(
                                          "Manter Cancelada",
                                          style: textMidImportance(
                                              font: 20, color: darkGreen),
                                        )
                                      : Text(
                                          "Não cancelar ",
                                          style: textMidImportance(
                                              font: 20, color: darkGreen),
                                        ),
                                ),
                                TextButton(
                                  style: ElevatedButton.styleFrom(
                                      foregroundColor: Colors.red),
                                  onPressed: () {
                                    notaCancelada == true
                                        ? descancelaNota(numeroNotaFiscal, cnpj,
                                            tipoNota, context)
                                        : cancelaNota(numeroNotaFiscal, cnpj,
                                            tipoNota, context);
                                    Navigator.pop(context);
                                  },
                                  child: notaCancelada == true
                                      ? Text(
                                          "Reativar Nota",
                                          style: textMidImportance(
                                              font: 20, color: darkBlue),
                                        )
                                      : Text(
                                          "Cancelar Nota",
                                          style: textMidImportance(
                                              font: 20, color: defaultRed),
                                        ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
                backgroundColor:
                    notaCancelada == true ? defaultBlue : defaultOrange,
                foregroundColor: notaCancelada == true ? darkBlue : darkOrange,
                elevation: 5.0),
            child: notaCancelada == true
                ? Text("Reativar Nota",
                    style: textMidImportance(color: Colors.white))
                : Text("Cancelar Nota",
                    style: textMidImportance(color: Colors.white)),
          ),
          ElevatedButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => Dialog(
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(24))),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "Nota $numeroNotaFiscal é despesa?",
                              style: textMidImportance(),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: notaDespesa == true
                                        ? Text(
                                            "Manter como Despesa",
                                            style: textMidImportance(
                                                font: 20, color: darkGreen),
                                          )
                                        : Text(
                                            "Não é Despesa",
                                            style: textMidImportance(
                                                font: 20, color: darkGreen),
                                          ),
                                  ),
                                  TextButton(
                                    style: ButtonStyle(
                                        foregroundColor:
                                            WidgetStateColor.resolveWith(
                                                (states) => Colors.black)),
                                    onPressed: () {
                                      notaDespesa == true
                                          ? desfazerNotaDespesa(
                                              numeroNotaFiscal,
                                              cnpj,
                                              tipoNota,
                                              context)
                                          : fazerNotaDespesa(numeroNotaFiscal,
                                              cnpj, tipoNota, context);
                                      Navigator.pop(context);
                                    },
                                    child: notaDespesa == true
                                        ? Text(
                                            "Não é despesa",
                                            style: textMidImportance(
                                                font: 20, color: darkBlue),
                                          )
                                        : Text(
                                            "É despesa",
                                            style: textMidImportance(
                                                font: 20, color: darkYellow),
                                          ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor:
                      notaDespesa == true ? defaultBlue : defaultYellow,
                  foregroundColor: notaDespesa == true ? darkBlue : darkYellow,
                  elevation: 5.0),
              child: notaDespesa == false
                  ? Text(
                      "Despesa?",
                      style: textMidImportance(color: Colors.white),
                    )
                  : Text(
                      "Não é Despesa",
                      style: textMidImportance(color: Colors.white),
                    )),
          ElevatedButton(
            onPressed: () {
              excluirNota(numeroNotaFiscal, tipoNota, context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: defaultRed,
                foregroundColor: darkRed,
                elevation: 5.0),
            child: Text(
              "Excluir Nota",
              style: textMidImportance(color: Colors.white),
            ),
          ),
        ]),
      ),
    );
  }
}
