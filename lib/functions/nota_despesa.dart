import 'package:erp/informacoes_importantes.dart';import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

fazerNotaDespesa(numeroNf, cnpj, tipoNota, context) async {
  var db = Db(servidor);
  await db.open();

  DbCollection coll;
  tipoNota == 0
      ? coll = db.collection('nfEntradas')
      : coll = db.collection("nfSaida");

  String tipoEmpresa =
      tipoNota == 0 ? "empresaEmissora" : "empresaDestinataria";

  coll.update(where.eq('nf', '$numeroNf').eq("$tipoEmpresa.cnpj", cnpj),
      modify.set('despesa', true));

  db.close();
  Navigator.pop(context);
}

desfazerNotaDespesa(numeroNf, cnpj, tipoNota, context) async {
  var db = Db(servidor);
  await db.open();

  DbCollection coll;
  tipoNota == 0
      ? coll = db.collection('nfEntradas')
      : coll = db.collection("nfSaida");

  String tipoEmpresa =
      tipoNota == 0 ? "empresaEmissora" : "empresaDestinataria";

  coll.update(where.eq('nf', '$numeroNf').eq("$tipoEmpresa.cnpj", cnpj),
      modify.set('despesa', false));

  db.close();
  Navigator.pop(context);
}
