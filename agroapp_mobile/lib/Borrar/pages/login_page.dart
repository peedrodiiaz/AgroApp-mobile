// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class LoginPage extends StatelessWidget {
//   const LoginPage({super.key});

//   static const Color agroColor = Color.fromARGB(255, 46, 95, 56);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5), 
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(30.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 50),
              
//               Container(
//                 width: 120,
//                 height: 120,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   border: Border.all(color: Colors.black, width: 0),
//                   borderRadius: BorderRadius.circular(30),
//                   boxShadow: [
//                     BoxShadow(
//                       blurRadius: 25,
//                       offset: const Offset(0, 15),
//                     ),
//                   ],
//                 ),
                  
//                   child: SvgPicture.asset(
//                     "assets/images/LogoAPP.svg",
//                     width: 80,
//                     height: 80,
//                     colorFilter: ColorFilter.mode(Colors.green, BlendMode.srcIn),
                    
//                   ),
                
//               ),
              
//               const SizedBox(height: 40),
              
//               const Text(
//                 'AgroApp',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Color.fromARGB(255, 46, 95, 56),
//                 ),
//               ),
//               const Text(
//                 'Inicia sesión para continuar',
//                 style: TextStyle(
//                   fontSize: 16,
//                   color: Colors.grey,
//                 ),
//               ),
              
//               const SizedBox(height: 50),
              
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   ' Usuario',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromARGB(255, 46, 95, 56),),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15),
//                   border: Border.all(color:  Color.fromARGB(255, 75, 75, 75)),
//                 ),
//                 child: const TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Tu nombre de usuario',
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 25),
              
//               const Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   ' Contraseña',
//                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color.fromARGB(255, 46, 95, 56),),
//                 ),
//               ),
//               const SizedBox(height: 8),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(15),
//                   border: Border.all(color:  Color.fromARGB(255, 75, 75, 75)),
//                 ),
//                 child: const TextField(
//                   obscureText: true, 
//                   decoration: InputDecoration(
//                     hintText: 'Tu contraseña secreta',
//                     border: InputBorder.none,
//                     contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
//                     suffixIcon: Icon(Icons.lock_outline),
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 50),
              
//               SizedBox(
//                 width: double.infinity, 
//                 height: 60,
//                 child: TextButton(
//                   onPressed: () {
//                   },
//                   style: TextButton.styleFrom(
//                     backgroundColor: agroColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15),
//                     ),
//                   ),
//                   child: const Text(
//                     'ENTRAR',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 1.2,
//                     ),
//                   ),
//                 ),
//               ),
              
//               const SizedBox(height: 40),
              
//               const Text(
//                 'AgroApp. Todos los derechos reservados',
//                 style: TextStyle(color: Colors.grey, fontSize: 12),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }