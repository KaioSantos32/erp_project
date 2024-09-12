import 'dart:io';

import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/functions/funcoes_mongo/entrar_nf_no_banco.dart';
import 'package:erp/informacoes_importantes.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

void lerXml(tipoNota, context) async {
  FilePickerResult? arquivoSelecionado = await FilePicker.platform
      .pickFiles(type: FileType.custom, allowedExtensions: ["xml"]);

  if (arquivoSelecionado != null) {
    // arquivoSelecionado contém o caminho do arquivo em uma lista
    // pegando o caminho do primeiro arquivo (Só tem 1 na lista)
    final file = File(arquivoSelecionado.paths[0]!);
    // Lendo todo o xml
    final document = XmlDocument.parse(file.readAsStringSync());
    int index = 0;

    // pegando a chave da nota fiscal, será usada como chave única no banco de dados
    final chaveNotaFiscal =
        document.xpath("/nfeProc/protNFe/infProt/chNFe").single.innerText;
    final numeroNf =
        document.xpath("/nfeProc/NFe/infNFe/ide/nNF").single.innerText;

    // Tipo da Nota == 0 : Nota de Entrada / Compra
    // Tipo da Nota == 1 : Nota de Saida / Venda
    if (tipoNota == 1) {
      // olhando a chave do XML, se conter o CNPJ da empresa a nota é de Saida
      // Tem uma exceção que é quando a empresa emite nota de entrada, solouções:
      // Avisar que  é uma nota de Saida/Entrada e falar que a nota parece ser de entrada ou saida, mas perguntar se quer continuar
      if (chaveNotaFiscal.contains(empresaCnpj)) {
        final numeroNf =
            document.xpath("/nfeProc/NFe/infNFe/ide/nNF").single.innerText;
        final dhEmissao = document
            .xpath("/nfeProc/NFe/infNFe/ide/dhEmi")
            .single
            .innerText
            .substring(0, 19);
        final natOp =
            document.xpath("/nfeProc/NFe/infNFe/ide/natOp").single.innerText;
        final infComplementar = document
            .xpath("/nfeProc/NFe/infNFe/infAdic/infCpl")
            .single
            .innerText;

        final listaVencimentos = {};
        index = 1;
        for (var vencimento in document.xpath("/nfeProc/NFe/infNFe/cobr/dup")) {
          String nDup = vencimento.findAllElements("nDup").single.innerText;
          listaVencimentos[nDup] = {
            "data_vencimento":
                vencimento.findAllElements("dVenc").single.innerText,
            "valor": vencimento.findAllElements("vDup").single.innerText
          };
          index++;
        }

        Map<String, dynamic> empresaEmissora = {};
        Map<String, dynamic> emissoraEndereco = {};
        Map<String, dynamic> empresaDestinataria = {};
        Map<String, dynamic> destinatariaEndereco = {};

        emissoraEndereco = {
          "rua": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/xLgr")
              .single
              .innerText,
          "numero": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/nro")
              .single
              .innerText,
          "bairro": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/xBairro")
              .single
              .innerText,
          "cod_municipio": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/cMun")
              .single
              .innerText,
          "municipio": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/xMun")
              .single
              .innerText,
          "uf": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/UF")
              .single
              .innerText,
          "cep": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/CEP")
              .single
              .innerText,
          "c_pais": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/cPais")
              .single
              .innerText
        };

        empresaEmissora = {
          "cnpj":
              document.xpath("/nfeProc/NFe/infNFe/emit/CNPJ").single.innerText,
          "nome":
              document.xpath("/nfeProc/NFe/infNFe/emit/xNome").single.innerText,
          "inscEstadual":
              document.xpath("/nfeProc/NFe/infNFe/emit/IE").single.innerText,
          "endereco": emissoraEndereco
        };

        destinatariaEndereco = {
          "rua": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/xLgr")
              .single
              .innerText,
          "numero": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/nro")
              .single
              .innerText,
          "bairro": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/xBairro")
              .single
              .innerText,
          "cod_municipio": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/cMun")
              .single
              .innerText,
          "municipio": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/xMun")
              .single
              .innerText,
          "uf": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/UF")
              .single
              .innerText,
          "cep": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/CEP")
              .single
              .innerText,
          "c_pais": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/cPais")
              .single
              .innerText
        };

        String cnpj;
        try {
          cnpj =
              document.xpath("/nfeProc/NFe/infNFe/dest/CNPJ").single.innerText;
        } catch (e) {
          cnpj =
              document.xpath("/nfeProc/NFe/infNFe/dest/CPF").single.innerText;
        }

        String inscEstadual;
        try {
          inscEstadual =
              document.xpath("/nfeProc/NFe/infNFe/dest/IE").single.innerText;
        } catch (e) {
          inscEstadual = document
              .xpath("/nfeProc/NFe/infNFe/dest/indIEDest")
              .single
              .innerText;
        }

        empresaDestinataria = {
          "cnpj": cnpj,
          "nome":
              document.xpath("/nfeProc/NFe/infNFe/dest/xNome").single.innerText,
          "inscEstadual": inscEstadual,
          "endereco": destinatariaEndereco
        };

        List<Map<String, dynamic>> listaProdutos = [];
        Map<String, dynamic> lista = {};
        index = 1;
        for (var produto in document.xpath("/nfeProc/NFe/infNFe/det")) {
          var valorProduto = produto.findAllElements("vUnCom").single.innerText;
          lista["ValorVrod_$index"] = valorProduto;

          String cstIcms = "";
          String vBcIcms = "0.0";
          String pIcms = "0.0";
          String vIcms = "0.0";
          String vBcSt = "0.0";
          String pIcmsSt = "0.0";
          String vIcmsSt = "0.0";
          String vBcStRet = "0.0";
          String pSt = "0.0";
          String vIcmsSubstituto = "0.0";
          String vIcmsStRet = "0.0";
          String qBcMonoRet = "0.0";
          String adRemIcmsRet = "0.0";
          String vIcmsMonoRet = "0.0";
          String vBcEfet = "0.0";
          String pIcmsEfet = "0.0";
          String vIcmsEfet = "0.0";

          String cstIpi = "0.0";
          String vBcIpi = "0.0";
          String pIpi = "0.0";
          String vIpi = "0.0";

          String cstPis = "0.0";
          String vBcPis = "0.0";
          String pPis = "0.0";
          String vPis = "0.0";

          String cstCofins = "0.0";
          String vBcCofins = "0.0";
          String pCofins = "0.0";
          String vCofins = "0.0";

          var impostos = produto.findAllElements("imposto").toString();

          // PEGANDO INFORMAÇÕES DO ICMS
          String stringIcms = impostos.substring(
              impostos.indexOf("ICMS") + 5, impostos.indexOf("/ICMS") - 1);
          try {
            cstIcms = stringIcms.substring(
                stringIcms.indexOf("CST") + 4, stringIcms.indexOf("/CST") - 1);
          } catch (e) {
            debugPrint("");
          }

          switch (cstIcms) {
            case "00":
              vBcIcms = stringIcms.substring(stringIcms.indexOf("vBC") + 4,
                  stringIcms.indexOf("/vBC") - 1);

              pIcms = stringIcms.substring(stringIcms.indexOf("pICMS") + 6,
                  stringIcms.indexOf("/pICMS") - 1);
              vIcms = stringIcms.substring(stringIcms.indexOf("vICMS") + 6,
                  stringIcms.indexOf("/vICMS") - 1);

              break;

            case "10":
              vBcIcms = stringIcms.substring(stringIcms.indexOf("vBC") + 4,
                  stringIcms.indexOf("/vBC") - 1);

              pIcms = stringIcms.substring(stringIcms.indexOf("pICMS") + 6,
                  stringIcms.indexOf("/pICMS") - 1);
              vIcms = stringIcms.substring(stringIcms.indexOf("vICMS") + 6,
                  stringIcms.indexOf("/vICMS") - 1);

              vBcSt = stringIcms.substring(stringIcms.indexOf("vBCST") + 6,
                  stringIcms.indexOf("/vBCST") - 1);

              pIcmsSt = stringIcms.substring(stringIcms.indexOf("pICMSST") + 8,
                  stringIcms.indexOf("/pICMSST") - 1);

              vIcmsSt = stringIcms.substring(stringIcms.indexOf("vICMSST") + 8,
                  stringIcms.indexOf("/vICMSST") - 1);

              break;

            case "60":
              vBcStRet = stringIcms.substring(
                  stringIcms.indexOf("vBCSTRet") + 9,
                  stringIcms.indexOf("/vBCSTRet") - 1);
              pSt = stringIcms.substring(stringIcms.indexOf("pST") + 4,
                  stringIcms.indexOf("/pST") - 1);

              vIcmsSubstituto = stringIcms.substring(
                  stringIcms.indexOf("vICMSSubstituto") + 16,
                  stringIcms.indexOf("/vICMSSubstituto") - 1);

              vIcmsStRet = stringIcms.substring(
                  stringIcms.indexOf("vICMSSTRet") + 11,
                  stringIcms.indexOf("/vICMSSTRet") - 1);

              try {
                adRemIcmsRet = stringIcms.substring(
                    stringIcms.indexOf("adRemICMSRet") + 13,
                    stringIcms.indexOf("/adRemICMSRet") - 1);
              } catch (e) {
                debugPrint("");
              }

              try {
                vBcEfet = stringIcms.substring(
                    stringIcms.indexOf("vBCEfet") + 8,
                    stringIcms.indexOf("/vBCEfet") - 1);
              } catch (e) {
                debugPrint("");
              }

              try {
                pIcmsEfet = stringIcms.substring(
                    stringIcms.indexOf("pICMSEfet") + 10,
                    stringIcms.indexOf("/pICMSEfet") - 1);
              } catch (e) {
                debugPrint("");
              }

              try {
                vIcmsEfet = stringIcms.substring(
                    stringIcms.indexOf("vICMSEfet") + 10,
                    stringIcms.indexOf("/vICMSEfet") - 1);
              } catch (e) {
                debugPrint("");
              }

              break;

            case "61":
              qBcMonoRet = stringIcms.substring(
                  stringIcms.indexOf("qBCMonoRet") + 11,
                  stringIcms.indexOf("/qBCMonoRet") - 1);

              adRemIcmsRet = stringIcms.substring(
                  stringIcms.indexOf("adRemICMSRet") + 13,
                  stringIcms.indexOf("/adRemICMSRet") - 1);

              vIcmsMonoRet = stringIcms.substring(
                  stringIcms.indexOf("vICMSMonoRet") + 13,
                  stringIcms.indexOf("/vICMSMonoRet") - 1);

              break;
          }

          Map<String, String> icms = {
            "cstIcms": cstIcms,
            "vBcIcms": vBcIcms,
            "pIcms": pIcms,
            "vIcms": vIcms,
            "pSt": pSt,
            "vBcSt": vBcSt,
            "vBcStRet": vBcStRet,
            "pIcmsSt": pIcmsSt,
            "vIcmsSt": vIcmsSt,
            "vIcmsSubstituto": vIcmsSubstituto,
            "vIcmsStRet": vIcmsStRet,
            "adRemICMSRet": adRemIcmsRet,
            "vICMSMonoRet": vIcmsMonoRet,
            "vBcEfet": vBcEfet,
            "pIcmsEfet": pIcmsEfet,
            "vIcmsEfet": vIcmsEfet,
            "qBcMonoRet": qBcMonoRet,
            "adRemIcmsRet": adRemIcmsRet,
            "vIcmsMonoRet": vIcmsMonoRet,
          };

          try {
            String stringIpi = impostos.substring(
                impostos.indexOf("<IPI>"), impostos.indexOf("/IPI") - 1);
            cstIpi = stringIpi.substring(
                stringIpi.indexOf("CST") + 4, stringIpi.indexOf("/CST") - 1);

            switch (cstIpi) {
              case "50":
                vBcIpi = stringIpi.substring(
                    stringIpi.indexOf("vBC") + 4, stringIpi.indexOf("</vBC>"));
                pIpi = stringIpi.substring(stringIpi.indexOf("pIPI") + 5,
                    stringIpi.indexOf("</pIPI>"));
                vIpi = stringIpi.substring(stringIpi.indexOf("vIPI") + 5,
                    stringIpi.indexOf("</vIPI>"));
                break;
            }
          } catch (e) {
            debugPrint("");
          }

          Map<String, String> ipi = {
            "cst": cstIpi,
            "vBcIpi": vBcIpi,
            "pIpi": pIpi,
            "vIpi": vIpi
          };

          String stringPis = impostos.substring(
              impostos.indexOf("<PIS>"), impostos.indexOf("</PIS>"));

          cstPis = stringPis.substring(
              stringPis.indexOf("<CST>") + 5, stringPis.indexOf("</CST>"));

          switch (cstPis) {
            case "01":
              vBcPis = stringPis.substring(
                  stringPis.indexOf("vBC") + 4, stringPis.indexOf("</vBC>"));

              pPis = stringPis.substring(
                  stringPis.indexOf("pPIS") + 5, stringPis.indexOf("</pPIS>"));

              vPis = stringPis.substring(
                  stringPis.indexOf("vPIS") + 5, stringPis.indexOf("</vPIS>"));
              break;
          }

          Map<String, String> pis = {
            "cst": cstPis,
            "vBcIpi": vBcPis,
            "pIpi": pPis,
            "vIpi": vPis
          };

          String stringCofins = impostos.substring(
              impostos.indexOf("<COFINS>"), impostos.indexOf("</COFINS>"));

          cstCofins = stringCofins.substring(
              stringCofins.indexOf("CST") + 4, stringCofins.indexOf("</CST>"));

          switch (cstCofins) {
            case "01":
              vBcCofins = stringCofins.substring(
                  stringCofins.indexOf("<vBC>") + 5,
                  stringCofins.indexOf("</vBC>"));

              pCofins = stringCofins.substring(
                  stringCofins.indexOf("<pCOFINS>") + 9,
                  stringCofins.indexOf("</pCOFINS>"));

              vCofins = stringCofins.substring(
                  stringCofins.indexOf("<vCOFINS>") + 9,
                  stringCofins.indexOf("</vCOFINS>"));
              break;
          }

          Map<String, String> cofins = {
            "cst": cstCofins,
            "vBcIpi": vBcCofins,
            "pIpi": pCofins,
            "vIpi": vCofins
          };

          listaProdutos.add({
            "cProd": produto.findAllElements("cProd").single.innerText,
            "nome_produto": produto.findAllElements("xProd").single.innerText,
            "ncm": produto.findAllElements("NCM").single.innerText,
            "cfop": produto.findAllElements("CFOP").single.innerText,
            "vProd": produto.findAllElements("vProd").single.innerText,
            "uTrib": produto.findAllElements("uTrib").single.innerText,
            "qTrib": produto.findAllElements("qTrib").single.innerText,
            "vUnTrib": produto.findAllElements("vUnCom").single.innerText,
            "impostos": {"icms": icms, "ipi": ipi, "pis": pis, "cofins": cofins}
          });
          index++;
        }

        Map<String, double> valores = {
          "valorBaseCalculo": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vBC")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorIcms": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vICMS")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorBaseCst": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vBCST")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorSt": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vST")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorDesconto": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vDesc")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorIpi": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vIPI")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorPis": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vPIS")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorCofins": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vCOFINS")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorOutro": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vOutro")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorNf": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vNF")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
        };

        double pesoL;
        double pesoB;
        try {
          pesoL = double.parse(document
              .xpath("/nfeProc/NFe/infNFe/transp/vol/pesoL")
              .single
              .innerText);
          pesoB = double.parse(document
              .xpath("/nfeProc/NFe/infNFe/transp/vol/pesoB")
              .single
              .innerText);
        } catch (e) {
          pesoL = 0.00;
          pesoB = 0.00;
        }

        Map<String, dynamic> transporte = {};
        String especie;
        String modFrete;
        String quantidade;

        try {
          modFrete = document
              .xpath("/nfeProc/NFe/infNFe/transp/modFrete")
              .single
              .innerText;
        } catch (e) {
          modFrete = "";
        }
        try {
          quantidade = document
              .xpath("/nfeProc/NFe/infNFe/transp/vol/qVol")
              .single
              .innerText;
        } catch (e) {
          quantidade = "";
        }
        try {
          especie = document
              .xpath("/nfeProc/NFe/infNFe/transp/vol/esp")
              .single
              .innerText;
        } catch (e) {
          especie = "";
        }
        transporte = {
          "mod_frete": modFrete,
          "quantidade": quantidade,
          "especie": especie,
          "peso_liq": pesoL,
          "peso_bruto": pesoB,
        };

        Map<String, dynamic> notaMongo = {
          "_id": chaveNotaFiscal,
          "nf": numeroNf,
          "dhEmissao": dhEmissao,
          "natOp": natOp,
          "infComplementar": infComplementar,
          "vencimentos": listaVencimentos,
          "empresaEmissora": empresaEmissora,
          "empresaDestinataria": empresaDestinataria,
          "produtos": listaProdutos,
          "valores": valores,
          "transporte": transporte,
          "cancelada": false,
          "despesa": false
        };

        await entrarNotaNoBanco(tipoNota, notaMongo, context);
        String oldPath = file.path;
        String numeroDaNf = oldPath.split("\\").last;
        var indiceDoNumeroDaNf = oldPath.indexOf(numeroDaNf);

        if (numeroDaNf.substring(0, 4) == "IMP-") {
          file.rename("${oldPath.substring(0, indiceDoNumeroDaNf)}$numeroDaNf");
        } else {
          file.rename(
              "${oldPath.substring(0, indiceDoNumeroDaNf)}IMP-$numeroDaNf");
        }
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
    } else {
      bool entrarNota = true;
      if (chaveNotaFiscal.contains(empresaCnpj)) {
        await showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "O CNPJ emissor é o seu, ainda quer cadastrar nota como ENTRADA?",
                    style: textMidImportance(),
                  ),
                  PersonalizedSpacer(amountSpaceHorizontal: 15),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Dar Entrada",
                          style: textMidImportance(color: darkGreen, font: 20),
                        ),
                      ),
                      PersonalizedSpacer(amountSpaceHorizontal: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.red),
                        onPressed: () {
                          entrarNota = false;
                          Navigator.pop(context);
                        },
                        child: Text("Voltar",
                            style: textMidImportance(color: darkRed, font: 20)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      }

      if (entrarNota) {
        final dhEmissao = document
            .xpath("/nfeProc/NFe/infNFe/ide/dhEmi")
            .single
            .innerText
            .substring(0, 19);
        final natOp =
            document.xpath("/nfeProc/NFe/infNFe/ide/natOp").single.innerText;

        String infComplementar = "";
        try {
          infComplementar = document
              .xpath("/nfeProc/NFe/infNFe/infAdic/infCpl")
              .single
              .innerText;
        } catch (e) {
          debugPrint("");
        }

        final listaVencimentos = {};
        index = 1;
        for (var vencimento in document.xpath("/nfeProc/NFe/infNFe/cobr/dup")) {
          String nDup = vencimento.findAllElements("nDup").single.innerText;
          listaVencimentos[nDup] = {
            "data_vencimento":
                vencimento.findAllElements("dVenc").single.innerText,
            "valor": vencimento.findAllElements("vDup").single.innerText
          };
          index++;
        }

        Map<String, dynamic> empresaEmissora = {};
        Map<String, dynamic> emissoraEndereco = {};
        Map<String, dynamic> empresaDestinataria = {};
        Map<String, dynamic> destinatariaEndereco = {};

        emissoraEndereco = {
          "rua": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/xLgr")
              .single
              .innerText,
          "numero": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/nro")
              .single
              .innerText,
          "bairro": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/xBairro")
              .single
              .innerText,
          "cod_municipio": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/cMun")
              .single
              .innerText,
          "municipio": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/xMun")
              .single
              .innerText,
          "uf": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/UF")
              .single
              .innerText,
          "cep": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/CEP")
              .single
              .innerText,
          "c_pais": document
              .xpath("/nfeProc/NFe/infNFe/emit/enderEmit/cPais")
              .single
              .innerText
        };

        empresaEmissora = {
          "cnpj":
              document.xpath("/nfeProc/NFe/infNFe/emit/CNPJ").single.innerText,
          "nome":
              document.xpath("/nfeProc/NFe/infNFe/emit/xNome").single.innerText,
          "inscEstadual":
              document.xpath("/nfeProc/NFe/infNFe/emit/IE").single.innerText,
          "endereco": emissoraEndereco
        };

        String cep = "";
        try {
          cep = document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/CEP")
              .single
              .innerText;
        } catch (e) {
          debugPrint("");
        }

        destinatariaEndereco = {
          "rua": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/xLgr")
              .single
              .innerText,
          "numero": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/nro")
              .single
              .innerText,
          "bairro": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/xBairro")
              .single
              .innerText,
          "cod_municipio": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/cMun")
              .single
              .innerText,
          "municipio": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/xMun")
              .single
              .innerText,
          "uf": document
              .xpath("/nfeProc/NFe/infNFe/dest/enderDest/UF")
              .single
              .innerText,
          "cep": cep,
        };

        String cnpj;
        try {
          cnpj =
              document.xpath("/nfeProc/NFe/infNFe/dest/CNPJ").single.innerText;
        } catch (e) {
          cnpj =
              document.xpath("/nfeProc/NFe/infNFe/dest/CPF").single.innerText;
        }

        String inscEstadual;
        try {
          inscEstadual =
              document.xpath("/nfeProc/NFe/infNFe/dest/IE").single.innerText;
        } catch (e) {
          inscEstadual = document
              .xpath("/nfeProc/NFe/infNFe/dest/indIEDest")
              .single
              .innerText;
        }

        empresaDestinataria = {
          "cnpj": cnpj,
          "nome":
              document.xpath("/nfeProc/NFe/infNFe/dest/xNome").single.innerText,
          "inscEstadual": inscEstadual,
          "endereco": destinatariaEndereco
        };

        List<Map<String, dynamic>> listaProdutos = [];
        Map<String, dynamic> lista = {};
        index = 1;

        for (var produto in document.xpath("/nfeProc/NFe/infNFe/det")) {
          var valorProduto = produto.findAllElements("vUnCom").single.innerText;
          lista["ValorVrod_$index"] = valorProduto;

          String cstIcms = "";
          String vBcIcms = "0.0";
          String pIcms = "0.0";
          String vIcms = "0.0";
          String vBcSt = "0.0";
          String pIcmsSt = "0.0";
          String vIcmsSt = "0.0";
          String vBcStRet = "0.0";
          String pSt = "0.0";
          String vIcmsSubstituto = "0.0";
          String vIcmsStRet = "0.0";
          String qBcMonoRet = "0.0";
          String adRemIcmsRet = "0.0";
          String vIcmsMonoRet = "0.0";
          String vBcEfet = "0.0";
          String pIcmsEfet = "0.0";
          String vIcmsEfet = "0.0";

          String cstIpi = "0.0";
          String vBcIpi = "0.0";
          String pIpi = "0.0";
          String vIpi = "0.0";

          String cstPis = "0.0";
          String vBcPis = "0.0";
          String pPis = "0.0";
          String vPis = "0.0";

          String cstCofins = "0.0";
          String vBcCofins = "0.0";
          String pCofins = "0.0";
          String vCofins = "0.0";

          var impostos = produto.findAllElements("imposto").toString();

          // PEGANDO INFORMAÇÕES DO ICMS
          String stringIcms = impostos.substring(
              impostos.indexOf("ICMS") + 5, impostos.indexOf("/ICMS") - 1);
          try {
            cstIcms = stringIcms.substring(
                stringIcms.indexOf("CST") + 4, stringIcms.indexOf("/CST") - 1);
          } catch (e) {
            debugPrint("");
          }

          switch (cstIcms) {
            case "00":
              vBcIcms = stringIcms.substring(stringIcms.indexOf("vBC") + 4,
                  stringIcms.indexOf("/vBC") - 1);

              pIcms = stringIcms.substring(stringIcms.indexOf("pICMS") + 6,
                  stringIcms.indexOf("/pICMS") - 1);
              vIcms = stringIcms.substring(stringIcms.indexOf("vICMS") + 6,
                  stringIcms.indexOf("/vICMS") - 1);

              break;

            case "10":
              vBcIcms = stringIcms.substring(stringIcms.indexOf("vBC") + 4,
                  stringIcms.indexOf("/vBC") - 1);

              pIcms = stringIcms.substring(stringIcms.indexOf("pICMS") + 6,
                  stringIcms.indexOf("/pICMS") - 1);
              vIcms = stringIcms.substring(stringIcms.indexOf("vICMS") + 6,
                  stringIcms.indexOf("/vICMS") - 1);

              vBcSt = stringIcms.substring(stringIcms.indexOf("vBCST") + 6,
                  stringIcms.indexOf("/vBCST") - 1);

              pIcmsSt = stringIcms.substring(stringIcms.indexOf("pICMSST") + 8,
                  stringIcms.indexOf("/pICMSST") - 1);

              vIcmsSt = stringIcms.substring(stringIcms.indexOf("vICMSST") + 8,
                  stringIcms.indexOf("/vICMSST") - 1);

              break;

            case "60":
              vBcStRet = stringIcms.substring(
                  stringIcms.indexOf("vBCSTRet") + 9,
                  stringIcms.indexOf("/vBCSTRet") - 1);
              pSt = stringIcms.substring(stringIcms.indexOf("pST") + 4,
                  stringIcms.indexOf("/pST") - 1);

              vIcmsSubstituto = stringIcms.substring(
                  stringIcms.indexOf("vICMSSubstituto") + 16,
                  stringIcms.indexOf("/vICMSSubstituto") - 1);

              vIcmsStRet = stringIcms.substring(
                  stringIcms.indexOf("vICMSSTRet") + 11,
                  stringIcms.indexOf("/vICMSSTRet") - 1);

              try {
                adRemIcmsRet = stringIcms.substring(
                    stringIcms.indexOf("adRemICMSRet") + 13,
                    stringIcms.indexOf("/adRemICMSRet") - 1);
              } catch (e) {
                debugPrint("");
              }

              try {
                vBcEfet = stringIcms.substring(
                    stringIcms.indexOf("vBCEfet") + 8,
                    stringIcms.indexOf("/vBCEfet") - 1);
              } catch (e) {
                debugPrint("");
              }

              try {
                pIcmsEfet = stringIcms.substring(
                    stringIcms.indexOf("pICMSEfet") + 10,
                    stringIcms.indexOf("/pICMSEfet") - 1);
              } catch (e) {
                debugPrint("");
              }

              try {
                vIcmsEfet = stringIcms.substring(
                    stringIcms.indexOf("vICMSEfet") + 10,
                    stringIcms.indexOf("/vICMSEfet") - 1);
              } catch (e) {
                debugPrint("");
              }

              break;

            case "61":
              qBcMonoRet = stringIcms.substring(
                  stringIcms.indexOf("qBCMonoRet") + 11,
                  stringIcms.indexOf("/qBCMonoRet") - 1);

              adRemIcmsRet = stringIcms.substring(
                  stringIcms.indexOf("adRemICMSRet") + 13,
                  stringIcms.indexOf("/adRemICMSRet") - 1);

              vIcmsMonoRet = stringIcms.substring(
                  stringIcms.indexOf("vICMSMonoRet") + 13,
                  stringIcms.indexOf("/vICMSMonoRet") - 1);

              break;
          }

          Map<String, String> icms = {
            "cstIcms": cstIcms,
            "vBcIcms": vBcIcms,
            "pIcms": pIcms,
            "vIcms": vIcms,
            "pSt": pSt,
            "vBcSt": vBcSt,
            "vBcStRet": vBcStRet,
            "pIcmsSt": pIcmsSt,
            "vIcmsSt": vIcmsSt,
            "vIcmsSubstituto": vIcmsSubstituto,
            "vIcmsStRet": vIcmsStRet,
            "adRemICMSRet": adRemIcmsRet,
            "vICMSMonoRet": vIcmsMonoRet,
            "vBcEfet": vBcEfet,
            "pIcmsEfet": pIcmsEfet,
            "vIcmsEfet": vIcmsEfet,
            "qBcMonoRet": qBcMonoRet,
            "adRemIcmsRet": adRemIcmsRet,
            "vIcmsMonoRet": vIcmsMonoRet,
          };

          try {
            String stringIpi = impostos.substring(
                impostos.indexOf("<IPI>"), impostos.indexOf("/IPI") - 1);
            cstIpi = stringIpi.substring(
                stringIpi.indexOf("CST") + 4, stringIpi.indexOf("/CST") - 1);

            switch (cstIpi) {
              case "50":
                vBcIpi = stringIpi.substring(
                    stringIpi.indexOf("vBC") + 4, stringIpi.indexOf("</vBC>"));
                pIpi = stringIpi.substring(stringIpi.indexOf("pIPI") + 5,
                    stringIpi.indexOf("</pIPI>"));
                vIpi = stringIpi.substring(stringIpi.indexOf("vIPI") + 5,
                    stringIpi.indexOf("</vIPI>"));
                break;
            }
          } catch (e) {
            debugPrint("");
          }

          Map<String, String> ipi = {
            "cst": cstIpi,
            "vBcIpi": vBcIpi,
            "pIpi": pIpi,
            "vIpi": vIpi
          };

          String stringPis = impostos.substring(
              impostos.indexOf("<PIS>"), impostos.indexOf("</PIS>"));

          cstPis = stringPis.substring(
              stringPis.indexOf("<CST>") + 5, stringPis.indexOf("</CST>"));

          switch (cstPis) {
            case "01":
              vBcPis = stringPis.substring(
                  stringPis.indexOf("vBC") + 4, stringPis.indexOf("</vBC>"));

              pPis = stringPis.substring(
                  stringPis.indexOf("pPIS") + 5, stringPis.indexOf("</pPIS>"));

              vPis = stringPis.substring(
                  stringPis.indexOf("vPIS") + 5, stringPis.indexOf("</vPIS>"));
              break;
          }

          Map<String, String> pis = {
            "cst": cstPis,
            "vBcIpi": vBcPis,
            "pIpi": pPis,
            "vIpi": vPis
          };

          String stringCofins = impostos.substring(
              impostos.indexOf("<COFINS>"), impostos.indexOf("</COFINS>"));

          cstCofins = stringCofins.substring(
              stringCofins.indexOf("CST") + 4, stringCofins.indexOf("</CST>"));

          switch (cstCofins) {
            case "01":
              vBcCofins = stringCofins.substring(
                  stringCofins.indexOf("<vBC>") + 5,
                  stringCofins.indexOf("</vBC>"));

              pCofins = stringCofins.substring(
                  stringCofins.indexOf("<pCOFINS>") + 9,
                  stringCofins.indexOf("</pCOFINS>"));

              vCofins = stringCofins.substring(
                  stringCofins.indexOf("<vCOFINS>") + 9,
                  stringCofins.indexOf("</vCOFINS>"));
              break;
          }

          Map<String, String> cofins = {
            "cst": cstCofins,
            "vBcIpi": vBcCofins,
            "pIpi": pCofins,
            "vIpi": vCofins
          };

          listaProdutos.add({
            "cProd": produto.findAllElements("cProd").single.innerText,
            "nome_produto": produto.findAllElements("xProd").single.innerText,
            "ncm": produto.findAllElements("NCM").single.innerText,
            "cfop": produto.findAllElements("CFOP").single.innerText,
            "vProd": produto.findAllElements("vProd").single.innerText,
            "uTrib": produto.findAllElements("uTrib").single.innerText,
            "qTrib": produto.findAllElements("qTrib").single.innerText,
            "vUnTrib": produto.findAllElements("vUnCom").single.innerText,
            "impostos": {"icms": icms, "ipi": ipi, "pis": pis, "cofins": cofins}
          });
          index++;
        }

        Map<String, double> valoresDaNota = {
          "valorBaseCalculo": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vBC")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorIcms": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vICMS")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorBaseCst": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vBCST")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorSt": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vST")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorDesconto": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vDesc")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorIpi": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vIPI")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorPis": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vPIS")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorCofins": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vCOFINS")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorOutro": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vOutro")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
          "valorNf": double.parse(double.parse(document
                  .xpath("/nfeProc/NFe/infNFe/total/ICMSTot/vNF")
                  .single
                  .innerText)
              .toStringAsFixed(2)),
        };

        double pesoL;
        double pesoB;
        try {
          pesoL = double.parse(document
              .xpath("/nfeProc/NFe/infNFe/transp/vol/pesoL")
              .single
              .innerText);
        } catch (e) {
          pesoL = 0.00;
        }

        try {
          pesoB = double.parse(document
              .xpath("/nfeProc/NFe/infNFe/transp/vol/pesoB")
              .single
              .innerText);
        } catch (e) {
          pesoB = 0.00;
        }

        Map<String, dynamic> transporte = {};
        String especie;
        String modFrete;
        String quantidade;

        try {
          modFrete = document
              .xpath("/nfeProc/NFe/infNFe/transp/modFrete")
              .single
              .innerText;
        } catch (e) {
          modFrete = "";
        }

        try {
          quantidade = document
              .xpath("/nfeProc/NFe/infNFe/transp/vol/qVol")
              .single
              .innerText;
        } catch (e) {
          quantidade = "";
        }
        try {
          especie = document
              .xpath("/nfeProc/NFe/infNFe/transp/vol/esp")
              .single
              .innerText;
        } catch (e) {
          especie = "";
        }

        transporte = {
          "mod_frete": modFrete,
          "quantidade": quantidade,
          "especie": especie,
          "peso_liq": pesoL,
          "peso_bruto": pesoB,
        };

        Map<String, dynamic> notaMongo = {
          "_id": chaveNotaFiscal,
          "nf": numeroNf,
          "dhEmissao": dhEmissao,
          "natOp": natOp,
          "infComplementar": infComplementar,
          "vencimentos": listaVencimentos,
          "empresaEmissora": empresaEmissora,
          "empresaDestinataria": empresaDestinataria,
          "produtos": listaProdutos,
          "valores": valoresDaNota,
          "transporte": transporte,
          "cancelada": false,
          "despesa": false
        };

        entrarNotaNoBanco(tipoNota, notaMongo, context);
        String oldPath = file.path;
        String numeroDaNf = oldPath.split("\\").last;
        var indiceDoNumeroDaNf = oldPath.indexOf(numeroDaNf);
        file.rename(
            "${oldPath.substring(0, indiceDoNumeroDaNf)}IMP-$numeroDaNf");
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) => Dialog(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.8),
                borderRadius: const BorderRadius.all(
                  Radius.circular(24),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "A nota é de Venda",
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
                ),
              ),
            ),
          ),
        );
      }
    }
  } else {
    // se não tiver nenhuma nota selecionada (null), indicar "Nota não encontrada"
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            borderRadius: const BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Nenhuma nota encontrada",
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
            ),
          ),
        ),
      ),
    );
  }
}
