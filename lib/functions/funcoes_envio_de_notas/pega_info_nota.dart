import 'dart:io';

import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/functions/funcoes_envio_de_notas/nome_do_mes.dart';
import 'package:erp/informacoes_importantes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

pegaInfoNota(context) async {
  String caminhoNotaPdf = "";
  String caminhoBoleto = "";
  String nomeMes;
  FilePickerResult? caminhoXml = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["xml"],
      initialDirectory: "[DIRETÓRIO INICIAL]");

  if (caminhoXml != null) {
    List diaEmissaoNota;
    // arquivoSelecionado contém o caminho do arquivo em uma lista
    // pegando o caminho do primeiro arquivo (Só tem 1 na lista)
    final caminhoDoArquivo = File(caminhoXml.paths[0]!);

    // Lendo todo o xml
    final document = XmlDocument.parse(caminhoDoArquivo.readAsStringSync());
    final chaveNotaFiscal =
        document.xpath("/nfeProc/protNFe/infProt/chNFe").single.innerText;

    if (chaveNotaFiscal.contains(empresaCnpj)) {
      diaEmissaoNota = document
          .xpath("/nfeProc/NFe/infNFe/ide/dhEmi")
          .single
          .innerText
          .substring(0, 10)
          .split("-");

      String numeroNf =
          document.xpath("/nfeProc/NFe/infNFe/ide/nNF").single.innerText;
      String nomeCliente =
          document.xpath("/nfeProc/NFe/infNFe/dest/xNome").single.innerText;
      String emailCliente = "";
      try {
        emailCliente =
            document.xpath("/nfeProc/NFe/infNFe/dest/email").single.innerText;
      } catch (e) {
        emailCliente = "Sem email na nota";
      }

      nomeMes = nomeDoMes(diaEmissaoNota[1]);
      final List<FileSystemEntity> notasFiscais = await Directory(
              "[caminho para o pdf de nota fiscal]")
          .list()
          .toList();
      for (var nota in notasFiscais) {
        if (nota.toString().contains("[nome do arquivo da NF]")) {
          caminhoNotaPdf =
              nota.toString().replaceAll("File: '", "").replaceAll("'", "");
        }
      }
      if (caminhoNotaPdf.isEmpty) {
        caminhoNotaPdf = "documento não encontrado";
      }

      final List<FileSystemEntity> boletos = await Directory(
              "[caminho para pdf do boleto]")
          .list()
          .toList();
      for (var boleto in boletos) {
        if (boleto.toString().contains("[nome do arquivo de boleto]")) {
          caminhoBoleto =
              boleto.toString().replaceAll("File: '", "").replaceAll("'", "");
        }
      }
      if (caminhoBoleto.isEmpty) {
        caminhoBoleto = "documento não encontrado";
      }

      return [
        caminhoDoArquivo.toString(),
        numeroNf,
        nomeCliente,
        emailCliente,
        caminhoNotaPdf,
        caminhoBoleto
      ];
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white.withOpacity(.8),
                borderRadius: const BorderRadius.all(Radius.circular(24))),
            child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "A Nota é de Compra",
                      style: textMidImportance(),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "OK",
                        style: textMidImportance(font: 20, color: darkGreen),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      );
    }
  }
}
