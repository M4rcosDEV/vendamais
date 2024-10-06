//amplify
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import '../amplifyconfiguration.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class AmplifyService {

  Future<void> configureAmplify() async {
    // Inicializar o Amplify
    try {
      final auth = AmplifyAuthCognito();
      final storage = AmplifyStorageS3();
      
      // Adiciona os plugins ao Amplify
      await Amplify.addPlugins([auth, storage]);
      await Amplify.configure(amplifyconfig); // Use seu arquivo de configuração
      
      print('Amplify configurado com sucesso');
    } catch (e) {
      print('Erro ao configurar Amplify: $e');
    }
  }
  
}