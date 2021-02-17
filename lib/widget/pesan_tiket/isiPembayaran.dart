import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoxAppBarPembayaran extends StatefulWidget {
  @override
  _BoxAppBarPembayaranState createState() => _BoxAppBarPembayaranState();
}

class _BoxAppBarPembayaranState extends State<BoxAppBarPembayaran> {
  String kode;

  getPref() async {
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
                return showDialog(
                  context: context,
                  builder: (context) {
                    return new AlertDialog(
                      title: new Text('Pembatalan Pemesanan'),
                      content: new Text(
                          'Apakah anda yakin ingin membatalkan pemesanan ini?',
                          style: TextStyle(color: Colors.grey[600])),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: new Text('Tidak',
                              style: TextStyle(color: Colors.grey[700])),
                        ),
                        new FlatButton(
                          onPressed: () => Navigator.of(context).popUntil(ModalRoute.withName('/')),
                          child: new Text('Ya'),
                        ),
                      ],
                    );
                  },
                );
              },
              child:
                  Icon(Icons.keyboard_backspace, color: Colors.white, size: 21),
            ),
            SizedBox(width: 20),
            Text("Pembayaran",
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
              child: Text("Kode Pemesanan\n$kode",
                  style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ],
        )
      ],
    );
  }
}

class BoxBodyPembayaran extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Pilih Metode Pembayaran", style: TextStyle(fontSize: 16)),
          ],
        ),
        SizedBox(height: 30),
        Expanded(
          child: Container(
            height: 590,
            child: ListView(
              primary: false,
              padding: EdgeInsets.symmetric(vertical: 0),
              children: <Widget>[
                _metode(context, "Bank Transfer"),
                _metode(context, "Tunai"),
              ],
            ),
          ),
        )
      ],
    );
  }
}

Widget _metode(context, teks) {
  return InkWell(
    onTap: () {
      teks == 'Bank Transfer'
          ? Navigator.of(context).pushNamed(
              '/rincitransfer')
          : Navigator.of(context)
              .pushNamed('/tunai');
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        width: 500,
        height: 50,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(14))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              teks,
              style: TextStyle(fontSize: 16),
            )
          ],
        ),
      ),
    ),
  );
}
