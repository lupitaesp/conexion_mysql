import 'dart:convert';
import 'package:connection_mysql/select.dart';
import 'package:http/http.dart' as http;
import 'Student.dart';
import 'package:flutter/material.dart';
import 'bd_connections.dart';

class Select extends StatefulWidget {
  Select() : super();
  final String title = "MySQL BD Connection";

  @override
  homepageState createState() => homepageState();
}

class homepageState extends State<Select> {
  
  GlobalKey<ScaffoldState> _scaffoldKey;

  //ELEMENTOS PARA BUSQUEDA
  String searchString = "";
  bool _isSearching = false;

  List<Student> _Students;
  var dbHelper;
  TextEditingController controller_busqueda = TextEditingController();

  @override
  void initState() {
    super.initState();
    dbHelper = BDConnections();
    _isSearching = false;
    refreshList();
  }

  void refreshList() {
  setState(() {
      _Students = dbHelper.selectData();
    });
  }

  void cleanData() {
    controller_busqueda.text = "";
  }

  //Desplegar la snackbar
  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  _selectDataLike(){
    BDConnections.selectData().then((students){
      setState(() {
        _Students = students;
      });
    });
  }

  //SELECT DATA
  get _selectData {
    //_showSnackBar('Loading Student...');
    BDConnections.selectData().then((students) {
      setState(() {
        _Students = students;
      });
      //Verificar si tenemos algo de retorno
      _showSnackBar(context, "Data Acquired");
      print("size of Students ${students.length}");
    });
  }

  //******************************************************************
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue[900],
        title: _isSearching ? TextField(
          decoration: InputDecoration(
              hintText: "Buscando..."),
          onChanged: (value) {
            setState(() {
              searchString = value;
            });
          },
          controller: controller_busqueda,
        )
            :Text("SELECT REGISTRY BY MATRICULA",
          style: TextStyle(
            color: Colors.white
          ),
        ),
        actions: <Widget>[
          !_isSearching ? IconButton(
            icon: Icon(Icons.search),
            onPressed: (){
              setState(() {
                searchString = "";
                this._isSearching = !this._isSearching;
              });
            },
          )
              :IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              setState(() {
                this._isSearching = !this._isSearching;
              });
            },
          )
         ],
        ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          child: FutureBuilder(
            future: _selectData(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return Container(
                  child: Center(
                    child: Text("Cargando..."),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return snapshot.data[index].matricula.contains(controller_busqueda.text)
                        ? ListTile(
                            leading: CircleAvatar(
                              minRadius: 25.0,
                              maxRadius:  25.0,
                              backgroundColor: Colors.white,
                              //backgroundImage: Convertir.imageFromBase64sString(snapshot.data[index].photoName).image
                            ),
                            title: new Text(
                              snapshot.data[index].firstName.toString().toUpperCase(),
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                            subtitle: new Text(
                              snapshot.data[index].matricula.toString().toUpperCase(),
                              style: TextStyle(
                                fontSize: 15.0,
                              ),
                            ),
                            onTap: (){
                              //MANDA A PANTALLA DE DETALLES
                            },
                          )
                        : Container();
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}