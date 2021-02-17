import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:apts/mailResetPass.dart';
import 'package:apts/widget/buttonWidget.dart';
import 'package:apts/widget/login_dan_daftar/boxFieldLupaPass.dart';
import 'package:apts/widget/login_dan_daftar/judul.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class LupaPassword extends StatefulWidget {
  @override
  _LupaPasswordState createState() => _LupaPasswordState();
}

class _LupaPasswordState extends State<LupaPassword> {
  TextEditingController email = TextEditingController();
  final _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  Random _rnd = Random();
  String newPassword, nama;
  bool isLoading = false;
  EmailTemplateResetPass emailTemplateResetPass;
  static String emailGmail = 'testingemailmus@gmail.com';
  static String passwordGmail = 'banaspati21';

  final smtpServer = gmail(emailGmail, passwordGmail);
  final message = Message();

  String getNewPassword(int length) {
    return String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  validasiEmail(context){
    final bool isValid = EmailValidator.validate(email.text);
    if (isValid) {
      getNama(context);
    }else{
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Email tidak valid!'),
        backgroundColor: Colors.red,
      ));
    }
  }

  getNama(context) async{
    var url = "https://aptsweb.000webhostapp.com/data_android/getNama.php";
    final respon = await http.post(url, body: {
      'email': email.text,      
    });
    var datauser = json.decode(respon.body);
    setState(() {
      nama = datauser['nama'];
    });
    int value = datauser['value'];
    String pesan = datauser['message'];    
    if (value == 1) {
      setState(() {
        isLoading = true;
        newPassword = getNewPassword(8);
      });      
      password(context);      
    } else {
      Scaffold.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Email yang anda masukkan tidak terdaftar!'),
        backgroundColor: Colors.red,
      ));
    }
    print(pesan);
    print(nama);
    print(newPassword);
  }

  password(context) async{    
    emailTemplateResetPass = EmailTemplateResetPass(nama, newPassword);
    setState(() {
        message.from = Address(emailGmail, "Support APTS");
        message.recipients.add(email.text); //recipent email
        message.subject = 'Reset Password'; //subject of the email        
        message.html = emailTemplateResetPass.emailT; //body of the email
      });
      try {        
        final sendReport = await send(message, smtpServer);
        resetPassword();
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
        Navigator.of(context).pop("Password baru telah dikirim ke ${email.text}!");
      }
  }
  
  resetPassword() async{    
    var url = "https://aptsweb.000webhostapp.com/data_android/ubahPassword.php";
    await http.post(url, body: {
      'email': email.text,
      'password': newPassword
    });    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xff21254A),
      body: Builder(
              builder: (context)=> Center(
          child: SingleChildScrollView(
            child: SafeArea(
              child: Container(      
                alignment: Alignment.center,
                margin: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Judul(teks1: "Lupa Password?", teks2: "Masukkan email yang sudah terdaftar"),
                    BoxFieldLupaPass(label: "Email", email: this.email),
                    SizedBox(height: 80,),
                    !isLoading
                    ? BtnOval(                    
                        label: "Reset", 
                        lebar: MediaQuery.of(context).size.width * 0.85, 
                        onPressed: () async{
                          if (email.text.isEmpty) {
                            Scaffold.of(context).showSnackBar(SnackBar(
                              duration: Duration(seconds: 3),
                              content: Text(
                                  'Email tidak boleh kosong!'),
                              backgroundColor: Colors.red));
                          } else {
                            await validasiEmail(context);
                          }                        
                        }
                      )
                    : Center(child:CircularProgressIndicator())
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}