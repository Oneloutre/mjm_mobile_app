import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/home_page.dart' as home;
import 'connection.dart' as connection;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _rememberMe = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 350, // Définir la largeur souhaitée du TextField
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Nom d\'utilisateur',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 350, // Définir la largeur souhaitée du TextField
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Mot de passe',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                child: const Text('Se connecter'),
                onPressed: () async {
                  String username = _usernameController.text;
                  String password = _passwordController.text;


                  connection.Data Connection_Result = await connection.authentication(username, password);
                  var connected = Connection_Result.response;
                  var name_firstname = Connection_Result.name_firstname;

                  if (connected == true) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('username', username);
                    prefs.setBool('_isLoggedIn', true);
                    prefs.setString('name_firstname', name_firstname);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const home.HomePage()),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Nom d\'utilisateur ou mot de passe incorrect'),
                      ),
                    );
                  }

                  if (_rememberMe) {
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('username', username);
                    prefs.setString('password', password);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}