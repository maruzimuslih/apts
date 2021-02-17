import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:apts/view/home.dart';

class BoxTanggalBerangkat extends StatelessWidget {
  final HomeState tanggal, tgl;
  BoxTanggalBerangkat({this.tanggal, this.tgl});
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(right: 20, left: 30),
          height: 70,
          width: MediaQuery.of(context).size.width * 0.85,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                      text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: "Tanggal",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]))
                  ])),
                  SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(Icons.calendar_today,
                          color: Colors.grey[600], size: 23),
                      SizedBox(width: 10),
                      PilihTanggal(tgl: tanggal, tanggal: tgl,)
                    ],
                  )
                ],
              )
            ],
          )),
    );
  }
}

class PilihTanggal extends StatefulWidget {
  final HomeState tgl, tanggal;
  PilihTanggal({this.tgl, this.tanggal});
  @override
  _PilihTanggalState createState() => _PilihTanggalState();
}

class _PilihTanggalState extends State<PilihTanggal> {
  DateTime selectedDate;
  String formatedDate, dateFormat;

  @override
  void initState() {
    
    super.initState();
    setState(() {
      selectedDate = DateTime.now();
    }); 
  }

  @override
  void setState(fn) {
    
    super.setState(fn);
    formatedDate = DateFormat('EEEE, d MMM yyyy').format(selectedDate);
    dateFormat = DateFormat('yMd').format(selectedDate);
    this.widget.tgl.tanggal = formatedDate;
    this.widget.tanggal.tgl = dateFormat;
  }

  @override
  Widget build(BuildContext context) {
    void _selectDate(BuildContext context) async {
      final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101)
      );
      if (picked != null && picked != selectedDate) {
        setState(() {
          selectedDate = picked;
        });
      }
    }
    return Container(
      child: InkWell(
          onTap: () => _selectDate(context),
          child: Text("$formatedDate",
              style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold))),
    );
  }
}
