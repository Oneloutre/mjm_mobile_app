import 'package:flutter/material.dart';
import 'loginHandler/login_page.dart' as login_page;
import 'loginHandler/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppState.loadAuthenticated();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MJM Mobile App',
      theme: ThemeData.dark(),
      home: const HomePage(),
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}


class HomePageState extends State<HomePage> {
  bool _isAuthenticated = AppState.isAuthenticated;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isAuthenticated ? _buildAuthenticatedUI() : _buildLoginUI(),
    );
  }
  Widget _buildLoginUI() {
    return const login_page.LoginPage();
  }
  Widget _buildAuthenticatedUI() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page d\'accueil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Vous êtes connecté'),
            ElevatedButton(
              onPressed: () async {
                await AppState.setAuthenticated(false);
                setState(() {
                  _isAuthenticated = false;
                });
              },
              child: const Text('Se déconnecter'),

            ),
          ],
        ),
      ),
      );
  }
}

