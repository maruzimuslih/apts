import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:apts/view/lihatprofil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoxAppBarDetailAkun extends StatelessWidget {
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
            Flexible(
              child: Text('Detail Akun',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }
}

class BoxBodyDetailAkun extends StatefulWidget {
  //final List profil;
  //BoxBodyDetailAkun({this.profil});

  @override
  _BoxBodyDetailAkunState createState() => _BoxBodyDetailAkunState();
}

class _BoxBodyDetailAkunState extends State<BoxBodyDetailAkun> {
  String email = "";

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      email = preferences.getString("email");
    });
  }

  @override
  void initState() {
    
    super.initState();
    getPref();
  }

  Future<List> getData() async {
    var data;
    final respon = await http.post("https://aptsweb.000webhostapp.com/data_android/penumpang.php",
        body: {'email': email});
    setState(() {
      data = json.decode(respon.body);
    });
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
            child: FutureBuilder<List>(
                future: getData(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  return snapshot.hasData
                      ? Profil(profil: snapshot.data)
                      : Center(
                          child: CircularProgressIndicator(),
                        );
                })),
      ],
    );
  }
}

class Profil extends StatefulWidget {
  final List profil;
  Profil({this.profil});

  @override
  _ProfilState createState() => _ProfilState();
}

class _ProfilState extends State<Profil> {
  String alertProfil, alertPassword;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(vertical: 0),
      children: <Widget>[
        _info(
            context,
            "Informasi Pribadi",
            'Nama Lengkap',
            this.widget.profil[0]['namaPenumpang']==null?"":this.widget.profil[0]['namaPenumpang'],
            'Jenis Kelamin',
            this.widget.profil[0]['jenisKelamin']==null?"":this.widget.profil[0]['jenisKelamin'],
            'Usia',
            this.widget.profil[0]['usia']==null?"":this.widget.profil[0]['usia']),
        SizedBox(
          height: 15,
        ),
        _info(
            context,
            "Informasi Akun",
            "Alamat Email",
            this.widget.profil[0]['email'],
            'Nomor Telepon',
            this.widget.profil[0]['noHP']==null?"":this.widget.profil[0]['noHP'],
            null,
            null),
        SizedBox(
          height: 15,
        ),
      ],
    );
  }

  void ubahProfil() async{    
    final alertP = await Navigator.of(context).push(MaterialPageRoute(
                builder: (BuildContext context) => UbahProfil(
                      profil: this.widget.profil,
                    )));
    setState(() {      
      alertProfil = alertP;
    });
    if (alertProfil!=null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(alertProfil), 
          backgroundColor: Colors.green, 
          duration: Duration(seconds: 3)
        )
      );     
    }
  }

  Widget _judul(context, teks, teks1) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(teks, style: TextStyle(fontSize: 16)),
        InkWell(
            onTap: () {
              ubahProfil();
            },
            child: Container(
              alignment: Alignment.center,
              height: 15,
              width: 30,
              child: Text(teks1,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple)),
            ))
      ],
    );
  }

  void ubahPassword(sandi) async{    
    final alertPass = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => GantiPassword(
                        sandi: sandi,
                      )));
    setState(() {      
      alertPassword = alertPass;
    });
    if (alertPassword!=null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(alertPassword), 
          backgroundColor: Colors.green, 
          duration: Duration(seconds: 3)
        )
      );     
    }
  }

  Widget _boxTombol(context, sandi) {
    return InkWell(
      onTap: () {
        ubahPassword(sandi);
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Container(
            //alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RichText(
                            text: TextSpan(children: <TextSpan>[
                          TextSpan(
                              text: "Ganti Kata Sandi",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold))
                        ])),
                        Icon(Icons.arrow_forward_ios, size: 15)
                      ],
                    ),
                  ],
                )
              ],
            )),
      ),
    );
  }

  Widget _info(context, teks, teks1, teks2, teks3, teks4, teks5, teks6) {
    return Column(
      children: <Widget>[
        teks == 'Informasi Pribadi'
            ? _judul(context, teks, 'Ubah')
            : _judul(context, teks, ''),
        SizedBox(height: 7),
        _boxInfo(context, teks1, teks2),
        _boxInfo(context, teks3, teks4),
        teks == 'Informasi Akun'
            ? _boxTombol(context, this.widget.profil)
            : _boxInfo(context, teks5, teks6),
      ],
    );
  }
}



Widget _boxInfo(context, teks1, teks2) {
  return Container(
    child: Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          height: 50,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _infoProfil(teks1, teks2),
            ],
          )),
    ),
  );
}

Widget _infoProfil(teks1, teks2) {
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
