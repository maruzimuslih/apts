import 'package:flutter/material.dart';
import 'package:apts/widget/detail_bantuan/isiBantuanTambahan.dart';
import 'package:apts/widget/detail_bantuan/isiDetailBantuan.dart';
import 'package:apts/widget/tampilanUmum.dart';

class DetailBantuan extends StatelessWidget {
  final String judul, deskripsi;

  const DetailBantuan({Key key, this.judul, this.deskripsi}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarDetailBantuan(judul: judul),
      boxBody: BoxBodyDetailBantuan(deskripsi: deskripsi),
    );
  }
}

class BantuanTambahan extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarBantuanTambahan(),
      boxBody: BoxBodyBantuanTambahan(),
    );
  }
}