import 'package:erp/designPatterns/colors.dart';
import 'package:erp/screens/paginas_de_relatorios/rel_por_nota.dart';
import 'package:erp/screens/paginas_de_relatorios/rel_por_produto.dart';
import 'package:erp/screens/paginas_de_relatorios/rel_por_cliente_ou_fornecedor.dart';
import 'package:erp/screens/paginas_de_relatorios/rel_por_mes.dart';

import 'package:flutter/material.dart';

int _selectedIndex = 0;

enum Pages { pageOne, pageTwo, pageThree, pageFour }

class RelatorioScreen extends StatefulWidget {
  const RelatorioScreen({super.key});

  @override
  State<RelatorioScreen> createState() => _RelatorioScreenState();
}

class _RelatorioScreenState extends State<RelatorioScreen> {
  final List<Widget> _options = [
    RelatorioPorMes(),
    const RelatorioPorNota(),
    const RelatorioPorCompraOuVenda(),
    const RelatorioPorProduto(),
  ];
  dynamic selected = Pages.pageOne;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: scaffoldBackgroundColor,
        body: Padding(
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
                        value: Pages.pageOne,
                        label: Text("Por Mês"),
                        icon: Icon(Icons.calendar_today)),
                    ButtonSegment(
                        value: Pages.pageTwo,
                        label: Text("Por Nota"),
                        icon: Icon(Icons.document_scanner)),
                    ButtonSegment(
                        value: Pages.pageThree,
                        label: Text("Por Fornecedor/Cliente"),
                        icon: Icon(Icons.person_pin)),
                    ButtonSegment(
                        value: Pages.pageFour,
                        label: Text("Por Produto"),
                        icon: Icon(Icons.category_rounded)),
                  ],
                  selected: {selected},
                  onSelectionChanged: (changed) {
                    setState(() {
                      selected = changed.first;
                      if (changed.first == Pages.pageOne) {
                        _selectedIndex = 0;
                      } else if (changed.first == Pages.pageTwo) {
                        _selectedIndex = 1;
                      } else if (changed.first == Pages.pageThree) {
                        _selectedIndex = 2;
                      } else if (changed.first == Pages.pageFour) {
                        _selectedIndex = 3;
                      }
                    });
                  }),
              const Divider(
                height: 20,
                thickness: 2,
              ),
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _options[_selectedIndex]),
            ],
          ),
        ));
  }
}
