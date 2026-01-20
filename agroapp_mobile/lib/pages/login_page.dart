import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Color principal de AgroApp Web (#29D44A)
  final Color agroColor = const Color(0xFF29D44A);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5), // Un gris muy clarito de fondo
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              
              // --- SECCIÓN LOGO ---
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: agroColor.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  // Nota: Asegúrate de tener la imagen en tus assets
                  child: Icon(Icons.eco, size: 60, color: agroColor), 
                ),
              ),
              
              const SizedBox(height: 30),
              
              // --- TÍTULOS ---
              const Text(
                'AgroApp',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const Text(
                'Inicia sesión para continuar',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              
              const SizedBox(height: 50),
              
              // --- CAMPO: USUARIO ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ' Usuario',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: 'Tu nombre de usuario',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  ),
                ),
              ),
              
              const SizedBox(height: 25),
              
              // --- CAMPO: CONTRASEÑA ---
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  ' Contraseña',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const TextField(
                  obscureText: true, // Para ocultar los puntitos
                  decoration: InputDecoration(
                    hintText: 'Tu contraseña secreta',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    suffixIcon: Icon(Icons.lock_outline),
                  ),
                ),
              ),
              
              const SizedBox(height: 50),
              
              // --- BOTÓN LOGIN ---
              SizedBox(
                width: double.infinity, // Para que ocupe todo el ancho
                height: 60,
                child: TextButton(
                  onPressed: () {
                    print("Intentando entrar en AgroApp...");
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: agroColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'ENTRAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              
              const SizedBox(height: 40),
              
              const Text(
                'AgroApp. Todos los derechos reservados',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}