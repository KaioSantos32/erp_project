import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/main.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

cadastraEntidades(
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
  context,
) async {
  var db = Db(servidor);
  await db.open();
  bool existeCadastrado = true;

  DbCollection coll;
  tipoCadastro == 0
      ? coll = db.collection('fornecedores')
      : coll = db.collection("clientes");

  String ultAcao = tipoCadastro == 0 ? "ult_compra" : "ult_venda";

  String cnpjFormatado = cnpj.replaceAllMapped(".", (match) => "");
  cnpjFormatado = cnpjFormatado.replaceAllMapped("/", (match) => "");
  cnpjFormatado = cnpjFormatado.replaceAllMapped("-", (match) => "");

  String cepFormatado = cep.replaceAllMapped("-", (match) => "");

  await coll
      .find(where.eq("_cnpj_entidade", cnpjFormatado))
      .toList()
      .then((value) {
    if (value.isNotEmpty) {
      existeCadastrado = true;
    } else {
      existeCadastrado = false;
    }
  });

  if (existeCadastrado) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Empresa $nomeEmpresa ja está cadastrada',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        width: 800,
      ),
    );
    Navigator.of(context).pop();
  } else {
    Map<String, dynamic> nota = {
      "_cnpj_entidade": cnpjFormatado,
      "nome": nomeEmpresa,
      "inscEstadual": inscEstadual,
      "endereco": {
        "cep": cepFormatado,
        "rua": rua,
        "numero": numero,
        "bairro": bairro,
        "municipio": municipio,
        "uf": uf
      },
      "dataCadastro": dataCadastro,
      "ultAtualizacao": ultAtualizacao,
      "responsavel": responsavel,
      "contato": {
        "email": emailEmpresa,
        "telefoneFixo": numeroFixo,
        "telefoneMovel": numeroCelular,
      },
      ultAcao: ""
    };

    coll.insertOne(nota);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green[100],
        content: Text(
          tipoCadastro == 0
              ? "Fornecedor $nomeEmpresa foi cadastrado (a)"
              : "Cliente $nomeEmpresa foi cadastrado (a)",
          textAlign: TextAlign.center,
          style: textLowImportance(color: Colors.black),
        ),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        width: 800,
      ),
    );
    Navigator.pop(context, 1);
  }
}
