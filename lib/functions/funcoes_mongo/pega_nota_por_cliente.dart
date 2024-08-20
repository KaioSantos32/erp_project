import 'package:erp/main.dart';
import 'package:mongo_dart/mongo_dart.dart';


pegaNotaPorClienteParaXlsx(
    String nomeCliente, List listaDataInicial, List listaDataFinal, tipoEntidade) async {
  var db = Db(servidor);
  await db.open();

  DbCollection coll;
  tipoEntidade == 0
      ? coll = db.collection("nfEntradas")
      : coll = db.collection("nfSaida");

  Stream notas;
  List<Map> listaNotas = [];

  print('"\$regex": "^${nomeCliente.toUpperCase()}"');
  notas = coll.find(where
      .eq("empresaDestinataria.nome",
          {"\$regex": "^${nomeCliente.toUpperCase()}"})
      .eq("dhEmissao", {
        "\$gte": "${listaDataInicial[2]}-${listaDataInicial[1]}-${listaDataInicial[0]}",
        "\$lte": "${listaDataFinal[2]}-${listaDataFinal[1]}-${listaDataFinal[0]}",
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
