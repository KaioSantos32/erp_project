import 'package:erp/main.dart';
import 'package:mongo_dart/mongo_dart.dart';


Future<Map> buscaValoresHomeScreen() async {
  List valoresDeEntrada = [];
  List valoresDeSaida = [];
  List valoresLiquido = [];
  Map<int, List> listaDeValores = {};

  var db = Db(servidor);
  await db.open();

  DateTime dataAtual = DateTime.now();
  var ano = dataAtual.year;

  for (int mes = 1; mes <= 12; mes++) {
    double totalEntradaMes = 0.0;
    double totalSaidaMes = 0.0;

    await db
        .collection("nfEntradas")
        .find(where
            .eq("dhEmissao", {
              "\$gte": "$ano-${mes < 10 ? "0$mes" : "$mes"}-00T00:00:00-00:00",
              "\$lt": "$ano-${mes < 10 ? "0$mes" : "$mes"}-32T00:00:00-00:00"
            })
            .eq("despesa", false)
            .eq("cancelada", false)
            .sortBy("dhEmissao", descending: true))
        .forEach((element) {
      totalEntradaMes += double.parse("${element["valores"]["valorNf"]}");
    });

    await db
        .collection("nfSaida")
        .find(where
            .eq("dhEmissao", {
              "\$gte": "$ano-${mes < 10 ? "0$mes" : "$mes"}-01T00:00:00-00:00",
              "\$lt": "$ano-${mes < 10 ? "0$mes" : "$mes"}-31T00:00:00-00:00"
            })
            .eq("despesa", false)
            .eq("cancelada", false)
            .sortBy("dhEmissao", descending: true))
        .forEach((element) {
      if (element["valores"]["valorNf"].runtimeType == double) {
        totalSaidaMes += element["valores"]["valorNf"];
      } else {
        totalSaidaMes += double.parse(element["valores"]["valorNf"]);
      }
    });

    valoresDeEntrada.add(totalEntradaMes);
    valoresDeSaida.add(totalSaidaMes);
    valoresLiquido.add(valoresDeSaida[mes - 1] - valoresDeEntrada[mes - 1]);
  }

  listaDeValores = {0: valoresDeEntrada, 1: valoresDeSaida, 2: valoresLiquido};
  return listaDeValores;
}
