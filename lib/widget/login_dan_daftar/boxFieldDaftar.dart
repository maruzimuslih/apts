import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BoxFieldDaftar extends StatefulWidget {
  final String label;
  TextEditingController nama = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  BoxFieldDaftar({Key key, this.label, this.nama, this.email, this.password})
      : super(key: key);

  @override
  _BoxFieldDaftarState createState() => _BoxFieldDaftarState();
}

class _BoxFieldDaftarState extends State<BoxFieldDaftar> {
  bool lihat;
  @override
  void initState() {
    lihat = true;
    super.initState();
  }

  Widget _fieldNama(label) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.transparent,
          ),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey[100],
                ))),
                child: TextField(
                  controller: widget.nama,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: label,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fieldEmail(label) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.transparent,
          ),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey[100],
                ))),
                child: TextField(
                  keyboardType: TextInputType.emailAddress,
                  controller: widget.email,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: label,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _fieldPassword(label) {
    return Column(
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.transparent,
          ),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey[100],
                ))),
                child: TextField(
                  controller: widget.password,
                  obscureText: lihat,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(
                          lihat ? Icons.visibility_off : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () => setState(() => lihat = !lihat)),
                    border: InputBorder.none,
                    hintText: label,
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (widget.label == 'Nama')
            _fieldNama(widget.label)
          else if (widget.label == 'Email')
            _fieldEmail(widget.label)
          else
            _fieldPassword(widget.label)
        ],
      ),
    );
  }
}
