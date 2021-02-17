import 'package:flutter/material.dart';

class BoxAppBarHubungiKami extends StatelessWidget {
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
              child: Text('Hubungi Kami',
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

class BoxBodyHubungiKami extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 0),
            children: <Widget>[
              _info(context, "Layanan Pelanggan", 'Nomor Telepon',
                  '0231-451234', 'Email', 'admin@email.com'),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _judul(context, teks) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(teks, style: TextStyle(fontSize: 16)),
    ],
  );
}

Widget _info(
    context, teks, teks1, teks2, teks3, teks4) {
  return Column(
    children: <Widget>[
      _judul(context, teks),
      SizedBox(height: 20),
      _boxInfo(context, teks1, teks2),
      _boxInfo(context, teks3, teks4),
    ],
  );
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
              _infoPelanggan(teks1, teks2),
            ],
          )),
    ),
  );
}

Widget _infoPelanggan(teks1, teks2) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(teks1, style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold)),
      Text(teks2, style: TextStyle(fontSize: 14, color: Colors.grey[600]))
    ],
  );
}