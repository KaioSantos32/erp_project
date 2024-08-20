import 'dart:io';
import 'package:erp/screens/ver_entidades.dart';
import 'package:erp/screens/notas/entra_nota_saida.dart';
import 'package:erp/screens/envia_email_screen.dart';
import 'package:erp/screens/estoque_screen.dart';
import 'package:erp/screens/home_screen.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/screens/notas/entra_nota_entrada.dart';
import 'package:erp/screens/relatorio.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

String appVersion = "1.0.4.5";
String empresaCnpj = "[CNPJ DA EMPRESA]";
String servidor = "mongodb://localhost:27017/";


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  if (Platform.isWindows) {
    WindowManager.instance.setMinimumSize(const Size(1270, 800));
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NavRail(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: defaultGreen),
      ),
    ),
  );
}

// ignore: must_be_immutable
class NavRail extends StatefulWidget {
  NavRail({super.key, this.selectedIndex = 0, this.tipoEntidadeBuscada = 0});
  int selectedIndex;
  int tipoEntidadeBuscada;

  List<String> appBarTitles = [
    "Dashboard",
    "Notas de Entrada",
    "Notas de Saída",
    "Estoque",
    "Envio de Email",
    "Relatórios",
    "Cadastro de Empresa"
  ];

  @override
  State<NavRail> createState() => _NavRailState();
}

class _NavRailState extends State<NavRail> {
  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      HomeScreen(),
      const EntraNotaEntradaScreen(),
      const EntraNotaSaidaScreen(),
      const EstoqueScreen(),
      const EmailScreen(),
      const RelatorioScreen(),
      VerEntidades(
        tipoEntidade: widget.tipoEntidadeBuscada,
      ),
    ];

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
              widget.appBarTitles[widget.selectedIndex],
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
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: widget.selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                widget.selectedIndex = index;
              });
            },
            backgroundColor: sidebarColor,
            destinations: const <NavigationRailDestination>[
              NavigationRailDestination(
                  icon: Icon(
                    Icons.dashboard_outlined,
                    color: darkGreen,
                  ),
                  selectedIcon: Icon(
                    Icons.dashboard,
                    color: defaultGreen,
                  ),
                  label: Text(
                    "Dashboard",
                    style: TextStyle(color: white),
                  ),
                  padding: EdgeInsets.only(top: 20, bottom: 10)),
              NavigationRailDestination(
                  icon: Icon(
                    Icons.arrow_downward_outlined,
                    color: darkGreen,
                  ),
                  selectedIcon: Icon(
                    Icons.arrow_downward_outlined,
                    color: defaultGreen,
                  ),
                  label: Text(
                    "Entrada",
                    style: TextStyle(color: white),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 10)),
              NavigationRailDestination(
                  icon: Icon(
                    Icons.arrow_upward_outlined,
                    color: darkGreen,
                  ),
                  selectedIcon: Icon(
                    Icons.arrow_upward_outlined,
                    color: defaultGreen,
                  ),
                  label: Text(
                    "Saída",
                    style: TextStyle(color: white),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 10)),
              NavigationRailDestination(
                  icon: Icon(
                    Icons.outbox_outlined,
                    color: darkGreen,
                  ),
                  selectedIcon: Icon(
                    Icons.outbox_rounded,
                    color: defaultGreen,
                  ),
                  label: Text(
                    "Estoque",
                    style: TextStyle(color: white),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 20)),
              NavigationRailDestination(
                  indicatorColor: Colors.blue,
                  icon: Icon(
                    Icons.email_outlined,
                    color: darkGreen,
                  ),
                  selectedIcon: Icon(
                    Icons.email_rounded,
                    color: darkGreen,
                  ),
                  label: Text(
                    "Envio Email",
                    style: TextStyle(color: white),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 20)),
              NavigationRailDestination(
                  indicatorColor: Colors.blue,
                  icon: Icon(
                    Icons.document_scanner_rounded,
                    color: darkGreen,
                  ),
                  selectedIcon: Icon(
                    Icons.edit_document,
                    color: darkGreen,
                  ),
                  label: Text(
                    "Relatórios",
                    style: TextStyle(color: white),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 20)),
              NavigationRailDestination(
                  indicatorColor: Colors.blue,
                  icon: Icon(
                    Icons.person_pin,
                    color: darkGreen,
                  ),
                  selectedIcon: Icon(
                    Icons.person_pin_circle_outlined,
                    color: darkGreen,
                  ),
                  label: Text(
                    "Cadastro de\nEmpresa",
                    style: TextStyle(color: white),
                    textAlign: TextAlign.center,
                  ),
                  padding: EdgeInsets.only(top: 10, bottom: 20)),
            ],
            indicatorColor: white.withOpacity(.2),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: pages[widget.selectedIndex],
            ),
          )
        ],
      ),
    );
  }
}

// ignore: must_be_immutable
class SideBar extends StatefulWidget {
  SideBar({super.key, required this.selectedIndex});

  int selectedIndex;

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
      selectedIndex: widget.selectedIndex,
      onDestinationSelected: (int index) {
        setState(() {
          widget.selectedIndex = index;
        });
      },
      backgroundColor: sidebarColor,
      destinations: const <NavigationRailDestination>[
        NavigationRailDestination(
            icon: Icon(
              Icons.dashboard_outlined,
              color: darkGreen,
            ),
            selectedIcon: Icon(
              Icons.dashboard,
              color: defaultGreen,
            ),
            label: Text(
              "Dashboard",
              style: TextStyle(color: white),
            ),
            padding: EdgeInsets.only(top: 20, bottom: 10)),
        NavigationRailDestination(
            icon: Icon(
              Icons.arrow_downward_outlined,
              color: darkGreen,
            ),
            selectedIcon: Icon(
              Icons.arrow_downward_outlined,
              color: defaultGreen,
            ),
            label: Text(
              "Entrada",
              style: TextStyle(color: white),
            ),
            padding: EdgeInsets.only(top: 10, bottom: 10)),
        NavigationRailDestination(
            icon: Icon(
              Icons.arrow_upward_outlined,
              color: darkGreen,
            ),
            selectedIcon: Icon(
              Icons.arrow_upward_outlined,
              color: defaultGreen,
            ),
            label: Text(
              "Saída",
              style: TextStyle(color: white),
            ),
            padding: EdgeInsets.only(top: 10, bottom: 10)),
        NavigationRailDestination(
            icon: Icon(
              Icons.outbox_outlined,
              color: darkGreen,
            ),
            selectedIcon: Icon(
              Icons.outbox_rounded,
              color: defaultGreen,
            ),
            label: Text(
              "Estoque",
              style: TextStyle(color: white),
            ),
            padding: EdgeInsets.only(top: 10, bottom: 20)),
        NavigationRailDestination(
            indicatorColor: Colors.blue,
            icon: Icon(
              Icons.email_outlined,
              color: darkGreen,
            ),
            selectedIcon: Icon(
              Icons.email_rounded,
              color: darkGreen,
            ),
            label: Text(
              "Envio Email",
              style: TextStyle(color: white),
            ),
            padding: EdgeInsets.only(top: 10, bottom: 20)),
        NavigationRailDestination(
            indicatorColor: Colors.blue,
            icon: Icon(
              Icons.report,
              color: darkGreen,
            ),
            selectedIcon: Icon(
              Icons.report_off,
              color: darkGreen,
            ),
            label: Text(
              "Relatórios",
              style: TextStyle(color: white),
            ),
            padding: EdgeInsets.only(top: 10, bottom: 20)),
      ],
      labelType: NavigationRailLabelType.selected,
      indicatorColor: white.withOpacity(.2),
    );
  }
}
