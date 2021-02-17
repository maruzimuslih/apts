import 'package:flutter/material.dart';
import 'package:apts/widget/buttonWidget.dart';
import 'package:http/http.dart' as http;

class BoxAppBarGantiPassword extends StatelessWidget {
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
              child: Text('Ganti Kata Sandi',
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

class BoxBodyGantiPassword extends StatefulWidget {
  final List sandi;
  BoxBodyGantiPassword({this.sandi});

  @override
  _BoxBodyGantiPasswordState createState() => _BoxBodyGantiPasswordState();
}

class _BoxBodyGantiPasswordState extends State<BoxBodyGantiPassword> {
  TextEditingController controllerPassLama = TextEditingController();
  TextEditingController controllerPassBaru = TextEditingController();
  TextEditingController controllerUlangPassBaru = TextEditingController();
  bool isLoading = false;

  editSandi() async{
    var url = "https://aptsweb.000webhostapp.com/data_android/ubahPassword.php";
    await http.post(url, body: {
      'id_user': widget.sandi[0]['id_user'],
      'password': controllerPassBaru.text
    });
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop("Password berhasil diganti!");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            primary: false,
            padding: EdgeInsets.symmetric(vertical: 0),
            children: <Widget>[
              SandiLama(
                teks1: "Kata Sandi Lama",
                teks2: "Kata Sandi Lama",
                controllerPassLama: this.controllerPassLama,
              ),
              //_infoPenumpang(context, "Kata Sandi Lama", "Kata Sandi Lama"),
              SizedBox(
                height: 5,
              ),
              SandiBaru(
                teks1: "Kata Sandi Baru",
                teks2: "Kata Sandi Baru",
                controllerPassBaru: this.controllerPassBaru,
              ),
              //_infoPenumpang(context, "Kata Sandi Baru", "Kata Sandi Baru"),
              SizedBox(
                height: 5,
              ),
              SandiBaru(
                teks1: "Ulangi Kata Sandi",
                teks2: "Ulangi Kata Sandi",
                controllerUlangPassBaru: this.controllerUlangPassBaru,
              ),
              //_infoPenumpang(context, "Ulangi Kata Sandi", "Ulangi Kata Sandi"),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: !isLoading
                ? BtnOval(
                  label: "Simpan",
                  lebar: MediaQuery.of(context).size.width * 0.35,
                  onPressed: () async{
                    if (controllerPassLama.text == "" ||
                        controllerPassBaru.text == "" ||
                        controllerUlangPassBaru.text == "") {
                      alertSandi(context, 'Field Tidak Boleh Kosong!');
                    } else if (controllerPassLama.text !=
                        this.widget.sandi[0]['password']) {
                      alertSandi(context, 'Kata Sandi Lama Anda Salah!');
                    } else if (controllerPassBaru.text ==
                        controllerUlangPassBaru.text) {
                          setState(() {
                            isLoading = true;
                          });
                      await editSandi();
                    } else {
                      alertSandi(context,
                          'Kata Sandi Baru dan Ulangi Kata Sandi Berbeda!');
                    }
                  },
                ):Center(child:CircularProgressIndicator()),
              )
            ],
          ),
        ),
      ],
    );
  }

  void alertSandi(context, teks) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(teks), 
        backgroundColor: Colors.red, 
        duration: Duration(seconds: 3)
      )
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
class SandiLama extends StatefulWidget {
  final String teks1, teks2;
  TextEditingController controllerPassLama = TextEditingController();
  SandiLama({this.teks1, this.teks2, this.controllerPassLama});

  @override
  _SandiLamaState createState() => _SandiLamaState();
}

class _SandiLamaState extends State<SandiLama> {
  bool lihat;

  @override
  void initState() {
    lihat = true;
    super.initState();
  }

  Widget _fieldSandiLama(label, lebar) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: lebar,
          child: TextField(
            obscureText: lihat,
            controller: widget.controllerPassLama,
            decoration: InputDecoration(
                suffix: GestureDetector(
                  onTap: () => setState(() => lihat = !lihat),
                  child: lihat
                      ? Icon(Icons.visibility_off, size: 18, color: Colors.grey)
                      : Icon(Icons.visibility, size: 18, color: Colors.grey),
                ),
                hintText: label,
                isDense: true,
                contentPadding: EdgeInsets.only(bottom: 5),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _judul(widget.teks1),
        Container(
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                height: 50,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _fieldSandiLama(
                        widget.teks2, MediaQuery.of(context).size.width * 0.7),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class SandiBaru extends StatefulWidget {
  String teks1, teks2;
  TextEditingController controllerPassBaru = TextEditingController();
  TextEditingController controllerUlangPassBaru = TextEditingController();
  SandiBaru(
      {this.teks1,
      this.teks2,
      this.controllerPassBaru,
      this.controllerUlangPassBaru});

  @override
  _SandiBaruState createState() => _SandiBaruState();
}

class _SandiBaruState extends State<SandiBaru> {
  bool lihat;

  @override
  void initState() {
    lihat = true;
    super.initState();
  }

  Widget _fieldSandiBaru(label, lebar) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: lebar,
          child: TextField(
            obscureText: lihat,
            controller: widget.controllerPassBaru,
            decoration: InputDecoration(
                suffix: GestureDetector(
                  onTap: () => setState(() => lihat = !lihat),
                  child: lihat
                      ? Icon(Icons.visibility_off, size: 18, color: Colors.grey)
                      : Icon(Icons.visibility, size: 18, color: Colors.grey),
                ),
                hintText: label,
                isDense: true,
                contentPadding: EdgeInsets.only(bottom: 5),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  Widget _fieldUlangSandiBaru(label, lebar) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: lebar,
          child: TextField(
            obscureText: lihat,
            controller: widget.controllerUlangPassBaru,
            decoration: InputDecoration(
                suffix: GestureDetector(
                  onTap: () => setState(() => lihat = !lihat),
                  child: lihat
                      ? Icon(Icons.visibility_off, size: 18, color: Colors.grey)
                      : Icon(Icons.visibility, size: 18, color: Colors.grey),
                ),
                hintText: label,
                isDense: true,
                contentPadding: EdgeInsets.only(bottom: 5),
                hintStyle: TextStyle(color: Colors.grey, fontSize: 16)),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _judul(widget.teks1),
        Container(
          child: Card(
            color: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                height: 50,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    widget.teks1 == 'Kata Sandi Baru'
                        ? _fieldSandiBaru(widget.teks2,
                            MediaQuery.of(context).size.width * 0.7)
                        : _fieldUlangSandiBaru(widget.teks2,
                            MediaQuery.of(context).size.width * 0.7)
                  ],
                )),
          ),
        ),
      ],
    );
  }
}
