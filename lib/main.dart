import 'package:flutter/material.dart';
import 'pages/PaginaLogin.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  _recuperarBancoDados() async {
    final caminhoBancoDados = await getDatabasesPath();
    final localBancoDados = join(caminhoBancoDados, "banco.bd");
    var bd = await openDatabase(
        localBancoDados,
        version: 1,
        onCreate: (db, dbVersaoRecente) {
          db.execute("CREATE TABLE usuarios (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, senha VARCHAR) ");
          db.execute("CREATE TABLE contas (id INTEGER PRIMARY KEY AUTOINCREMENT, nome VARCHAR, preco FLOAT, idUsuario INTEGER, validade VARCHAR) ");
          },
        onOpen: (Database db) async {
          print('db version ${await db.getVersion()}');
        }
    );
    return bd;
  }


  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.lightBlue,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.blueGrey,
    ),
    home: PaginaLogin(),
  ));
}