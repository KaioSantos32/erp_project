import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/functions/funcoes_mongo/mongodb_actions.dart';
import 'package:erp/main.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VerTodaEntidade extends StatefulWidget {
  Map entidade;
  int tipoEntidade;
  int iniciado = 0;

  VerTodaEntidade(
      {super.key, required this.entidade, required this.tipoEntidade});

  @override
  State<VerTodaEntidade> createState() => _VerTodaEntidadeState();
}

class _VerTodaEntidadeState extends State<VerTodaEntidade> {
  TextEditingController cnpjController = TextEditingController();
  TextEditingController nomeEmpresaController = TextEditingController();
  TextEditingController inscEstadualController = TextEditingController();
  TextEditingController emailEmpresaController = TextEditingController();
  TextEditingController numeroFixoController = TextEditingController();
  TextEditingController numeroCelularController = TextEditingController();
  TextEditingController cepController = TextEditingController();
  TextEditingController ruaController = TextEditingController();
  TextEditingController numeroController = TextEditingController();
  TextEditingController bairroController = TextEditingController();
  TextEditingController municipioController = TextEditingController();
  TextEditingController ufController = TextEditingController();
  TextEditingController responsavelController = TextEditingController();
  TextEditingController dataCadastroController = TextEditingController();
  TextEditingController dataUltimaAtualizacaoController =
      TextEditingController();
  TextEditingController dataUltimaAcaoController = TextEditingController();

  bool cnpjCadastrado = false;
  bool nomeEmpresaCadastrado = false;
  bool apenasLeitura = true;

  @override
  Widget build(BuildContext context) {
    String tipoPesquisa = widget.tipoEntidade == 0 ? "ult_venda" : "ult_compra";

    // DATA ULTIMA ACAO
    String dataUltimaAcao = "";

    if (widget.entidade[tipoPesquisa].length > 4) {
      String diaUltimaAcao =
          widget.entidade[tipoPesquisa].toString().substring(8, 10);
      String mesUltimaAcao =
          widget.entidade[tipoPesquisa].toString().substring(5, 7);

      // if (int.parse(mesUltimaAcao) < 10) {
      //   mesUltimaAcao = "0$mesUltimaAcao";
      // }

      String anoUltimaAcao =
          widget.entidade[tipoPesquisa].toString().substring(0, 4);

      dataUltimaAcao = "$diaUltimaAcao/$mesUltimaAcao/$anoUltimaAcao";
    } else {
      dataUltimaAcao = "";
    }

    // DATA DE CADASTRO
    String diaDataCadastro =
        widget.entidade["dataCadastro"].toString().substring(8, 10);
    String mesDataCadastro =
        widget.entidade["dataCadastro"].toString().substring(5, 7);

    String anoDataCadastro =
        widget.entidade["dataCadastro"].toString().substring(0, 4);

    String dataCadastro = "";
    dataCadastro = "$diaDataCadastro/$mesDataCadastro/$anoDataCadastro";

    // DATA ULTIMA ATUALIZACAO
    String diaDataAtualizacao =
        widget.entidade["ultAtualizacao"].toString().substring(8, 10);
    String mesDataAtualizacao =
        widget.entidade["ultAtualizacao"].toString().substring(5, 7);
    String anoDataAtualizacao =
        widget.entidade["ultAtualizacao"].toString().substring(0, 4);

    String dataAtualizacao = "";

    // if (int.parse(mesDataAtualizacao) < 10) {
    //   mesDataAtualizacao = "0$mesDataAtualizacao";
    // }

    dataAtualizacao =
        "$diaDataAtualizacao/$mesDataAtualizacao/$anoDataAtualizacao";

    // INDICANDO TEXTO INICIAL DOS CONTROLLERS
    if (widget.iniciado == 0) {
      dynamic grupo1 = "";
      dynamic grupo2 = "";
      dynamic grupo3 = "";
      dynamic grupo4 = "";
      dynamic grupo5 = "";

      grupo1 = widget.entidade["_cnpj_entidade"].substring(0, 2);
      grupo2 = widget.entidade["_cnpj_entidade"].substring(2, 5);
      grupo3 = widget.entidade["_cnpj_entidade"].substring(5, 8);
      grupo4 = widget.entidade["_cnpj_entidade"].substring(8, 12);
      grupo5 = widget.entidade["_cnpj_entidade"].substring(12, 14);
      cnpjController.text = "$grupo1.$grupo2.$grupo3/$grupo4-$grupo5";

      nomeEmpresaController.text = widget.entidade["nome"];
      inscEstadualController.text = widget.entidade["inscEstadual"];
      emailEmpresaController.text = widget.entidade["contato"]["email"];
      numeroFixoController.text = widget.entidade["contato"]["telefoneFixo"];
      numeroCelularController.text =
          widget.entidade["contato"]["telefoneMovel"];
      cepController.text = widget.entidade["endereco"]["cep"];
      ruaController.text = widget.entidade["endereco"]["rua"];
      numeroController.text = widget.entidade["endereco"]["numero"];
      bairroController.text = widget.entidade["endereco"]["bairro"];
      municipioController.text = widget.entidade["endereco"]["municipio"];
      ufController.text = widget.entidade["endereco"]["uf"];
      responsavelController.text = widget.entidade["responsavel"];

      dataCadastroController.text = dataCadastro;
      dataUltimaAtualizacaoController.text = dataAtualizacao;
      dataUltimaAcaoController.text = dataUltimaAcao;
    }
    return Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        appBar: AppBar(
          shadowColor: lightGreen,
          elevation: 6,
          backgroundColor: defaultGreen,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cadastro de - ${widget.entidade["nome"]}",
                style: const TextStyle(
                  fontFamily: "Righteous",
                  color: white,
                  fontSize: 32,
                ),
              ),
              Text(
                appVersion,
                style: const TextStyle(
                  fontFamily: "Righteous",
                  color: white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    apenasLeitura == true
                        ? ElevatedButton(
                            onPressed: () {
                              _showMyDialog(
                                  cnpjController.text,
                                  nomeEmpresaController.text,
                                  inscEstadualController.text,
                                  emailEmpresaController.text,
                                  numeroFixoController.text,
                                  numeroCelularController.text,
                                  cepController.text,
                                  ruaController.text,
                                  numeroController.text,
                                  bairroController.text,
                                  municipioController.text,
                                  ufController.text,
                                  responsavelController.text,
                                  widget.tipoEntidade,
                                  context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: defaultRed,
                                foregroundColor: darkRed,
                                elevation: 5.0),
                            child: Text("Excluir Cadastro",
                                style: textMidImportance(color: white)))
                        : const Text(""),
                    apenasLeitura == true
                        ? ElevatedButton(
                            onPressed: () {
                              apenasLeitura = false;
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: defaultBlue,
                                foregroundColor: darkBlue,
                                elevation: 5.0),
                            child: Text(
                              "Editar",
                              style: textMidImportance(color: white),
                            ))
                        : ElevatedButton(
                            onPressed: () {
                              apenasLeitura = true;
                              setState(() {});
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: defaultRed,
                                foregroundColor: darkRed,
                                elevation: 5.0),
                            child: Text(
                              "Cancelar",
                              style: textMidImportance(color: white),
                            ),
                          ),
                    apenasLeitura == true
                        ? ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: defaultGreen,
                                foregroundColor: darkGreen,
                                elevation: 5.0),
                            child: Text(
                              "Voltar",
                              style: textMidImportance(color: white),
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              apenasLeitura = true;
                              DateTime dataUltimaAtiaizacao = DateTime.now();
                              dynamic diaUltimaAtualizacao =
                                  "${dataUltimaAtiaizacao.day}";
                              dynamic mesUltimaAtualizacao =
                                  "${dataUltimaAtiaizacao.month}";
                              dynamic anoUltimaAtualizacao =
                                  "${dataUltimaAtiaizacao.year}";

                              String cnpjFormatado = cnpjController.text
                                  .replaceAllMapped(".", (match) => "");
                              cnpjFormatado = cnpjFormatado.replaceAllMapped(
                                  "/", (match) => "");
                              cnpjFormatado = cnpjFormatado.replaceAllMapped(
                                  "-", (match) => "");

                              String cepFormatado = cepController.text
                                  .replaceAllMapped("-", (match) => "");

                              if (int.parse(mesUltimaAtualizacao) < 10) {
                                mesUltimaAtualizacao = "0$mesUltimaAtualizacao";
                              }
                              if (int.parse(diaUltimaAtualizacao) < 10) {
                                diaUltimaAtualizacao = "0$diaUltimaAtualizacao";
                              }

                              Map entidade = {
                                "cnpj": cnpjFormatado,
                                "endereco": {
                                  "cep": cepFormatado,
                                  "rua": ruaController.text,
                                  "numero": numeroController.text,
                                  "bairro": bairroController.text,
                                  "municipio": municipioController.text,
                                  "uf": ufController.text,
                                },
                                "responsavel": responsavelController.text,
                                "contato": {
                                  "email": emailEmpresaController.text,
                                  "numeroFixo": numeroFixoController.text,
                                  "numeroCelular": numeroCelularController.text,
                                },
                                "ultimaAtualizacao":
                                    "${DateTime.parse("$anoUltimaAtualizacao-$mesUltimaAtualizacao-$diaUltimaAtualizacao")}"
                                // "$diaUltimaAtualizacao-$mesUltimaAtualizacao-$anoUltimaAtualizacao",
                              };

                              atualizaCadastroEntidade(
                                  entidade, widget.tipoEntidade);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => NavRail(
                                            selectedIndex: 6,
                                            tipoEntidadeBuscada:
                                                widget.tipoEntidade,
                                          )));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: defaultBlue,
                                foregroundColor: darkBlue,
                                elevation: 5.0),
                            child: Text(
                              "Salvar",
                              style: textMidImportance(color: white),
                            ),
                          )
                  ]),
            ),
            PersonalizedSpacer(amountSpaceHorizontal: 20),
            SizedBox(
                width: MediaQuery.of(context).size.width * .9,
                height: MediaQuery.of(context).size.height * .75,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Data de cadastro (dataHojeFormatada)
                          SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: true,
                                controller: dataCadastroController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(.2),
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: 'Data de cadastro',
                                ),
                              ),
                            ),
                          ),
                          // Ultima Compra (dataHojeFormatada)
                          SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                controller: dataUltimaAcaoController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(.2),
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: widget.tipoEntidade == 0
                                      ? 'Ultima Venda'
                                      : "Ultima Compra",
                                ),
                              ),
                            ),
                          ),
                          // Ultima Atualização (dataHojeFormatada)
                          SizedBox(
                            width: 300,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: true,
                                controller: dataUltimaAtualizacaoController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(.2),
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: 'Ultima Atualização',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // CNPJ
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .15,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: true,
                                controller: cnpjController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(.2),
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: 'CNPJ da empresa',
                                ),
                                onChanged: ((cnpj) {
                                  try {
                                    String cnpjFormatado = cnpj
                                        .replaceAllMapped(".", (match) => "");
                                    cnpjFormatado = cnpjFormatado
                                        .replaceAllMapped("/", (match) => "");
                                    cnpjFormatado = cnpjFormatado
                                        .replaceAllMapped("-", (match) => "");

                                    double.parse(cnpjFormatado);
                                    dynamic grupo1;
                                    dynamic grupo2;
                                    dynamic grupo3;
                                    dynamic grupo4;
                                    dynamic grupo5;

                                    if (cnpjFormatado.length >= 14) {
                                      grupo1 = cnpjFormatado.substring(0, 2);
                                      grupo2 = cnpjFormatado.substring(2, 5);
                                      grupo3 = cnpjFormatado.substring(5, 8);
                                      grupo4 = cnpjFormatado.substring(8, 12);
                                      grupo5 = cnpjFormatado.substring(12, 14);
                                      cnpjCadastrado = true;
                                      cnpjController.text =
                                          "$grupo1.$grupo2.$grupo3/$grupo4-$grupo5";
                                    } else if (cnpjFormatado.length == 12) {
                                      grupo1 = cnpjFormatado.substring(0, 2);
                                      grupo2 = cnpjFormatado.substring(2, 5);
                                      grupo3 = cnpjFormatado.substring(5, 8);
                                      grupo4 = cnpjFormatado.substring(8, 12);

                                      cnpjController.text =
                                          "$grupo1.$grupo2.$grupo3/$grupo4";
                                      cnpjCadastrado = false;
                                    } else if (cnpjFormatado.length == 8) {
                                      grupo1 = cnpjFormatado.substring(0, 2);
                                      grupo2 = cnpjFormatado.substring(2, 5);
                                      grupo3 = cnpjFormatado.substring(5, 8);

                                      cnpjController.text =
                                          "$grupo1.$grupo2.$grupo3";
                                      cnpjCadastrado = false;
                                    } else if (cnpjFormatado.length == 5) {
                                      grupo1 = cnpjFormatado.substring(0, 2);
                                      grupo2 = cnpjFormatado.substring(2, 5);

                                      cnpjController.text = "$grupo1.$grupo2";
                                      cnpjCadastrado = false;
                                    } else if (cnpjFormatado.length == 2) {
                                      grupo1 = cnpjFormatado.substring(0, 2);
                                      cnpjController.text = "$grupo1";
                                      cnpjCadastrado = false;
                                    } else {
                                      cnpjCadastrado = false;
                                    }
                                    setState(() {});
                                  } catch (e) {
                                    int tamanhoCnpj =
                                        cnpjController.text.length;
                                    cnpjController.text = tamanhoCnpj > 0
                                        ? cnpjController.text
                                            .substring(0, tamanhoCnpj - 1)
                                        : cnpjController.text
                                            .substring(0, tamanhoCnpj);
                                  }
                                }),
                              ),
                            ),
                          ),
                          // Inscriçao Estadual
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .15,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: true,
                                controller: inscEstadualController,
                                decoration: InputDecoration(
                                  fillColor: apenasLeitura
                                      ? Colors.grey.withOpacity(.2)
                                      : Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: 'Inscriçao Estadual',
                                ),
                                onChanged: ((inscricaoEst) {
                                  try {
                                    String inscricaoEstadualFormatada =
                                        inscricaoEst.replaceAllMapped(
                                            ".", (match) => "");
                                    double.parse(inscricaoEstadualFormatada);

                                    dynamic grupo1 = "";
                                    dynamic grupo2 = "";
                                    dynamic grupo3 = "";
                                    dynamic grupo4 = "";

                                    if (inscricaoEstadualFormatada.length >=
                                        12) {
                                      grupo1 = inscricaoEstadualFormatada
                                          .substring(0, 3);
                                      grupo2 = inscricaoEstadualFormatada
                                          .substring(3, 6);
                                      grupo3 = inscricaoEstadualFormatada
                                          .substring(6, 9);
                                      grupo4 = inscricaoEstadualFormatada
                                          .substring(9, 12);
                                      inscEstadualController.text =
                                          "$grupo1.$grupo2.$grupo3.$grupo4";
                                    } else if (inscricaoEstadualFormatada
                                            .length ==
                                        9) {
                                      grupo1 = inscricaoEstadualFormatada
                                          .substring(0, 3);
                                      grupo2 = inscricaoEstadualFormatada
                                          .substring(3, 6);
                                      grupo3 = inscricaoEstadualFormatada
                                          .substring(6, 9);
                                      inscEstadualController.text =
                                          "$grupo1.$grupo2.$grupo3";
                                    } else if (inscricaoEstadualFormatada
                                            .length ==
                                        6) {
                                      grupo1 = inscricaoEstadualFormatada
                                          .substring(0, 3);
                                      grupo2 = inscricaoEstadualFormatada
                                          .substring(3, 6);
                                      inscEstadualController.text =
                                          "$grupo1.$grupo2";
                                    } else if (inscricaoEstadualFormatada
                                            .length ==
                                        3) {
                                      grupo1 = inscricaoEstadualFormatada
                                          .substring(0, 3);
                                      inscEstadualController.text = "$grupo1";
                                    }
                                    setState(() {});
                                  } catch (e) {
                                    int tamanhoInscEstadual =
                                        inscEstadualController.text.length;
                                    inscEstadualController.text =
                                        inscEstadualController.text.substring(
                                            0,
                                            tamanhoInscEstadual > 0
                                                ? tamanhoInscEstadual - 1
                                                : tamanhoInscEstadual);
                                  }
                                }),
                              ),
                            ),
                          ),
                          // NOME
                          SizedBox(
                            width: MediaQuery.of(context).size.width * .6,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: true,
                                controller: nomeEmpresaController,
                                decoration: InputDecoration(
                                  fillColor: Colors.grey.withOpacity(.2),
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: 'Nome',
                                ),
                                onChanged: ((value) {
                                  nomeEmpresaController.text =
                                      value.toUpperCase();
                                  if (value.length >= 3) {
                                    nomeEmpresaCadastrado = true;
                                    setState(() {});
                                  } else {
                                    nomeEmpresaCadastrado = false;
                                    setState(() {});
                                  }
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          "Endereço",
                          style: textMidImportance(),
                        ),
                      ),
                      // ENDEREÇO LINHA 1
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // CEP
                          SizedBox(
                            width: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                  readOnly: apenasLeitura,
                                  controller: cepController,
                                  decoration: InputDecoration(
                                    fillColor: apenasLeitura
                                        ? Colors.grey.withOpacity(.2)
                                        : Colors.white,
                                    filled: true,
                                    border: const OutlineInputBorder(),
                                    labelText: 'CEP',
                                  ),
                                  onChanged: ((cep) {
                                    try {
                                      String cepFormatado = cep
                                          .replaceAllMapped("-", (match) => "");

                                      double.parse(cepFormatado);

                                      dynamic grupo1;
                                      dynamic grupo2;

                                      debugPrint(cepFormatado);
                                      debugPrint("${cepFormatado.length}");

                                      if (cepFormatado.length >= 8) {
                                        grupo1 = cepFormatado.substring(0, 5);
                                        grupo2 = cepFormatado.substring(5, 8);
                                        cepController.text = "$grupo1-$grupo2";
                                      } else {
                                        cepController.text = cepFormatado;
                                      }
                                    } catch (e) {
                                      cepController.text = "";
                                    }
                                  })),
                            ),
                          ),
                          // RUA
                          SizedBox(
                            width: 800,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: apenasLeitura,
                                controller: ruaController,
                                decoration: InputDecoration(
                                  fillColor: apenasLeitura
                                      ? Colors.grey.withOpacity(.2)
                                      : Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: 'Rua',
                                ),
                                onChanged: ((value) {
                                  ruaController.text = value.toUpperCase();
                                }),
                              ),
                            ),
                          ),
                          // NÚMERO
                          SizedBox(
                            width: 250,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: apenasLeitura,
                                controller: numeroController,
                                decoration: InputDecoration(
                                  fillColor: apenasLeitura
                                      ? Colors.grey.withOpacity(.2)
                                      : Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: 'Número',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // ENDEREÇO LINHA 2
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // BAIRRO
                          SizedBox(
                            width: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: apenasLeitura,
                                controller: bairroController,
                                decoration: InputDecoration(
                                  fillColor: apenasLeitura
                                      ? Colors.grey.withOpacity(.2)
                                      : Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: 'Bairro',
                                ),
                                onChanged: ((value) {
                                  bairroController.text = value.toUpperCase();
                                }),
                              ),
                            ),
                          ),
                          // MUNICÍPIO
                          SizedBox(
                            width: 800,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: apenasLeitura,
                                controller: municipioController,
                                decoration: InputDecoration(
                                  fillColor: apenasLeitura
                                      ? Colors.grey.withOpacity(.2)
                                      : Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: 'Município',
                                ),
                                onChanged: ((value) {
                                  municipioController.text =
                                      value.toUpperCase();
                                }),
                              ),
                            ),
                          ),
                          // UF
                          SizedBox(
                            width: 250,
                            child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  readOnly: apenasLeitura,
                                  controller: ufController,
                                  decoration: InputDecoration(
                                    fillColor: apenasLeitura
                                        ? Colors.grey.withOpacity(.2)
                                        : Colors.white,
                                    filled: true,
                                    border: const OutlineInputBorder(),
                                    labelText: "UF",
                                  ),
                                )),
                          ),
                        ],
                      ),
                      // RESPONSAVEL E EMAIL DE NF
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // RESPONSAVEL
                          SizedBox(
                            width: 500,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: apenasLeitura,
                                controller: responsavelController,
                                decoration: InputDecoration(
                                  fillColor: apenasLeitura
                                      ? Colors.grey.withOpacity(.2)
                                      : Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: "Responsável",
                                ),
                              ),
                            ),
                          ),
                          // EMAIL PARA ENVIO DE NF
                          SizedBox(
                            width: 600,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: apenasLeitura,
                                controller: emailEmpresaController,
                                decoration: InputDecoration(
                                  fillColor: apenasLeitura
                                      ? Colors.grey.withOpacity(.2)
                                      : Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: 'Email para envio de NF',
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // NUMERO FIXO E MÓVEL
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // FIXO
                          SizedBox(
                            width: 500,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: apenasLeitura,
                                controller: numeroFixoController,
                                decoration: InputDecoration(
                                  fillColor: apenasLeitura
                                      ? Colors.grey.withOpacity(.2)
                                      : Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: "Número Fixo",
                                ),
                                onChanged: ((value) {
                                  String numero = value.replaceAll("(", "");
                                  numero = numero.replaceAll(")", "");
                                  numero = numero.replaceAll(" ", "");

                                  if (numero.length > 2 && numero.length < 10) {
                                    numeroFixoController.text =
                                        "(${numero.substring(0, 2)}) ${numero.substring(2)}";
                                  } else if (numero.length >= 10) {
                                    numeroFixoController.text =
                                        "(${numero.substring(0, 2)}) ${numero.substring(2, 10)}";
                                  } else {
                                    numeroFixoController.text = numero;
                                  }
                                  // setState(() {});
                                }),
                              ),
                            ),
                          ),
                          // MOVEL
                          SizedBox(
                            width: 600,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                readOnly: apenasLeitura,
                                controller: numeroCelularController,
                                decoration: InputDecoration(
                                  fillColor: apenasLeitura
                                      ? Colors.grey.withOpacity(.2)
                                      : Colors.white,
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  labelText: 'Número Móvel',
                                ),
                                onChanged: ((value) {
                                  String numero = value.replaceAll("(", "");
                                  numero = numero.replaceAll(")", "");
                                  numero = numero.replaceAll(" ", "");

                                  if (numero.length > 2 && numero.length < 11) {
                                    numeroCelularController.text =
                                        "(${numero.substring(0, 2)}) ${numero.substring(2)}";
                                  } else if (numero.length >= 11) {
                                    numeroCelularController.text =
                                        "(${numero.substring(0, 2)}) ${numero.substring(2, 11)}";
                                  } else {
                                    numeroCelularController.text = numero;
                                  }
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ])),
          ],
        ));
  }
}

_showMyDialog(
    cnpj,
    nomeEmpresa,
    inscEstadual,
    emailEmpresa,
    numeroFixo,
    numeroCelular,
    cep,
    rua,
    numero,
    bairro,
    municipio,
    uf,
    responsavel,
    tipoCadastro,
    context) {
  String tipoDeEntidade = tipoCadastro == 0 ? "Cliente" : "Fornecedor";

  String numeroFixoFormatado = numeroFixo.replaceAll("(", "");
  numeroFixoFormatado = numeroFixoFormatado.replaceAll(")", "");
  numeroFixoFormatado = numeroFixoFormatado.replaceAll(" ", "");

  String numeroCelularFormatado = numeroCelular.replaceAll("(", "");
  numeroCelularFormatado = numeroCelularFormatado.replaceAll(")", "");
  numeroCelularFormatado = numeroCelularFormatado.replaceAll(" ", "");

  String cnpjFormatado = cnpj.replaceAll("-", "");
  cnpjFormatado = cnpjFormatado.replaceAll("/", "");
  cnpjFormatado = cnpjFormatado.replaceAll(".", "");

  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          "Cadastro de $tipoDeEntidade",
          style: textHighImportance(),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: 600,
          child: SingleChildScrollView(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "Nome: ",
                    style: textLowImportance(),
                  ),
                  Text(
                    nomeEmpresa,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "CNPJ: ",
                    style: textLowImportance(),
                  ),
                  Text(
                    cnpj,
                    style: const TextStyle(fontSize: 18),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    "Ins. Estadual: ",
                    style: textLowImportance(),
                  ),
                  Text(
                    inscEstadual,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Email de NF: ",
                    style: textLowImportance(),
                  ),
                  Text(
                    emailEmpresa,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Número Fixo: ",
                    style: textLowImportance(),
                  ),
                  Text(
                    numeroFixoFormatado,
                    style: const TextStyle(fontSize: 18),
                  ),
                  PersonalizedSpacer(amountSpaceHorizontal: 30),
                  Text(
                    "Número Celular: ",
                    style: textLowImportance(),
                  ),
                  Text(
                    numeroCelularFormatado,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Email de NF: ",
                    style: textLowImportance(),
                  ),
                  Text(
                    emailEmpresa,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              const Text(""),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Endereço",
                  style: textMidImportance(),
                ),
              ),
              Row(
                children: [
                  Text(
                    "CEP: ",
                    style: textLowImportance(),
                  ),
                  Text(
                    cep,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Rua: ",
                    style: textLowImportance(),
                  ),
                  Text(
                    "$rua, $numero",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Bairro: ",
                    style: textLowImportance(),
                  ),
                  Text(
                    bairro,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "Município: ",
                    style: textLowImportance(),
                  ),
                  Text(
                    municipio,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    "UF: ",
                    style: textLowImportance(),
                  ),
                  Text(
                    uf,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
              PersonalizedSpacer(amountSpaceHorizontal: 20),
              Row(
                children: [
                  Text(
                    "Responsável na empresa: ",
                    style: textLowImportance(),
                  ),
                  Text(
                    responsavel,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ],
          )),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(foregroundColor: Colors.red),
            child: Text(
              'Cancelar',
              style: textLowImportance(color: Colors.green),
            ),
          ),
          TextButton(
              child: Text(
                'Excluir',
                style: textLowImportance(color: Colors.red),
              ),
              onPressed: () {
                excluirCadastroEntidade(
                    cnpjFormatado, tipoCadastro, nomeEmpresa, context);
                Navigator.pop(context);
              }),
        ],
      );
    },
  );
}
