import 'package:erp/informacoes_importantes.dart';
import 'package:mongo_dart/mongo_dart.dart';

pegaNotaPorClienteParaXlsx(String nomeCliente, List listaDataInicial,
    List listaDataFinal, tipoEntidade) async {
  var db = Db(servidor);
  await db.open();

  String tipoEmpresa =
      tipoEntidade == 0 ? "empresaEmissora" : "empresaDestinataria";

  DbCollection coll;
  tipoEntidade == 0
      ? coll = db.collection("nfEntradas")
      : coll = db.collection("nfSaida");

  Stream notas;
  List<Map> listaNotas = [];

  notas = coll.find(where
      .eq("$tipoEmpresa.nome", {"\$regex": "^${nomeCliente.toUpperCase()}"})
      .eq("dhEmissao", {
        "\$gte":
            "${listaDataInicial[2]}-${listaDataInicial[1]}-${listaDataInicial[0]}",
        "\$lte":
            "${listaDataFinal[2]}-${listaDataFinal[1]}-${listaDataFinal[0]}",
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
