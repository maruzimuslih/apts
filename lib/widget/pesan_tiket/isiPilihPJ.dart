import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BoxAppBarPJ extends StatefulWidget {
  @override
  _BoxAppBarPJState createState() => _BoxAppBarPJState();
}

class _BoxAppBarPJState extends State<BoxAppBarPJ> {
  String kotaAsal, kotaTujuan, tanggal;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      kotaAsal = preferences.getString('kotaAsal');
      kotaTujuan = preferences.getString('kotaTujuan');
      tanggal = preferences.getString('tanggal');
    });
  }

  @override
  void initState() {
    
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child:
                  Icon(Icons.keyboard_backspace, color: Colors.white, size: 21),
            ),
            SizedBox(width: 20),
            Text("$kotaAsal",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            SizedBox(width: 10),
            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 14),
            SizedBox(width: 10),
            Text("$kotaTujuan",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text("$tanggal",
                  style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ],
        )
      ],
    );
  }
}

class BoxBodyPJ extends StatefulWidget {
  @override
  _BoxBodyPJState createState() => _BoxBodyPJState();
}

class _BoxBodyPJState extends State<BoxBodyPJ> {
  String kotaAsal, kotaTujuan;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      kotaAsal = preferences.getString("kotaAsal");
      kotaTujuan = preferences.getString("kotaTujuan");
    });
  }

  @override
  void initState() {
    
    super.initState();
    getPref();
  }

  Future<List> getData() async {
    final respon = await http.post("https://aptsweb.000webhostapp.com/data_android/armada.php",
        body: {'kota': kotaAsal, 'kotaTujuan': kotaTujuan});
    return json.decode(respon.body);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Hasil Pencarian", style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 30),
        Expanded(
          child: Container(
              height: MediaQuery.of(context).size.height,
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
                      "Data tidak ditemukan",
                      style: TextStyle(fontSize: 16),
                    ));
                  }
                  //load empty data UI
                  if (snapshot.data.isEmpty) {
                    return Center(
                        child: Text(
                      "Data tidak ditemukan",
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
                      itemCount: snapshot?.data?.length ?? 0,
                      itemBuilder: (context, index) {
                        return PJpilihan(pj: snapshot.data, i: index);
                      });
                },
              )),
        )
      ],
    );
  }
}

class PJpilihan extends StatefulWidget {
  final List pj;
  final int i;
  const PJpilihan({Key key, this.pj, this.i}) : super(key: key);

  @override
  _PJpilihanState createState() => _PJpilihanState();
}

class _PJpilihanState extends State<PJpilihan> {
  String tgl; double hargaDouble;
  DateFormat jamFormat = DateFormat.Hm();
  DateFormat menitFormat = DateFormat.m();
  DateFormat tanggalFormat = DateFormat.yMd();
  DateTime now = DateTime.now();
  bool cekWaktuBerangkat = true;
  var jeda, jedaM, total, totalFix, f = NumberFormat('#,###,###');
  DateTime jamBerangkat,
      jamTiba,
      menitBerangkat,
      menitTiba,
      tglBerangkat,
      waktuBerangkat;

  @override
  void initState() {
    
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      tgl = preferences.getString('tgl');
      jamBerangkat = jamFormat.parse(widget.pj[widget.i]['jamBerangkat']);
      jamTiba = jamFormat.parse(widget.pj[widget.i]['jamTiba']);
      jeda = jamTiba.difference(jamBerangkat).inHours;
      menitBerangkat = menitFormat.parse(jamBerangkat.minute.toString());
      menitTiba = menitFormat.parse(jamTiba.minute.toString());
      jedaM = menitTiba.difference(menitBerangkat).inMinutes;
      tglBerangkat = tanggalFormat.parse(tgl);
      waktuBerangkat = new DateTime(tglBerangkat.year, tglBerangkat.month,
          tglBerangkat.day, jamBerangkat.hour, jamBerangkat.minute);
      cekWaktuBerangkat = now.isAfter(waktuBerangkat);

      hargaDouble = double.parse(widget.pj[widget.i]['harga']);
      total= hargaDouble*1000;
      totalFix = f.format(total);
    });
  }

  pilihKursi() {
    savePref();
    Navigator.of(context).pushNamed('/pilihkursi');
  }

  savePref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString('id_pj', widget.pj[widget.i]['id_pj']);
      preferences.setString('namaPJ', widget.pj[widget.i]['namaPJ']);
      preferences.setString('alamat', widget.pj[widget.i]['alamat']);
      preferences.setString('poolAsal', widget.pj[widget.i]['pool']);
      preferences.setString('namaBank', widget.pj[widget.i]['namaBank']);
      preferences.setString('noRekening', widget.pj[widget.i]['noRekening']);
      preferences.setString('pemilikRekening', widget.pj[widget.i]['pemilikRekening']);
      preferences.setString('id_armada', widget.pj[widget.i]['id_armada']);
      preferences.setString('namaArmada', widget.pj[widget.i]['namaArmada']);
      preferences.setString('poolTujuan', widget.pj[widget.i]['poolTujuan']);
      preferences.setString('jamBerangkat', widget.pj[widget.i]['jamBerangkat']);
      preferences.setString('jamTiba', widget.pj[widget.i]['jamTiba']);
      preferences.setString('kursi', widget.pj[widget.i]['kapasitasKursi']);
      preferences.setString('sisaKursi', widget.pj[widget.i]['sisaKursi']);
      preferences.setString('harga', widget.pj[widget.i]['harga']);
    });
  }

  Widget _itemDepartment() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.pj[widget.i]['pool'],
              style: TextStyle(color: Colors.grey[600])),
          SizedBox(height: 1),
          Text(widget.pj[widget.i]['jamBerangkat'],
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _itemDepartment2() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.pj[widget.i]['poolTujuan'],
              style: TextStyle(color: Colors.grey[600])),
          SizedBox(height: 1),
          Text(widget.pj[widget.i]['jamTiba'],
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _locationPlane() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            "${jeda.toString()}j${jedaM.toString()}m",
            style: TextStyle(fontSize: 12),
          ),
          // SizedBox(height: 10),
          Row(
            children: <Widget>[
              Icon(Icons.airport_shuttle, color: Colors.indigo, size: 20),
              Icon(Icons.fiber_manual_record, color: Colors.indigo, size: 8),
              Icon(Icons.fiber_manual_record, color: Colors.indigo, size: 8),
              Icon(Icons.fiber_manual_record, color: Colors.indigo, size: 8),
              Icon(Icons.fiber_manual_record, color: Colors.indigo, size: 8),
              Icon(Icons.fiber_manual_record, color: Colors.indigo, size: 8),
              Icon(Icons.fiber_manual_record,
                  color: Colors.deepPurple, size: 14),
              Icon(Icons.fiber_manual_record, color: Colors.purple, size: 8),
              Icon(Icons.fiber_manual_record, color: Colors.purple, size: 8),
              Icon(Icons.fiber_manual_record, color: Colors.purple, size: 8),
              Icon(Icons.fiber_manual_record, color: Colors.purple, size: 8),
              Icon(Icons.fiber_manual_record, color: Colors.purple, size: 8),
              Icon(Icons.location_on, color: Colors.purple, size: 20),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cekWaktuBerangkat) {
      return Container();
    } else if (widget.pj[widget.i]['sisaKursi'] == '0') {
      return Container();
    } else {
      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: InkWell(
          onTap: pilihKursi,
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(14))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(Icons.directions_bus,
                            color: Colors.deepPurple, size: 25),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(widget.pj[widget.i]['namaPJ'],
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          children: <Widget>[
                            Text("Rp. $totalFix",
                                style: TextStyle(
                                    fontSize: 12, fontWeight: FontWeight.bold)),
                            SizedBox(width: 3),
                            Icon(Icons.trending_flat,
                                color: Colors.black, size: 20)
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(widget.pj[widget.i]['namaArmada'],
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 1),
                        Text(
                            "${widget.pj[widget.i]['sisaKursi']} kursi tersedia",
                            style: TextStyle(color: Colors.grey[600])),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _itemDepartment(),
                        _locationPlane(),
                        _itemDepartment2(),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }
  }
}
