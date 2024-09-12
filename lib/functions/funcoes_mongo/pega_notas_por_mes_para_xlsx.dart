import 'package:erp/informacoes_importantes.dart';
import 'package:mongo_dart/mongo_dart.dart';


pegaNotaParaXlsx(
    List listaDataInicial, List listaDataFinal, int tipoEntidade) async {
  var db = Db(servidor);
  await db.open();

  DbCollection coll;
  tipoEntidade == 0
      ? coll = db.collection("nfEntradas")
      : coll = db.collection("nfSaida");

  Stream notas;
  List<Map> listaNotas = [];

  notas = coll.find(where
      .eq("dhEmissao", {
        "\$gte":
            "${listaDataInicial[2]}-${listaDataInicial[1]}-${int.parse(listaDataInicial[0])-1}",
        "\$lte":
            "${listaDataFinal[2]}-${listaDataFinal[1]}-${int.parse(listaDataFinal[0])+1}",
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
