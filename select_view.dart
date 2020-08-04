import 'convertidor.dart';
import 'student.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Select extends StatelessWidget {
  //get fechStudent => null;

  Future<List<Student>> fetchStudent() async {
    String url = "http://192.168.0.108/Students/GetStudent.php";
    try {
      final response = await http.get(url);
      // print('ListView response: ${response.body}');
      //  return studentFromJson(response.body);
      if (200 == response.statusCode) {
        //Mapear la lista
        List<Student> list = parseResponse(response.body);
        return list;
      } else {
        return List<Student>();
      }
    } catch (e) {
      print("Error getting datafrom SQL Server");
      print(e.toString());
      return List<Student>();
    }
  }

  /* static const SERVER = "http://192.168.0.108/Students/GetStudent.php";
  static const _SELECT_TABLE_COMMAND = "SELECT_TABLE";

  static Future<List<Student>> selectData() async {
    try {
      //Mapeamos para comparar
      var map = Map<String, dynamic>();
      map['action'] = _SELECT_TABLE_COMMAND;
      //Body es lo que estamos mapeando
      final response = await http.post(SERVER, body: map);
      print('ListView response: ${response.body}');
      if (200 == response.statusCode) {
        //Mapear la lista
        List<Student> list = parseResponse(response.body);
        return list;
      } else {
        return List<Student>();
      }
    } catch (e) {
      print("Error getting datafrom SQL Server");
      print(e.toString());
      return List<Student>();
    }
  }*/

  //ParseResponse Method
  static List<Student> parseResponse(String responseBody) {
    final parseData = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parseData.map<Student>((json) => Student.fromJson(json)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Demo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: FutureBuilder(
            future: fetchStudent(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              // print(fetchStudent());
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data.length,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    Student student = snapshot.data[index];
                    return ListTile(
                      leading: CircleAvatar(
                        minRadius: 30.0,
                        maxRadius: 30.0,
                        backgroundColor: Colors.white,
                        backgroundImage: Convertir.imageFromBase64sString(   '${student.foto}',).image,
                      ),
                      title: new Text(
                          '${student.firstName}',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: new Text(
                         '${student.matricula}',
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                      /* onTap: (){
                              Navigator.push(context,
                                new MaterialPageRoute(builder: (context)=> DetailPage(snapshot.data[index])));
                            },*/
                    );
                  },
                );
              }
              return Container(
                  child: Center(
                child: CircularProgressIndicator(),
              ));
            },
          ),
        ),
      ),
    );
  }
}
