import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../buttonWidget.dart';

class BoxAppBarKonfirmasiTunai extends StatefulWidget {
  @override
  _BoxAppBarKonfirmasiTunaiState createState() => _BoxAppBarKonfirmasiTunaiState();
}

class _BoxAppBarKonfirmasiTunaiState extends State<BoxAppBarKonfirmasiTunai> {
  String kode;

  getPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      kode = preferences.getString('kode');
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
            Text("Detail Tiket",
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
              child: Text("Kode Pemesanan",
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
              child: Text("$kode",
                  style: TextStyle(color: Colors.white, fontSize: 16)),
            ),
          ],
        )
      ],
    );
  }
}

class BoxBodyKonfirmasiTunai extends StatefulWidget {
  @override
  _BoxBodyKonfirmasiTunaiState createState() => _BoxBodyKonfirmasiTunaiState();
}

class _BoxBodyKonfirmasiTunaiState extends State<BoxBodyKonfirmasiTunai> {
  String idPesanan, kotaAsal, poolAsal, kotaTujuan, poolTujuan,
    tglBerangkat, jamBerangkat, jamTiba, namaPJ, namaArmada,
    totalHarga, metodePembayaran, statusPembayaran,
    harga, kodePemesanan;
  double hargaDouble;
  var total, totalFix, f = NumberFormat('#,###,###');
  List noKursiDipilih, listNama, listUsia;

  @override
  void initState() {
    
    super.initState();
    getPref();
    new Future<Null>.delayed(Duration.zero, () {
      Scaffold.of(context).showSnackBar(
        new SnackBar(
          content: Text("Berhasil dipesan!"), 
          backgroundColor: Colors.green, 
          duration: Duration(seconds: 3)
        )
      );
    });
  }

  getPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      harga = preferences.getString('harga');
      totalHarga = preferences.getString('totalPembayaran');
      noKursiDipilih = preferences.getStringList('noKursiDipilih');      
      kotaAsal = preferences.getString('kotaAsal');
      kotaTujuan = preferences.getString('kotaTujuan');
      tglBerangkat = preferences.getString('tanggal');
      namaPJ = preferences.getString('namaPJ');
      namaArmada = preferences.getString('namaArmada');
      poolAsal = preferences.getString('poolAsal');
      poolTujuan = preferences.getString('poolTujuan');
      jamBerangkat = preferences.getString('jamBerangkat');
      jamTiba = preferences.getString('jamTiba');
      kodePemesanan = preferences.getString('kode');
      listNama = preferences.getStringList('listNama');
      listUsia = preferences.getStringList('listUsia');
      metodePembayaran = "Tunai";
      statusPembayaran = preferences.getString('statusPembayaran');

      hargaDouble = double.parse(harga);
      total= hargaDouble*1000;
      totalFix = f.format(total);
    });
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
                            Text("$tglBerangkat",
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
                            Text("No.kursi ${noKursiDipilih.join(', ')}",
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

  Widget _detailTransaksi(context, teks) {
    return Column(
      children: <Widget>[
        _judul(teks),
        SizedBox(height: 7),
        Container(
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 90,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _infoTiket("Harga Tiket", "Rp. $totalFix/kursi"),
                    _infoTiket("Biaya Admin", "-"),
                    Divider(thickness: 2),
                    _infoTiket('Total(x${noKursiDipilih.length} Orang)', 'Rp. $totalHarga')
                  ],
                )),
          ),
        ),
        Container(
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                height: 53,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    _infoTiket("Metode Pembayaran", "$metodePembayaran"),
                    _infoTiket("Status", "$statusPembayaran"),
                  ],
                )),
          ),
        ),
      ],
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            primary: false,
            padding: EdgeInsets.symmetric(vertical: 0),
            children: <Widget>[
              _infoShuttle(context, "Info Shuttle"),
              SizedBox(
                height: 15,
              ),
              Column(
                children: <Widget>[
                  _judul("Info Penumpang"),
                  SizedBox(height: 7),
                  Card(
                    color: Colors.white,
                    shape:
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Flex(
                      direction: Axis.vertical,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text("Daftar Penumpang",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold)),
                              Divider(thickness: 2),
                              ListView.builder(
                                padding: EdgeInsets.only(top: 0),
                                shrinkWrap: true,
                                primary: false,
                                itemCount: noKursiDipilih.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: <Widget>[
                                      SizedBox(height: 5,),
                                      _infoPenumpang("${index+1}. ${listNama[index]}", "${listUsia[index]} tahun")
                                    ],
                                  );
                                },
                              ),
                            ],
                          )
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              _detailTransaksi(context, "Detail Transaksi"),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40, ),
                child: BtnOval(
                    label: "Kembali ke Beranda",
                    lebar: MediaQuery.of(context).size.width * 0.35,
                    onPressed: (){                      
                      Navigator.of(context).pop();                      
                    },
                  )
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

Widget _infoPenumpang(teks1, teks2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(teks1,
          style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold)),
      Text(teks2, style: TextStyle(fontSize: 14, color: Colors.grey[600]))
    ],
  );
}

Widget _infoTiket(teks1, teks2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(teks1, style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold)),
      Text(teks2, style: TextStyle(fontSize: 14, color: Colors.grey[600]))
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