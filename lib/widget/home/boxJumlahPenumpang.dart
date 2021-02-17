import 'package:flutter/material.dart';
import 'package:apts/view/home.dart';

class BoxJumlahPenumpang extends StatelessWidget {
  final HomeState jumlahP;
  BoxJumlahPenumpang({Key key, @required this.jumlahP}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10)
      ),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(right: 20, left: 30),
        height: 70,
        width: MediaQuery.of(context).size.width * 0.85,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            JumlahPenumpang(jmlh: jumlahP)
          ],
        )
      ),
    );
  }
}

class JumlahPenumpang extends StatefulWidget {
  final HomeState jmlh;
  JumlahPenumpang({this.jmlh});
  @override
  _JumlahPenumpangState createState() => _JumlahPenumpangState();
}

class _JumlahPenumpangState extends State<JumlahPenumpang> {
  int penumpang;

  @override
  void initState() {
    
    super.initState();
    setState(() {
      penumpang = 1;
    });
  }

  void _increment(){
    setState(() {
      if (penumpang <4) {
        penumpang++;
      } else {
        penumpang = 4;
      }      
    });
  }
  void _decrement(){
    setState(() {
      if (penumpang > 1) {
        penumpang--;
      } else {
        penumpang = 1;
      }      
    });
  }

  @override
  void setState(fn) {
    
    super.setState(fn);
    this.widget.jmlh.jumlah = penumpang;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      RichText(
        text: TextSpan(
          children: <TextSpan>[
            TextSpan(text: "Jumlah Penumpang", style: TextStyle(fontSize: 12, color: Colors.grey[600]))
          ]
        ) 
      ),
      SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
        Icon(Icons.person,
          color: Colors.grey[600],
          size: 23
        ),
        SizedBox(width: 10),
        Text("$penumpang Orang", style: TextStyle(fontSize: 14, color: Colors.deepPurple, fontWeight: FontWeight.bold)
            ),
        SizedBox(width: 120),
        InkWell(
          onTap: (){
            _increment();
          },
          child: Icon(Icons.add,
            color: Colors.deepPurple,
            size: 20
          ),
        ),
        SizedBox(width: 5),
        InkWell(
          onTap: (){
            _decrement();
          },
          child: Icon(Icons.remove,
            color: Colors.deepPurple,
            size: 20
          ),
        ),
        ],
      ),
    ],
  );
  }
}