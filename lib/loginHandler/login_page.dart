import 'package:flutter/material.dart';
import 'connection.dart' as connection;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'app_state.dart';
import '../main.dart' as main;

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isConnected = false;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page de Connexion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(
                labelText: 'Nom d\'utilisateur',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Mot de passe',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Checkbox(
                  value: _isConnected,
                  onChanged: (value) {
                    setState(() {
                      _isConnected = value!;
                    });
                  },
                ),
                const Text('Rester connecté'),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                bool connected = await _submitForm();
                if (connected) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (BuildContext context) => const HomePage(),
                      ),
                    );
                  });
                }
              },
                    child: const Text('Se Connecter'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _submitForm() async {
    String username = _usernameController.text;
    String password = _passwordController.text;

    if (_isConnected) {
      // Si la case est cochée, sauvegardez les identifiants de manière sécurisée
      await _saveCredentials(username, password);
    }

    // Ajoutez ici la logique de redirection ou traitement après la connexion
    bool connected = await connection.authentication(username, password);

    if (connected) {
      _saveCredentials(username, password);
      await AppState.setAuthenticated(true);
    } else {
      // Affichez un message d'erreur si la connexion échoue
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Erreur de connexion'),
            content: const Text('Nom d\'utilisateur ou mot de passe incorrect.'),
            actions: [
              TextButton(
                onPressed: () {
                  // Utilisez WidgetsBinding pour obtenir le contexte de la racine de l'application
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    Navigator.of(context).pop();
                  });
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return connected;
  }

  Future<void> _saveCredentials(String username, String password) async {
    await _secureStorage.write(key: 'username', value: username);
    await _secureStorage.write(key: 'password', value: password);
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Vous êtes bien connecté !',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const main.HomePage(),
                  ),
                );
              },
              child: const Text('Recharger la Page'),
            ),
          ],
        ),
      ),
    );
  }
}
