import 'package:flutter/material.dart';
import 'package:apts/widget/detail_tiket/isiDetailTiket.dart';
import 'package:apts/widget/tampilanUmum.dart';

class DetailTiket extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarDetailTiket(),
      boxBody: BoxBodyDetailTiket(),
    );
  }
}