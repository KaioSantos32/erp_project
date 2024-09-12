import 'dart:io';
import 'package:erp/screens/ver_entidades.dart';
import 'package:erp/screens/notas/entra_nota_saida.dart';
import 'package:erp/screens/envia_email_screen.dart';
import 'package:erp/screens/home_screen.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/screens/notas/entra_nota_entrada.dart';
import 'package:erp/screens/relatorio.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:erp/informacoes_importantes.dart';

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
    "Envio de Email",
    "Relatórios",
    "Cadastro de Empresa",
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
                color: Colors.white,
                fontSize: 32,
              ),
            ),
            Text(
              appVersion,
              style: const TextStyle(
                fontFamily: "Righteous",
                color: Colors.white,
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
            destinations: <NavigationRailDestination>[
              const NavigationRailDestination(
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
                    style: TextStyle(color: Colors.white),
                  ),
                  padding: EdgeInsets.only(top: 20, bottom: 10)),
              NavigationRailDestination(
                  icon: const Icon(
                    Icons.arrow_downward_outlined,
                    color: Color.fromARGB(255, 50, 119, 46),
                    size: 24,
                  ),
                  selectedIcon: Image.asset(
                      "assets/icons/sidebar_icons/nota_entrada_selecionado.png"),
                  label: const Text(
                    "Entrada",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.only(top: 10, bottom: 10)),
              NavigationRailDestination(
                  icon: const Icon(
                    Icons.arrow_upward_outlined,
                    color: Color.fromARGB(255, 50, 119, 46),
                    size: 24,
                  ),
                  selectedIcon: Image.asset(
                      "assets/icons/sidebar_icons/nota_saida_selecionado.png"),
                  label: const Text(
                    "Saída",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.only(top: 10, bottom: 10)),
              NavigationRailDestination(
                  indicatorColor: Colors.blue,
                  icon: Image.asset(
                    "assets/icons/sidebar_icons/email_padrao.png",
                    height: 24,
                    width: 24,
                  ),
                  selectedIcon: Image.asset(
                    "assets/icons/sidebar_icons/email_selecionado.png",
                    height: 24,
                    width: 24,
                  ),
                  label: const Text(
                    "Envio Email",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.only(top: 10, bottom: 20)),
              NavigationRailDestination(
                  indicatorColor: Colors.blue,
                  icon: Image.asset(
                    "assets/icons/sidebar_icons/relatorio_padrao.png",
                    height: 24,
                    width: 24,
                  ),
                  selectedIcon: Image.asset(
                    "assets/icons/sidebar_icons/relatorio_selecionado.png",
                    height: 24,
                    width: 24,
                  ),
                  label: const Text(
                    "Relatórios",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.only(top: 10, bottom: 20)),
              NavigationRailDestination(
                  indicatorColor: Colors.blue,
                  icon: Image.asset(
                    "assets/icons/sidebar_icons/empresa_padrao.png",
                    height: 28,
                    width: 28,
                  ),
                  selectedIcon: Image.asset(
                    "assets/icons/sidebar_icons/empresa_selecionado.png",
                    height: 28,
                    width: 28,
                  ),
                  label: const Text(
                    "Cadastro de\nEmpresa",
                    style: TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  padding: const EdgeInsets.only(top: 10, bottom: 20)),
            ],
            indicatorColor: Colors.white.withOpacity(.2),
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
