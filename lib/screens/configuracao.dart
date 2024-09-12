import 'package:erp/informacoes_importantes.dart';
import 'package:flutter/material.dart';

class ConfiguracaoScreen extends StatefulWidget {
  const ConfiguracaoScreen({super.key});

  @override
  State<ConfiguracaoScreen> createState() => _ConfiguracaoScreenState();
}

class _ConfiguracaoScreenState extends State<ConfiguracaoScreen> {
  @override
  Widget build(BuildContext context) {

    TextEditingController dominioEmpresa = TextEditingController();
    dominioEmpresa.text = empresaDominio;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text("Dominio da empresa"),
            TextField(
              controller: dominioEmpresa,              
            ),

            TextButton(onPressed: (){
              setState(() {
                empresaDominio = dominioEmpresa.text;                
              });
            }, child: const Text("Salvar"))
          ],
        ),
      ),
    );
  }
}
