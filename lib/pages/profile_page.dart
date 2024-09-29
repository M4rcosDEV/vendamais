import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();

  final TextEditingController _surnameController = TextEditingController();

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
      TextEditingController();

  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery); // Escolhe a imagem da galeria

    if (image != null) {
      setState(() {
        _imageFile = image; // Armazena a imagem escolhida
      });
      print('Image Path: ${image.path}'); // Exibe o caminho da imagem
      Provider.of<MyAppState>(context, listen: false).updateImage(image);
    } else {
      print(
          'No image selected.'); // Mensagem caso nenhuma imagem seja escolhida
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: const Color.fromARGB(255, 255, 255, 255)),
        backgroundColor: const Color.fromARGB(255, 15, 95, 161),
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
            // Campo de Apelido
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