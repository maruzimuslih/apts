import 'package:flutter/material.dart';

class BtnOval extends StatelessWidget {

  final String label;
  final double lebar;
  final double tinggi;
  
  final Function onPressed;

  BtnOval({Key key, this.label, this.lebar, this.onPressed, this.tinggi}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: tinggi??50,
      width: lebar,
      child: Container(
        child: MaterialButton(
          onPressed: onPressed,
          color: Colors.purple,
          elevation: 7.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              this.label,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        )
      )
    );
  }
}