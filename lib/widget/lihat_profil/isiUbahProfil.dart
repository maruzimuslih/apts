import 'package:flutter/material.dart';
import 'package:apts/widget/buttonWidget.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BoxAppBarUbahProfil extends StatelessWidget {
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
              child: Text('Ubah Profil',
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

class BoxBodyUbahProfil extends StatefulWidget {
  final List profil;
  BoxBodyUbahProfil({this.profil});

  @override
  _BoxBodyUbahProfilState createState() => _BoxBodyUbahProfilState();
}

class _BoxBodyUbahProfilState extends State<BoxBodyUbahProfil> {
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerJK = TextEditingController();
  TextEditingController controllerUsia = TextEditingController();
  TextEditingController controllerNoHP = TextEditingController();
  bool isLoading = false;

  editData() async{
    var url = "https://aptsweb.000webhostapp.com/data_android/ubahPenumpang.php";
    await http.post(url, body: {
      'id_penumpang' : widget.profil[0]['id_penumpang'],
      'namaPenumpang' : controllerNama.text,
      'jenisKelamin' : controllerJK.text,
      'usia' : controllerUsia.text,
      'noHP' : controllerNoHP.text,
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString("noHP", controllerNoHP.text);
      isLoading = false;
    });
    Navigator.of(context).pop("Profil berhasil diubah!");
  }

  @override
  void initState() {
    controllerNama =
        TextEditingController(text: widget.profil[0]['namaPenumpang']);
    controllerJK =
        TextEditingController(text: widget.profil[0]['jenisKelamin']);
    controllerUsia = TextEditingController(text: widget.profil[0]['usia']);
    controllerNoHP = TextEditingController(text: widget.profil[0]['noHP']);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        UbahNamaDanJK(
            teks1: "Nama Lengkap", controllerNama: this.controllerNama),
        //_ubahNamaDanJK(context, "Nama Lengkap", "Nama"),
        SizedBox(
          height: 5,
        ),
        UbahNamaDanJK(
            teks1: "Jenis Kelamin", controllerJK: this.controllerJK),
        SizedBox(
          height: 5,
        ),
        Row(
          children: <Widget>[
            UbahUsiaDanNoTel(
              teks1: "Usia",
              controllerUsia: this.controllerUsia,
            ),
            UbahUsiaDanNoTel(
                teks1: "Nomor Telepon",
                controllerNoHP: this.controllerNoHP),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40),
          child: !isLoading
          ? BtnOval(
            label: "Ubah",
            lebar: MediaQuery.of(context).size.width,
            onPressed: () async{
              setState(() {
                isLoading = true;
              });
              await editData();
            },
          ): Center(child: CircularProgressIndicator()),
        ),
      ],
    );
  }
}

Widget _judul(teks) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Text(teks, style: TextStyle(fontSize: 16)),
    ],
  );
}

// ignore: must_be_immutable
class UbahNamaDanJK extends StatelessWidget {
  String teks1;
  TextEditingController controllerNama = TextEditingController();
  TextEditingController controllerJK = TextEditingController();
  UbahNamaDanJK({this.teks1, this.controllerNama, this.controllerJK});

  Widget _fieldUbahNama(lebar) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: lebar,
          child: TextField(
            controller: controllerNama,
            decoration: InputDecoration(
              //hintText: label,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _judul(teks1),
        Container(
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            child: Container(
                alignment: Alignment.center,
                padding: teks1 == 'Jenis Kelamin'
                    ? EdgeInsets.only(right: 15)
                    : EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    teks1 == 'Jenis Kelamin'
                        ? ButtonJK(controllerJK: this.controllerJK)
                        : _fieldUbahNama(
                            MediaQuery.of(context).size.width * 0.7),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class UbahUsiaDanNoTel extends StatelessWidget {
  TextEditingController controllerUsia = TextEditingController();
  TextEditingController controllerNoHP = TextEditingController();
  String teks1;
  UbahUsiaDanNoTel({this.teks1, this.controllerUsia, this.controllerNoHP});

  Widget _fieldUsia(lebar) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: lebar,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: controllerUsia,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              //hintText: label,
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  Widget _fieldNoHP(lebar) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: lebar,
          child: TextField(
            keyboardType: TextInputType.number,
            controller: controllerNoHP,
            decoration: InputDecoration(
                //hintText: label,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _judul(teks1),
        Container(
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
            child: Container(
                alignment: Alignment.center,
                padding: teks1 == 'Usia'
                    ? EdgeInsets.symmetric(horizontal: 20)
                    : EdgeInsets.symmetric(horizontal: 20),
                height: 50,
                width: teks1 == 'Usia'
                    ? MediaQuery.of(context).size.width * 0.2
                    : MediaQuery.of(context).size.width * 0.588,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    teks1 == 'Usia'
                        ? _fieldUsia(MediaQuery.of(context).size.width * 0.088)
                        : _fieldNoHP(MediaQuery.of(context).size.width * 0.47),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class ButtonJK extends StatefulWidget {
  TextEditingController controllerJK;
  final double lebar;

  ButtonJK({Key key, this.lebar, this.controllerJK}) : super(key: key);
  @override
  _ButtonJKState createState() => _ButtonJKState(lebar);
}

/*class JK {
  int jkId;
  String namaJk;

  JK({this.namaJk, this.jkId});

  static List<JK> getJK() {
    return <JK>[
      JK(jkId: 1, namaJk: 'Laki-laki'),
      JK(jkId: 2, namaJk: 'Perempuan'),
    ];
  }
}*/

class _ButtonJKState extends State<ButtonJK> {
  final double lebar;
  String _radioValue;
  String choice;
  _ButtonJKState(this.lebar);

  void radioButtonChanges(String value) {
    setState(() {
      _radioValue = value;
      switch (value) {
        case 'Laki-laki':
          choice = value;
          break;
        case 'Perempuan':
          choice = value;
          break;
        default:
          choice = null;
      }
      widget.controllerJK.text = choice;
      print(widget.controllerJK.text);
      //debugPrint(choice); //Debug the choice in console
    });
  }

  @override
  void initState() {
    _radioValue = widget.controllerJK.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        GestureDetector(
          onTap: () {
            radioButtonChanges('Laki-laki');
          },
          child: Container(
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'Laki-laki',
                  groupValue: _radioValue,
                  onChanged: radioButtonChanges,
                  activeColor: Colors.purple,
                ),
                Text("Laki-laki", style: TextStyle(fontSize: 14))
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            radioButtonChanges('Perempuan');
          },
          child: Container(
            width: 120,
            child: Row(
              children: <Widget>[
                Radio(
                  value: 'Perempuan',
                  groupValue: _radioValue,
                  onChanged: radioButtonChanges,
                  activeColor: Colors.purple,
                ),
                Text("Perempuan", style: TextStyle(fontSize: 14))
              ],
            ),
          ),
        )
      ],
    );
  }
}
