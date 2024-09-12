import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/functions/cadastra_entidades.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:flutter/material.dart';

class CadastrarFornecedor extends StatefulWidget {
  const CadastrarFornecedor({super.key, required this.tipoCadastro});

  final int tipoCadastro;

  @override
  State<CadastrarFornecedor> createState() => _CadastrarFornecedorState();
}

class _CadastrarFornecedorState extends State<CadastrarFornecedor> {
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

  DateTime datetimeDataCadastro = DateTime.now();

  bool cnpjCadastrado = false;
  bool nomeEmpresaCadastrado = false;
  bool numeroFixoContatoCadastrado = false;
  bool numeroCelularContatoCadastrado = false;
  bool emailContatoCadastrado = false;

  List<String> listaUF = [
    "AC",
    "AL",
    "AP",
    "AM",
    "BA",
    "CE",
    "DF",
    "ES",
    "GO",
    "MA",
    "MT",
    "MS",
    "MG",
    "PA",
    "PB",
    "PR",
    "PE",
    "PI",
    "RJ",
    "RN",
    "RS",
    "RO",
    "RR",
    "SC",
    "SP",
    "SE",
    "TO",
  ];

  @override
  Widget build(BuildContext context) {
    String dia = "${datetimeDataCadastro.day}";
    String mes = "${datetimeDataCadastro.month}";
    String ano = "${datetimeDataCadastro.year}";

    if (int.parse(mes) < 10) {
      mes = "0$mes";
    }
    if (int.parse(dia) < 10) {
      dia = "0$dia";
    }

    DateTime dataHojeFormatado = DateTime.parse("$ano-$mes-$dia");

    DateTime ultAtualizacao = dataHojeFormatado;

    return SizedBox(
      width: MediaQuery.sizeOf(context).width * .9,
      height: MediaQuery.sizeOf(context).height * .75,
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
                    controller: TextEditingController()
                      ..text = "$dia/$mes/$ano",
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
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
                    readOnly: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: const OutlineInputBorder(),
                      labelText: widget.tipoCadastro == 0
                          ? 'Ultima Compra'
                          : "Ultima Venda",
                    ),
                    onChanged: ((value) {
                      nomeEmpresaController.text = value.toUpperCase();
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
              // Ultima Atualização (dataHojeFormatada)
              SizedBox(
                width: 300,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    readOnly: true,
                    controller: TextEditingController()
                      ..text = "$dia/$mes/$ano",
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
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
                width: MediaQuery.sizeOf(context).width * .15,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: cnpjController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'CNPJ da empresa',
                    ),
                    onChanged: ((cnpj) {
                      try {
                        String cnpjFormatado =
                            cnpj.replaceAllMapped(".", (match) => "");
                        cnpjFormatado =
                            cnpjFormatado.replaceAllMapped("/", (match) => "");
                        cnpjFormatado =
                            cnpjFormatado.replaceAllMapped("-", (match) => "");

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

                          cnpjController.text = "$grupo1.$grupo2.$grupo3";
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
                        int tamanhoCnpj = cnpjController.text.length;
                        cnpjController.text = tamanhoCnpj > 0
                            ? cnpjController.text.substring(0, tamanhoCnpj - 1)
                            : cnpjController.text.substring(0, tamanhoCnpj);
                      }
                    }),
                  ),
                ),
              ),
              // Inscriçao Estadual
              SizedBox(
                width: MediaQuery.sizeOf(context).width * .15,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: inscEstadualController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Inscriçao Estadual',
                    ),
                    onChanged: ((inscricaoEst) {
                      try {
                        String inscricaoEstadualFormatada =
                            inscricaoEst.replaceAllMapped(".", (match) => "");
                        double.parse(inscricaoEstadualFormatada);

                        dynamic grupo1 = "";
                        dynamic grupo2 = "";
                        dynamic grupo3 = "";
                        dynamic grupo4 = "";

                        if (inscricaoEstadualFormatada.length >= 12) {
                          grupo1 = inscricaoEstadualFormatada.substring(0, 3);
                          grupo2 = inscricaoEstadualFormatada.substring(3, 6);
                          grupo3 = inscricaoEstadualFormatada.substring(6, 9);
                          grupo4 = inscricaoEstadualFormatada.substring(9, 12);
                          inscEstadualController.text =
                              "$grupo1.$grupo2.$grupo3.$grupo4";
                        } else if (inscricaoEstadualFormatada.length == 9) {
                          grupo1 = inscricaoEstadualFormatada.substring(0, 3);
                          grupo2 = inscricaoEstadualFormatada.substring(3, 6);
                          grupo3 = inscricaoEstadualFormatada.substring(6, 9);
                          inscEstadualController.text =
                              "$grupo1.$grupo2.$grupo3";
                        } else if (inscricaoEstadualFormatada.length == 6) {
                          grupo1 = inscricaoEstadualFormatada.substring(0, 3);
                          grupo2 = inscricaoEstadualFormatada.substring(3, 6);
                          inscEstadualController.text = "$grupo1.$grupo2";
                        } else if (inscricaoEstadualFormatada.length == 3) {
                          grupo1 = inscricaoEstadualFormatada.substring(0, 3);
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
                width: MediaQuery.sizeOf(context).width * .6,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: nomeEmpresaController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Nome',
                    ),
                    onChanged: ((value) {
                      nomeEmpresaController.text = value.toUpperCase();
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
                      controller: cepController,
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(),
                        labelText: 'CEP',
                      ),
                      onChanged: ((cep) {
                        try {
                          String cepFormatado =
                              cep.replaceAllMapped("-", (match) => "");

                          double.parse(cepFormatado);

                          dynamic grupo1;
                          dynamic grupo2;

                          if (cepFormatado.length >= 8) {
                            grupo1 = cepFormatado.substring(0, 5);
                            grupo2 = cepFormatado.substring(5, 8);

                            setState(() {
                              cepController.text = "$grupo1-$grupo2";
                            });
                          } else {
                            setState(() {
                              cepController.text = cepFormatado;
                            });
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
                    controller: ruaController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
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
                    controller: numeroController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
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
                    controller: bairroController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
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
                    controller: municipioController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Município',
                    ),
                    onChanged: ((value) {
                      municipioController.text = value.toUpperCase();
                    }),
                  ),
                ),
              ),
              // UF
              SizedBox(
                width: 250,
                child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                      child: Autocomplete(
                        optionsBuilder: (TextEditingValue ufInserido) {
                          if (ufInserido.text == '') {
                            return const Iterable<String>.empty();
                          }
                          ufController.text = ufInserido.text;
                          return listaUF.where((String option) {
                            return option
                                .contains(ufInserido.text.toUpperCase());
                          });
                        },
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
                    controller: responsavelController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
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
                    controller: emailEmpresaController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Email para envio de NF',
                    ),
                    onChanged: ((emailOnChanged) {
                      emailOnChanged = emailOnChanged.toLowerCase();
                      emailEmpresaController.text = emailOnChanged;
                      // Expressão copiada do site https://emailregex.com/
                      const pattern =
                          r'''(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.)]).[a-z]''';
                      final regex = RegExp(pattern);

                      if (regex.hasMatch(emailOnChanged)) {
                        emailContatoCadastrado = true;
                      } else {
                        emailContatoCadastrado = false;
                      }

                      setState(() {});
                    }),
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
                    controller: numeroFixoController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: "Número Fixo",
                    ),
                    onChanged: ((value) {
                      String numero = value.replaceAll("(", "");
                      numero = numero.replaceAll(")", "");
                      numero = numero.replaceAll(" ", "");

                      if (numero.length > 2 && numero.length < 10) {
                        numeroFixoController.text =
                            "(${numero.substring(0, 2)}) ${numero.substring(2)}";
                        numeroFixoContatoCadastrado = false;
                      } else if (numero.length >= 10) {
                        numeroFixoController.text =
                            "(${numero.substring(0, 2)}) ${numero.substring(2, 10)}";
                        numeroFixoContatoCadastrado = true;
                      } else {
                        numeroFixoController.text = numero;
                      }
                      setState(() {});
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
                    controller: numeroCelularController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'Número Móvel',
                    ),
                    onChanged: ((value) {
                      String numero = value.replaceAll("(", "");
                      numero = numero.replaceAll(")", "");
                      numero = numero.replaceAll(" ", "");

                      if (numero.length > 2 && numero.length < 11) {
                        numeroCelularController.text =
                            "(${numero.substring(0, 2)}) ${numero.substring(2)}";
                        numeroCelularContatoCadastrado = false;
                      } else if (numero.length >= 11) {
                        numeroCelularController.text =
                            "(${numero.substring(0, 2)}) ${numero.substring(2, 11)}";
                        numeroCelularContatoCadastrado = true;
                      } else {
                        numeroCelularController.text = numero;
                        numeroCelularContatoCadastrado = false;
                      }
                      setState(() {});
                    }),
                  ),
                ),
              ),
            ],
          ),
          // BOTOES DE AÇÃO
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.red),
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancelar")),
                ),
                SizedBox(
                  width: 200,
                  height: 60,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: defaultGreen),
                      onPressed: cnpjCadastrado == true &&
                              nomeEmpresaCadastrado == true &&
                              (numeroCelularContatoCadastrado ||
                                  numeroFixoContatoCadastrado ||
                                  emailContatoCadastrado)
                          ? () {
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
                                  "$dataHojeFormatado",
                                  "$ultAtualizacao",
                                  "",
                                  widget.tipoCadastro);
                            }
                          : null,
                      child: const Text("Cadastrar")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    dataCadastro,
    ultAtualizacao,
    ultAcao,
    tipoCadastro,
  ) {
    String tipoDeEntidade = tipoCadastro == 0 ? "Fornecedor" : "Cliente";

    String numeroFixoFormatado = numeroFixo.replaceAll("(", "");
    numeroFixoFormatado = numeroFixoFormatado.replaceAll(")", "");
    numeroFixoFormatado = numeroFixoFormatado.replaceAll(" ", "");

    String numeroCelularFormatado = numeroCelular.replaceAll("(", "");
    numeroCelularFormatado = numeroCelularFormatado.replaceAll(")", "");
    numeroCelularFormatado = numeroCelularFormatado.replaceAll(" ", "");

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
                style: textLowImportance(color: Colors.red),
              ),
            ),
            TextButton(
              child: Text(
                'Cadastrar',
                style: textLowImportance(color: Colors.green),
              ),
              onPressed: () async {
                await cadastraEntidades(
                    cnpj,
                    nomeEmpresa,
                    inscEstadual,
                    emailEmpresa,
                    numeroFixoFormatado,
                    numeroCelularFormatado,
                    cep,
                    rua,
                    numero,
                    bairro,
                    municipio,
                    uf,
                    responsavel,
                    dataCadastro,
                    ultAtualizacao,
                    ultAcao,
                    tipoCadastro,
                    context);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
