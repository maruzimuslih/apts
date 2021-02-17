import 'package:flutter/material.dart';
import 'package:apts/view/akun.dart';
import 'package:apts/view/bantuan.dart';
import 'package:apts/view/home.dart';
import 'package:apts/view/ticket.dart';

class Dashboard extends StatefulWidget {
  final VoidCallback logout;
  Dashboard({this.logout});
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  TabController tabController;
  
  @override
  void initState() {
    tabController = new TabController(length: 4, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: new TabBarView(
        controller: tabController,
        children: <Widget>[
          new Home(),
          new Ticket(),
          new Bantuan(),
          new Akun(logout: widget.logout),
        ],
      ),
      bottomNavigationBar: new TabBar(
          indicatorColor: Colors.transparent,
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.grey, 
          controller: tabController,
          tabs: <Widget>[
            new Tab(icon: Icon(Icons.home),text: "Beranda",),
            new Tab(icon: Icon(Icons.list),text: "Tiket"),
            new Tab(icon: Icon(Icons.help),text: "Bantuan"),
            new Tab(icon: Icon(Icons.person),text: "Akun"),
          ],
        ),
      
    );
  }
}