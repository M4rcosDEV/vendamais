import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vendamais/models/user_model.dart';

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
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Cria a credencial para o Firebase
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Salva o estado de login e informações do usuário
      await _saveUserData(userCredential);

      // Faz login no Firebase com a credencial do Google
      return userCredential;
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

      // Remove as informações do usuário salvas localmente
      await _clearUserData();

      print("Usuário desconectado do Google e Firebase");
    } catch (e) {
      print('Erro ao fazer logout: $e');
    }
  }

  Future<void> _saveUserData(UserCredential userCredential) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_uid', userCredential.user?.uid ?? '');
    await prefs.setString(
        'user_displayName', userCredential.user?.displayName ?? '');
    await prefs.setString('user_email', userCredential.user?.email ?? '');
    await prefs.setString('user_photoUrl', userCredential.user?.photoURL ?? '');
    await prefs.setBool('isLoggedIn', true);
  }

  Future<void> _clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Limpa todas as informações do usuário
  }

  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<UserModel?> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('user_uid');
    String? displayName = prefs.getString('user_displayName');
    String? email = prefs.getString('user_email');
    String? photoUrl = prefs.getString('user_photoUrl');

    if (uid != null) {
      return UserModel(
        uid: uid,
        displayName: displayName,
        email: email,
        photoUrl: photoUrl,
      );
    }

    return null; // Retorna null se não houver dados de usuário salvos
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
