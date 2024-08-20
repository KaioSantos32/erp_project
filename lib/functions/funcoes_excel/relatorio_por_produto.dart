import 'dart:io';

import 'package:erp/functions/funcoes_mongo/pega_nota_por_cliente.dart';
import 'package:erp/functions/funcoes_mongo/pega_nota_por_produto_para_xlsx.dart';
import 'package:file_picker/file_picker.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:erp/functions/funcoes_mongo/pega_notas_por_mes_para_xlsx.dart';

List<String> titulosColunas = [
  "Data",
  "NF",
  "Cliente",
  "Valor Total NF",
  "Vencimento(s)",
  "ICMS",
  "IPI",
  "PIS",
  "COFINS",
  "ICMS ST",
  "Valor Total dos Produtos",
];

// TODO: fazer uma função que entrega para o 'criarXlsx' a lista que volta do mongodb



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
      nomeProduto, listaDataInicial, listaDataFinal, tipoEntidade);

  for (var nota in notas) {
    var colunaInicial = "A".codeUnitAt(0);
    List vencimentos = [];
    int quantidadeVencimentos = nota["vencimentos"].length;

    for (int index = 0; index < quantidadeVencimentos; index++) {
      vencimentos.add(nota["vencimentos"]["00${index + 1}"]);
    }

    for (int indexColuna = 0;
        indexColuna < titulosColunas.length;
        indexColuna++) {
      sheet
          .getRangeByName('${String.fromCharCode(colunaInicial)}1')
          .setText(titulosColunas[indexColuna]);
      colunaInicial++;
    }
    colunaInicial -= 11; // VOLTANDO O VALOR DA COLUNA INICIAL DE 'L' PARA 'A'
    indexLinha++; // descendo para linha 1 (sera usada como linha 2 pois a 1 é onde ficam os titulos)

    for (int indexColuna = 0;
        indexColuna < titulosColunas.length;
        indexColuna++) {
      switch (String.fromCharCode(colunaInicial)) {
        case "A":
          String dia = "";
          String mes = "";
          String ano = "";
          dia = "${DateTime.parse(nota["dhEmissao"]).day}";
          mes = "${DateTime.parse(nota["dhEmissao"]).month}";
          ano = "${DateTime.parse(nota["dhEmissao"]).year}";

          sheet
              .getRangeByName(
                  '${String.fromCharCode(colunaInicial)}${indexLinha + 1}')
              .setText("$dia/$mes/$ano");
          colunaInicial += 1;
          break;
        case "B":
          sheet
              .getRangeByName(
                  '${String.fromCharCode(colunaInicial)}${indexLinha + 1}')
              .setText("${nota["nf"]}");
          colunaInicial += 1;
          break;
        case "C":
          sheet
              .getRangeByName(
                  '${String.fromCharCode(colunaInicial)}${indexLinha + 1}')
              .setText("${nota["empresaDestinataria"]["nome"]}");
          colunaInicial += 1;
          break;
        case "D":
          double valorTotalNf = double.parse("${nota["valores"]["valorNf"]}");
          sheet
              .getRangeByName(
                  '${String.fromCharCode(colunaInicial)}${indexLinha + 1}')
              // .setText("R\$ $valorTotalNf");
              .setNumber(valorTotalNf);

          colunaInicial += 1;
          break;
        case "E":
          String stringVencimentos = "";
          print(nota["nf"]);
          if (vencimentos.length == 0) {
            stringVencimentos = "A Vista";
            sheet
                .getRangeByName(
                    '${String.fromCharCode(colunaInicial)}${indexLinha + 1}')
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
                      '${String.fromCharCode(colunaInicial)}${indexLinha + 1}')
                  .setText(stringVencimentos);
            }
          }
          colunaInicial += 1;
          break;
        case "F":
          double icms = double.parse("${nota["valores"]["valorIcms"]}");

          sheet
              .getRangeByName(
                  '${String.fromCharCode(colunaInicial)}${indexLinha + 1}')
              .setNumber(icms);
          colunaInicial += 1;
          break;
        case "G":
          double ipi = double.parse("${nota["valores"]["valorIpi"]}");
          sheet
              .getRangeByName(
                  '${String.fromCharCode(colunaInicial)}${indexLinha + 1}')
              .setNumber(ipi);
          colunaInicial += 1;
          break;
        case "H":
          double pis = double.parse("${nota["valores"]["valorPis"]}");

          sheet
              .getRangeByName(
                  '${String.fromCharCode(colunaInicial)}${indexLinha + 1}')
              .setNumber(pis);

          final conditions = sheet
              .getRangeByName(
                  '${String.fromCharCode(colunaInicial)}${indexLinha + 1}')
              .conditionalFormats;
          final ConditionalFormat condition = conditions.addCondition();

//Represents conditional format rule that the value in target range should be between 10 and 20
          condition.formatType = ExcelCFType.cellValue;

          colunaInicial += 1;
          break;
        case "I":
          double cofins = double.parse("${nota["valores"]["valorCofins"]}");

          sheet
              .getRangeByName(
                  '${String.fromCharCode(colunaInicial)}${indexLinha + 1}')
              .setNumber(cofins);
          colunaInicial += 1;
          break;
        case "J":
          double st = double.parse("${nota["valores"]["valorSt"]}");

          sheet
              .getRangeByName(
                  '${String.fromCharCode(colunaInicial)}${indexLinha + 1}')
              .setNumber(st);
          colunaInicial += 1;
          break;
        case "K":
          // valor dos produtos sem impostos(K) = valor da nota(D) - valor do IPI(G) - valor do ST(J)
          sheet
              .getRangeByName(
                  '${String.fromCharCode(colunaInicial)}${indexLinha + 1}')
              .setFormula(
                  "D${indexLinha + 1}-G${indexLinha + 1}-J${indexLinha + 1}");
          colunaInicial += 1;
          break;
      }
    }
  }
//set back color by hexa decimal.
  globalStyle.backColor = '#b5e6a2';

  sheet.getRangeByName('A${notas.length + 2}:K${notas.length + 2}').cellStyle =
      globalStyle;

  sheet
      .getRangeByName("D${notas.length + 2}")
      .setFormula("SUM(D2:D${notas.length + 1})");

  sheet
      .getRangeByName("F${notas.length + 2}")
      .setFormula("SUM(F2:F${notas.length + 1})");
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
