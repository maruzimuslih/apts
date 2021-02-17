import 'package:flutter/material.dart';
import 'package:apts/widget/home/boxAsalTujuan.dart';
import 'package:apts/widget/home/boxJumlahPenumpang.dart';
import 'package:apts/widget/home/boxTanggalBerangkat.dart';
import 'package:apts/widget/buttonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String kotaAsal, kotaTujuan, tanggal, tgl;
  int jumlah;
  bool _disposed = false;
  bool isLoading = false;
  kotaDipilih(asal, tujuan){
    if (asal=="Pilih Kota Asal"||tujuan=="Pilih Kota Tujuan") {
      asal=null; tujuan=null;
    }
    setState(() {
      kotaAsal = asal;
      kotaTujuan = tujuan;
    });
  }

  cariTiket(){
    if (kotaAsal!=null||kotaTujuan!=null) {
      print(kotaAsal); print(kotaTujuan);
      if (kotaAsal==kotaTujuan) {
        setState(() {
          isLoading = false;
        });
        _scaffoldKey.currentState
          .showSnackBar(SnackBar(
            duration: Duration(seconds: 3),
            content: Text('Kota Asal dan Kota Tujuan tidak boleh sama!'),backgroundColor: Colors.red,));
      } else {
        setState(() {
          isLoading = false;
        });
        savePref();
        Navigator.of(context).pushNamed('/pilihpj');
      }
    }else{
      setState(() {
        isLoading = false;
      });
      _scaffoldKey.currentState
          .showSnackBar(SnackBar(
            duration: Duration(seconds: 3),
            content: Text('Pilih Kota Asal dan Kota Tujuan telebih dahulu!'),backgroundColor: Colors.red,));
    }
    print(tanggal);
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
   void setState(fn) {
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  void initState() {
    
    super.initState();
    if (!_disposed) {
      clearPref();
    }
  }

  savePref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString('kotaAsal', kotaAsal);
      preferences.setString('kotaTujuan', kotaTujuan);
      preferences.setInt('jumlah', jumlah);
      preferences.setString('tanggal', tanggal);
      preferences.setString('tgl', tgl);
    });
  }

  clearPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      preferences.remove('kotaAsal');
      preferences.remove('kotaTujuan');
      preferences.remove('jumlah');
      preferences.remove('tanggal');
      preferences.remove('tgl');
      preferences.remove('idPesanan');
      preferences.remove('kode');
      preferences.remove('kodePemesanan');
      preferences.remove('tglBerangkat');
      preferences.remove('noKursi');
      preferences.remove('hargaTotal');
      preferences.remove('metodePembayaran');
      preferences.remove('namaArmadaTiket');
      preferences.remove('namaPJTiket');
      preferences.remove('kotaAsalTiket');
      preferences.remove('kotaTujuanTiket');
      preferences.remove('poolAsalTiket');
      preferences.remove('poolTujuanTiket');
      preferences.remove('jamBerangkatTiket');
      preferences.remove('jamTibaTiket');
      preferences.remove('hargaTiket');
      preferences.remove('statusPembayaran');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: Text('APTS'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(20),
            //margin: EdgeInsets.all(20),
            child: Column(
              children: <Widget>[
                BoxAsalTujuan(kotaTerpilih: kotaDipilih),
                SizedBox(height: 5),
                BoxTanggalBerangkat(tanggal: this, tgl: this),
                SizedBox(height: 5),
                BoxJumlahPenumpang(jumlahP: this),
                SizedBox(height: 80),
                !isLoading
                  ? BtnOval(
                      label: "Cari Tiket",
                      lebar: MediaQuery.of(context).size.width * 0.85,
                      onPressed: () async{
                        setState(() {
                          isLoading = true;
                        });
                        await cariTiket();
                      },
                    )
                  : Center(child:CircularProgressIndicator())
              ],
            ),
          ),
        ),
      ),
    );
  }
}