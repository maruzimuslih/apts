import 'dart:math';
import 'package:flutter/material.dart';
import 'package:apts/widget/buttonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoxAppBarVerPesanan extends StatefulWidget {
  @override
  _BoxAppBarVerPesananState createState() => _BoxAppBarVerPesananState();
}

class _BoxAppBarVerPesananState extends State<BoxAppBarVerPesanan> {
  String kotaAsal, kotaTujuan, jmlPenumpang;
  List noKursi;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      kotaAsal = preferences.getString('kotaAsal');
      kotaTujuan = preferences.getString('kotaTujuan');
      noKursi = preferences.getStringList('noKursiDipilih');
      jmlPenumpang = noKursi.length.toString();
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
            Text("Verifikasi Pemesanan",
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
              child: Text("$kotaAsal - $kotaTujuan",
                  style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ],
        ),
        //SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text("$jmlPenumpang Penumpang",
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        )
      ],
    );
  }
}

class BoxBodyVerPesanan extends StatefulWidget {
  @override
  _BoxBodyVerPesananState createState() => _BoxBodyVerPesananState();
}

class _BoxBodyVerPesananState extends State<BoxBodyVerPesanan> {
  bool addDataPesanan;
  int sisaKursi;
  String idArmada,
      idPJ,
      idPenumpang,
      kodePemesanan,
      nama,
      email,
      noHP,
      totalPembayaran,
      kotaAsal,
      kotaTujuan,
      tanggal,
      poolAsal,
      poolTujuan,
      jamBerangkat,
      jamTiba,
      namaPJ,
      namaArmada,
      noKursi;
  List noKursiDipilih, kursiDipesan;
  List<TextEditingController> controllerNama = List();
  List<TextEditingController> controllerUsia = List();
  List<String> listNama = List();
  List<String> listUsia = List();
  final _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  Random _rnd = Random();
  //TextEditingController controllerNama = TextEditingController();
  //TextEditingController controllerUsia = TextEditingController();

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idPenumpang = preferences.getString('id_penumpang');
      nama = preferences.getString('nama');
      idArmada = preferences.getString('id_armada');
      idPJ = preferences.getString('id_pj');
      email = preferences.getString('email');
      noHP = preferences.getString('noHP');
      totalPembayaran = preferences.getString('totalPembayaran');
      sisaKursi = preferences.getInt('updateSisaKursi');
      noKursiDipilih = preferences.getStringList('noKursiDipilih');
      kursiDipesan = preferences.getStringList('kursiDipesan');
      kotaAsal = preferences.getString('kotaAsal');
      kotaTujuan = preferences.getString('kotaTujuan');
      tanggal = preferences.getString('tanggal');
      namaPJ = preferences.getString('namaPJ');
      namaArmada = preferences.getString('namaArmada');
      poolAsal = preferences.getString('poolAsal');
      poolTujuan = preferences.getString('poolTujuan');
      jamBerangkat = preferences.getString('jamBerangkat');
      jamTiba = preferences.getString('jamTiba');
      kodePemesanan = getKodePemesanan(10);
    });
    if (noKursiDipilih.length==1) {
      noKursi = noKursiDipilih[0].toString();
    }else{
      noKursi = noKursiDipilih.join(', ').toString();
    }
    print(kursiDipesan);
    print(noKursiDipilih.join(', ').toString());
    print(kodePemesanan);
    print(sisaKursi);
  }

  @override
  void initState() {
    super.initState();
    getPref();
    addDataPesanan = false;
  }  

  void simpenController() {
    for (var i = 0; i < noKursiDipilih.length; i++) {
      if (controllerNama[i].text!=""&&controllerUsia[i].text!="") {
        if (addDataPesanan == false) {
          setState(() {
            listUsia.add(controllerUsia[i].text);
            listNama.add(controllerNama[i].text);
          });
        }
      }
    }
    print(listNama);
    print(listUsia);
  }

  saveP() async{
    simpenController();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString('kode', kodePemesanan);
      preferences.setStringList('listNama', listNama);
      preferences.setStringList('listUsia', listUsia);
    });
  }  

  String getKodePemesanan(int length) {
    return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  Widget _infoShuttle(context, teks) {
    return Column(
      children: <Widget>[
        _judul(teks),
        SizedBox(height: 7),
        Container(
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                height: 130,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            _iconTujuan(),
                            SizedBox(
                              width: 17,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                RichText(
                                    text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "$kotaAsal \n",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600])),
                                  TextSpan(
                                      text: "$poolAsal",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold)),
                                ])),
                                SizedBox(
                                  height: 40,
                                ),
                                RichText(
                                    text: TextSpan(children: <TextSpan>[
                                  TextSpan(
                                      text: "$kotaTujuan \n",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600])),
                                  TextSpan(
                                      text: "$poolTujuan",
                                      style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[800],
                                          fontWeight: FontWeight.bold)),
                                ])),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text("$tanggal",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold)),
                            Text("$jamBerangkat - $jamTiba",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 30),
                            Text("$namaPJ",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold)),
                            Text("$namaArmada",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold)),
                            Text("No.kursi $noKursi",
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Widget _kontak(context, teks) {
    return Column(
      children: <Widget>[
        _judul(teks),
        SizedBox(height: 7),
        Container(
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 100,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.person, size: 23),
                        SizedBox(width: 5),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("$nama",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold)),
                          ],
                        )
                      ],
                    ),
                    Divider(thickness: 2),
                    _infoKontak("Email", "$email"),
                    SizedBox(height: 5),
                    _infoKontak("Nomor Telepon", "$noHP"),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  Widget _fieldNama(context, label, lebar, ikon, controllerN) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(ikon, size: 23),
        SizedBox(width: 5),
        Container(
          width: lebar,
          child: TextField(
            controller: controllerN,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
                hintText: label,
                isDense: true,
                contentPadding: EdgeInsets.only(bottom: 5),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  Widget _fieldUsia(context, label, lebar, ikon, controllerU) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(ikon, size: 23),
        SizedBox(width: 5),
        Container(
          width: lebar,
          child: TextField(
            controller: controllerU,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: label,
                isDense: true,
                contentPadding: EdgeInsets.only(bottom: 5),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  _infoPenumpang(){
    //load null data UI
    if (noKursiDipilih == null) {
      return Center(child: CircularProgressIndicator());
    }else if (noKursiDipilih.isEmpty) {
      return Center(
          child: Text(
        "Data tidak ditemukan",
        style: TextStyle(fontSize: 16),
      ));
    }else if (noKursiDipilih.length == 0) {
      return Center(
          child: Text(
        "Data tidak ditemukan",
        style: TextStyle(fontSize: 16),
      ));
    }else{
      return ListView.builder(
      padding: EdgeInsets.only(top: 0),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      primary: false,
      itemCount: noKursiDipilih?.length??0,
      itemBuilder: (context, index) {
        controllerNama.add(new TextEditingController());
        controllerUsia.add(new TextEditingController());
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                "Penumpang ${index + 1}",
                style: TextStyle(
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    height: 90,
                    width: MediaQuery.of(context).size.width *
                        0.85,
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _fieldNama(
                            context,
                            "Nama Lengkap",
                            MediaQuery.of(context).size.width *
                                0.6,
                            Icons.person,
                            controllerNama[index]),
                        _fieldUsia(
                            context,
                            "Usia",
                            MediaQuery.of(context).size.width *
                                0.15,
                            Icons.calendar_today,
                            controllerUsia[index])
                      ],
                    )),
              ),
            ),
          ],
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.symmetric(vertical: 0),
            children: <Widget>[
              _infoShuttle(context, "Info Shuttle"),
              SizedBox(
                height: 15,
              ),
              _kontak(context, "Kontak Pemesan"),
              SizedBox(
                height: 15,
              ),
              Column(
                children: <Widget>[
                  _judul("Info Penumpang"),
                  SizedBox(height: 7),
                  _infoPenumpang()
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: BtnOval(
                  label: "Verifikasi Data",
                  lebar: MediaQuery.of(context).size.width,
                  onPressed: () {
                    //simpenController();
                    for (var i = 0; i < noKursiDipilih.length; i++) {
                      if (controllerNama[i].text==""||controllerUsia[noKursiDipilih.length-1].text=="") {
                        Scaffold.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Nama atau Usia tidak boleh kosong!"), 
                            backgroundColor: Colors.red, 
                            duration: Duration(seconds: 3)
                          )
                        ); 
                      }else{                    
                        //addDataPesanan = true;
                        return showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text("Verifikasi data"),
                              content: Text(
                                  "Apakah data yang anda masukkan sudah benar?",
                                  style: TextStyle(color: Colors.grey[600])),
                              actions: <Widget>[
                                FlatButton(
                                  onPressed: (){
                                    Navigator.of(context).pop();
                                  }, 
                                  child: Text("Kembali", style: TextStyle(color: Colors.grey[700]))),
                                FlatButton(
                                  onPressed: (){
                                    //inputDataPesanan();
                                    saveP();
                                    Navigator.of(context).pushNamedAndRemoveUntil('/pembayaran', ModalRoute.withName('/'));
                                  }, 
                                  child: Text("Ya"))
                              ],
                            );
                          }
                        );
                      }
                      
                    }                    
                    //Navigator.of(context).pushNamed('/pembayaran');
                  },
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}

Widget _judul(teks) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(teks, style: TextStyle(fontSize: 16)),
    ],
  );
}

Widget _infoKontak(teks1, teks2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(teks1,
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold)),
      Text(teks2, style: TextStyle(fontSize: 14, color: Colors.grey))
    ],
  );
}

Widget _iconTujuan() {
  return Container(
    child: Column(
      children: <Widget>[
        Icon(
          Icons.airport_shuttle,
          color: Colors.indigo,
          size: 23,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Colors.indigo,
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Colors.indigo,
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Colors.indigo,
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Colors.purple,
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Colors.purple,
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Colors.purple,
          size: 9,
        ),
        Icon(
          Icons.location_on,
          color: Colors.purple,
          size: 23,
        ),
      ],
    ),
  );
}
