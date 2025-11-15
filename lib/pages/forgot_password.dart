// pages/forgot_password.dart
import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _email = TextEditingController();
  final _newPassword = TextEditingController();

  bool _showNewPasswordField = false;
  bool _passwordVisible = false;

  String? _message;

  Future<void> _checkEmail() async {
    final db = await DatabaseHelper.database;

    final user = await db.query(
      "users",
      where: "email = ?",
      whereArgs: [_email.text],
    );

    if (user.isEmpty) {
      setState(() => _message = "❌ Aucun compte trouvé avec cet email.");
    } else {
      setState(() {
        _showNewPasswordField = true;
        _message = "✔ Email existant. Entrez un nouveau mot de passe.";
      });
    }
  }

  Future<void> _resetPassword() async {
    if (_newPassword.text.length < 6) {
      setState(
        () => _message = "⚠ Le mot de passe doit avoir au moins 6 caractères.",
      );
      return;
    }

    final db = await DatabaseHelper.database;

    await db.update(
      "users",
      {"password": _newPassword.text},
      where: "email = ?",
      whereArgs: [_email.text],
    );

    setState(() => _message = "🎉 Mot de passe réinitialisé avec succès !");

    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pop(context);
    });
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
            padding: const EdgeInsets.all(25),
            child: Container(
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.92),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black26,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Icon(Icons.lock_reset, size: 70, color: Colors.blue),
                    const SizedBox(height: 20),
                    const Text(
                      "Réinitialiser le mot de passe",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 25),

                    /// Email
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Adresse email",
                        prefixIcon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton.icon(
                      onPressed: _checkEmail,
                      icon: const Icon(Icons.search, color: Colors.white),
                      label: const Text(
                        "Vérifier l'email",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 40,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (_showNewPasswordField)
                      Column(
                        children: [
                          TextField(
                            controller: _newPassword,
                            obscureText: !_passwordVisible,
                            decoration: InputDecoration(
                              labelText: "Nouveau mot de passe",
                              prefixIcon: const Icon(Icons.lock),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  setState(
                                    () => _passwordVisible = !_passwordVisible,
                                  );
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ElevatedButton.icon(
                            onPressed: _resetPassword,
                            icon: const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "Réinitialiser",
                              style: TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 40,
                              ),
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 20),

                    if (_message != null)
                      Text(
                        _message!,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              _message!.contains("✔") ||
                                  _message!.contains("succès")
                              ? Colors.green
                              : Colors.red,
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "← Retour",
                        style: TextStyle(color: Colors.blue),
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
