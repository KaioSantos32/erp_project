import 'package:erp/functions/funcoes_mongo/pega_produtos.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:erp/widgets/tile_produto.dart';
import 'package:flutter/material.dart';

class EstoqueScreen extends StatefulWidget {
  const EstoqueScreen({super.key});

  @override
  State<EstoqueScreen> createState() => _EstoqueScreenState();
}

class _EstoqueScreenState extends State<EstoqueScreen> {
  var produtos = pegaProdutos();
  List listaDeProdutos = [];

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.sizeOf(context).width;
    return FutureBuilder(
      future: produtos,
      builder: (context, listaProdutos) {
        if (listaProdutos.hasData) {
          if (listaProdutos.data != null) {
            var listaTileProduto = [];
            for (var produto in listaProdutos.data!) {
              listaTileProduto.add(
                tileDeProduto(
                  produto["nome"],
                  produto["tags"],
                  produto["quantidade"],
                  produto["unidade"],
                  produto["ult_preco"],
                  produto["ult_data_venda"],
                  produto["ult_comprador"],
                  screenWidth,
                ),
              );
            }

            return mostraProdutos(listaTileProduto, context);
          }
        } else {
          return mostraProdutos(null, context);
        }
        return mostraProdutos(null, context);
      },
    );
  }
}

mostraProdutos(List? listaTilesProdutos, context) {
  final txtEditNomeProduto = TextEditingController();
  final txtEditTags = TextEditingController();
  final txtEditCodigo = TextEditingController();

  return Padding(
    padding: const EdgeInsets.all(20.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .3,
              child: TextField(
                controller: txtEditNomeProduto,
                onChanged: (value) {},
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Nome do Produto',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 138, 138, 138))),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .2,
              child: TextField(
                controller: txtEditTags,
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Tag. Ex.:',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 138, 138, 138))),
              ),
            ),
            SizedBox(
              width: MediaQuery.sizeOf(context).width * .1,
              child: TextField(
                controller: txtEditCodigo,
                decoration: const InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(),
                    labelText: 'Código',
                    labelStyle:
                        TextStyle(color: Color.fromARGB(255, 138, 138, 138))),
              ),
            ),
          ],
        ),
        PersonalizedSpacer(amountSpaceHorizontal: 30),
        listaTilesProdutos != null
            ? Expanded(
                child: SingleChildScrollView(
                  child: Column(children: [
                    for (var tileProduto in listaTilesProdutos) tileProduto
                  ]),
                ),
              )
            : const Text("Sem dados")
      ],
    ),
  );
}

class Message {
  String text;

  Message({required this.text});
}
