import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BoxField extends StatefulWidget {
  String label;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  BoxField({Key key, this.label, this.email, this.password}) : super(key: key);

  @override
  _BoxFieldState createState() => _BoxFieldState();
}

class _BoxFieldState extends State<BoxField> {
  bool lihat;
  @override
  void initState() {
    lihat = true;
    super.initState();
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
                child: TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: widget.email,
                  //onSaved: (e)=>widget.email = e,
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
                child: TextFormField(
                  controller: widget.password,
                  //onSaved: (e)=>widget.password = e,
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
          widget.label == 'Email'
              ? _fieldEmail(widget.label)
              : _fieldPassword(widget.label)
        ],
      ),
    );
  }
}
