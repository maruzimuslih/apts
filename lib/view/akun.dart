import 'package:flutter/material.dart';
import 'package:apts/widget/akun/boxProfil.dart';
import 'package:apts/widget/akun/boxTombolDiProfil.dart';

class Akun extends StatelessWidget {
  
  final VoidCallback logout;
  Akun({this.logout});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(        
        title: Text('Akun'),
        backgroundColor: Colors.deepPurple,
      ),
          body: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    BoxProfil(),
                    SizedBox(height: 10),
                    BoxHubungiKami(),
                    BoxTentangKami(),
                    BoxKeluar(logout: this.logout)
                  ],
                ),
              ),
            ),
          ),
    );
  }
}