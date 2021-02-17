import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BoxFieldLupaPass extends StatelessWidget {
  final String label;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  BoxFieldLupaPass({Key key, this.label, this.email, this.password}) : super(key: key);
  

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
                  controller: email,
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _fieldEmail(label)
        ],
      ),
    );
  }
}