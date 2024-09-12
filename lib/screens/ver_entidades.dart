import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/functions/cria_row_entidade.dart';
import 'package:erp/functions/funcoes_mongo/mongodb_actions.dart';
import 'package:erp/screens/cadastro_fornecedor_cliente.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class VerEntidades extends StatefulWidget {
  VerEntidades({
    super.key,
    this.tipoEntidade = 0,
  });

  int tipoEntidade;

  @override
  State<VerEntidades> createState() => _VerEntidadesState();
}

class _VerEntidadesState extends State<VerEntidades> {
  TextEditingController cnpjParaBuscar = TextEditingController();

  TextEditingController nomeEntidade = TextEditingController();
  TextEditingController cnpjEntidade = TextEditingController();

  bool cnpjCadastrado = false;

  @override
  Widget build(BuildContext context) {
    Future entidades = mongoPegaEntidades("", "", widget.tipoEntidade);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 400,
                child: TextField(
                  controller: nomeEntidade,
                  onChanged: (value) {
                    nomeEntidade.text = value;
                    entidades = mongoPegaEntidades(nomeEntidade.text,
                        cnpjEntidade.text, widget.tipoEntidade);
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Nome da Empresa',
                  ),
                ),
              ),
              SizedBox(
                width: 200,
                child: TextField(
                  controller: cnpjEntidade,
                  onChanged: ((cnpj) {
                    try {
                      if (cnpj.isNotEmpty) {
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
                          cnpjEntidade.text =
                              "$grupo1.$grupo2.$grupo3/$grupo4-$grupo5";
                        } else if (cnpjFormatado.length == 12) {
                          grupo1 = cnpjFormatado.substring(0, 2);
                          grupo2 = cnpjFormatado.substring(2, 5);
                          grupo3 = cnpjFormatado.substring(5, 8);
                          grupo4 = cnpjFormatado.substring(8, 12);

                          cnpjEntidade.text = "$grupo1.$grupo2.$grupo3/$grupo4";
                          cnpjCadastrado = false;
                        } else if (cnpjFormatado.length == 8) {
                          grupo1 = cnpjFormatado.substring(0, 2);
                          grupo2 = cnpjFormatado.substring(2, 5);
                          grupo3 = cnpjFormatado.substring(5, 8);

                          cnpjEntidade.text = "$grupo1.$grupo2.$grupo3";
                          cnpjCadastrado = false;
                        } else if (cnpjFormatado.length == 5) {
                          grupo1 = cnpjFormatado.substring(0, 2);
                          grupo2 = cnpjFormatado.substring(2, 5);

                          cnpjEntidade.text = "$grupo1.$grupo2";
                          cnpjCadastrado = false;
                        } else if (cnpjFormatado.length == 2) {
                          grupo1 = cnpjFormatado.substring(0, 2);
                          cnpjEntidade.text = "$grupo1";
                          cnpjCadastrado = false;
                        } else {
                          cnpjCadastrado = false;
                        }
                        entidades = mongoPegaEntidades(nomeEntidade.text,
                            cnpjFormatado, widget.tipoEntidade);
                      } else {
                        entidades = mongoPegaEntidades(nomeEntidade.text,
                            cnpjEntidade.text, widget.tipoEntidade);
                      }
                      setState(() {});
                    } catch (e) {
                      int tamanhoCnpj = cnpjEntidade.text.length;
                      cnpjEntidade.text = tamanhoCnpj > 0
                          ? cnpjEntidade.text.substring(0, tamanhoCnpj - 1)
                          : cnpjEntidade.text.substring(0, tamanhoCnpj);
                    }
                  }),
                  decoration: const InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(),
                      labelText: 'CNPJ'),
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      widget.tipoEntidade = 0;
                      entidades = mongoPegaEntidades(nomeEntidade.text,
                          cnpjEntidade.text, widget.tipoEntidade);
                      setState(() {});
                    },
                    child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        width: 150,
                        child: ListTile(
                          title: const Text("Cliente"),
                          leading: Radio(
                            value: 0,
                            groupValue: widget.tipoEntidade,
                            onChanged: (value) {
                              widget.tipoEntidade = 0;
                              entidades = mongoPegaEntidades(
                                nomeEntidade.text,
                                cnpjEntidade.text,
                                widget.tipoEntidade,
                              );
                              setState(() {});
                            },
                          ),
                        )),
                  ),
                  PersonalizedSpacer(amountSpaceHorizontal: 20),
                  GestureDetector(
                    onTap: () {
                      widget.tipoEntidade = 1;
                      entidades = mongoPegaEntidades(nomeEntidade.text,
                          cnpjEntidade.text, widget.tipoEntidade);
                      setState(() {});
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      width: 170,
                      child: ListTile(
                        title: const Text("Fornecedor"),
                        leading: Radio(
                          value: 1,
                          groupValue: widget.tipoEntidade,
                          onChanged: (value) {
                            widget.tipoEntidade = 1;
                            entidades = mongoPegaEntidades(
                              nomeEntidade.text,
                              cnpjEntidade.text,
                              widget.tipoEntidade,
                            );

                            setState(() {});
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              FilledButton(
                onPressed: () {},
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CadastroFornecedorECliente()),
                  );
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                  backgroundColor: darkGreen,
                  shape: const ContinuousRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16))),
                ),
                child: const Text("Cadastrar Empresa"),
              ),
            ],
          ),
          const Divider(
            height: 20,
            thickness: 2,
          ),
          Container(
            color: Colors.black.withOpacity(.2),
            width: MediaQuery.sizeOf(context).width,
            height: MediaQuery.sizeOf(context).height * .8,
            child: SingleChildScrollView(
              child: MontaTabelaDeEntidades(
                listaEntidades: entidades,
                tipoEntidade: widget.tipoEntidade,
              ),
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class MontaTabelaDeEntidades extends StatelessWidget {
  MontaTabelaDeEntidades({
    super.key,
    required this.listaEntidades,
    required this.tipoEntidade,
  });

  dynamic listaEntidades;
  int tipoEntidade;
  List<DataRow> listaRows = [];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: listaEntidades,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List lista =
                criaLinhasEntidades(snapshot.data, tipoEntidade, context);
            return DataTable(
                decoration: BoxDecoration(color: Colors.grey.withOpacity(.3)),
                border: TableBorder.all(),
                columns: [
                  DataColumn(
                      label: Text("Nome Empresa", style: textLowImportance())),
                  DataColumn(label: Text("CNPJ", style: textLowImportance())),
                  DataColumn(
                      label: Text(
                          tipoEntidade == 0 ? "Ult. Venda" : "Ult. Compra",
                          style: textLowImportance())),
                  DataColumn(
                      label: Text("Responsavel", style: textLowImportance())),
                  DataColumn(label: Text("Cidade", style: textLowImportance())),
                ],
                rows: [
                  for (var linha in lista) linha
                ]);
          } else {
            return const Text("Não tem dados");
          }
        });
  }
}
