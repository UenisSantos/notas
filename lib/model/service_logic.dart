import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ServiceLogic {
  TextEditingController controllerTarefa = TextEditingController();
  TextEditingController controleTitulo = TextEditingController();
  List listaTarefas = [];
  Map<String, dynamic> ultimaTarefaRemovida = Map();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  salvarTarefa() {
   String textoDigitado = controllerTarefa.text +"\n \n" ;
    String tituloDigitado = controleTitulo.text;

    Map<String, dynamic> tarefa = Map();
    tarefa[tituloDigitado] = textoDigitado;

    listaTarefas.add(tarefa  );

    salvarArquivo();

    controllerTarefa.text = "";

    controleTitulo.text = "";
  }

  salvarArquivo() async {
    var arquivo = await _getFile();

    String dados = json.encode(listaTarefas);
    arquivo.writeAsString(dados);
  }

  lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }
}
