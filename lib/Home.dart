import 'dart:ui';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share_me/flutter_share_me.dart';
import 'package:multiselect_scope/multiselect_scope.dart';
import 'package:nota_diaria/Admob/Admob_admob.dart';
import 'package:nota_diaria/Admob/banner.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MultiselectController _multiselectController = MultiselectController();
  TextEditingController _controllerTarefa = TextEditingController();
TextEditingController _controleTitulo =TextEditingController();
  AdmobBannerSize bannerSize;
  AdmobInterstitial interstitialAd;
  AdmobReward rewardAd;

  List _listaTarefas = [];


  Map<String, dynamic> _ultimaTarefaRemovida = Map();

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File("${diretorio.path}/dados.json");
  }

  _salvarTarefa() {
    String textoDigitado = _controllerTarefa.text;
String tituloDigitado =_controleTitulo.text;
    Map<String, dynamic> tarefa = Map();
    tarefa [tituloDigitado]= textoDigitado;

    setState(() {
      _listaTarefas.add(tarefa);
    });
    _salvarArquivo();

    _controllerTarefa.text = "";

    _controleTitulo.text='';
  }

  _salvarArquivo() async {
    var arquivo = await _getFile();

    String dados = json.encode(_listaTarefas);
    arquivo.writeAsString(dados);
  }

  _lerArquivo() async {
    try {
      final arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      return null;
    }
  }

  test(){

    Text('test');


  }

  @override
  void initState() {
    super.initState();
    _lerArquivo().then((dados) {
      setState(() {
        _listaTarefas = json.decode(dados);
      });
    });
    bannerSize = AdmobBannerSize.BANNER;

    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );

    rewardAd = AdmobReward(
        adUnitId: getRewardBasedVideoAdUnitId(),
        listener: (AdmobAdEvent event, Map<String, dynamic> args) {
          if (event == AdmobAdEvent.closed) rewardAd.load();
        });

    interstitialAd.load();
    rewardAd.load();
  }

  Widget criarItemLista(context, index) {
    return Dismissible(
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        //recuperar último item excluído
        _ultimaTarefaRemovida = _listaTarefas[index];

        //Remove item da lista
        _listaTarefas.removeAt(index);
        _salvarArquivo();

        //snackbar
        final snackbar = SnackBar(
          //backgroundColor: Colors.green,
          duration: Duration(seconds: 5),
          content: Text("Tarefa removida!!"),
          action: SnackBarAction(
              label: "Desfazer",
              onPressed: () {
                //Insere novamente item removido na lista
                setState(() {
                  _listaTarefas.insert(index, _ultimaTarefaRemovida);
                });
                _salvarArquivo();
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
        title:
            // ignore: deprecated_member_use
            RaisedButton(
          color: Colors.white,
          child: Center(
            child: Text(
              _listaTarefas[index].toString(),
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ),


        ),
        subtitle:index==3||index==8||index==15||index==22||index==28||index==35

            ?BannerC():Text(''),
      ),

    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar:
          AppBar(elevation: 10, backgroundColor: Theme.of(context).primaryColor,
            title: Center(child: BannerC() ),),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          foregroundColor: Theme.of(context).primaryColor,
          backgroundColor: Colors.grey[300],
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return ListView(
                    children: [
           //    BannerC(),
                      AlertDialog(
                        title: Text("criar nota"),
                        content: Column(
                          children: [
BannerC(),
                          Divider(height: 50,),
                            TextField(
                              controller: _controleTitulo,
                              decoration:
                              InputDecoration(labelText: "Digite um titulo"),
                              onChanged: (text) {},
                            ),
                            TextField(
                              controller: _controllerTarefa,
                              decoration:
                                  InputDecoration(labelText: "Digite sua tarefa"),
                              onChanged: (text) {},
                            ),
                          ],
                        ),
                        actions: <Widget>[
                          // ignore: deprecated_member_use
                          FlatButton(
                            child: Text("Cancelar",style: TextStyle(color: Colors.brown[300]),),
                            onPressed: () => Navigator.pop(context),
                          ),
                          // ignore: deprecated_member_use
                          FlatButton(
                            child: Text("Salvar",style: TextStyle(color: Colors.brown[300]),),
                            onPressed: () {
                              //salvar
                              _salvarTarefa();
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      BannerQuadrado()

                    ],
                  );
                });
          }),
      body: MultiselectScope(
        controller: _multiselectController,
        dataSource: _listaTarefas,

        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/fundo.png'),fit:BoxFit.fill )),
                  child: ListView.builder(
                      itemCount: _listaTarefas.length,
                      itemBuilder: (context, index) {
                        final controller = MultiselectScope.controllerOf(context);

                        final itemIsSelected = controller.isSelected(index);

                        return InkWell(
                          onLongPress: () {
                            if (!controller.selectionAttached) {
                              controller.select(index);
                            }
                          },
                          onTap: () {
                            debugPrint('Item is selected: $itemIsSelected');

                            if (controller.selectionAttached) {
                              controller.select(index);
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              color: itemIsSelected
                                  ? Theme.of(context).primaryColor
                                  : null,

                              child:Container(child: criarItemLista(context, index))
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Row(
                children: [
                  MaterialButton(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('compartilhar',style: TextStyle(color: Colors.white),),
                      //fillColor: Colors.deepPurpleAccent,
                      onPressed: () async {
                        var response = FlutterShareMe().shareToSystem(
                            msg: _multiselectController
                                .getSelectedItems()
                                .toString());
                        if (response == 'success') ;
                      }),
                  MaterialButton(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Container(height: 50,width:50,child: Image.asset('assets/wat.png',)),
                      //fillColor: Colors.deepPurpleAccent,
                      onPressed: () async {
                            var response = FlutterShareMe().shareToWhatsApp(
                              msg: _multiselectController
                                  .getSelectedItems()
                                  .toString());
                          if (response == 'success') ; interstitialAd.show();

                      },



                      ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }  @override
  void dispose() {
    interstitialAd.dispose();
    rewardAd.dispose();
    super.dispose();
  }


}
