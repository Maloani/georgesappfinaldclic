// pages/register.dart
import 'package:flutter/material.dart';
import '../database/database_helper.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _fullname = TextEditingController();
  final _phone = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();

  bool _isPasswordVisible = false;
  String? _message;
  String? _selectedSex;

  //-------------------------------------------------------------
  // 🔍 VALIDATION EMAIL
  //-------------------------------------------------------------
  bool isValidEmail(String email) {
    return RegExp(r"^[\w\.-]+@([\w-]+\.)+[\w-]{2,4}$").hasMatch(email);
  }

  //-------------------------------------------------------------
  // 🔍 VALIDATION TÉLÉPHONE
  //-------------------------------------------------------------
  bool isValidPhone(String phone) {
    return RegExp(r"^[0-9]{8,15}$").hasMatch(phone);
  }

  //-------------------------------------------------------------
  // 🔥 INSCRIPTION UTILISATEUR
  //-------------------------------------------------------------
  Future<void> _register() async {
    final db = await DatabaseHelper.database;

    // Vérification des champs obligatoires
    if (_fullname.text.isEmpty ||
        _selectedSex == null ||
        _phone.text.isEmpty ||
        _email.text.isEmpty ||
        _password.text.isEmpty) {
      setState(() => _message = "Veuillez remplir tous les champs.");
      return;
    }

    // Email valide ?
    if (!isValidEmail(_email.text)) {
      setState(() => _message = "Adresse email invalide.");
      return;
    }

    // Téléphone valide ?
    if (!isValidPhone(_phone.text)) {
      setState(() => _message = "Numéro de téléphone invalide.");
      return;
    }

    // Mot de passe minimum
    if (_password.text.length < 6) {
      setState(
        () => _message = "Le mot de passe doit contenir au moins 6 caractères.",
      );
      return;
    }

    try {
      await db.insert('users', {
        'fullname': _fullname.text,
        'sex': _selectedSex,
        'phone': _phone.text,
        'email': _email.text,
        'password': _password.text,
      });

      setState(() => _message = "✅ Compte créé avec succès !");
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pop(context);
      });
    } catch (e) {
      setState(
        () => _message =
            "❌ Email ou téléphone déjà enregistré. Vérifiez et réessayez.",
      );
    }
  }

  //-------------------------------------------------------------
  // 🔥 DESIGN / AFFICHAGE
  //-------------------------------------------------------------
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
                    const Icon(
                      Icons.person_add_alt_1,
                      size: 70,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "Créer un compte",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.blue,
                      ),
                    ),

                    const SizedBox(height: 20),

                    //---------------------------------------------------------
                    // Nom complet
                    //---------------------------------------------------------
                    TextField(
                      controller: _fullname,
                      decoration: InputDecoration(
                        labelText: "Nom complet",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.badge),
                      ),
                    ),
                    const SizedBox(height: 12),

                    //---------------------------------------------------------
                    // Sexe
                    //---------------------------------------------------------
                    DropdownButtonFormField<String>(
                      value: _selectedSex,
                      decoration: InputDecoration(
                        labelText: "Sexe",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.transgender),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "M",
                          child: Text("Masculin (M)"),
                        ),
                        DropdownMenuItem(
                          value: "F",
                          child: Text("Féminin (F)"),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedSex = value);
                      },
                    ),
                    const SizedBox(height: 12),

                    //---------------------------------------------------------
                    // Téléphone
                    //---------------------------------------------------------
                    TextField(
                      controller: _phone,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Téléphone",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                    ),
                    const SizedBox(height: 12),

                    //---------------------------------------------------------
                    // Email
                    //---------------------------------------------------------
                    TextField(
                      controller: _email,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Adresse email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 12),

                    //---------------------------------------------------------
                    // Mot de passe + icône œil
                    //---------------------------------------------------------
                    TextField(
                      controller: _password,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: "Mot de passe",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.lock),
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

                    const SizedBox(height: 20),

                    //---------------------------------------------------------
                    // Message d’erreur / succès
                    //---------------------------------------------------------
                    if (_message != null)
                      Text(
                        _message!,
                        style: TextStyle(
                          color: _message!.contains("succès")
                              ? Colors.green
                              : Colors.redAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    const SizedBox(height: 15),

                    //---------------------------------------------------------
                    // Bouton valider
                    //---------------------------------------------------------
                    ElevatedButton.icon(
                      icon: const Icon(
                        Icons.check_circle_outline,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Créer mon compte",
                        style: TextStyle(color: Colors.white),
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
                      onPressed: _register,
                    ),

                    const SizedBox(height: 12),

                    //---------------------------------------------------------
                    // Retour
                    //---------------------------------------------------------
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        "← Retour à la connexion",
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
