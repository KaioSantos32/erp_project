import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/main.dart';
import 'package:erp/screens/notas/ver_toda_nota.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MontaTabelaDeNotas extends StatelessWidget {
  MontaTabelaDeNotas({super.key, required this.notas, required this.tipoNota});

  Future<List> notas;
  int tipoNota;
  bool autoEntrada = false;

  void mostraTodaNota(String nNota, String cnpj, bool cancelada, bool despesa,
      int tipoNota, context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) {
        return VerTodaNota(
          infoParaNota: {
            "nNf": nNota,
            "cnpj": cnpj,
            "cancelada": cancelada,
            "despesa": despesa,
            "autoEntrada": autoEntrada
          },
          tipoNota: tipoNota,
        );
      }),
    );
  }


  @override
  Widget build(BuildContext context) {
    String tipoEmpresa = "";

    return FutureBuilder(
      future: notas,
      builder: (context, dados) {
        try {
          if (!dados.hasData) {
            Future.delayed(const Duration(seconds: 2)).then((value) => Center(
                child: Text(
                  "Não foi encontrado nota (Lista vazia)",
                  style: textMidImportance(),
                ),
              ));
            return const Text("");
          } else {
            List<DataRow> novaLinha = [];
            for (var nota in dados.data!) {
              var dia = DateTime.parse(nota["dhEmissao"]).day;
              var mes = DateTime.parse(nota["dhEmissao"]).month;
              var ano = DateTime.parse(nota["dhEmissao"]).year;

              if (tipoNota == 0) {
                // se nota for de entrada
                autoEntrada = nota["_id"]
                    .contains(empresaCnpj); // Checar se é auto entrada
                if (autoEntrada) {
                  tipoEmpresa = "empresaDestinataria";
                } else {
                  tipoEmpresa = "empresaEmissora";
                }
              } else {
                tipoEmpresa = "empresaDestinataria";
              }

              dynamic dataVencimento;
              try {
                String data = nota["vencimentos"]["001"]["data_vencimento"];
                String ano = data.substring(0, 4);
                String mes = data.substring(5, 7);
                String dia = data.substring(8, 10);
                dataVencimento = "$dia/$mes/$ano";
              } catch (e) {
                dataVencimento = "Á Vista";
              }
              novaLinha.add(
                DataRow(
                  cells: [
                    DataCell(Text(nota["nf"]), onTap: () {
                      mostraTodaNota(
                          nota["nf"],
                          nota[tipoEmpresa]["cnpj"],
                          nota["cancelada"],
                          nota["despesa"],
                          tipoNota,
                          context);
                    }),
                    DataCell(Text(nota[tipoEmpresa]["cnpj"]), onTap: () {
                      mostraTodaNota(
                          nota["nf"],
                          nota[tipoEmpresa]["cnpj"],
                          nota["cancelada"],
                          nota["despesa"],
                          tipoNota,
                          context);
                    }),
                    DataCell(Text(nota[tipoEmpresa]['nome']), onTap: () {
                      mostraTodaNota(
                          nota["nf"],
                          nota[tipoEmpresa]["cnpj"],
                          nota["cancelada"],
                          nota["despesa"],
                          tipoNota,
                          context);
                    }),
                    DataCell(Text("R\$${nota["valores"]["valorNf"]}"),
                        onTap: () {
                      mostraTodaNota(
                          nota["nf"],
                          nota[tipoEmpresa]["cnpj"],
                          nota["cancelada"],
                          nota["despesa"],
                          tipoNota,
                          context);
                    }),
                    DataCell(Text("$dia/$mes/$ano"), onTap: () {
                      mostraTodaNota(
                          nota["nf"],
                          nota[tipoEmpresa]["cnpj"],
                          nota["cancelada"],
                          nota["despesa"],
                          tipoNota,
                          context);
                    }),
                    DataCell(Text("$dataVencimento"), onTap: () {
                      mostraTodaNota(
                          nota["nf"],
                          nota[tipoEmpresa]["cnpj"],
                          nota["cancelada"],
                          nota["despesa"],
                          tipoNota,
                          context);
                    }),
                  ],
                ),
              );
            }
            return DataTable(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(.3)),
                border: TableBorder.all(),
                columns: [
                  DataColumn(
                      label: Text("Número NF", style: textLowImportance())),
                  DataColumn(label: Text("CNPJ", style: textLowImportance())),
                  DataColumn(
                      label: Text(tipoNota == 0 ? "Fornecedor" : "Cliente",
                          style: textLowImportance())),
                  DataColumn(
                      label: Text("Valor Total", style: textLowImportance())),
                  DataColumn(
                      label: Text("Data Emissão", style: textLowImportance())),
                  DataColumn(
                      label: Text("Vencimento", style: textLowImportance())),
                ],
                rows: [
                  for (var linha in novaLinha) linha
                ]);
          }
        } catch (e) {
          Future.delayed(const Duration(seconds: 2)).then((value) => Center(
                child: Text(
                  "Não foi encontrado nota (Lista vazia)",
                  style: textMidImportance(),
                ),
              ));

          return const Text("");
        }
      },
    );
  }
}

