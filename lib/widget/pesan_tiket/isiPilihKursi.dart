import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:apts/widget/buttonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoxAppBarKursi extends StatefulWidget {
  @override
  _BoxAppBarKursiState createState() => _BoxAppBarKursiState();
}

class _BoxAppBarKursiState extends State<BoxAppBarKursi> {
  String namaPJ, namaArmada, tanggal;

  getPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      namaPJ = preferences.getString('namaPJ');
      namaArmada = preferences.getString('namaArmada');
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
            Text("$namaPJ",
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
              child: Text("$namaArmada",
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
              child: Text("$tanggal",
                  style: TextStyle(color: Colors.white, fontSize: 12)),
            ),
          ],
        )
      ],
    );
  }
}

class BoxBodyKursi extends StatefulWidget {
  @override
  _BoxBodyKursiState createState() => _BoxBodyKursiState();
}

class _BoxBodyKursiState extends State<BoxBodyKursi> {
  List<int> jumlah = List(); 
  List<String> noKursiDipilih = List(); List<String> kursiDipesan=List();
  int kursi;
  double hargaDouble; var total;
  String harga, kursiData; 

  void onTapKursi(index) {
    setState(() {
      index=index+1;
      //buat nge set yg dipilih
      if (jumlah.contains(index)) {
        jumlah.remove(index);
      } else {
        jumlah.add(index);
      }
      setState(() {
        total = jumlah.length * hargaDouble * 1000;
        totalFix = f.format(total);
      });
    });
  }

  void sisaKursi(sisaKursi, kursiDipilih){
    setState(() {
      kursi = sisaKursi - kursiDipilih;
    });
  }

  void noKursiBooked(noKursi){
    if (noKursiDipilih.contains(noKursi)) {
      setState(() {
        noKursiDipilih.remove(noKursi);
      });
    }else{
      setState(() {
        noKursiDipilih.add(noKursi);
      });
    }
  }

  void bookedKursi(kursiArmada){
    if (kursiDipesan.contains(kursiArmada)) {
      setState(() {
        kursiDipesan.remove(kursiArmada);
      });
    }else{
      setState(() {
        kursiDipesan.add(kursiArmada);
      });
    } 
  }

  savePref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setStringList('kursiDipesan', kursiDipesan);
      preferences.setStringList('noKursiDipilih', noKursiDipilih);
      preferences.setInt('updateSisaKursi', kursi);
      preferences.setString('totalPembayaran', totalFix);
    });
    print(kursiDipesan);
    print(noKursiDipilih);
  }

  simpanDataKursi(){
    if (jumlah.length==0||jumlah.length==null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Pilih kursi terlebih dahulu!"), 
          backgroundColor: Colors.red, 
          duration: Duration(seconds: 3)
        )
      ); 
    } else {
      if (kursiDipesan.length!=0 || noKursiDipilih.length!=0) {
        savePref();
        Navigator.of(context).pushNamed('/verpesanan');
      } 
    }
  }

  getPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      harga = preferences.getString('harga');
      hargaDouble = double.parse(harga);
      total = 0 * hargaDouble * 1000;
      totalFix = f.format(total);    
    });
  }

  @override
  void initState() {
    
    super.initState();
    getPref();
  }

  var totalFix, f = NumberFormat('#,###,###');
  Widget _total() {    
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
      width: 270,
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "${jumlah.length} Kursi (No. ${jumlah.join(', ')})",
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 5),
          Text(
            "Total : Rp. $totalFix",
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _seatItem() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 230,
        height: 270,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Color(0xFFFf6f5fb),
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      border: Border.all(
                          color: Colors.black,
                          width: 2,
                          style: BorderStyle.solid)),
                  width: 70,
                  height: 40,
                  child: Text(
                    "Sopir",
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Kursi(
              onTapKursi: this.onTapKursi, 
              sisaKursi: this.sisaKursi, 
              noKursiBooked: this.noKursiBooked, 
              bookedKursi: this.bookedKursi
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Pilih Kursi", style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 30),
        Container(
          //height: 590,
          child: Column(
            children: <Widget>[
              _seatItem(),
              _total(),
              //SizedBox(height: 20),
              BtnOval(
                label: "Selesai",
                lebar: MediaQuery.of(context).size.width,
                onPressed: simpanDataKursi,
              )
            ],
          ),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class Kursi extends StatefulWidget {
  Function onTapKursi, sisaKursi, noKursiBooked, bookedKursi;
  Kursi({this.onTapKursi, this.sisaKursi, this.bookedKursi, this.noKursiBooked});

  @override
  _KursiState createState() => _KursiState();
}

class _KursiState extends State<Kursi> {
  
  List<String> _listKursi = List();
  List idKursi = List();
  List<int> _selectedIndexList = List();
  String kapasitas, namaPJ, sisaKursi, idArmada; 
  int kapasitasInt, idArmadaInt, jumlahPenumpang, sisaKursiInt, kursi;

  getPref()async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idArmada = preferences.getString('id_armada');
      kapasitas = preferences.getString('kursi');
      sisaKursi = preferences.getString('sisaKursi');
      namaPJ = preferences.getString('namaPJ');
      jumlahPenumpang = preferences.getInt('jumlah');
      idArmadaInt = int.parse(idArmada);
      kapasitasInt = int.parse(kapasitas);
      sisaKursiInt = int.parse(sisaKursi);
      for (var i = 1; i <= kapasitasInt; i++) {
       _listKursi.add(i.toString());
      }
      
    });
    final respon = await http.post("https://aptsweb.000webhostapp.com/data_android/kursi.php",
        body: {'id_armada': idArmada});
    setState(() {
      idKursi = json.decode(respon.body);
    });
    
  }

  @override
  void initState() {
    getPref();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StaggeredGridView.countBuilder(
        padding: EdgeInsets.only(top: 0, bottom: 0),
        crossAxisSpacing: 70,
        mainAxisSpacing: 7,
        crossAxisCount: 2,
        itemCount: idKursi.length,
        staggeredTileBuilder: (int index) => StaggeredTile.fit(1),
        itemBuilder: (BuildContext context, int index) {
          Color warna;
          if (idKursi[index]['dipesan']=='tidak') {
            if (_selectedIndexList.contains(index)) {
              warna = Colors.purple;
            }else {
              warna = Color(0xFFFf6f5fb);
            }
          }else if(idKursi[index]['dipesan']=='ya'){
            if (_selectedIndexList.contains(index)) {
              warna = Colors.purple;
            } else {
              warna = Colors.grey;
            }
          }
          return GridTile(
            child: InkWell(
              child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: warna,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    border: Border.all(
                        color: Colors.black,
                        width: 2,
                        style: BorderStyle.solid)),
                height: 30,
                width: 30,
                child: Text(
                  //buat nampilin pilihan kursi(nomor-nomornya)
                  _listKursi[index],
                ),
              ),
              onTap: () {
                if (idKursi[index]['dipesan']=='tidak') {
                  if (_selectedIndexList.length < jumlahPenumpang || _selectedIndexList.contains(index) ) {
                    setState(() {
                    //buat nge set yg dipilih
                        _selectedIndexList.add(index);
                        idKursi[index]['dipesan']='ya';
                    });
                    this.widget.onTapKursi(index);
                    this.widget.sisaKursi(sisaKursiInt, _selectedIndexList.length);
                    this.widget.noKursiBooked(_listKursi[index]);
                    this.widget.bookedKursi(idKursi[index]['id_kursi']);
                  }else{ 
                    return null;
                  }//print(idKursi);
                  //print(armada.bookedKursi);
                }else{
                  if (_selectedIndexList.contains(index)) {
                    setState(() {
                      _selectedIndexList.remove(index);
                      idKursi[index]['dipesan']='tidak';
                    });
                    this.widget.onTapKursi(index);
                    this.widget.sisaKursi(sisaKursiInt, _selectedIndexList.length);
                    this.widget.noKursiBooked(_listKursi[index]);
                    this.widget.bookedKursi(idKursi[index]['id_kursi']);
                    //print(idKursi);
                    //print(armada.bookedKursi);
                  }
                  return null;
                }
                
                //this.widget.bookedKursi(armada.bookedKursi);
              },
            ),
          );
        },
      ),
    );
  }
}