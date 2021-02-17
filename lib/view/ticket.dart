import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Ticket extends StatefulWidget {
  @override
  _TicketState createState() => _TicketState();
}

class _TicketState extends State<Ticket> {
  String idPenumpang;
  bool _disposed = false;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      idPenumpang = preferences.getString('id_penumpang');
    });
  }

  clearPref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
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
      getPref();
      clearPref();      
    }    
  }

  lihatTiket() async{ 
    String alertTiket;  
    final alertP = await Navigator.of(context).pushNamed('/detailtiket');    
    setState(() {      
      alertTiket = alertP;
    });    
    if (alertTiket!=null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(alertTiket), 
          backgroundColor: Colors.green, 
          duration: Duration(seconds: 3)
        )
      );     
    }        
  }  

  Future<List> getData() async {    
    final respon = await http.post("https://aptsweb.000webhostapp.com/data_android/tiket.php",
        body: {'id_penumpang': idPenumpang});
    var data;
    setState(() {
      data = json.decode(respon.body);
    });        
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Tiket'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: FutureBuilder<List>(
          future: getData(),          
          builder: (context, snapshot) {                       
            //load null data UI
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: CircularProgressIndicator());
            }
            //load empty data UI
            if (snapshot.data.isEmpty) {
              return Center(
                  child: Text(
                "Anda belum memesan tiket satupun",
                style: TextStyle(fontSize: 16),
              ));
            }
            if (snapshot.data.length == 0) {
              return Center(
                  child: Text(
                "Anda belum memesan tiket satupun",
                style: TextStyle(fontSize: 16),
              ));
            } 
            return ListView.builder(
              padding: EdgeInsets.only(top: 0),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return BoxTiket(data: snapshot.data, i: index, snackBar: this.lihatTiket);
              }
            );
          },
        ),
      ),
    );
  }
}

class BoxTiket extends StatefulWidget {
  final List data; final int i; final Function snackBar;

  const BoxTiket({Key key, this.data, this.i, this.snackBar}) : super(key: key);

  @override
  _BoxTiketState createState() => _BoxTiketState();
}

class _BoxTiketState extends State<BoxTiket> {
  double hargaDouble;
  var total, totalFix, f = NumberFormat('#,###,###');
  @override
  void initState() {
    
    super.initState();
    getPref();
  }

  getPref() async {    
    setState(() {     
      hargaDouble = double.parse(widget.data[widget.i]['harga']);
      total= hargaDouble*1000;
      totalFix = f.format(total);
    });
  }  

  savePref() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString('idPesanan', widget.data[widget.i]['id_pesanan']);
      preferences.setString('kodePemesanan', widget.data[widget.i]['kodePemesanan']);
      preferences.setString('tglBerangkat', widget.data[widget.i]['tglBerangkat']);
      preferences.setString('noKursi', widget.data[widget.i]['noKursi']);
      preferences.setString('hargaTotal', widget.data[widget.i]['totalPembayaran']);
      preferences.setString('metodePembayaran', widget.data[widget.i]['metodePembayaran']);
      preferences.setString('namaArmadaTiket', widget.data[widget.i]['namaArmada']);
      preferences.setString('namaPJTiket', widget.data[widget.i]['namaPJ']);
      preferences.setString('kotaAsalTiket', widget.data[widget.i]['kota']);
      preferences.setString('kotaTujuanTiket', widget.data[widget.i]['kotaTujuan']);
      preferences.setString('poolAsalTiket', widget.data[widget.i]['pool']);
      preferences.setString('poolTujuanTiket', widget.data[widget.i]['poolTujuan']);
      preferences.setString('jamBerangkatTiket', widget.data[widget.i]['jamBerangkat']);
      preferences.setString('jamTibaTiket', widget.data[widget.i]['jamTiba']);
      preferences.setString('hargaTiket', totalFix);
      preferences.setString('statusPembayaran', widget.data[widget.i]['statusPembayaran']);
      preferences.setString('namaBankTiket', widget.data[widget.i]['namaBank']);
      preferences.setString('noRekeningTiket', widget.data[widget.i]['noRekening']);
      preferences.setString('pemilikRekeningTiket', widget.data[widget.i]['pemilikRekening']);
      preferences.setString('googleMaps', widget.data[widget.i]['googleMaps']);
    });
  }

  Widget _tiket(context) {
    Color warnaBox, warnaText;
    if (widget.data[widget.i]['statusPembayaran'] == 'Belum dibayar') {
      warnaBox = Colors.yellow;
      warnaText = Colors.black;
    }else if(widget.data[widget.i]['statusPembayaran'] == 'Belum diverifikasi'){
      warnaBox = Colors.blue;
      warnaText = Colors.white;
    }else if(widget.data[widget.i]['statusPembayaran'] == 'Ditolak'){
      warnaBox = Colors.red;
      warnaText = Colors.white;
    }else{
      warnaBox = Colors.green;
      warnaText = Colors.white;
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(widget.data[widget.i]['kodePemesanan'],
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.bold)),
            //SizedBox(width: 110),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: warnaBox,
              ),
              padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
              child: Text(widget.data[widget.i]['statusPembayaran'],
                  style: TextStyle(color: warnaText, fontSize: 12)),
            )
          ],
        ),
        Divider(thickness: 2,color: Colors.grey,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(Icons.directions_bus, color: Colors.black, size: 25),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(widget.data[widget.i]['kota'],
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    SizedBox(width: 30),
                    Icon(Icons.arrow_forward_ios, color: Colors.black, size: 12),
                    SizedBox(width: 30),
                    Text(widget.data[widget.i]['kotaTujuan'],
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 5),
                Text(widget.data[widget.i]['tglBerangkat'],
                    style: TextStyle(fontSize: 14, color: Colors.black)),
              ],
            ),SizedBox(width: 10),
            Container(width: 15,)
          ],
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: InkWell(
          onTap: (){
            widget.snackBar();
            savePref();
          },
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 100,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _tiket(context),
              ],
            )
          ),
        ),
      ),
    );
  }
}