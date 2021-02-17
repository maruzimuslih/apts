import 'package:flutter/material.dart';

class BoxAsalTujuan extends StatelessWidget {
  final Function kotaTerpilih;
  BoxAsalTujuan({Key key, @required this.kotaTerpilih}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: 150,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  _iconTujuan(),
                  SizedBox(
                    width: 17,
                  ),
                  AsalDanTujuan(kota: kotaTerpilih),
                ],
              ),
            ],
          )),
    );
  }
}

class AsalDanTujuan extends StatefulWidget {
  final Function kota;
  AsalDanTujuan({this.kota});
  @override
  _AsalDanTujuanState createState() => _AsalDanTujuanState();
}

class _AsalDanTujuanState extends State<AsalDanTujuan> {
  var kotaAsal, kotaTujuan, temp, kotaAsalDipilih, kotaTujuanDipilih;

  @override
  void initState() {
    
    super.initState();
    kotaAsalDipilih = "Pilih Kota Asal";
    kotaTujuanDipilih = "Pilih Kota Tujuan";
  }
  
  @override
  void setState(fn) {
    
    super.setState(fn);
    widget.kota(kotaAsalDipilih.toString(), kotaTujuanDipilih.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              onTap: () async {
                kotaAsal = await Navigator.of(context).pushNamed('/pilihasal');
                setState(() {
                  kotaAsalDipilih = kotaAsal??kotaAsalDipilih;
                });
              },
              child: Container(
                alignment: Alignment.topLeft,
                width: 168,
                height: 50,
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Asal \n",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  TextSpan(
                      text: kotaAsalDipilih,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold)),
                ])),
              ),
            ),
            Container(
              height: 2,
              width: 168,
              color: Colors.grey,
            ),
            InkWell(
              onTap: () async {
                kotaTujuan = await Navigator.of(context).pushNamed('/pilihtujuan');
                setState(() {
                  kotaTujuanDipilih = kotaTujuan??kotaTujuanDipilih;
                });
              },
              child: Container(
                alignment: Alignment.bottomLeft,
                width: 168,
                height: 50,
                child: RichText(
                    text: TextSpan(children: <TextSpan>[
                  TextSpan(
                      text: "Tujuan \n",
                      style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  TextSpan(
                      text: kotaTujuanDipilih,
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold)),
                ])),
              ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            IconButton(
                onPressed: () {
                  if(kotaAsalDipilih!="Pilih Kota Asal"&&kotaTujuanDipilih!="Pilih Kota Tujuan"){
                    setState(() {
                    temp = kotaAsalDipilih;
                    kotaAsalDipilih = kotaTujuanDipilih;
                    kotaTujuanDipilih = temp;
                  });
                  }
                },
                icon:
                    Icon(Icons.swap_vert, size: 25, color: Colors.deepPurple)),
          ],
        ),
      ],
    );
  }
}

Widget _iconTujuan() {
  return Container(
    child: Column(
      children: <Widget>[
        Icon(
          Icons.airport_shuttle,
          color: Colors.indigo,
          size: 23,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Colors.indigo,
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Colors.indigo,
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Colors.indigo,
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Colors.purple,
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Colors.purple,
          size: 9,
        ),
        Icon(
          Icons.fiber_manual_record,
          color: Colors.purple,
          size: 9,
        ),
        Icon(
          Icons.location_on,
          color: Colors.purple,
          size: 23,
        ),
      ],
    ),
  );
}
