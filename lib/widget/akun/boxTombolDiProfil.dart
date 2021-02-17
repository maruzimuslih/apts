import 'package:flutter/material.dart';

class BoxHubungiKami extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed('/hubungikami');
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Container(
            //alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_hubungiKami()],
            )),
      ),
    );
  }
}

class BoxTentangKami extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.of(context).pushNamed('/tentangkami');
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Container(
            //alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_tentangKami()],
            )),
      ),
    );
  }
}

class BoxKeluar extends StatefulWidget {
  final VoidCallback logout;
  BoxKeluar({this.logout});
  @override
  _BoxKeluarState createState() => _BoxKeluarState();
}

class _BoxKeluarState extends State<BoxKeluar> {
  logout(){
    setState(() {
      widget.logout();
    });
    Navigator.of(context).pop();
  }
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        return showDialog(
          context: context,
          builder: (context) {
            return new AlertDialog(
              title: new Text('Keluar'),
              content: new Text(
                  'Yakin ingin keluar?',
                  style: TextStyle(color: Colors.grey[600])),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: new Text('Tidak',
                      style: TextStyle(color: Colors.grey[700])),
                ),
                new FlatButton(
                  onPressed: () {
                    logout();
                  },
                  child: new Text('Ya'),
                ),
              ],
            );
          },
        );                
      },
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
        child: Container(
            //alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 50,
            width: MediaQuery.of(context).size.width * 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[_btnKeluar()],
            )),
      ),
    );
  }
}

Widget _hubungiKami(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: "Hubungi Kami", style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold))
              ]
            ) 
          ),
          Icon(Icons.arrow_forward_ios,
                size: 15
                )
        ],
      ),
    ],
  );
}

Widget _tentangKami(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: "Tentang Kami", style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold))
              ]
            ) 
          ),
          Icon(Icons.arrow_forward_ios,
                size: 15
                )
        ],
      ),
    ],
  );
}

Widget _btnKeluar(){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RichText(
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(text: "Keluar", style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.bold))
              ]
            ) 
          ),
        ],
      ),
    ],
  );
}