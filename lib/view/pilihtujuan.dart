import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PilihKotaTujuan extends StatefulWidget {
  @override
  _PilihKotaTujuanState createState() => _PilihKotaTujuanState();
}

class _PilihKotaTujuanState extends State<PilihKotaTujuan> {
  var list;
  Future<List> getData() async {
    final respon =
        await http.get("https://aptsweb.000webhostapp.com/data_android/penyediajasa.php");
    return json.decode(respon.body);
  }

  var kotaTerpilih, kota;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: Text("Pilih Kota Tujuan"),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                kota = await showSearch(context: context, delegate: CariData(this.list));
                setState(() {
                  kotaTerpilih = kota;
                });
              })
        ],
      ),
      body: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            list = snapshot.data;
            if (snapshot.hasError) print(snapshot.error);
            return snapshot.hasData
                ? ListView.builder(
                    itemCount: kotaTerpilih==null?list.length:1,
                    itemBuilder: (context, index) {
                      //print(list[index].toString());
                      return ListTile(
                          onTap: () {Navigator.pop(context, kotaTerpilih==null?list[index]['kota']:kotaTerpilih);},
                          leading: Icon(Icons.location_city),
                          title: Text(
                            kotaTerpilih==null?list[index]['kota']:kotaTerpilih,
                          ));
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  );
          }),
    );
  }
}

class CariData extends SearchDelegate<String> {
  final List kota;
  CariData(this.kota);

  @override
  List<Widget> buildActions(BuildContext context) {
    
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    
    final Iterable suggestionList = query.isEmpty
        ? kota
        : kota.where((k) => k.toString().toLowerCase().contains(query));

    return ListView.builder(
      itemCount: suggestionList.toList().length,
      itemBuilder: (context, index) {
        //print(list[index].toString());
        return ListTile(
            onTap: () {
              close(context, suggestionList.toList()[index]['kota']);
              print(suggestionList.toList()[index]['kota']);
            },
            leading: Icon(Icons.location_city),
            title: Text(
              suggestionList.toList()[index]['kota'],
            ));
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {    

    final Iterable suggestionList = query.isEmpty
        ? kota
        : kota.where((k) => k.toString().toLowerCase().contains(query));

    return ListView.builder(
      itemCount: suggestionList.toList().length,
      itemBuilder: (context, index) {
        //print(list[index].toString());
        return ListTile(
            onTap: () {
              close(context, suggestionList.toList()[index]['kota']);
              print(suggestionList.toList()[index]['kota']);
            },
            leading: Icon(Icons.location_city),
            title: Text(
              suggestionList.toList()[index]['kota'],
            ));
      },
    );
  }
}
