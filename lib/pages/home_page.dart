import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../loginHandler/login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  sharedPreferences() {}
  bool _isLoggedIn = false;
  String _username = '';

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';

    setState(() {
      _isLoggedIn = username.isNotEmpty;
      _username = username;
    });

    if (!_isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('Devoirs'),
              onTap: () {
                //
              },
            ),
            ListTile(
              title: const Text('Cours à venir'),
              onTap: () {
                //
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Déconnexion', style: TextStyle(color: Colors.red)),
              onTap: () {
                SharedPreferences.getInstance().then((prefs) {
                  prefs.remove('username');
                  setState(() {
                    _isLoggedIn = false;
                  });
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                });
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: _isLoggedIn
            ? Text(
          'Bienvenue, $_username!',
          style: const TextStyle(fontSize: 24),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}