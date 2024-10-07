// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthGoogleService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final GoogleSignIn googleSignIn = GoogleSignIn();

//   Future<User?> signInWithGoogle(BuildContext context) async {
//     try {
//       print("Iniciando processo de login com Google...");
//       final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
//       print("Usuário do Google autenticado: ${googleUser?.email}");
//       final GoogleSignInAuthentication? googleAuth =
//           await googleUser?.authentication;

//       if (googleAuth == null) {
//         return null;
//       }

//       final credential = GoogleAuthProvider.credential(
//         accessToken: googleAuth.accessToken,
//         idToken: googleAuth.idToken,
//       );

//       UserCredential userCredential =
//           await _auth.signInWithCredential(credential);
//       return userCredential.user;
//     } catch (e) {
//       print(e);
//       // Aqui, você pode usar o context passado
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Erro ao autenticar: ${e.toString()}")),
//       );
//       return null; // Retornar null em caso de erro
//     }
//   }

//   Future<void> signOutGoogle() async {
//     await googleSignIn.signOut();
//     print("Usuário desconectado do Google");
//   }
// }

// import 'package:google_sign_in/google_sign_in.dart';

// Future<UserCredential> signInWithGoogle() async {
//   // Trigger the authentication flow
//   final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

//   // Obtain the auth details from the request
//   final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

//   // Create a new credential
//   final credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth?.accessToken,
//     idToken: googleAuth?.idToken,
//   );

//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }