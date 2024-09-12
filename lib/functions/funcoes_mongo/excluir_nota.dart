import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/informacoes_importantes.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';

excluirNota(numeroNota, tipoNota, context) {
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
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Deseja excluir nota $numeroNota?",
                  style: textMidImportance(),
                ),
                PersonalizedSpacer(amountSpaceHorizontal: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Não",
                          style: textMidImportance(
                            color: defaultBlue,
                          ),
                        )),
                    PersonalizedSpacer(amountSpaceHorizontal: 20),
                    TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          var db = Db(servidor);
                          await db.open();

                          DbCollection coll;
                          tipoNota == 0
                              ? coll = db.collection('nfEntradas')
                              : coll = db.collection("nfSaida");

                          coll.deleteOne({"nf": "$numeroNota"}).then((a) {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) => Dialog(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(.8),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(24))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Nota $numeroNota foi excluida!",
                                            style: textMidImportance(),
                                          ),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text("OK"))
                                        ]),
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                        child: Text(
                          "Sim",
                          style: textMidImportance(color: defaultRed),
                        )),
                  ],
                )
              ]),
        ),
      ),
    ),
  );
}
