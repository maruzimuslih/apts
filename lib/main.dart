import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:apts/view/daftarakun.dart';
import 'package:apts/view/dashboard.dart';
import 'package:apts/view/detailbantuan.dart';
import 'package:apts/view/detailtiket.dart';
import 'package:apts/view/hubungitentangkami.dart';
import 'package:apts/view/lihatprofil.dart';
import 'package:apts/view/login.dart';
import 'package:apts/view/lupapassword.dart';
import 'package:apts/view/pesantiket.dart';
import 'package:apts/view/pilihasal.dart';
import 'package:apts/view/pilihtujuan.dart';
import 'package:apts/view/ticket.dart';
void main() {WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
    .then((_) {
      runApp(new MyApp());
    });} 

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APTS',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: HalamanLogin(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/login': (BuildContext context)=> new HalamanLogin(),
        '/lupapassword': (BuildContext context)=> new LupaPassword(),
        '/daftar': (BuildContext context)=> new DaftarAkun(),
        '/dashboard': (BuildContext context)=> new Dashboard(),
        '/tiket': (BuildContext context)=> new Ticket(),
        '/pilihasal': (BuildContext context)=> new PilihKotaAsal(),
        '/pilihtujuan': (BuildContext context)=> new PilihKotaTujuan(),
        '/pilihpj': (BuildContext context)=> new PilihPJ(),
        '/pilihkursi': (BuildContext context)=> new PilihKursi(),
        '/verpesanan': (BuildContext context)=> new VerifPemesanan(),
        '/pembayaran': (BuildContext context)=> new Pembayaran(),
        '/rincitransfer': (BuildContext context)=> new RincianTransfer(),
        '/banktransfer': (BuildContext context)=> new Transfer(),
        '/konfirmasi': (BuildContext context)=> new Konfirmasi(),
        '/konfirmasiTunai': (BuildContext context)=> new KonfirmasiTunai(),
        '/tunai': (BuildContext context)=> new Tunai(),
        '/detailtiket': (BuildContext context)=> new DetailTiket(),
        '/bantuantambahan': (BuildContext context)=> new BantuanTambahan(),
        '/detailakun': (BuildContext context)=> new DetailAkun(),
        '/ubahprofil': (BuildContext context)=> new UbahProfil(),
        '/gantipassword': (BuildContext context)=> new GantiPassword(),
        '/hubungikami': (BuildContext context)=> new HubungiKami(),
        '/tentangkami': (BuildContext context)=> new TentangKami(),
      }
    );
  }
}