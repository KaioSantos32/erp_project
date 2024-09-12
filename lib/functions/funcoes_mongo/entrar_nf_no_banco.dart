import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/informacoes_importantes.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

entrarNotaNoBanco(tipoNota, notaFiscal, context) async {
  var db = Db(servidor);
  await db.open();

  DbCollection coll;
  tipoNota == 0
      ? coll = db.collection('nfEntradas')
      : coll = db.collection("nfSaida");

  coll.insertOne(notaFiscal);
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
                  "A Nota ${notaFiscal["nf"]} foi cadastrada com sucesso",
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
