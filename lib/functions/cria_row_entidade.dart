import 'package:erp/screens/cadastro_fornecedor_cliente/ver_toda_entidade.dart';
import 'package:flutter/material.dart';

criaLinhasEntidades(
    dynamic listaEntidades, int tipoEntidade, BuildContext context) {
  List listaRows = [];

  String tipoBusca = tipoEntidade == 0 ? "ult_venda" : "ult_compra";

  for (var entidade in listaEntidades) {
    String dia;
    String mes;
    String ano;
    String ultimaAcao = "";

    try {
      if ("${entidade[tipoBusca]}".length > 4) {
        dia = entidade[tipoBusca].toString().substring(8, 10);
        mes = entidade[tipoBusca].toString().substring(5, 7);
        ano = entidade[tipoBusca].toString().substring(0, 4);

        
        ultimaAcao = "$dia/$mes/$ano";
      }
    } catch (e) {
      debugPrint("");
    }

    listaRows.add(DataRow(
      cells: [
        DataCell(Text("${entidade["nome"]}"), onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerTodaEntidade(
                        entidade: {
                          "_cnpj_entidade": entidade["_cnpj_entidade"],
                          "nome": entidade["nome"],
                          "inscEstadual": entidade["inscEstadual"],
                          "endereco": {
                            "cep": entidade["endereco"]["cep"],
                            "rua": entidade["endereco"]["rua"],
                            "numero": entidade["endereco"]["numero"],
                            "bairro": entidade["endereco"]["bairro"],
                            "municipio": entidade["endereco"]["municipio"],
                            "uf": entidade["endereco"]["uf"]
                          },
                          "dataCadastro": entidade["dataCadastro"],
                          "ultAtualizacao": entidade["ultAtualizacao"],
                          "responsavel": entidade["responsavel"],
                          "contato": {
                            "email": entidade["contato"]["email"],
                            "telefoneFixo": entidade["contato"]["telefoneFixo"],
                            "telefoneMovel": entidade["contato"]
                                ["telefoneMovel"]
                          },
                          "ult_compra": entidade[tipoBusca],
                          tipoBusca: entidade[tipoBusca]
                        },
                        tipoEntidade: tipoEntidade,
                      )));
        }),
        DataCell(Text("${entidade["_cnpj_entidade"]}"), onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerTodaEntidade(
                        entidade: {
                          "_cnpj_entidade": entidade["_cnpj_entidade"],
                          "nome": entidade["nome"],
                          "inscEstadual": entidade["inscEstadual"],
                          "endereco": {
                            "cep": entidade["endereco"]["cep"],
                            "rua": entidade["endereco"]["rua"],
                            "numero": entidade["endereco"]["numero"],
                            "bairro": entidade["endereco"]["bairro"],
                            "municipio": entidade["endereco"]["municipio"],
                            "uf": entidade["endereco"]["uf"]
                          },
                          "dataCadastro": entidade["dataCadastro"],
                          "ultAtualizacao": entidade["ultAtualizacao"],
                          "responsavel": entidade["responsavel"],
                          "contato": {
                            "email": entidade["contato"]["email"],
                            "telefoneFixo": entidade["contato"]["telefoneFixo"],
                            "telefoneMovel": entidade["contato"]
                                ["telefoneMovel"]
                          },
                          tipoBusca: entidade[tipoBusca],
                        },
                        tipoEntidade: tipoEntidade,
                      )));
        }),
        DataCell(Text(ultimaAcao), onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerTodaEntidade(
                        entidade: {
                          "_cnpj_entidade": entidade["_cnpj_entidade"],
                          "nome": entidade["nome"],
                          "inscEstadual": entidade["inscEstadual"],
                          "endereco": {
                            "cep": entidade["endereco"]["cep"],
                            "rua": entidade["endereco"]["rua"],
                            "numero": entidade["endereco"]["numero"],
                            "bairro": entidade["endereco"]["bairro"],
                            "municipio": entidade["endereco"]["municipio"],
                            "uf": entidade["endereco"]["uf"]
                          },
                          "dataCadastro": entidade["dataCadastro"],
                          "ultAtualizacao": entidade["ultAtualizacao"],
                          "responsavel": entidade["responsavel"],
                          "contato": {
                            "email": entidade["contato"]["email"],
                            "telefoneFixo": entidade["contato"]["telefoneFixo"],
                            "telefoneMovel": entidade["contato"]
                                ["telefoneMovel"]
                          },
                          "ult_compra": entidade[tipoBusca],
                          tipoBusca: entidade[tipoBusca]
                        },
                        tipoEntidade: tipoEntidade,
                      )));
        }),
        DataCell(Text("${entidade["responsavel"]}"), onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerTodaEntidade(
                        entidade: {
                          "_cnpj_entidade": entidade["_cnpj_entidade"],
                          "nome": entidade["nome"],
                          "inscEstadual": entidade["inscEstadual"],
                          "endereco": {
                            "cep": entidade["endereco"]["cep"],
                            "rua": entidade["endereco"]["rua"],
                            "numero": entidade["endereco"]["numero"],
                            "bairro": entidade["endereco"]["bairro"],
                            "municipio": entidade["endereco"]["municipio"],
                            "uf": entidade["endereco"]["uf"]
                          },
                          "dataCadastro": entidade["dataCadastro"],
                          "ultAtualizacao": entidade["ultAtualizacao"],
                          "responsavel": entidade["responsavel"],
                          "contato": {
                            "email": entidade["contato"]["email"],
                            "telefoneFixo": entidade["contato"]["telefoneFixo"],
                            "telefoneMovel": entidade["contato"]
                                ["telefoneMovel"]
                          },
                          tipoBusca: entidade[tipoBusca]
                        },
                        tipoEntidade: tipoEntidade,
                      )));
        }),
        DataCell(Text("${entidade["endereco"]["municipio"]}"), onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VerTodaEntidade(
                        entidade: {
                          "_cnpj_entidade": entidade["_cnpj_entidade"],
                          "nome": entidade["nome"],
                          "inscEstadual": entidade["inscEstadual"],
                          "endereco": {
                            "cep": entidade["endereco"]["cep"],
                            "rua": entidade["endereco"]["rua"],
                            "numero": entidade["endereco"]["numero"],
                            "bairro": entidade["endereco"]["bairro"],
                            "municipio": entidade["endereco"]["municipio"],
                            "uf": entidade["endereco"]["uf"]
                          },
                          "dataCadastro": entidade["dataCadastro"],
                          "ultAtualizacao": entidade["ultAtualizacao"],
                          "responsavel": entidade["responsavel"],
                          "contato": {
                            "email": entidade["contato"]["email"],
                            "telefoneFixo": entidade["contato"]["telefoneFixo"],
                            "telefoneMovel": entidade["contato"]
                                ["telefoneMovel"]
                          },
                          "ult_compra": entidade[tipoBusca],
                          tipoBusca: entidade[tipoBusca]
                        },
                        tipoEntidade: tipoEntidade,
                      )));
        }),
      ],
    ));
  }
  return listaRows;
}
