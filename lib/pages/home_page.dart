import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../loginHandler/login_page.dart';
import '../pages/devoirs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  sharedPreferences() {}
  bool _isLoggedIn = false;
  String _username = '';
  String _nameFirstName = '';

  _HomePageState createState() => _HomePageState();
  int _currentPage = 0;

  final List<String> _pages = [
    'Accueil',
    'Devoirs',
    // Ajoutez d'autres pages ici...
  ];

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    String nameFirstname = prefs.getString('name_firstname') ?? '';

    setState(() {
      _isLoggedIn = username.isNotEmpty;
      _username = username;
      _nameFirstName = nameFirstname;
    });

    if (!_isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(_pages[_currentPage].toString()),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                  image: DecorationImage(
                    image: AssetImage('assets/banner.png'),
                    alignment: Alignment.center,
                  ),
                ),
                child: Text(
                  '',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Accueil'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentPage = 0;
                  });
                  const Divider();
                },
              ),
              ListTile(
                leading: const Icon(Icons.assignment),
                title: const Text('Devoirs'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentPage = 1;
                  });
                },
              ),
              ListTile(
                leading: const Icon(Icons.event),
                title: const Text('Cours à venir'),
                onTap: () {
                  //
                },
              ),
              ListTile(
                leading: const Icon(Icons.credit_card),
                title: const Text('Carte Étudiant'),
                onTap: () {
                  //
                },
              ),
              ListTile(
                leading: const Icon(Icons.watch_later),
                title: const Text('Absences'),
                onTap: () {
                  //
                },
              ),
              ListTile(
                leading: const Icon(Icons.school),
                title: const Text('Notes'),
                onTap: () {
                  //
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Paramètres'),
                onTap: () {
                  //
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text('Déconnexion',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.remove('username');
                    setState(() {
                      _isLoggedIn = false;
                    });
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  });
                },
              ),
            ],
          ),
        ),
        body: Stack(children: [
          _currentPage == 0
              ? Center(
                  child: Text(
                    'Bienvenue, $_nameFirstName',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              : Container(),
          _currentPage == 1 ? const DevoirsPage() : Container(),
        ]));
  }
}
