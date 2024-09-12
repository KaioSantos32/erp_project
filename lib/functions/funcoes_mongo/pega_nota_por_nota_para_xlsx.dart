import 'package:erp/informacoes_importantes.dart';
import 'package:mongo_dart/mongo_dart.dart';


pegaNotaPorNumeroParaXlsx(
    String numeroNotaInicial, String numeroNotaFinal, int tipoEntidade) async {
  var db = Db(servidor);
  await db.open();

  DbCollection coll;
  tipoEntidade == 0
      ? coll = db.collection("nfEntradas")
      : coll = db.collection("nfSaida");

  Stream notas;
  List<Map> listaNotas = [];

  notas = coll.find(where
      .eq("nf", {
        "\$gte": numeroNotaInicial,
        "\$lte": numeroNotaFinal,
      })
      .eq("despesa", false)
      .eq("cancelada", false)
      .sortBy("dhEmissao", descending: false));

  await notas.forEach((element) {
    listaNotas.add(element);
  });
  await db.close();
  return listaNotas;
}
