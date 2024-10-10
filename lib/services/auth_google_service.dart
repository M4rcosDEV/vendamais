import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthGoogleService {
  final GoogleSignIn googleSignIn = GoogleSignIn();

Future<UserCredential?> signInWithGoogle() async {
  try {
    // Realiza o login com o Google
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

    if (googleUser == null) {
      // O login foi cancelado pelo usuário
      return null;
    }

    // Autentica o usuário com o Google
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Cria a credencial para o Firebase
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Faz login no Firebase com a credencial do Google
    return await FirebaseAuth.instance.signInWithCredential(credential);
  } catch (e) {
    print('Erro ao fazer login com o Google: $e');
    return null; // Trate o erro como achar melhor
  }
}

Future<void> signOutGoogle() async {
  try {
    // Faz o logout do Google
    await googleSignIn.signOut();

    // Faz o logout do Firebase também
    await FirebaseAuth.instance.signOut();

    print("Usuário desconectado do Google e Firebase");
  } catch (e) {
    print('Erro ao fazer logout: $e');
  }
}

}
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
