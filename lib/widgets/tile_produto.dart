import 'package:auto_size_text/auto_size_text.dart';
import 'package:erp/designPatterns/TextPatterns.dart';
import 'package:erp/widgets/personalized_spacer.dart';
import 'package:flutter/material.dart';

Widget tileDeProduto(
    String nomeProduto,
    List<dynamic> tags,
    dynamic qntd,
    String unTrib,
    dynamic ultPreco,
    DateTime dataUltVenda,
    String ultComprador,
    double screeWidth) {
  
  return Padding(
    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
    child: GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 202, 202, 202),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black54,
              spreadRadius: 2,
              blurRadius: 3,
              offset: Offset.fromDirection(4, -8),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(
              width: 300,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: AutoSizeText(
                    nomeProduto,
                    presetFontSizes: const [20, 16, 12],
                    maxLines: 5,
                    style: textMidImportance(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(
              width: 1.5,
              height: 120,
              color: Colors.black,
            ),
            PersonalizedSpacer(amountSpaceHorizontal: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 226, 226, 226),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                color: Colors.black,
                                offset: Offset.fromDirection(-5, 3))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: AutoSizeText(
                          presetFontSizes: const [24, 16, 12],
                          maxLines: 1,
                          tags[0],
                          style: textLowImportance(font: 16),
                        )),
                      )),
                  PersonalizedSpacer(amountSpaceHorizontal: 10),
                  Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 226, 226, 226),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                color: Colors.black,
                                offset: Offset.fromDirection(-5, 3))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: AutoSizeText(
                          presetFontSizes: const [24, 16, 12],
                          maxLines: 1,
                          tags[1],
                          style: textLowImportance(font: 16),
                        )),
                      )),
                  PersonalizedSpacer(amountSpaceHorizontal: 10),
                  Container(
                      width: 150,
                      height: 40,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 226, 226, 226),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 2,
                                color: Colors.black,
                                offset: Offset.fromDirection(-5, 3))
                          ]),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                            child: AutoSizeText(
                          presetFontSizes: const [20, 16, 12],
                          maxLines: 1,
                          tags[2],
                          style: textLowImportance(font: 16),
                        )),
                      )),
                ],
              ),
            ),
            PersonalizedSpacer(amountSpaceHorizontal: 20),
            Container(
              width: 1.5,
              height: 120,
              color: Colors.black,
            ),
            SizedBox(
              width: 200,
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    "Qntd.\n${qntd ?? 0.0} $unTrib",
                    style: textMidImportance(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(
              width: 1.5,
              height: 120,
              color: Colors.black,
            ),
            SizedBox(
              width: 150,
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    "Ult. Preço\n R\$$ultPreco",
                    style: textMidImportance(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(
              width: 1.5,
              height: 120,
              color: Colors.black,
            ),
            SizedBox(
              width: 200,
              height: 150,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: Text(
                    "Ult. Venda\n ${dataUltVenda.day}/${dataUltVenda.month}/${dataUltVenda.year}",
                    style: textMidImportance(),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Container(
              width: 1.5,
              height: 120,
              color: Colors.black,
            ),
            SizedBox(
              width: screeWidth * 0.15,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: AutoSizeText(
                    ultComprador,
                    presetFontSizes: const [24, 16, 12],
                    style: textLowImportance(),
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
