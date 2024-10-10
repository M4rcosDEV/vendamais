import 'dart:io' show File;

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:vendamais/services/amplify_service.dart';
import 'package:aws_common/vm.dart';
import '../main.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AmplifyService amplifyService = AmplifyService();

  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _surnameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      safePrint('Nenhuma imagem selecionada');
      return;
    }
    try {
      // Fazer upload da imagem para o S3
      final file = File(image.path);

      final result = await Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(file.path),
        path: StoragePath.fromString(
            'user-profile/${file.uri.pathSegments.last}'),
        onProgress: (progress) {
          double progressValue =
              (progress.transferredBytes / progress.totalBytes) * 100;

          safePrint(
              'Upando nas nuvens: ${progressValue.toStringAsFixed(2)}%'); // Acompanhe o progresso
        },
      ).result;

      safePrint('Arquivo enviado com sucesso: ${result.uploadedItem.path}');
      const String bucketName =
          'vendamais7a802190a7bd4ab2b3232d43f4c078954b133-dev';

      String region = 'sa-east-1'; // Região do seu bucket

      String imageUrl =
          'https://${bucketName}.s3.${region}.amazonaws.com/${result.uploadedItem.path}';

      print('imageUrl : $imageUrl');

      print('Image Path: ${image.path}'); // Exibe o caminho da imagem
    } on StorageException catch (e) {
      safePrint(e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: Colors.blue,
        title: Text(
          'Perfil',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                  radius: 50,
                  backgroundImage: _imageFile != null
                      ? FileImage(File(_imageFile!.path))
                      : null,
                  child: _imageFile == null
                      ? const Icon(Icons.add_a_photo, size: 50)
                      : null),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                labelText: 'Nome',
              ),
            ),
            TextField(
              controller: _surnameController,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                labelText: 'Apelido',
              ),
            ),

            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primaryContainer,
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                  ),
                ),
                labelText: 'Email',
              ),
            ),

            // Campos de Email e Senha lado a lado
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Campo de Email
                Expanded(
                  child: TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .grey, // Linha cinza quando não está em foco
                        ),
                      ),
                      labelText: 'Senha',
                    ),
                    obscureText: true, // Oculta o texto da senha
                  ),
                ),
                SizedBox(width: 16), // Espaçamento entre os campos
                // Campo de Senha
                Expanded(
                  child: TextField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primaryContainer,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors
                              .grey, // Linha cinza quando não está em foco
                        ),
                      ),
                      labelText: 'Confirmar senha',
                    ),
                    obscureText: true, // Oculta o texto da senha
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
