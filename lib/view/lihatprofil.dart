import 'package:flutter/material.dart';
import 'package:apts/widget/lihat_profil/isiDetailAkun.dart';
import 'package:apts/widget/lihat_profil/isiGantiPassword.dart';
import 'package:apts/widget/lihat_profil/isiUbahProfil.dart';
import 'package:apts/widget/tampilanUmum.dart';

class DetailAkun extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarDetailAkun(),
      boxBody: BoxBodyDetailAkun(),
    );
  }
}

class UbahProfil extends StatelessWidget {
  final List profil;
  UbahProfil({this.profil});

  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarUbahProfil(),
      boxBody: BoxBodyUbahProfil(profil: this.profil),
    );
  }
}

class GantiPassword extends StatelessWidget {
  final List sandi;
  GantiPassword({this.sandi});
  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarGantiPassword(),
      boxBody: BoxBodyGantiPassword(sandi: this.sandi),
    );
  }
}