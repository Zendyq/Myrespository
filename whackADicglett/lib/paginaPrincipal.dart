import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:whackadicglett/infoDiglett.dart';

class paginaPrincipal extends StatefulWidget {
  @override
  _estadoPaginaPrincipal createState() => _estadoPaginaPrincipal();
}

class _estadoPaginaPrincipal extends State<paginaPrincipal> {
  late Future<infoDiglett> informacionDiglett;

  Future<infoDiglett> recogerInfoDiglett() async {
    String spriteDiglett="";
    String habilidad1="";
    String habilidad2="";
    String habilidad3="";
    print("Antes del await");
    final response = await http.get(Uri( scheme: "https", host: "pokeapi.co", path: "/api/v2/pokemon/diglett/"));
    //Uri( scheme: "https", host: "pokeapi.co", path: "/api/v2/pokemon/diglett")
    if(response.statusCode == 200){
        print("despues del await");
        String jData = utf8.decode(response.bodyBytes);
        final json = jsonDecode(jData);
        spriteDiglett = json["sprites"]["front_default"];
        habilidad1 = json["abilities"][0]["ability"]["name"];
        habilidad2 = json["abilities"][1]["ability"]["name"];
        habilidad3 = json["abilities"][2]["ability"]["name"];
    }else{
      throw Exception("Fallo de conexion");
    }
    return infoDiglett(spriteDiglett, habilidad1, habilidad2, habilidad3);
  }

  List<bool> listaDiglettVisible = [false, false, false, false];
  Random aleatorio = Random();
  int puntuacion = 0;
  final audioName = "assests/diglettSound.mp3";

  @override
  void initState() {
    super.initState();
    informacionDiglett = recogerInfoDiglett();
    jugar();
  }

  void jugar() {
    Timer.periodic(Duration(milliseconds: 900), (Timer timer) {
      setState(() {
        listaDiglettVisible =
            listaDiglettVisible.map((_) => aleatorio.nextBool()).toList();
      });
    });
  }

  void golpearDiglett(int indice) {
    setState(() {
      if (listaDiglettVisible[indice]) {
        puntuacion++;
        listaDiglettVisible[indice] = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/fondoHierva.png'),
            fit: BoxFit.fill,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            toolbarHeight: 70,
            title: Text(
              'Whack a Diglett',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            backgroundColor: Color.fromRGBO(255, 203, 98, 0.0),
            centerTitle: true,
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Puntos: $puntuacion',
                  style: TextStyle(fontSize: 35.0),
                ),
                TextButton(
                  onPressed: () {
                    SnackBar(content: Text("FIGLLETASDA"));
                  },
                  child: Container(
                    decoration: BoxDecoration(

                    ),
                      child: Text(
                    "VER MÁS",
                    style: TextStyle(fontSize: 20, color: Colors.black, ),
                  )),
                ),
                SizedBox(height: 50.0),
                GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.0,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int indice) {
                    return GestureDetector(
                      onTap: () => golpearDiglett(indice),
                      child: Container(
                        color: Colors.transparent,
                        child: Center(
                            child: listaDiglettVisible[indice]
                                ? Image.asset('assets/diglettFuera.png',
                                    width: 150, height: 150)
                                : Image.asset('assets/diglettDentro.png',
                                    width: 150, height: 150)),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
