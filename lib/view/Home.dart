import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multiselect_scope/multiselect_scope.dart';
import 'package:nota_diaria/model/admob_service.dart';
import 'package:nota_diaria/model/service_logic.dart';
import 'package:nota_diaria/model/share.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  AdmobService admobService = AdmobService();
  ServiceLogic service = ServiceLogic();
  Share share = Share();
  @override
  void initState() {
    super.initState();

    admobService.admob();
    service.lerArquivo().then((dados) {
      setState(() {
        service.listaTarefas = json.decode(dados);
      });
    });
  }

  dialog() {
    showDialog(
        context: context,
        builder: (context) {
          return StreamBuilder(
              stream: admobService.admob(),
              builder: (context, snapshot) {
                return ListView(
                  children: [
                    //    BannerC(),
                    AlertDialog(
                      title: Text("criar nota"),
                      content: Column(
                        children: [
                          admobService.banner,
                          Divider(
                            height: 50,
                          ),
                          TextField(
                            controller: service.controleTitulo,
                            decoration:
                                InputDecoration(labelText: "Digite um titulo"),
                            onChanged: (text) {},
                          ),
                          TextField(
                            controller: service.controllerTarefa,
                            decoration:
                                InputDecoration(labelText: "Digite sua tarefa"),
                            onChanged: (text) {},
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        // ignore: deprecated_member_use
                        FlatButton(
                          child: Text(
                            "Cancelar",
                            style: TextStyle(color: Colors.brown[300]),
                          ),
                          onPressed: () => Navigator.pop(context),
                        ),
                        // ignore: deprecated_member_use
                        StreamBuilder(
                            // stream: //_readWrite.salvarTarefa(),
                            builder: (context, snapshot) {
                          return TextButton(
                            child: Text(
                              "Salvar",
                              style: TextStyle(color: Colors.brown[300]),
                            ),
                            onPressed: () {
                              //salvar
                              setState(() {
                                service.salvarTarefa();
                              });

                              Navigator.pop(context);
                            },
                          );
                        }),
                      ],
                    ),
                    admobService.rectangle
                  ],
                );
              });
        });
  }

  Widget criarItemLista(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        //recuperar último item excluído
        service.ultimaTarefaRemovida = service.listaTarefas[index];

        //Remove item da lista
        service.listaTarefas.removeAt(index);
        service.salvarArquivo();
        //snackbar
        final snackbar = SnackBar(
          //backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
          content:
              Text("${service.ultimaTarefaRemovida} foi excluido de sua lista"),
          action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                service.listaTarefas
                    .insert(index, service.ultimaTarefaRemovida);

                service.salvarArquivo();
              }),
        );

        // ignore: deprecated_member_use
        Scaffold.of(context).showSnackBar(snackbar);
      },
      background: Container(
        color: Colors.red,
        padding: EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.grey,
            )
          ],
        ),
      ),
      child: ListTile(
        focusColor: Colors.black,
        hoverColor: Colors.white,
        title: ElevatedButton(
          onPressed: () {},
          child: Center(
            child: Text(
              service.listaTarefas[index].toString(),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),
        ),
        subtitle:
            index != 0 && index % 4 == 0 ? admobService.banner : Text('  '),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(child: admobService.banner),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          foregroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.grey[300],
          onPressed: () {
            dialog();
          }),
      body: MultiselectScope(
        controller: share.multiselectController,
        dataSource: service.listaTarefas,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/fundo.png'),
                          fit: BoxFit.fill)),
                  child: ListView.builder(
                      itemCount: service.listaTarefas.length,
                      itemBuilder: (context, index) {
                        final controller =
                            MultiselectScope.controllerOf(context);
                        final itemIsSelected = controller.isSelected(index);
                        return InkWell(
                            onLongPress: () {
                              if (!controller.selectionAttached) {
                                controller.select(index);
                              }
                            },
                            onTap: () {
                              if (controller.selectionAttached) {
                                controller.select(index);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  color: itemIsSelected
                                      ? Colors.white
                                      : Theme.of(context).primaryColor,
                                  child: Container(
                                      child: criarItemLista(context, index))),
                            ));
                      }),
                ),
              ),
              Row(
                children: [
                  MaterialButton(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'compartilhar',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        share.shareToSystem().toString();
                      }),
                  MaterialButton(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: Container(
                        height: 50,
                        width: 50,
                        child: Image.asset(
                          'assets/wat.png',
                        )),
                    onPressed: () async {
                      // ignore: unnecessary_statements
                      admobService.rewardAd;

                      share.shareToWhatsApp();
                      admobService.rewardAd.show();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    admobService.rewardAd.dispose();
    admobService.interstitialAd.dispose();
    super.dispose();
  }
}
