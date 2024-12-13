import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController tfNameSurname = TextEditingController();
  final TextEditingController tfEmail = TextEditingController();
  final TextEditingController tfPhone = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Future<void> loginCheck() async {
    if (formKey.currentState!.validate()) {
      final sp = await SharedPreferences.getInstance();
      sp.setString('Email', tfEmail.text);
      sp.setString('NameSurname', tfNameSurname.text);
      sp.setString('Phone', tfPhone.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login Successful!')),
      );
    }
  }

  bool validateEmail(String email) {
    final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+$');
    return emailRegex.hasMatch(email);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: tfNameSurname,
                decoration: const InputDecoration(
                  hintText: 'Enter Name-Surname',
                ),
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                textInputAction: TextInputAction.done,
                validator: (value) {
                  return value!.isEmpty ? 'Please enter your name' : null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: tfEmail,
                decoration: const InputDecoration(
                  hintText: 'Enter Email',
                ),
                style: const TextStyle(color: Colors.blue, fontStyle: FontStyle.italic),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  return validateEmail(value!) ? null : 'Invalid email format';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: tfPhone,
                decoration: const InputDecoration(
                  hintText: 'Enter Phone Number',
                ),
                style: const TextStyle(color: Colors.green, decoration: TextDecoration.underline),
                keyboardType: TextInputType.phone,
                maxLength: 10,
                validator: (value) {
                  return value!.length == 10 ? null : 'Phone number must be 10 digits';
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: loginCheck,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
