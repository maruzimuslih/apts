import 'package:flutter/material.dart';
import 'package:apts/widget/pesan_tiket/isiKonfirmasi.dart';
import 'package:apts/widget/pesan_tiket/isiKonfirmasiTunai.dart';
import 'package:apts/widget/pesan_tiket/isiPembayaran.dart';
import 'package:apts/widget/pesan_tiket/isiPilihKursi.dart';
import 'package:apts/widget/pesan_tiket/isiPilihPJ.dart';
import 'package:apts/widget/pesan_tiket/isiRincianTransfer.dart';
import 'package:apts/widget/pesan_tiket/isiTransfer.dart';
import 'package:apts/widget/pesan_tiket/isiTunai.dart';
import 'package:apts/widget/pesan_tiket/isiVerPesanan.dart';
import 'package:apts/widget/tampilanUmum.dart';

class PilihPJ extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return //Text('Coba');
    TampilanUmum(
      boxAppBar: BoxAppBarPJ(),
      boxBody: BoxBodyPJ(),
    );
  }
}

class PilihKursi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarKursi(),
      boxBody: BoxBodyKursi(),
    );
  }
}

class VerifPemesanan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarVerPesanan(),
      boxBody: BoxBodyVerPesanan(),
    );
  }
}

class Pembayaran extends StatefulWidget {
  @override
  _PembayaranState createState() => _PembayaranState();
}

class _PembayaranState extends State<Pembayaran> {

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context){
        return new AlertDialog(
          title: new Text('Pembatalan Pemesanan'),
          content: new Text('Apakah anda yakin ingin membatalkan pemesanan ini?',
            style: TextStyle(color: Colors.grey[600])
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('Tidak',
                style: TextStyle(color: Colors.grey[700])
              ),
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: new Text('Ya'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: TampilanUmum(
        boxAppBar: BoxAppBarPembayaran(),
        boxBody: BoxBodyPembayaran(),
      ),
    );
  }
}

class RincianTransfer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarRincianTransfer(),
      boxBody: BoxBodyRincianTransfer(),
    );
  }
}

class Transfer extends StatefulWidget {
  @override
  _TransferState createState() => _TransferState();
}

class _TransferState extends State<Transfer> {
  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context){
        return new AlertDialog(
          title: new Text('Verifikasi Pembayaran'),
          content: new Text('Apakah anda yakin ingin melanjutkannya nanti?',
            style: TextStyle(color: Colors.grey[600])
          ),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('Tidak',
                style: TextStyle(color: Colors.grey[700])
              ),
            ),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: new Text('Ya'),
            ),
          ],
        );
      },
    ) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: TampilanUmum(
        boxAppBar: BoxAppBarTransfer(),
        boxBody: BoxBodyTransfer(),
      ),
    );
  }
}

class Tunai extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarTunai(),
      boxBody: BoxBodyTunai(),
    );
  }
}

class Konfirmasi extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarKonfirmasi(),
      boxBody: BoxBodyKonfirmasi(),
    );
  }
}

class KonfirmasiTunai extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarKonfirmasiTunai(),
      boxBody: BoxBodyKonfirmasiTunai(),
    );
  }
}