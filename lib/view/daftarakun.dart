import 'dart:convert';
import 'package:apts/mailTemplate.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:apts/widget/buttonWidget.dart';
import 'package:apts/widget/login_dan_daftar/boxFieldDaftar.dart';
import 'package:apts/widget/login_dan_daftar/judul.dart';

class DaftarAkun extends StatefulWidget {
  @override
  _DaftarAkunState createState() => _DaftarAkunState();
}

class _DaftarAkunState extends State<DaftarAkun> {
  TextEditingController nama = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  EmailTemplate emailTemplate;
  static String emailGmail = 'testingemailmus@gmail.com';
  static String passwordGmail = 'banaspati21';

  final smtpServer = gmail(emailGmail, passwordGmail);
  final message = Message();
  // Creating the Gmail server
  // Create our email message.

  validasiEmail(){
    final bool isValid = EmailValidator.validate(email.text);
    if (isValid) {
      tryEmail();
    }else{
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Email tidak valid!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  tryEmail() async {
    final respon =
        await http.post("https://aptsweb.000webhostapp.com/data_android/cekemail.php", body: {
      "email": email.text,
    });
    final data = json.decode(respon.body);
    int value = data['value'];
    String pesan = data['message'];    
    if (value == 2) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Email telah digunakan!'),
        backgroundColor: Colors.red,
      ));
    } else {
      setState(() {
        isLoading = true;
      });
      saveAkun();
    }
    print(pesan);
  }

  saveAkun() async{
    emailTemplate = EmailTemplate(nama.text, email.text, password.text);
    setState(() {
        message.from = Address(emailGmail, 'Support APTS');
        message.recipients.add(email.text); //recipent email
        message.subject = 'Verifikasi Akun'; //subject of the email        
        message.html = emailTemplate.emailT; //body of the email
      });
      try {
        final sendReport = await send(message, smtpServer);
        print('Message sent: ' +
            sendReport.toString()); //print if the email is sent                    
      } on MailerException catch (e) {
        print('Message not sent. \n' +
            e.toString()); //print if the email is not sent
        // e.toString() will show why the email is not sending
      }finally{
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop("Email Verifikasi telah dikirim ke email anda!");
      }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Color(0xff21254A),
        body: Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Judul(
                        teks1: "Selamat Datang!",
                        teks2: "Lengkapi data berikut dan akunmu akan terbuat"),
                    BoxFieldDaftar(label: "Nama", nama: this.nama),
                    BoxFieldDaftar(label: "Email", email: this.email),
                    BoxFieldDaftar(label: "Password", password: this.password),
                    SizedBox(
                      height: 80,
                    ),
                    !isLoading
                    ?BtnOval(
                        label: "Daftar",
                        lebar: MediaQuery.of(context).size.width * 0.85,
                        onPressed: () async{
                          if (nama.text.isEmpty || email.text.isEmpty || password.text.isEmpty) {
                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                              duration: Duration(seconds: 3),
                                content: Text(
                                    'Nama, Email atau Password tidak boleh kosong!'),
                                backgroundColor: Colors.red));
                          }else{                            
                            await validasiEmail();                            
                          }
                        }
                    ):Center(child:CircularProgressIndicator()) //Navigator.of(context).pushReplacementNamed('/dashboard');
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
