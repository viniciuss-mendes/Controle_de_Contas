import 'package:flutter/material.dart';
import 'PaginaListaDeContas.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'PaginaCadastro.dart';

class PaginaLogin extends StatefulWidget {
  @override
  _PaginaLoginState createState() => _PaginaLoginState();
}

class _PaginaLoginState extends State<PaginaLogin> {
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

  _validarUsuario(String nome, String senha, BuildContext context) async{
  try {
    Database bd = await _recuperarBancoDados();
    String sql = "SELECT * FROM usuarios WHERE nome = (?) AND senha = (?)";
    List usuarios = await bd.rawQuery(
        sql, [nome, senha]);
    print(usuarios.length > 0);
    if (usuarios.length>0) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PaginaListaDeContas()
        ),
      );
    }
    } catch(e){

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CONTROLE DE CONTAS MENSAL"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(30),
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
              controller: _controllerLogin
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
              controller: _controllerSenha
            ),
            SizedBox(height: 20,),
            Container(
              height: 46,
              child: ElevatedButton(
                  child: Text("Login",
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
                      _validarUsuario(_controllerLogin.text, _controllerSenha.text, context);
                    }
                    print("Login "+_controllerLogin.text);
                    print("Senha "+_controllerSenha.text);
                  }
              ),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PaginaCadastro()
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
