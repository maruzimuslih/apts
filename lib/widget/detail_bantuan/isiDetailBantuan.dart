import 'package:flutter/material.dart';

class BoxAppBarDetailBantuan extends StatelessWidget {
  final String judul;
  const BoxAppBarDetailBantuan({Key key, this.judul}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      //crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child:
                  Icon(Icons.keyboard_backspace, color: Colors.white, size: 21),
            ),
            SizedBox(width: 20),
            Flexible(
              child: Text(judul,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ],
    );
  }
}

class BoxBodyDetailBantuan extends StatefulWidget {
  final String deskripsi;

  const BoxBodyDetailBantuan({Key key, this.deskripsi}) : super(key: key);

  @override
  _BoxBodyDetailBantuanState createState() => _BoxBodyDetailBantuanState();
}

class _BoxBodyDetailBantuanState extends State<BoxBodyDetailBantuan> {
  
  void ajukanPertanyaan() async{  
    var alertPesan;  
    final pesan = await Navigator.of(context).pushNamed('/bantuantambahan');
    setState(() {      
      alertPesan = pesan;
    });
    if (alertPesan!=null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(alertPesan), 
          backgroundColor: Colors.green, 
          duration: Duration(seconds: 3)
        )
      );     
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          //height: 590,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(15),
                  constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                      minWidth: MediaQuery.of(context).size.width),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(14))),
                  child: Text(widget.deskripsi,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 50),
        Container(
          padding: EdgeInsets.only(top: 30),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Punya pertanyaan lain?",
                  style: TextStyle(
                    color: Colors.black,
                  )),
              SizedBox(width: 5),
              InkWell(
                  onTap: () {
                    ajukanPertanyaan();
                  },
                  child: Text(
                    "Ajukan pertanyaan",
                    style: TextStyle(
                      color: Colors.deepPurple,
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }
}
