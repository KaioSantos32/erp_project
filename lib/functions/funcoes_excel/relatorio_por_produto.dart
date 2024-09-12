import 'dart:io';

import 'package:erp/functions/funcoes_mongo/pega_nota_por_produto_para_xlsx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

List<String> titulosColunas = [
  "Data",
  "NF",
  "Cliente",
  "Nome Prod",
  "Valor Total NF",
  "Vencimento(s)",
  "ICMS Prod",
  "IPI Prod",
  "PIS Prod",
  "COFINS Prod",
  "ICMS ST Prod",
  "V. Total Prod",
];

criarXlsxPorProduto(
  String nomeProduto,
  String dataInicial,
  String dataFinal,
  int tipoEntidade,
) async {
  // Create a new Excel document.
  final Workbook excelFile = Workbook();
  // Acessando a tabela pelo index.
  final Worksheet sheet = excelFile.worksheets[0];
  Style globalStyle = excelFile.styles.add('style');
 
  int indexLinha = 0;

  List listaDataInicial = dataInicial.split("/");
  List listaDataFinal = dataFinal.split("/");

  List<Map> notas = await pegaNotaPorProdutoParaXlsx(
    nomeProduto,
    listaDataInicial,
    listaDataFinal,
    tipoEntidade,
  );

  for (var nota in notas) {
    var coluna = "A".codeUnitAt(0);
    List vencimentos = [];
    int quantidadeVencimentos = nota["vencimentos"].length;

    // Adicionando os vencimentos da nota na lista de vencimentos
    for (int index = 0; index < quantidadeVencimentos; index++) {
      vencimentos.add(nota["vencimentos"]["00${index + 1}"]);
    }

    for (int indexColuna = 0;
        indexColuna < titulosColunas.length;
        indexColuna++) {
      sheet
          .getRangeByName('${String.fromCharCode(coluna)}1')
          .setText(titulosColunas[indexColuna]);
      coluna++;
    }

    coluna =
        "A".codeUnitAt(0); // VOLTANDO O VALOR DA COLUNA INICIAL DE 'L' PARA 'A'
    indexLinha++; // descendo para linha 1 (sera usada como linha 2 pois a 1 é onde ficam os titulos)
    for (var produto in nota["produtos"]) {
      if (produto["nome_produto"].toString().contains(nomeProduto)) {
        for (int indexColuna = 0;
            indexColuna < titulosColunas.length;
            indexColuna++) {
          switch (String.fromCharCode(coluna)) {
            case "A": // Data Emissão
              String dia = "";
              String mes = "";
              String ano = "";
              dia = "${DateTime.parse(nota["dhEmissao"]).day}";
              mes = "${DateTime.parse(nota["dhEmissao"]).month}";
              ano = "${DateTime.parse(nota["dhEmissao"]).year}";

              sheet
                  .getRangeByName(
                      '${String.fromCharCode(coluna)}${indexLinha + 1}')
                  .setText("$dia/$mes/$ano");
              coluna += 1;
              break;
            case "B": // Numero da nota
              sheet
                  .getRangeByName(
                      '${String.fromCharCode(coluna)}${indexLinha + 1}')
                  .setText("${nota["nf"]}");
              coluna += 1;
              break;
            case "C": // Nome dos Clientes
              sheet
                  .getRangeByName(
                      '${String.fromCharCode(coluna)}${indexLinha + 1}')
                  .setText("${nota["empresaDestinataria"]["nome"]}");
              coluna += 1;
              break;
            case "D": // Nome do Produto
              double valorTotalNf =
                  double.parse("${nota["valores"]["valorNf"]}");
              sheet
                  .getRangeByName(
                      '${String.fromCharCode(coluna)}${indexLinha + 1}')
                  // .setText("R\$ $valorTotalNf");
                  .setText(produto["nome_produto"]);

              coluna += 1;
              break;
            case "E": // Valor total da nota
              double valorTotalNota =
                  double.parse("${nota["valores"]["valorNf"]}");

              sheet
                  .getRangeByName(
                      '${String.fromCharCode(coluna)}${indexLinha + 1}')
                  .setNumber(valorTotalNota);

              coluna += 1;
              break;
            case "F": // Vencimento(s)

              String stringVencimentos = "";
              if (vencimentos.isEmpty) {
                stringVencimentos = "A Vista";
                sheet
                    .getRangeByName(
                        '${String.fromCharCode(coluna)}${indexLinha + 1}')
                    .setText(stringVencimentos);
              } else {
                for (var venc in vencimentos) {
                  String dia = "";
                  String mes = "";
                  String ano = "";

                  if (venc["data_vencimento"] == "A Vista" ||
                      venc["data_vencimento"] == "") {
                    stringVencimentos = "A Vista";
                  } else {
                    dia = "${DateTime.parse(venc["data_vencimento"]).day}";
                    mes = "${DateTime.parse(venc["data_vencimento"]).month}";
                    ano = "${DateTime.parse(venc["data_vencimento"]).year}";
                    stringVencimentos += " $dia/$mes/$ano |";
                  }
                  sheet
                      .getRangeByName(
                          '${String.fromCharCode(coluna)}${indexLinha + 1}')
                      .setText(stringVencimentos);
                }
              }
              coluna += 1;
              break;
            case "G": // ICMS do Produto
              // switch(produto[""])
              var icms;
              try {
                icms = double.parse("${produto["impostos"]["icms"]["vIcms"]}");
                sheet
                    .getRangeByName(
                        '${String.fromCharCode(coluna)}${indexLinha + 1}')
                    .setNumber(icms);
              } catch (e) {
                icms = "N/D";
                sheet
                    .getRangeByName(
                        '${String.fromCharCode(coluna)}${indexLinha + 1}')
                    .setText(icms);
              }
              coluna++;

              break;
            case "H": // IPI do Produto
              try {
                double ipi =
                    double.parse("${produto["impostos"]["ipi"]["vIpi"]}");
                sheet
                    .getRangeByName(
                        '${String.fromCharCode(coluna)}${indexLinha + 1}')
                    .setNumber(ipi);
              } catch (e) {
                sheet
                    .getRangeByName(
                        '${String.fromCharCode(coluna)}${indexLinha + 1}')
                    .setText("N/D");
              }
              coluna++;
              break;
            case "I": // PIS do Produto
              try {
                double pis =
                    double.parse("${produto["impostos"]["pis"]["vPis"]}");
                sheet
                    .getRangeByName(
                        '${String.fromCharCode(coluna)}${indexLinha + 1}')
                    .setNumber(pis);
              } catch (e) {
                sheet
                    .getRangeByName(
                        '${String.fromCharCode(coluna)}${indexLinha + 1}')
                    .setText("N/D");
              }
              coluna++;
              break;
            case "J": // COFINS do Produto

              try {
                double cofins =
                    double.parse("${produto["impostos"]["cofins"]["vCofins"]}");
                sheet
                    .getRangeByName(
                        '${String.fromCharCode(coluna)}${indexLinha + 1}')
                    .setNumber(cofins);
              } catch (e) {
                sheet
                    .getRangeByName(
                        '${String.fromCharCode(coluna)}${indexLinha + 1}')
                    .setText("N/D");
              }
              coluna++;
              break;
            case "K": // ICMS ST do Produto
              // valor dos produtos sem impostos(K) = valor da nota(D) - valor do IPI(G) - valor do ST(J)
              try {
                double st =
                    double.parse("${produto["impostos"]["icms"]["vIcmsSt"]}");
                sheet
                    .getRangeByName(
                        '${String.fromCharCode(coluna)}${indexLinha + 1}')
                    .setNumber(st);
              } catch (e) {
                sheet
                    .getRangeByName(
                        '${String.fromCharCode(coluna)}${indexLinha + 1}')
                    .setText("N/D");
              }
              coluna++;
              break;
            case "L": // Valor do Produto
              sheet
                  .getRangeByName(
                      '${String.fromCharCode(coluna)}${indexLinha + 1}')
                  .setNumber(double.parse("${produto["vProd"]}"));
              coluna += 1;
              break;
          }
        }
      }
    }
  }

  //set back color by hexa decimal.
  globalStyle.backColor = '#b5e6a2';

  sheet.getRangeByName('A${notas.length + 2}:K${notas.length + 2}').cellStyle =
      globalStyle;
  sheet
      .getRangeByName("E${notas.length + 2}")
      .setFormula("SUM(E2:E${notas.length + 1})");
  sheet
      .getRangeByName("G${notas.length + 2}")
      .setFormula("SUM(G2:G${notas.length + 1})");
  sheet
      .getRangeByName("H${notas.length + 2}")
      .setFormula("SUM(H2:H${notas.length + 1})");
  sheet
      .getRangeByName("I${notas.length + 2}")
      .setFormula("SUM(I2:I${notas.length + 1})");
  sheet
      .getRangeByName("J${notas.length + 2}")
      .setFormula("SUM(J2:J${notas.length + 1})");
  sheet
      .getRangeByName("K${notas.length + 2}")
      .setFormula("SUM(K2:K${notas.length + 1})");
  sheet
      .getRangeByName("L${notas.length + 2}")
      .setFormula("SUM(L2:L${notas.length + 1})");

  final condicoes = sheet.getRangeByName('Z1').conditionalFormats;
  final ConditionalFormat valorTotalCondicoes = condicoes.addCondition();
  valorTotalCondicoes.formatType = ExcelCFType.cellValue;

  globalStyle.numberFormat = '_(R\$* #,##0_)';

  // condition.numberFormat = "0.0";

// Formula calculation is enabled for the sheet
  sheet.enableSheetCalculations();

// Save the document.
  final List<int> bytes = excelFile.saveAsStream();

  String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

  if (selectedDirectory != null) {
    File("$selectedDirectory/Relatório do produto ${nomeProduto.toUpperCase()}.xlsx")
        .writeAsBytes(bytes);
  }
//Dispose the workbook.

  excelFile.dispose();
}
