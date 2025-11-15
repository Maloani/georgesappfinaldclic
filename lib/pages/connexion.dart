// pages/connexion.dart
import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import 'accueil.dart';
import 'register.dart';
import 'package:sqflite/sqflite.dart';
// import 'forgot_password.dart'; // 🔥 Décommente si tu as ajouté l'écran reset

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isPasswordVisible = false;

  String? _errorMessage;
  Database? _database;

  @override
  void initState() {
    super.initState();
    _loadDatabase();
  }

  Future<void> _loadDatabase() async {
    _database = await DatabaseHelper.database;
  }

  Future<void> _login() async {
    if (_database == null) return;

    if (_email.text.isEmpty || _password.text.isEmpty) {
      setState(
        () => _errorMessage = "Veuillez entrer votre email et mot de passe.",
      );
      return;
    }

    final users = await _database!.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [_email.text, _password.text],
    );

    if (users.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomePage(
            user: users.first, // 🔥 On envoie l'utilisateur complet
            database: _database!,
          ),
        ),
      );
    } else {
      setState(() {
        _errorMessage = "Email ou mot de passe incorrect.";
      });
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (ctx) => const RegisterPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/bg_login.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 📷 Image du login
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        "assets/img/login.jpeg",
                        width: 110,
                        height: 110,
                        fit: BoxFit.cover,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Titre
                    const Text(
                      "Connexion à l'application",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Email
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Adresse email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.email_outlined),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 🔹 Mot de passe
                    TextField(
                      controller: _password,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.blue,
                          ),
                          onPressed: () {
                            setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🔹 Mot de passe oublié
                    TextButton(
                      onPressed: () {
                        // Navigator.push(context,
                        //   MaterialPageRoute(builder: (_) => const ForgotPasswordPage()));
                      },
                      child: const Text(
                        "Mot de passe oublié ?",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // 🔹 Erreur
                    if (_errorMessage != null)
                      Text(
                        _errorMessage!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    const SizedBox(height: 15),

                    // 🔹 Bouton connexion
                    ElevatedButton.icon(
                      icon: const Icon(Icons.login, color: Colors.white),
                      label: const Text(
                        "Se connecter",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: _login,
                    ),

                    const SizedBox(height: 12),

                    // 🔹 Aller à Inscription
                    TextButton(
                      onPressed: _goToRegister,
                      child: const Text(
                        "Pas encore de compte ? Créez-en un ici",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
