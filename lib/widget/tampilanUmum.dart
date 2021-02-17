import 'package:flutter/material.dart';

class TampilanUmum extends StatelessWidget {
  final Widget boxAppBar;
  final Widget boxBody;

  const TampilanUmum({Key key, this.boxAppBar, this.boxBody}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SafeArea(
              top: false,
              bottom: false,
              child: Stack(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 50),
                    color: Colors.deepPurple,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: boxAppBar
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                      decoration: BoxDecoration(
                          color: Color(0xFFFf6f5fb),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.85,
                      child: boxBody
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}