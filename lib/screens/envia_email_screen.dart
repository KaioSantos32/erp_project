import 'dart:io';

import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/functions/funcoes_envio_de_notas/envia_email.dart';
import 'package:erp/functions/funcoes_envio_de_notas/pega_info_nota.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class EmailScreen extends StatefulWidget {
  const EmailScreen({super.key});

  @override
  State<EmailScreen> createState() => _EmailScreenState();
}

class _EmailScreenState extends State<EmailScreen> {
  String cliente = "";
  String nNf = "";
  String email = "";
  String caminhoNotaPdf = "Caminho para Nota em PDF";
  String caminhoCartaCorrecao = "Caminho para Carta de correção";
  String caminhoBoleto = "Caminho para Boleto";
  String caminhoXml = "";
  TextEditingController emailDigitado = TextEditingController();

  int podeEnviarEmail = 0;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextButton(
              onPressed: () async {
                List informacoes = await pegaInfoNota(context);
                setState(() {
                  // caminhoXml,
                  caminhoXml = informacoes[0]
                      .replaceAll("File: '", "")
                      .replaceAll("'", "");
                  // numeroNf,
                  nNf = informacoes[1];
                  // nomeCliente,
                  cliente = informacoes[2];
                  // emailCliente,
                  email = informacoes[3];
                  // caminhoNotaPdf,
                  caminhoNotaPdf = informacoes[4];
                  // caminhoBoleto
                  caminhoBoleto = informacoes[5];

                  email != "Sem email na nota"
                      ? podeEnviarEmail = 1
                      : podeEnviarEmail = 0;
                  emailDigitado.text = "";
                });
              },
              style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(20.0),
                  backgroundColor: darkBlue,
                  shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                  shadowColor: Colors.black,
                  elevation: 10),
              child: Text(
                "Importar XML",
                style: textLowImportance(color: Colors.white),
              ),
            ),
            PersonalizedSpacer(amountSpaceHorizontal: 40),
            Text(
              "Cliente: $cliente",
              style: textMidImportance(),
            ),
            PersonalizedSpacer(amountSpaceHorizontal: 40),
            email != "Sem email na nota"
                ? Text(
                    "Email: $email",
                    style: textMidImportance(),
                  )
                : SizedBox(
                    width: 300,
                    child: TextField(
                      controller: emailDigitado,
                      decoration: const InputDecoration(labelText: "Email:"),
                      onChanged: (value) {
                        const pattern =
                            r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.)]).[a-z]''';
                        final regex = RegExp(pattern);
                        setState(() {
                          if (regex.hasMatch(value.toLowerCase())) {
                            podeEnviarEmail = 1;
                            emailDigitado.text =
                                emailDigitado.text.toLowerCase();
                          } else {
                            emailDigitado.text =
                                emailDigitado.text.toLowerCase();
                            podeEnviarEmail = 0;
                          }
                        });
                      },
                    ),
                  ),
            PersonalizedSpacer(amountSpaceHorizontal: 40),
            Text(
              "N° Nota: $nNf",
              style: textMidImportance(),
            ),
            PersonalizedSpacer(amountSpaceHorizontal: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: TextButton(
                      onPressed: () async {
                        FilePickerResult? arquivoSelecionado =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ["pdf"],
                          initialDirectory:
                              "[caminho para pdf de nf]",
                        );
                        if (arquivoSelecionado != null) {
                          // arquivoSelecionado contém o caminho do arquivo em uma lista
                          // pegando o caminho do primeiro arquivo (Só tem 1 na lista)
                          setState(() {
                            caminhoNotaPdf = File(arquivoSelecionado.paths[0]!)
                                .toString()
                                .replaceAll("File: '", "")
                                .replaceAll("'", "");
                          });
                        }
                      },
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: defaultBlue,
                          shape: const ContinuousRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          shadowColor: Colors.black,
                          elevation: 10),
                      child: Text(
                        "Importar Nota Fiscal PDF",
                        style: textLowImportance(color: Colors.white),
                      )),
                ),
                PersonalizedSpacer(amountSpaceHorizontal: 60),
                SizedBox(
                  width: 400,
                  child: Text(
                    caminhoNotaPdf,
                    textAlign: TextAlign.center,
                    style: textLowImportance(),
                  ),
                )
              ],
            ),
            PersonalizedSpacer(amountSpaceHorizontal: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: TextButton(
                      onPressed: () async {
                        FilePickerResult? arquivoSelecionado =
                            await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: ["pdf"],
                          initialDirectory:
                              "[caminho para pdf de nf]",
                        );
                        if (arquivoSelecionado != null) {
                          // arquivoSelecionado contém o caminho do arquivo em uma lista
                          // pegando o caminho do primeiro arquivo (Só tem 1 na lista)
                          setState(() {
                            caminhoCartaCorrecao =
                                File(arquivoSelecionado.paths[0]!)
                                    .toString()
                                    .replaceAll("File: '", "")
                                    .replaceAll("'", "");
                          });
                        }
                      },
                      style: FilledButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          backgroundColor: defaultBlue,
                          shape: const ContinuousRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          shadowColor: Colors.black,
                          elevation: 10),
                      child: Text(
                        "Importar Carta de correção",
                        style: textLowImportance(color: Colors.white),
                      )),
                ),
                PersonalizedSpacer(amountSpaceHorizontal: 60),
                SizedBox(
                  width: 400,
                  child: Text(
                    caminhoCartaCorrecao,
                    textAlign: TextAlign.center,
                    style: textLowImportance(),
                  ),
                )
              ],
            ),
            PersonalizedSpacer(amountSpaceHorizontal: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 300,
                  child: TextButton(
                      onPressed: () async {
                        FilePickerResult? arquivoSelecionado =
                            await FilePicker.platform.pickFiles(
                                type: FileType.custom,
                                allowedExtensions: ["pdf"],
                                initialDirectory:
                                    "[caminho para pdf do boleto]");
                        if (arquivoSelecionado != null) {
                          // arquivoSelecionado contém o caminho do arquivo em uma lista
                          // pegando o caminho do primeiro arquivo (Só tem 1 na lista)
                          setState(() {
                            caminhoBoleto = File(arquivoSelecionado.paths[0]!)
                                .toString()
                                .replaceAll("File: '", "")
                                .replaceAll("'", "");
                          });
                        }
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.all(20.0),
                        backgroundColor: defaultBlue,
                        shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        shadowColor: Colors.black,
                        elevation: 10,
                      ),
                      child: Text(
                        "Importar Boleto",
                        style: textLowImportance(color: Colors.white),
                      )),
                ),
                PersonalizedSpacer(amountSpaceHorizontal: 60),
                SizedBox(
                    width: 400,
                    child: Text(
                      caminhoBoleto,
                      textAlign: TextAlign.center,
                      style: textLowImportance(),
                    ))
              ],
            ),
            PersonalizedSpacer(amountSpaceHorizontal: 40),
            podeEnviarEmail == 1
                ? TextButton(
                    onPressed: () {
                      enviaNotas(
                          email == "Sem email na nota"
                              ? emailDigitado.text
                              : email,
                          nNf,
                          caminhoXml,
                          caminhoNotaPdf,
                          caminhoBoleto,
                          caminhoCartaCorrecao,
                          context);
                    },
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                      backgroundColor: darkGreen,
                      shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      shadowColor: Colors.black,
                      elevation: 10,
                    ),
                    child: Text(
                      "Enviar Email",
                      style: textLowImportance(color: Colors.white),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
