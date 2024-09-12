import 'dart:io';

import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/designPatterns/colors.dart';
import 'package:erp/informacoes_importantes.dart';
import 'package:enough_mail/enough_mail.dart';
import 'package:flutter/material.dart';

enviaNotas(email, nNf, caminhoXml, caminhoNotaPdf, caminhoBoleto,
    caminhoCartaCorrecao, context) async {
  String emailRemetente = '[email que vai enviar nota]@$empresaDominio';
  String senha = '[senha do email]';

  String smtpServerHost = empresaEnderecoSmtp;
  int smtpServerPort = 465;
  bool isSmtpServerSecure = true;

  final client = SmtpClient(empresaProvedorEmail, isLogEnabled: true);

  try {
    await client.connectToServer(smtpServerHost, smtpServerPort,
        isSecure: isSmtpServerSecure);
    // Essa parte do código "abre" o processo para envio de email, não funciona sem ele
    await client.ehlo();

    if (client.serverInfo.supportsAuth(AuthMechanism.plain)) {
      await client.authenticate(emailRemetente, senha, AuthMechanism.plain);
    } else if (client.serverInfo.supportsAuth(AuthMechanism.login)) {
      await client.authenticate(emailRemetente, senha, AuthMechanism.login);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.8),
              borderRadius: const BorderRadius.all(
                Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Erro ao enviar nota.",
                    style: textMidImportance(),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "OK",
                      style: textMidImportance(font: 20, color: darkGreen),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      return;
    }

    final builder = MessageBuilder()
      ..from = [MailAddress('[empresa]', emailRemetente)]
      ..to = [MailAddress("Cliente", email)]
      ..bcc = [MailAddress("Bcc", '[email para envio de cópia]@$empresaDominio')]
      ..subject = 'Nota Fiscal $nNf'
      ..addMultipartAlternative(
        plainText: '',
        htmlText: '''<!DOCTYPE html> 
        <html lang='pt-br'>
          <h2>Informamos a emiss\xE3o de NF-e (Nota Fiscal Eletr\xF4nica) conforme anexo.</h2>\n
          <p><strong>Contato/WhatsApp:</strong> [telefone fixo] </p>
          <p>Site: <a href='$empresaSite'>$empresaNome</a></p>\n
          <p>E-mail de contato: <a href:"mailto:[email de contato]@$empresaDominio">[email de contato]@$empresaDominio</a></p>\n
          <h5>Este e-mail foi enviado de forma autom\xE1tica. Se necess\xE1rio, entre em contato pelo e-mail <a href:"mailto:[email]@$empresaDominio>[email]@$empresaDominio</a></h5>\n
          <br/>
          <br/>
          <p>Atenciosamente,</p>\n
          <p><strong>${empresaNome.toUpperCase()}</strong></p>
        </html>
      ''',
      );

    var a = File.fromUri(Uri.parse(caminhoXml));

    await builder.addFile(a, MediaSubtype.applicationXml.mediaType);
    await builder.addFile(
        File(caminhoNotaPdf), MediaSubtype.applicationPdf.mediaType);

    if (caminhoCartaCorrecao != "Caminho para Carta de correção") {
      await builder.addFile(
          File(caminhoCartaCorrecao), MediaSubtype.applicationPdf.mediaType);
    }
    if (caminhoBoleto != "documento não encontrado") {
      await builder.addFile(
          File(caminhoBoleto), MediaSubtype.applicationPdf.mediaType);
    }

    await client.sendMessage(builder.buildMimeMessage());

    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            borderRadius: const BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Email Enviado para $email",
                  style: textMidImportance(),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: textMidImportance(font: 20, color: darkGreen),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } on SmtpException catch (e) {
    showDialog(
      context: context,
      builder: (BuildContext context) => Dialog(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(.8),
            borderRadius: const BorderRadius.all(
              Radius.circular(24),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Email não enviado.\n Erro:\n$e",
                  style: textMidImportance(),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "OK",
                    style: textMidImportance(font: 20, color: darkGreen),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
