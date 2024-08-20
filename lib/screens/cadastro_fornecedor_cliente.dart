import 'package:erp/designPatterns/colors.dart';
import 'package:erp/main.dart';
import 'package:erp/screens/cadastro_fornecedor_cliente/cadastro_fornecedor.dart';
import 'package:flutter/material.dart';

enum Pages { cadastroCliente, cadastroFornecedor }

// ignore: must_be_immutable
class CadastroFornecedorECliente extends StatefulWidget {
  CadastroFornecedorECliente({super.key});

  List<String> titulos = ["Fornecedor", "Cliente"];

  int _selectedIndex = 0;
  dynamic selected = Pages.cadastroCliente;
  @override
  State<CadastroFornecedorECliente> createState() =>
      _CadastroFornecedorEClienteState();
}

class _CadastroFornecedorEClienteState
    extends State<CadastroFornecedorECliente> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        shadowColor: lightGreen,
        elevation: 6,
        backgroundColor: defaultGreen,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Cadastro de ${widget.titulos[widget._selectedIndex]}",
              style: const TextStyle(
                fontFamily: "Righteous",
                color: white,
                fontSize: 32,
              ),
            ),
            Text(
              appVersion,
              style: const TextStyle(
                fontFamily: "Righteous",
                color: white,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SegmentedButton(
                    style: SegmentedButton.styleFrom(
                      backgroundColor: Colors.grey[200],
                      foregroundColor: Colors.black,
                      selectedForegroundColor: Colors.white,
                      selectedBackgroundColor: Colors.green,
                    ),
                    segments: const <ButtonSegment>[
                      ButtonSegment(
                          value: Pages.cadastroCliente,
                          label: Text("Cadastrar Fornecedor"),
                          icon: Icon(Icons.person_4)),
                      ButtonSegment(
                          value: Pages.cadastroFornecedor,
                          label: Text("Cadastrar Cliente"),
                          icon: Icon(Icons.person_rounded)),
                    ],
                    selected: {widget.selected},
                    onSelectionChanged: (changed) {
                      setState(() {
                        widget.selected = changed.first;
                        if (changed.first == Pages.cadastroCliente) {
                          widget._selectedIndex = 0;
                        } else if (changed.first == Pages.cadastroFornecedor) {
                          widget._selectedIndex = 1;
                        }
                      });
                    }),
                const Divider(
                  height: 20,
                  thickness: 2,
                ),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: CadastrarFornecedor(
                      tipoCadastro: widget._selectedIndex,
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
