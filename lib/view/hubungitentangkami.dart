import 'package:flutter/material.dart';
import 'package:apts/widget/hubungi_tentang_kami/isiHubungiKami.dart';
import 'package:apts/widget/hubungi_tentang_kami/isiTentangKami.dart';
import 'package:apts/widget/tampilanUmum.dart';

class HubungiKami extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarHubungiKami(),
      boxBody: BoxBodyHubungiKami(),
    );
  }
}

class TentangKami extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TampilanUmum(
      boxAppBar: BoxAppBarTentangKami(),
      boxBody: BoxBodyTentangKami(),
    );
  }
}