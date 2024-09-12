import 'package:erp/informacoes_importantes.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<List> pegaProdutos() async {
  var db = Db(servidor);
  await db.open();

  DbCollection coll = db.collection("produtos");

  Stream<Map<String, dynamic>> produtos;

  produtos = coll.find(
    where.limit(20).sortBy("nome"),
  );

  List<Map> listaProdutos = [];

  await produtos.forEach((element) {
    listaProdutos.add(element);
  });
  await db.close();
  return listaProdutos;
}


