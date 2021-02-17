import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:apts/widget/buttonWidget.dart';
import 'package:http/http.dart' as http;

class BoxAppBarBantuanTambahan extends StatelessWidget {
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
              child: Text('Ajukan Pertanyaan',
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

class BoxBodyBantuanTambahan extends StatefulWidget {
  @override
  _BoxBodyBantuanTambahanState createState() => _BoxBodyBantuanTambahanState();
}

class _BoxBodyBantuanTambahanState extends State<BoxBodyBantuanTambahan> {
  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerSubjek = TextEditingController();
  TextEditingController controllerDeskripsi = TextEditingController();
  bool isLoading = false;

  ajukanPertanyaan() async {
    var url = "https://aptsweb.000webhostapp.com/data_android/bantuanTambahan.php";
    await http.post(url, body: {
      'email': controllerEmail.text,
      'subjek': controllerSubjek.text,
      'deskripsi': controllerDeskripsi.text,
    });
    setState(() {
      isLoading = false;
    });
    Navigator.of(context).pop("Pertanyaan terkirim!");
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 0),
            children: <Widget>[
              _boxField(context, "Email", "Email", controllerDeskripsi,
                  controllerSubjek, controllerEmail),
              SizedBox(
                height: 5,
              ),
              _boxField(context, "Subjek", "Subjek", controllerDeskripsi,
                  controllerSubjek, controllerEmail),
              SizedBox(
                height: 5,
              ),
              _boxField(context, "Deskripsi", "", controllerDeskripsi,
                  controllerSubjek, controllerEmail),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: !isLoading
                ? BtnOval(
                  label: "Kirim",
                  lebar: MediaQuery.of(context).size.width * 0.35,
                  onPressed: () async{
                    final bool isValid = EmailValidator.validate(controllerEmail.text);
                    if (controllerEmail.text.isEmpty ||
                        controllerSubjek.text.isEmpty ||
                        controllerDeskripsi.text.isEmpty) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Email, Subjek atau Deskripsi tidak boleh kosong!"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3)));
                    } else if (!isValid) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Email tidak valid!"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3)));
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      await ajukanPertanyaan();
                    }                    
                  },
                ):Center(child: CircularProgressIndicator())
              )
            ],
          ),
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

Widget _boxField(context, teks1, teks2, cDes, cSub, cEmail) {
  Widget field;
  if (teks1 == 'Deskripsi') {
    field =
        _multilineField(context, MediaQuery.of(context).size.width * 0.7, cDes);
  } else if (teks1 == "Subjek") {
    field = _fieldSubjek(
        context, teks2, MediaQuery.of(context).size.width * 0.7, cSub);
  } else {
    field = _fieldEmail(
        context, teks2, MediaQuery.of(context).size.width * 0.7, cEmail);
  }
  return Column(
    children: <Widget>[
      _judul(teks1),
      Container(
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
          child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              height: teks1 == 'Deskripsi' ? 150 : 50,
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[field],
              )),
        ),
      ),
    ],
  );
}

Widget _multilineField(context, lebar, controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        width: lebar,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 140,
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            reverse: true,
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              minLines: 7,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(bottom: 5),
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
            ),
          ),
        ),
      ),
    ],
  );
}

Widget _fieldEmail(context, label, lebar, controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        width: lebar,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: label,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
        ),
      ),
    ],
  );
}

Widget _fieldSubjek(context, label, lebar, controller) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        width: lebar,
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
              hintText: label,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 5),
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
        ),
      ),
    ],
  );
}
