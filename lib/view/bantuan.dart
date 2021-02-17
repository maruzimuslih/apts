import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'detailbantuan.dart';

class Bantuan extends StatefulWidget {
  @override
  _BantuanState createState() => _BantuanState();
}

class _BantuanState extends State<Bantuan> {

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<List> getData() async {
    final respon = await http.get("https://aptsweb.000webhostapp.com/data_android/bantuan.php");
    return json.decode(respon.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Bantuan (FAQ)'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: FutureBuilder<List>(
          future: getData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(child: CircularProgressIndicator());
            }
            //load null data UI
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(
                  child: Text(
                "null",
                style: TextStyle(fontSize: 16),
              ));
            }
            //load empty data UI
            if (snapshot.data.isEmpty) {
              return Center(
                  child: Text(
                "empty",
                style: TextStyle(fontSize: 16),
              ));
            }
            if (snapshot.data.length == 0) {
              return Center(
                  child: Text(
                "Data tidak ditemukan",
                style: TextStyle(fontSize: 16),
              ));
            }
            return ListView.builder(
                padding: EdgeInsets.only(top: 0),
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  return Kategori(data: snapshot.data, i: index);
                });
          },
        ),
      ),
    );
  }
}

class Kategori extends StatefulWidget {
  final List data;
  final int i;

  const Kategori({Key key, this.data, this.i}) : super(key: key);

  @override
  _KategoriState createState() => _KategoriState();
}

class _KategoriState extends State<Kategori> {
  List judulDeskripsi = List();

  getJudulDeskripsi() async {
    final respon = await http.post("https://aptsweb.000webhostapp.com/data_android/judulDeskBantuan.php",
        body: {'jenisBantuan': this.widget.data[widget.i]['jenisBantuan']});
    setState(() {
      judulDeskripsi = json.decode(respon.body);
    });
  }

  @override
  void initState() {
    
    super.initState();
    getJudulDeskripsi();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              _kategoriBantuan(this.widget.data[widget.i]['jenisBantuan']),
            ],
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
              padding: EdgeInsets.only(top: 0),
              itemCount: judulDeskripsi.length,
              itemBuilder: (context, index) {
                return _judulBantuan(
                    context,
                    judulDeskripsi[index]['judul'],
                    judulDeskripsi[index]['deskripsi']);
              })
        ],
      ),
    );
  }
}

Widget _judulBantuan(context, judul, deskripsi) {
  return InkWell(
    onTap: () {
      Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (BuildContext context) =>
                DetailBantuan(judul: judul, deskripsi: deskripsi),
          ));
    },
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Column(
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: Text(judul,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      )),
                ),
                Icon(Icons.arrow_forward_ios, size: 15)
              ],
            ),
          ),
          Divider(),
        ],
      ),
    ),
  );
}

Widget _kategoriBantuan(kategori) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(kategori,
          style: TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold)),
    ],
  );
}
