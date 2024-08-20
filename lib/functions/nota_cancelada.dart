import 'package:erp/main.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

cancelaNota(numeroNf, cnpj, tipoNota, context) async {
  var db = Db(servidor);
  await db.open();

  DbCollection coll;
  tipoNota == 0
      ? coll = db.collection('nfEntradas')
      : coll = db.collection("nfSaida");

  String tipoEmpresa =
      tipoNota == 0 ? "empresaEmissora" : "empresaDestinataria";

  coll.update(where.eq('nf', '$numeroNf').eq("$tipoEmpresa.cnpj", cnpj),
      modify.set('cancelada', true));

  db.close();
  Navigator.pop(context);
}

descancelaNota(numeroNf, cnpj, tipoNota, context) async {
  var db = Db(servidor);
  await db.open();

  DbCollection coll;
  tipoNota == 0
      ? coll = db.collection('nfEntradas')
      : coll = db.collection("nfSaida");

  String tipoEmpresa =
      tipoNota == 0 ? "empresaEmissora" : "empresaDestinataria";

  coll.update(where.eq('nf', '$numeroNf').eq("$tipoEmpresa.cnpj", cnpj),
      modify.set('cancelada', false));

  db.close();
  Navigator.pop(context);
}
