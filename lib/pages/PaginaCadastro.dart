import 'package:flutter/material.dart';
import 'PaginaLogin.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io';

class PaginaCadastro extends StatefulWidget {
  @override
  _PaginaCadastroState createState() => _PaginaCadastroState();
}

class _PaginaCadastroState extends State<PaginaCadastro> {
  TextEditingController _controllerLogin = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.bd");
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

  _salvarDados(String nome, String senha) async {
    Database bd = await _recuperarBancoDados();
    Map<String, dynamic> dadosUsuario = {
      "nome" : nome,
      "senha" : senha
    };
    int id = await bd.insert("usuarios", dadosUsuario);
    print("Salvo: $id " );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CADASTRO"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
              decoration: InputDecoration(
                  labelText: "Login:",
                  hintText: "Informe o login"
              ),
              controller: _controllerLogin,
              validator: (String text){
                if(text.isEmpty){
                  return "Digite o texto";
                }
                return null;
              },
            ),
            SizedBox(height: 10,),
            TextFormField(
              style: TextStyle(
                fontSize: 20,
                color: Colors.black,
              ),
              decoration: InputDecoration(
                  labelText: "Senha:",
                  hintText: "Informe a senha"
              ),
              obscureText: true,
              controller: _controllerSenha,
              validator: (String text){
                if(text.isEmpty){
                  return "Informe a senha ";
                }
                if(text.length < 4){
                  return "A senha tem pelo menos 4 dígitos";
                }
                return null;
              },
            ),
            SizedBox(height: 20,),

            Container(
              height: 46,
              child: ElevatedButton(
                  child: Text("Cadastro",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                    ),),
                  onPressed: (){
                    bool formOk = _formKey.currentState.validate();
                    if(! formOk){
                      return;
                    }
                    else{
                      _salvarDados(_controllerLogin.text, _controllerSenha.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaginaLogin()
                        ),
                      );
                    }
                    print("Login "+_controllerLogin.text);
                    print("Senha "+_controllerSenha.text);
                  }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
