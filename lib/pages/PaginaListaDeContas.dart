import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

_recuperarBancoDados() async {
  final caminhoBancoDados = await getDatabasesPath();
  final localBancoDados = join(caminhoBancoDados, "bancodedados.bd");
  var bd = await openDatabase(
      localBancoDados,
      version: 2,
      onCreate: (db, dbVersaoRecente) {
        db.execute("CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, senha VARCHAR) ");
        db.execute("CREATE TABLE contas (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, preco FLOAT, idUsuario INTEGER) ");
      },
      onOpen: (Database db) async {
        // Database is open, print its version
        print('db version ${await db.getVersion()}');
      }
  );
  return bd;
}

_adicionarConta(String nome, String senha) async {
  Database bd = await _recuperarBancoDados();
  Map<String, dynamic> dadosUsuario = {
    "nome" : nome,
    "senha" : senha
  };
  int id = await bd.insert("usuarios", dadosUsuario);
  print("Salvo: $id " );
}

_listarUsuarios() async{
  Database bd = await _recuperarBancoDados();
  String sql = "SELECT * FROM contas";
  List contas = await bd.rawQuery(sql);
  for(var usu in contas){
    print(" id: "+usu['id'].toString() +
        " nome: "+usu['nome']+
        " idade: "+usu['idade'].toString());
  }
}

class PaginaListaDeContas extends StatefulWidget {
  @override
  _PaginaListaDeContasState createState() => _PaginaListaDeContasState();

}

class _PaginaListaDeContasState extends State<PaginaListaDeContas> {
  List _listaCompras = ["Conta de água  10/01/2021  RS 100,00", "Cartão de crédito 15/02/2021  RS 98,90"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LISTA DE CONTAS"),
      ),
      //floatingActionButtonLocation: FloatingActionButtonLocation.endDocked, //usar com o BottomNavigationBar
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.lightGreen,
          elevation: 6,
          child: Icon(Icons.add),
          onPressed: (){
            print("Botão pressionado!");
            showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: Text("Adicionar conta: "),
                    content: TextField(
                      decoration: InputDecoration(
                          labelText: "Digite a descrição da conta"
                      ),
                      onChanged: (text){

                      },
                    ),
                    actions: <Widget>[
                      TextButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          child: Text("Cancelar")
                      ),
                      TextButton(
                          onPressed: (){

                          },
                          child: Text("Salvar")
                      ),
                      TextButton(
                          onPressed: (){

                          },
                          child: Text("Pagar")
                      ),
                    ],
                  );
                }
            );
          }
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: _listaCompras.length,
                itemBuilder: (context, index){
                  return ListTile(
                    title: Text(_listaCompras[index]),
                  );
                }
            ),
          ),
        ],
      ),
    );
  }
}