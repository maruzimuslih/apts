import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:apts/widget/buttonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BoxAppBarTransfer extends StatefulWidget {
  @override
  _BoxAppBarTransferState createState() => _BoxAppBarTransferState();
}

class _BoxAppBarTransferState extends State<BoxAppBarTransfer> {
  String kodePemesanan;

  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('kodePemesanan') != null) {
      setState(() {
        kodePemesanan = preferences.getString('kodePemesanan');
      });
    } else {
      setState(() {
        kodePemesanan = preferences.getString('kode');
      });
    }
  }

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
                return showDialog(
                  context: context,
                  builder: (context) {
                    return new AlertDialog(
                      title: new Text('Verifikasi Pembayaran'),
                      content: new Text(
                          'Apakah anda yakin ingin melanjutkannya nanti?',
                          style: TextStyle(color: Colors.grey[600])),
                      actions: <Widget>[
                        new FlatButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: new Text('Tidak',
                              style: TextStyle(color: Colors.grey[700])),
                        ),
                        new FlatButton(
                          onPressed: () => Navigator.of(context)
                              .popUntil(ModalRoute.withName('/')),
                          child: new Text('Ya'),
                        ),
                      ],
                    );
                  },
                );
              },
              child:
                  Icon(Icons.keyboard_backspace, color: Colors.white, size: 21),
            ),
            SizedBox(width: 20),
            Text("Verifikasi Pembayaran",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 5),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text("Pembayaran via Bank Transfer\n$kodePemesanan",
                  style: TextStyle(color: Colors.white, fontSize: 15)),
            ),
          ],
        ),
      ],
    );
  }
}

class BoxBodyTransfer extends StatefulWidget {
  @override
  _BoxBodyTransferState createState() => _BoxBodyTransferState();
}

class _BoxBodyTransferState extends State<BoxBodyTransfer> {
  String kodePemesanan, namaBank, noRek, namaFile = "", idPesanan, kode;
  File image;
  bool isLoading = false;
  var datauser;
  TextEditingController controllerNamaPemilikRek = TextEditingController();
  TextEditingController controllerNamaBankPengirim = TextEditingController();

  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if (preferences.getString('kodePemesanan') != null) {
      setState(() {
        kodePemesanan = preferences.getString('kodePemesanan');
      });
    } else {
      setState(() {
        kodePemesanan = preferences.getString('kode');
      });
    }
    setState(() {
      kode = preferences.getString('kode');
      namaBank = preferences.getString('namaBank');
      noRek = preferences.getString('noRekening');
      idPesanan = preferences.getString('id_pesanan');
      //idPesanan = preferences.getString('idPesanan');
    });
  }

  getData() async {
    final respon = await http.post("https://aptsweb.000webhostapp.com/data_android/bank.php",
        body: {'kodePemesanan': kodePemesanan});

    datauser = json.decode(respon.body);
    setState(() {
      namaBank = datauser['namaBank'];
      noRek = datauser['noRekening'];
      idPesanan = datauser['id_pesanan'];
    });
    print(kodePemesanan);
    print(datauser);
  }

  void getImage(File file, String nama) {
    setState(() {
      image = file;
      namaFile = nama;
    });
  }

  ubahPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setString(kodePemesanan, "Sudah");
      preferences.setString('statusPembayaran', "Belum diverifikasi");
    });
  }

  Future verifPesanan(context) async {
    var stream = http.ByteStream(DelegatingStream(image.openRead()));
    var length = await image.length();
    var uri = Uri.parse("https://aptsweb.000webhostapp.com/data_android/uploadBuktiTrf.php");

    var request = http.MultipartRequest("POST", uri);
    var multipartFile =
        http.MultipartFile('image', stream, length, filename: namaFile);

    request.fields['namaPemilikRek'] = controllerNamaPemilikRek.text;
    request.fields['namaBankPengirim'] = controllerNamaBankPengirim.text;
    request.fields['id_pesanan'] = idPesanan;
    request.files.add(multipartFile);
    var response = await request.send();
    if (response.statusCode == 200) {      
      if (kode != null) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/konfirmasi', ModalRoute.withName('/'));
        ubahPref();
      } else {
        Navigator.of(context).pop("Data terkirim");
        ubahPref();
      }
      setState(() {
        isLoading = false;
      });
      print("Image Uploaded");
    } else {
      print("Upload Failed");
    }
  }  

  Widget _boxInfoPembayaran(context, teks1, teks2) {
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
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                height: 50,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    teks1 == "Atas Nama"
                        ? _fieldNamaPemilik(
                            context,
                            teks2,
                            MediaQuery.of(context).size.width * 0.7,
                            controllerNamaPemilikRek)
                        : _fieldNamaBank(
                            context,
                            teks2,
                            MediaQuery.of(context).size.width * 0.7,
                            controllerNamaBankPengirim),
                  ],
                )),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 0),
            children: <Widget>[
              _boxInfoPembayaran(context, "Atas Nama", "Nama Pemilik Rekening"),
              SizedBox(
                height: 5,
              ),
              _boxInfoPembayaran(context, "Dari Bank", "Nama Bank Anda"),
              SizedBox(
                height: 5,
              ),
              PilihBank(
                  teks1: "Ke Bank", namaBank: this.namaBank, noRek: this.noRek),
              SizedBox(
                height: 5,
              ),
              /*_boxInfoPembayaran(context, "Tanggal Bayar", "Tanggal"),
              SizedBox(
                height: 5,
              ),*/
              PilihGambar(
                teks1: "Bukti Transfer",
                uploadImg: this.getImage,
                getID: this.getData,
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: !isLoading
                ? BtnOval(
                  label: "Konfirmasi",
                  lebar: MediaQuery.of(context).size.width,
                  onPressed: () async{
                    if (namaFile == "" ||
                        controllerNamaPemilikRek.text.isEmpty ||
                        controllerNamaBankPengirim.text.isEmpty) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(
                              "Nama Pemilik Rekening, Nama Bank Pengirim atau File tidak boleh kosong!"),
                          backgroundColor: Colors.red,
                          duration: Duration(seconds: 3)));
                    } else {
                      setState(() {
                        isLoading = true;
                      });
                      await verifPesanan(context);
                    }                    
                  },
                ): Center(child: CircularProgressIndicator()),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class PilihBank extends StatefulWidget {
  final String teks1, namaBank, noRek, id;

  const PilihBank({Key key, this.teks1, this.namaBank, this.noRek, this.id})
      : super(key: key);
  @override
  _PilihBankState createState() => _PilihBankState(teks1);
}

class Bank {
  int id;
  String nama;

  Bank(this.id, this.nama);

  static List<Bank> getBank() {
    return <Bank>[
      Bank(1, 'Bank Mandiri'),
      Bank(2, 'BNI'),
      Bank(3, 'BRI'),
      Bank(4, 'BCA'),
    ];
  }
}

class _PilihBankState extends State<PilihBank> {
  //List<Bank> _banks = Bank.getBank();
  //List<DropdownMenuItem<Bank>> _dropDownMenuItems;
  //Bank _selectedBank;
  final String teks1;

  _PilihBankState(this.teks1);

  @override
  void initState() {
    //_dropDownMenuItems = buildDropDownMenuItems(_banks);
    //_selectedBank = _dropDownMenuItems[0].value;
    super.initState();
  }

  List<DropdownMenuItem<Bank>> buildDropDownMenuItems(List banks) {
    List<DropdownMenuItem<Bank>> item = List();
    for (Bank bank in banks) {
      item.add(DropdownMenuItem(
          value: bank,
          child: Container(
              height: 15,
              width: 220,
              child: Text(
                bank.nama,
                style: TextStyle(fontSize: 14),
              ))));
    }
    return item;
  }

  onChangeDropdownItem(Bank selectedBank) {
    setState(() {
      //_selectedBank = selectedBank;
    });
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
                //alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 10),
                height: 50,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('${widget.namaBank} - ${widget.noRek}')
                    /*DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton(
                            hint: Text('Pilih Bank',
                                style: TextStyle(fontSize: 14)),
                            value: _selectedBank,
                            items: _dropDownMenuItems,
                            onChanged: onChangeDropdownItem),
                      ),
                    )*/
                  ],
                )),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class PilihGambar extends StatefulWidget {
  final String teks1;
  Function uploadImg, getID;
  PilihGambar({Key key, this.teks1, this.uploadImg, this.getID})
      : super(key: key);

  @override
  _PilihGambarState createState() => _PilihGambarState(teks1);
}

class _PilihGambarState extends State<PilihGambar> {
  final String teks1;
  File _image;
  String namaFile;
  _PilihGambarState(this.teks1);

  openGallery(context) async {
    var img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = img;
      namaFile = basename(_image.path);
    });
    widget.uploadImg(_image, namaFile);
    Navigator.of(context).pop();
  }

  openCamera(context) async {
    var img = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = img;
      namaFile = basename(_image.path);
    });
    widget.uploadImg(_image, namaFile);
    Navigator.of(context).pop();
  }

  Future getImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.only(top: 20, left: 20),
            contentPadding: EdgeInsets.only(top: 10, left: 20, bottom: 20),
            title: Text("Plih File"),
            content: Container(
              height: 60,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  InkWell(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        height: 30,
                        child: Text("Gallery")),
                    onTap: () {
                      openGallery(context);
                    },
                  ),
                  InkWell(
                    child: Container(
                        alignment: Alignment.centerLeft,
                        height: 30,
                        child: Text("Camera")),
                    onTap: () {
                      openCamera(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
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
            child: Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _image == null
                            ? Row(
                                children: <Widget>[
                                  MaterialButton(
                                    color: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () {
                                      getImage(context);
                                      widget.getID();
                                    },
                                    child: Text('Pilih File'),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text('Tidak ada file')
                                ],
                              )
                            : Row(
                                children: <Widget>[
                                  Expanded(child: Text('$namaFile')),
                                  Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5)),
                                  MaterialButton(
                                    color: Colors.grey[200],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    onPressed: () {
                                      getImage(context);
                                    },
                                    child: Text('Ubah File'),
                                  )
                                ],
                              )
                      ],
                    )),
              ],
            ),
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

Widget _fieldNamaPemilik(context, label, lebar, controllerNamaP) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        width: lebar,
        child: TextField(
          controller: controllerNamaP,
          decoration: InputDecoration(
              hintText: label,
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 5),
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
        ),
      ),
    ],
  );
}

Widget _fieldNamaBank(context, label, lebar, controllerNamaB) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: <Widget>[
      Container(
        width: lebar,
        child: TextField(
          controller: controllerNamaB,
          decoration: InputDecoration(
              hintText: label,
              isDense: true,
              contentPadding: EdgeInsets.only(bottom: 5),
              hintStyle: TextStyle(color: Colors.grey, fontSize: 14)),
        ),
      ),
    ],
  );
}
