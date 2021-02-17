import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apts/view/lihatprofil.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class BoxProfil extends StatefulWidget {

  @override
  _BoxProfilState createState() => _BoxProfilState();
}

class _BoxProfilState extends State<BoxProfil> {
  String email = "";
  getPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString("email");
    });
  }

  @override
  void initState() {
    
    super.initState();
    getPref();
  }

  Future<List> getData() async {
    final respon = await http.post("https://aptsweb.000webhostapp.com/data_android/penumpang.php",
        body: {'email': email});
    return json.decode(respon.body);
  }
  

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: Container(
          //alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 100,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FutureBuilder<List>(
                  future: getData(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    return snapshot.hasData
                        ? ProfilSingkat(list: snapshot.data)
                        : Center(
                            child: CircularProgressIndicator(),
                          );
                  }),
            ],
          )),
    );
  }
}

class ProfilSingkat extends StatelessWidget {
  final List list;
  ProfilSingkat({this.list});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
            text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: list[0]['namaPenumpang'],
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.bold))
        ])),
        SizedBox(height: 15),
        Text(list[0]['email'],
            style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(list[0]['noHP']==null?"":list[0]['noHP'],
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            InkWell(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => DetailAkun())),
              child: Container(
                alignment: Alignment.center,
                height: 20,
                width: 60,
                child: Text("Lihat Profil",
                    style: TextStyle(
                        fontSize: 12,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ],
    );
  }
}