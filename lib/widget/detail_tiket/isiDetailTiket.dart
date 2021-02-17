import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:apts/view/pesantiket.dart';
import 'package:apts/widget/buttonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class BoxAppBarDetailTiket extends StatefulWidget {
  @override
  _BoxAppBarDetailTiketState createState() => _BoxAppBarDetailTiketState();
}

class _BoxAppBarDetailTiketState extends State<BoxAppBarDetailTiket> {
  String kode;

  getPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      kode = preferences.getString('kodePemesanan');
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

class BoxBodyDetailTiket extends StatefulWidget {
  @override
  _BoxBodyDetailTiketState createState() => _BoxBodyDetailTiketState();
}

class _BoxBodyDetailTiketState extends State<BoxBodyDetailTiket> {
  String idPesanan, kotaAsal, poolAsal, kotaTujuan, poolTujuan,
    tglBerangkat, jamBerangkat, jamTiba, namaPJ, namaArmada,
    noKursi, totalHarga, metodePembayaran, statusPembayaran,
    harga, statusUpload, uploadStatus, kodePemesanan,
    namaBank, pemilikRekening, noRekening, googleMaps;
  List listNamaUsia = List();
  bool isLoading = false;
  bool isLoading2 = false;

  @override
  void initState() {
    
    super.initState();
    getPref();    
  }

  getPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idPesanan = preferences.getString('idPesanan');
      kotaAsal = preferences.getString('kotaAsalTiket');
      kotaTujuan = preferences.getString('kotaTujuanTiket');
      poolAsal = preferences.getString('poolAsalTiket');
      poolTujuan = preferences.getString('poolTujuanTiket');
      tglBerangkat = preferences.getString('tglBerangkat');
      jamBerangkat = preferences.getString('jamBerangkatTiket');
      jamTiba = preferences.getString('jamTibaTiket');
      namaPJ = preferences.getString('namaPJTiket');
      namaArmada = preferences.getString('namaArmadaTiket');
      noKursi = preferences.getString('noKursi');
      harga = preferences.getString('hargaTiket');
      totalHarga = preferences.getString('hargaTotal');
      metodePembayaran = preferences.getString('metodePembayaran');
      statusPembayaran = preferences.getString('statusPembayaran');
      kodePemesanan = preferences.getString('kodePemesanan');      
      namaBank = preferences.getString('namaBankTiket');
      pemilikRekening = preferences.getString('pemilikRekeningTiket');
      noRekening = preferences.getString('noRekeningTiket');
      googleMaps = preferences.getString('googleMaps');
    });
    if (statusPembayaran=='Ditolak') {
      setState(() {
        statusUpload = null;
      });      
    } else {
      setState(() {
        statusUpload = preferences.getString(kodePemesanan);
      });      
    }
    final respon = await http.post("https://aptsweb.000webhostapp.com/data_android/namaUsia.php",
        body: {'id_pesanan': idPesanan});
    setState(() {
      listNamaUsia = json.decode(respon.body);
    });
    print(statusPembayaran);
    print(statusUpload);
    print(uploadStatus);    
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
                    _infoTiket("Harga Tiket", "Rp. $harga/kursi"),
                    _infoTiket("Biaya Admin", "-"),
                    Divider(thickness: 2),
                    _infoTiket('Total(x${listNamaUsia.length} Orang)', 'Rp. $totalHarga')
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
                        _infoPembayaran("Nama Bank", "$namaBank"),
                        SizedBox(height: 5),
                        _infoPembayaran("No. Rekening", "$noRekening"),
                        SizedBox(height: 5),
                        _infoPembayaran("Pemilik Rekening", "$pemilikRekening"),
                        Divider(thickness: 2),
                        _infoPembayaran(
                            "Jumlah dibayar", "Rp. $totalHarga"),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _rincianPembayaranTunai(context, teks) {
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
                            "Jumlah dibayar", "Rp. $totalHarga"),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void verif() async{    
    final newStatus = await Navigator.push(context, MaterialPageRoute(builder: (context)=>Transfer()));
    setState(() {            
      uploadStatus = newStatus;
    });
    if (newStatus!=null) {      
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(newStatus), 
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3)
        )
      );
      setState(() {
        statusPembayaran = 'Belum diverifikasi';
      });   
    }
  }

  /*
  hapusNamaUsia() async{
    var url = "https://aptsweb.000webhostapp.com/data_android/hapusNamaUsia.php";
    await http.post(url, body: {
      'id_pesanan': idPesanan,      
    });
  }

  hapusSisaKursi() async{
    var url = "https://aptsweb.000webhostapp.com/data_android/hapusSisaKursi.php";
    for (var i = 0; i < listNamaUsia.length; i++) {
      await http.post(url, body: {
        'id_pesanan': idPesanan,        
      });
    }
  }

  hapusKursiPesanan() async{
    var url = "https://aptsweb.000webhostapp.com/data_android/hapusKursiPesanan.php";
    await http.post(url, body: {
      'id_pesanan': idPesanan,      
    });
  }

  hapusKursiDipesan() async{
    var url = "https://aptsweb.000webhostapp.com/data_android/hapusKursiDipesan.php";
    await http.post(url, body: {
      'id_pesanan': idPesanan,      
    });
  }  

  hapusKursi() async{
    await hapusKursiPesanan().then((_) {
      hapusKursiDipesan();
    });
  }

  hapusNamaKursiSisa() async{
    await hapusNamaUsia();
    await hapusSisaKursi();
    await hapusKursi();
  }
  */

  hapusPesanan() async{
    var url = "https://aptsweb.000webhostapp.com/data_android/hapusPesanan.php";
    await http.post(url, body: {
      'id_pesanan': idPesanan,      
    });
  }

  hapus() async{
    try{      
      await hapusPesanan();
    }catch(e){
      print('Gagal: \n' + e.toString());
    }
    finally{
      setState(() {
        isLoading=false;
      });
      Navigator.of(context).pop("Tiket berhasil dibatalkan!");
    }        
  }  

  Widget pembayaran(){
    if (statusUpload != null || uploadStatus != null) {    
      return _detailTransaksi(context, "Detail Transaksi");        
    } else if (metodePembayaran=='Tunai') {
      return _rincianPembayaranTunai(context, "Rincian Pembayaran");
    }else{
      return _rincianPembayaran(context, "Rincian Pembayaran");
    }                 
  }

  Future<void> launchGoogleMaps(String url) async {
    if (await canLaunch(url)) {
      setState(() {
        isLoading2 = false;
      });      
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget btnBatalPesan(){
    if (metodePembayaran=='Bank Transfer' && statusUpload == null && uploadStatus == null) {
      return !isLoading
        ? BtnOval(
            label: 'Batalkan Pesanan',
            lebar: MediaQuery.of(context).size.width * 0.35,
            onPressed: () async{
              return showDialog(
                context: context,
                builder: (context) {
                  return new AlertDialog(
                    title: new Text('Pembatalan Tiket'),
                    content: new Text(
                        'Yakin ingin membatalkan tiket?',
                        style: TextStyle(color: Colors.grey[600])),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: new Text('Tidak',
                            style: TextStyle(color: Colors.grey[700])),
                      ),
                      new FlatButton(
                        onPressed: () async{
                          Navigator.of(context).pop();
                          setState(() {
                            isLoading=true;
                          });                          
                          await hapus();
                        },
                        child: new Text('Ya'),
                      ),
                    ],
                  );
                },
              );

              
            },
          )
        : Center(child:CircularProgressIndicator());
    } else {
        return !isLoading2
        ? BtnOval(
            label: 'Lihat lokasi keberangkatan',
            lebar: MediaQuery.of(context).size.width * 0.35,
            onPressed: () async{                         
              if (googleMaps.isNotEmpty) {
                setState(() {
                  isLoading2 = true;
                });
                await launchGoogleMaps(googleMaps); 
              } else {
                return;
              }                                                             
            },
          )
        : Center(child:CircularProgressIndicator());        
    }
  }

  Widget btnLokasi(){
    if (metodePembayaran == 'Tunai' && statusPembayaran=='Belum dibayar') {
      return !isLoading
        ? BtnOval(
            label: 'Batalkan Pesanan',
            lebar: MediaQuery.of(context).size.width * 0.35,
            onPressed: () async{                         
              return showDialog(
                context: context,
                builder: (context) {
                  return new AlertDialog(
                    title: new Text('Pembatalan Tiket'),
                    content: new Text(
                        'Yakin ingin membatalkan tiket?',
                        style: TextStyle(color: Colors.grey[600])),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: new Text('Tidak',
                            style: TextStyle(color: Colors.grey[700])),
                      ),
                      new FlatButton(
                        onPressed: () async{
                          Navigator.of(context).pop();
                          setState(() {
                            isLoading=true;
                          });                          
                          await hapus();
                        },
                        child: new Text('Ya'),
                      ),
                    ],
                  );
                },
              );
            },
          )
        : Center(child:CircularProgressIndicator());
    } else {      
        return Container();      
    }
  }
  
  @override
  Widget build(BuildContext context) {
    String teksButton;
    if (statusPembayaran=='Belum dibayar'&&metodePembayaran=='Bank Transfer') {
      teksButton = 'Saya Sudah Melakukan Pembayaran';
    }else if(statusPembayaran=='Ditolak'){
      teksButton = 'Saya Sudah Melakukan Pembayaran';
    }else{
      teksButton = 'Lihat lokasi keberangkatan';
    }
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            primary: false,
            padding: EdgeInsets.symmetric(vertical: 0),
            children: <Widget>[
              _infoShuttle(context, "Info Shuttle"),              
              SizedBox(
                height: 25,
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
                                itemCount: listNamaUsia.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: <Widget>[
                                      SizedBox(height: 5,),
                                      _infoPenumpang("${index+1}. ${listNamaUsia[index]['nama']}", "${listNamaUsia[index]['usia']} tahun")
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
              pembayaran(),              
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: btnBatalPesan()                
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: uploadStatus != null || statusUpload!=null || metodePembayaran=='Tunai'
                ? btnLokasi()
                : BtnOval(
                    label: teksButton,
                    lebar: MediaQuery.of(context).size.width * 0.35,
                    onPressed: () {
                      verif();
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
      teks1 == "No. Rekening" || teks1 == "Jumlah dibayar"
          ? SelectableText(teks2,
              style: TextStyle(
                  fontSize: 14,
                  //fontWeight: FontWeight.bold,
                  color: Colors.deepPurple))
          : Text(teks2,
              style: TextStyle(
                  fontSize: 14,
                  //fontWeight: FontWeight.bold,
                  color: Colors.grey[600]))
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