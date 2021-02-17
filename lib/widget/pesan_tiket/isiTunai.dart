import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../buttonWidget.dart';

class BoxAppBarTunai extends StatelessWidget {
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
            Text("Intstruksi Pembayaran",
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
              child: Text("Pembayaran via Tunai",
                  style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ],
        )
      ],
    );
  }
}

class BoxBodyTunai extends StatefulWidget {
  @override
  _BoxBodyTunaiState createState() => _BoxBodyTunaiState();
}

class _BoxBodyTunaiState extends State<BoxBodyTunai> {
  int sisaKursi;

  String idPenumpang,
      idArmada,
      idPJ,
      kotaAsal,
      namaBank,
      noRekening,
      pemilikRekening,
      poolAsal,
      kotaTujuan,
      poolTujuan,
      tanggal,
      jamBerangkat,
      jamTiba,
      namaPJ,
      namaArmada,
      harga,
      totalPembayaran,
      nama,
      noHP,
      email,
      kodePemesanan;

  List noKursiDipilih, kursiDipesan, listNama, listUsia;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idPenumpang = preferences.getString('id_penumpang');
      nama = preferences.getString('nama');
      idArmada = preferences.getString('id_armada');
      idPJ = preferences.getString('id_pj');
      email = preferences.getString('email');
      noHP = preferences.getString('noHP');
      namaBank = preferences.getString('namaBank');
      noRekening = preferences.getString('noRekening');
      pemilikRekening = preferences.getString('pemilikRekening');
      harga = preferences.getString('harga');
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
      kodePemesanan = preferences.getString('kode');
      listNama = preferences.getStringList('listNama');
      listUsia = preferences.getStringList('listUsia');
    });
    print(listNama);
    print(listUsia);
  }

  @override
  void initState() {
    super.initState();
    getPref();
  }

  void ubahSisaKursi() {
    var url = "https://aptsweb.000webhostapp.com/data_android/ubahSisaKursi.php";
    http.post(url, body: {
      'id_armada': idArmada,
      'sisaKursi': sisaKursi.toString(),
    });
  }

  void ubahStatusDipesan() {
    var url = "https://aptsweb.000webhostapp.com/data_android/ubahKursi.php";
    for (var i = 0; i < kursiDipesan.length; i++) {
      http.post(url, body: {
        "id_kursi": kursiDipesan[i],
      });
      print(kursiDipesan[i]);
    }
  }

  delayedSend() async {
    await tambahPesanan().then((_) {
      tambahNamaUsiaPesanan();
      tambahKursiPesanan();
    });
  }

  tambahNamaUsiaPesanan() async{
    var url = "https://aptsweb.000webhostapp.com/data_android/tambahNamaUsia.php";
    for (var i = 0; i < listNama.length; i++) {
      await http.post(url, body: {
        "nama": listNama[i], 
        "usia": listUsia[i],
        "kode" : kodePemesanan
      });
    }
  }

  tambahKursiPesanan() async{
    var url = "https://aptsweb.000webhostapp.com/data_android/tambahKursiPesanan.php";
    for (var i = 0; i < kursiDipesan.length; i++) {
      await http.post(url, body: {         
        "id_kursi": kursiDipesan[i],
        "kode" : kodePemesanan
      });
    }
  }

  ubahStatus() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString('statusPembayaran', 'Belum dibayar');
    });
  }

  inputDataPesanan() async{
    ubahSisaKursi();
    ubahStatusDipesan();
    await delayedSend();
    ubahStatus();
    setState(() {
      isLoading=false;
    });
    Navigator.of(context).pushNamedAndRemoveUntil('/konfirmasiTunai', ModalRoute.withName('/'));
  }

  Future tambahPesanan() async{
    var url = "https://aptsweb.000webhostapp.com/data_android/tambahPesanan.php";
    await http.post(url, body: {
      'kodePemesanan': kodePemesanan,
      'tglBerangkat': tanggal,
      'noKursi': noKursiDipilih.join(', ').toString(),
      'totalPembayaran': totalPembayaran,
      'metodePembayaran': 'Tunai',
      'statusPembayaran': 'Belum dibayar',
      'id_penumpang': idPenumpang,
      'id_pj': idPJ,
      'id_armada': idArmada
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

  Widget _rincianPembayaran(context, teks) {
    return Column(
      children: <Widget>[
        _judul(teks),
        SizedBox(height: 7),
        Container(
          child: Card(
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Kode Pemesanan",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.bold)),
                            SizedBox(width: 5),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("$kodePemesanan",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold)),
                              ],
                            )
                          ],
                        ),
                        Divider(thickness: 2),
                        Text("Cara pembayaran via Tunai:",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold)),
                        SizedBox(height: 5,),
                        Text("Silahkan datang langsung ke tempat keberangkatan (Pool $namaPJ $poolAsal) dan lakukan pembayaran.",
                          style: TextStyle(fontSize: 14 , color: Colors.grey[600],)),
                        Divider(thickness: 2),
                        _infoPembayaran(
                            "Jumlah dibayar", "Rp. $totalPembayaran"),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  bool isLoading = false;
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
              SizedBox(height: 15,),
              _rincianPembayaran(context, "Rincian Pembayaran"),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: !isLoading
                ? BtnOval(
                  label: "Pilih Pembayaran Tunai",
                  lebar: MediaQuery.of(context).size.width,
                  onPressed: () {
                    return showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: new Text('Pembayaran via Tunai'),
                          content: new Text(
                              'Anda tidak dapat mengubah metode pembayaran. Lanjut?',
                              style: TextStyle(color: Colors.grey[600])),
                          actions: <Widget>[
                            new FlatButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: new Text('Tidak',
                                  style: TextStyle(color: Colors.grey[700])),
                            ),
                            new FlatButton(
                              onPressed: ()async {
                                Navigator.of(context).pop();
                                setState(() {
                                  isLoading=true;
                                });
                                await inputDataPesanan();
                              },
                              child: new Text('Ya'),
                            ),
                          ],
                        );                      
                      },
                    );
                    //Navigator.of(context).pushNamed('/pembayaran');
                  },
                ):Center(child: CircularProgressIndicator())
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

Widget _infoPembayaran(teks1, teks2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Expanded(
        child: Text(teks1,
            style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
                fontWeight: FontWeight.bold)),
      ),
      Text(teks2,
        style: TextStyle(
            fontSize: 14,
            color: Colors.deepPurple))
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