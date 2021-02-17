import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:apts/widget/buttonWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:apts/view/dashboard.dart';
import 'package:apts/widget/login_dan_daftar/boxFieldLogin.dart';
import 'package:apts/widget/login_dan_daftar/judul.dart';

class HalamanLogin extends StatefulWidget {
  @override
  HalamanLoginState createState() => HalamanLoginState();
}

enum LoginStatus { notSignIn, signIn }

class HalamanLoginState extends State<HalamanLogin> {
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  LoginStatus _loginStatus = LoginStatus.notSignIn;
  bool isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  login() async {   
    final respon = await http.post("https://aptsweb.000webhostapp.com/data_android/login.php",
        body: {'email': email.text, 'password': password.text});

    var datauser = json.decode(respon.body);
    String level = datauser['level'];
    print(level);
    int value = datauser['value'];
    String pesan = datauser['message'];
    String idPenumpangAPI = datauser['id_penumpang'];
    String namaAPI = datauser['namaPenumpang'];
    String noHpAPI = datauser['noHP'];
    String emailAPI = datauser['email'];
    String passwordAPI = datauser['password'];
    print(idPenumpangAPI);
    print(passwordAPI);
    print(noHpAPI);
    print(namaAPI);
    if (value == 1 && level == 'penumpang') {
      setState(() {
        isLoading = false;
        _loginStatus = LoginStatus.signIn;
        savePref(
            value, emailAPI, passwordAPI, noHpAPI, namaAPI, idPenumpangAPI);
      });
      print(pesan);
    } else {       
      setState(() {
        isLoading = false;
      });
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        duration: Duration(seconds: 3),
        content: Text('Email atau Password Salah!'),
        backgroundColor: Colors.red,
      ));
    
    print(pesan);
    }
  }

  logout() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", null);
      email.text = "";
      password.text = "";
      _loginStatus = LoginStatus.notSignIn;
    });
  }

  savePref(int value, String email, String password, String noHP, String nama,
      String id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      preferences.setInt("value", value);
      preferences.setString("email", email);
      preferences.setString("password", password);
      preferences.setString("noHP", noHP);
      preferences.setString("nama", nama);
      preferences.setString("id_penumpang", id);
    });
  }

  var nilai;
  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      nilai = preferences.getInt("value");
      _loginStatus = nilai == 1 ? LoginStatus.signIn : LoginStatus.notSignIn;
    });
  }

  @override
  void initState() {
    
    super.initState();
    getPref();
  }

  void daftar() async {
    var alertPesan;
    final pesan = await Navigator.of(context).pushNamed('/daftar');
    setState(() {
      alertPesan = pesan;
    });
    if (alertPesan != null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(alertPesan),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3)));
    }
  }

  void lupaPass() async {
    var alertPesan;
    final pesan = await Navigator.of(context).pushNamed('/lupapassword');
    setState(() {
      alertPesan = pesan;
    });
    if (alertPesan != null) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text(alertPesan),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3)));
    }
  }

  Widget _buatAkun(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 30),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Belum punya akun?",
              style: TextStyle(
                color: Colors.grey,
              )),
          SizedBox(width: 5),
          InkWell(
              onTap: () {
                daftar();
              },
              child: Text(
                "Daftar",
                style: TextStyle(
                  color: Colors.white,
                ),
              )),
        ],
      ),
    );
  }

  Widget _lupaPassword(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 10,
        right: 8,
      ),
      alignment: Alignment.centerRight,
      child: InkWell(
          onTap: () {
            lupaPass();
          },
          child: Text(
            "Lupa Password?",
            style: TextStyle(
              color: Colors.white,
            ),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_loginStatus) {
      case LoginStatus.notSignIn:
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Judul(
                            teks1: "Halo!",
                            teks2: "Silahkan masuk dan pesan\ntiket Shuttle"),
                        BoxField(
                          label: "Email",
                          email: this.email,
                        ),
                        BoxField(
                          label: "Password",
                          password: this.password,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _lupaPassword(context),
                              !isLoading
                                ? Container(
                                    padding: EdgeInsets.only(top: 60),
                                    alignment: Alignment.center,
                                    child: BtnOval(
                                        label: "Masuk",
                                        lebar: MediaQuery.of(context).size.width * 0.85,
                                        onPressed: () async {
                                          if (email.text.isEmpty && password.text.isEmpty) {                                            
                                            _scaffoldKey.currentState.showSnackBar(SnackBar(
                                                duration: Duration(seconds: 3),
                                                content: Text('Email atau Password tidak boleh kosong!'),
                                                backgroundColor: Colors.red));
                                          }else{
                                            setState(() {
                                              isLoading = true;
                                            });
                                            await login();
                                          }                                            
                                        }),
                                  )
                                : Container(
                                    padding: EdgeInsets.only(top: 60),
                                    alignment: Alignment.center,
                                    child: Center(
                                        child: CircularProgressIndicator())),
                              _buatAkun(context)
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ));
        break;
      case LoginStatus.signIn:
        return Dashboard(logout: this.logout);
        break;
    }
  }
}
