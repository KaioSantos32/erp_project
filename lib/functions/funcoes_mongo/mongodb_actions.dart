import 'package:erp/main.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';


Future<List> mongoPesquisaNota({
  required int tipoNota,
  String? numeroNota,
  String? dataInicial,
  String? dataFinal,
  String? nomeFornecedor,
  String? nomeProduto,
  String? cnpj,
  bool? despesa,
  bool? cancelada,
  bool autoEntrada = false,
}) async {
  var db = Db(servidor);
  await db.open();

  DbCollection coll;
  tipoNota == 0
      ? coll = db.collection('nfEntradas')
      : coll = db.collection("nfSaida");

  Stream notas;
  List<Map> listaNotas = [];

  String tipoEmpresa =
      tipoNota == 0 ? "empresaEmissora" : "empresaDestinataria";

  int tipoPesquisa = 0;
  if (numeroNota != null && numeroNota != "") tipoPesquisa += 1;
  if (nomeFornecedor != null && nomeFornecedor != "") tipoPesquisa += 2;
  if (nomeProduto != null && nomeProduto != "") tipoPesquisa += 4;
  if (dataInicial != "" && dataInicial != null) tipoPesquisa += 8;
  if (dataFinal != "" && dataFinal != null) tipoPesquisa += 16;
  if (cnpj != null) tipoPesquisa += 32;

  // DATAS INICIAIS E FINAIS
  dynamic dataInicialRaw;
  dynamic dataInicialFormatada;
  dynamic dataFinalRaw;
  dynamic dataFinalFormatada;

  if (tipoNota == 0) {
    // se nota for de entrada
    // print("Nota de entrada");
    if (autoEntrada) {
      // print("É auto entrada");
      tipoEmpresa = "empresaDestinataria";
    } else {
      // print("Não é auto entrada");
      tipoEmpresa = "empresaEmissora";
    }
  } else {
    tipoEmpresa = "empresaDestinataria";
  }
  // print("OLHAR AQUI: $tipoEmpresa");

  if (tipoPesquisa >= 8 && dataInicial != "" && dataInicial != null) {
    dataInicialRaw = dataInicial.split("/");

    dataInicialFormatada = DateTime.parse(
        "${dataInicialRaw?[2]}-${dataInicialRaw?[1]}-${dataInicialRaw![0]}");

  }
  if (tipoPesquisa >= 16 && dataFinal != "" && dataFinal != null) {
    dataFinalRaw = dataFinal.split("/");
    dataFinalFormatada = DateTime.parse(
        "${dataFinalRaw?[2]}-${dataFinalRaw?[1]}-${dataFinalRaw![0]}");
  }

  // PRODUTOS
  try {
    if (tipoPesquisa == 01 ||
        tipoPesquisa == 05 ||
        tipoPesquisa == 09 ||
        tipoPesquisa == 13 ||
        tipoPesquisa == 15 ||
        tipoPesquisa == 17 ||
        tipoPesquisa == 19 ||
        tipoPesquisa == 21 ||
        tipoPesquisa == 23 ||
        tipoPesquisa == 25 ||
        tipoPesquisa == 27 ||
        tipoPesquisa == 29 ||
        tipoPesquisa == 31) {
      notas = coll.find(where
          .eq("nf", {"\$regex": "^$numeroNota"})
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .limit(30)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 2) {
      notas = coll.find(where
          .eq("$tipoEmpresa.nome",
              {"\$regex": "^${nomeFornecedor!.toUpperCase()}"})
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .limit(30)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 3) {
      notas = coll.find(where
          .eq("nf", {"\$regex": "^$numeroNota"})
          .eq("$tipoEmpresa.nome",
              {"\$regex": "^${nomeFornecedor!.toUpperCase()}"})
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .limit(20)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 4) {
      notas = coll.find(where
          .eq("produtos", {
            "\$elemMatch": {
              "nome_produto": {"\$regex": nomeProduto!.toUpperCase()}
            }
          })
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .limit(70)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 6) {
      notas = coll.find(where
              .eq("produtos", {
                "\$elemMatch": {
                  "nome_produto": {"\$regex": nomeProduto!.toUpperCase()}
                }
              })
              .eq("$tipoEmpresa.nome",
                  {"\$regex": "^${nomeFornecedor!.toUpperCase()}"})
              .eq("despesa", despesa)
              .eq("cancelada", cancelada)
              .sortBy("dhEmissao", descending: true)
          );
    } else if (tipoPesquisa == 7) {
      notas = coll.find(where
          .eq("produtos", {
            "\$elemMatch": {
              "nome_produto": {"\$regex": nomeProduto!.toUpperCase()}
            }
          })
          .eq("nf", {"\$regex": "^$numeroNota"})
          .eq("$tipoEmpresa.nome",
              {"\$regex": "^${nomeFornecedor!.toUpperCase()}"})
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .limit(80)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 8) {
      notas = coll.find(where
          .eq("dhEmissao", {"\$gte": "$dataInicialFormatada"})
          .limit(60)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 10) {
      notas = coll.find(where
          .eq("$tipoEmpresa.nome",
              {"\$regex": "^${nomeFornecedor!.toUpperCase()}"})
          .eq("dhEmissao", {"\$gte": "$dataInicialFormatada"})
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .limit(30)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 11) {
      notas = coll.find(where
          .eq("nf", {"\$regex": "^$numeroNota"})
          .eq("$tipoEmpresa.nome",
              {"\$regex": "^${nomeFornecedor!.toUpperCase()}"})
          .eq("dhEmissao", {"\$gte": "$dataInicialFormatada"})
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .limit(20)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 12) {
      notas = coll.find(where
          .eq("dhEmissao", {"\$gte": "$dataInicialFormatada"})
          .eq("produtos", {
            "\$elemMatch": {
              "nome_produto": {"\$regex": nomeProduto!.toUpperCase()}
            }
          })
          .limit(60)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 14) {
      notas = coll.find(where
          .eq("dhEmissao", {"\$gte": "$dataInicialFormatada"})
          .eq("produtos", {
            "\$elemMatch": {
              "nome_produto": {"\$regex": nomeProduto!.toUpperCase()}
            }
          })
          .eq("$tipoEmpresa.nome",
              {"\$regex": "^${nomeFornecedor!.toUpperCase()}"})
          .limit(60)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 16) {
      notas = coll.find(where
          .eq("dhEmissao", {"\$lte": "$dataFinalFormatada"})
          .limit(60)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 18) {
      notas = coll.find(where
          .eq("dhEmissao", {"\$lte": "$dataFinalFormatada"})
          .eq("$tipoEmpresa.nome",
              {"\$regex": "^${nomeFornecedor!.toUpperCase()}"})
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .limit(30)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 20) {
      notas = coll.find(where
          .eq("dhEmissao", {"\$lte": "$dataFinalFormatada"})
          .eq("produtos", {
            "\$elemMatch": {
              "nome_produto": {"\$regex": nomeProduto!.toUpperCase()}
            }
          })
          .limit(60)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 22) {
      notas = coll.find(where
          .eq("dhEmissao", {"\$lte": "$dataFinalFormatada"})
          .eq("$tipoEmpresa.nome",
              {"\$regex": "^${nomeFornecedor!.toUpperCase()}"})
          .eq("produtos", {
            "\$elemMatch": {
              "nome_produto": {"\$regex": nomeProduto!.toUpperCase()}
            }
          })
          .limit(60)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 24) {
      notas = coll.find(where
          .eq("dhEmissao",
              {"\$gte": "$dataInicialFormatada", "\$lt": "$dataFinalFormatada"})
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 25) {
      notas = coll.find(where
          .eq("nf", {"^$numeroNota"})
          .eq("dhEmissao",
              {"\$gte": "$dataInicialFormatada", "\$lt": "$dataFinalFormatada"})
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .limit(30)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 26) {
      notas = coll.find(where
          .eq("dhEmissao",
              {"\$gte": "$dataInicialFormatada", "\$lt": "$dataFinalFormatada"})
          .eq("$tipoEmpresa.nome",
              {"\$regex": "^${nomeFornecedor!.toUpperCase()}"})
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 28) {
      notas = coll.find(where
          .eq("dhEmissao",
              {"\$gte": "$dataInicialFormatada", "\$lt": "$dataFinalFormatada"})
          .eq("produtos", {
            "\$elemMatch": {
              "nome_produto": {"\$regex": nomeProduto!.toUpperCase()}
            }
          })
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 30) {
      notas = coll.find(where
          .eq("dhEmissao",
              {"\$gte": "$dataInicialFormatada", "\$lt": "$dataFinalFormatada"})
          .eq("$tipoEmpresa.nome",
              {"\$regex": "^${nomeFornecedor!.toUpperCase()}"})
          .eq("produtos", {
            "\$elemMatch": {
              "nome_produto": {"\$regex": nomeProduto!.toUpperCase()}
            }
          })
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .sortBy("dhEmissao", descending: true));
    } else if (tipoPesquisa == 33) {
      notas =
          coll.find(where.eq("nf", numeroNota).eq("$tipoEmpresa.cnpj", cnpj));
    } else {
      notas = coll.find(where
          .eq("despesa", despesa)
          .eq("cancelada", cancelada)
          .sortBy("dhEmissao", descending: true)
          .limit(20));
    }
  } catch (e) {
    // print("Deu erro");
    notas = coll.find(where
        .eq("despesa", despesa)
        .eq("cancelada", cancelada)
        .sortBy("dhEmissao", descending: true)
        .limit(20));
  }

  await notas.forEach((element) {
    listaNotas.add(element);
  });
  await db.close();
  return listaNotas;
}

Future<List> mongoPegaTodasNotas(
    {required int tipoNota,
    required int limite,
    required bool cancelada,
    required bool despesa}) async {
  var db = Db(servidor);
  await db.open();
  DbCollection coll;
  tipoNota == 0
      ? coll = db.collection('nfEntradas')
      : coll = db.collection("nfSaida");

  Stream<Map<String, dynamic>> notas;

  notas = coll.find(
    where
        .eq("cancelada", cancelada)
        .eq("despesa", despesa)
        .sortBy("dhEmissao", descending: true)
        .limit(limite),
  );

  List<Map> listaNotas = [];
  await notas.forEach((element) {
    listaNotas.add(element);
  });
  await db.close();
  return listaNotas;
}

Future mongoPegaEntidades(
  String nomeEntidade,
  String cnpjEntidade,
  int tipoEntidade,
  BuildContext? context,
) async {
  var db = Db(servidor);
  await db.open();

  DbCollection coll = tipoEntidade == 0
      ? db.collection("clientes")
      : db.collection("fornecedores");

  int tipoPesquisa = 0;

  if (nomeEntidade.isNotEmpty) {
    tipoPesquisa += 1;
  }
  if (cnpjEntidade.isNotEmpty) {
    tipoPesquisa += 2;
  }

  Stream<Map> entidades;
  if (tipoPesquisa == 1) {
    entidades =
        coll.find(where.eq("nome", {"\$regex": nomeEntidade.toUpperCase()}));
  } else if (tipoPesquisa == 2) {
    entidades =
        coll.find(where.eq("_cnpj_entidade", {"\$regex": cnpjEntidade}));
  } else if (tipoPesquisa == 3) {
    entidades = coll.find(
      where.eq("_cnpj_entidade", {"\$regex": cnpjEntidade}).eq(
          "nome", {"\$regex": nomeEntidade.toUpperCase()}),
    );
  } else {
    entidades = coll.find(where.limit(30));
  }

  List<Map> listaEntidades = [];

  await entidades.forEach((value) {
    listaEntidades.add(value);
  });
  return listaEntidades;
}

atualizaCadastroEntidade(entidade, tipoEntidade) async {
  var db = Db(servidor);
  await db.open();

  DbCollection coll = tipoEntidade == 0
      ? db.collection("clientes")
      : db.collection("fornecedores");

  try {
    coll.update({
      "_cnpj_entidade": entidade["cnpj"]
    }, {
      "\$set": {
        "endereco.cep": entidade["endereco"]["cep"],
        "endereco.rua": entidade["endereco"]["rua"],
        "endereco.numero": entidade["endereco"]["numero"],
        "endereco.bairro": entidade["endereco"]["bairro"],
        "endereco.municipio": entidade["endereco"]["municipio"],
        "endereco.uf": entidade["endereco"]["uf"],
        "responsavel": entidade["responsavel"],
        "contato.email": entidade["contato"]["email"],
        "contato.telefoneFixo": entidade["contato"]["numeroFixo"],
        "contato.telefoneMovel": entidade["contato"]["numeroCelular"],
        "ultAtualizacao": entidade["ultimaAtualizacao"],
      }
    });
  } catch (e) {
    debugPrint("$e");
  }
}

excluirCadastroEntidade(cnpj, tipoEntidade, nomeEmpresa, context) async {
  var db = Db(servidor);
  await db.open();

  DbCollection coll = tipoEntidade == 0
      ? db.collection("clientes")
      : db.collection("fornecedores");

  coll.deleteOne(where.eq("_cnpj_entidade", cnpj));
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        'Empresa $nomeEmpresa foi excluida do banco de dados',
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

  Navigator.pop(context, 1);
}
