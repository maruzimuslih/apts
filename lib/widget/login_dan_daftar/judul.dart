import 'package:flutter/material.dart';

class Judul extends StatelessWidget {
  final String teks1;
  final String teks2;

  const Judul({Key key, this.teks1, this.teks2}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _judul(teks1, teks2),
        ],
      ),
    );
  }
}

Widget _judul(teks1, teks2){
  return Padding(
    padding: const EdgeInsets.only(bottom: 50, left: 8, right: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(teks1,
            style: TextStyle(
                fontSize: 35, color: Colors.white, fontWeight: FontWeight.bold)),
        Text(teks2,
            style: TextStyle(
                fontSize: 20, color: Colors.white, )),   
      ],
    ),
  );
}