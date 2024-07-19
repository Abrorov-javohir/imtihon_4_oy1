import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:imtihon_4_oy1/screens/home_page.dart';
import 'package:imtihon_4_oy1/services/auth_firebase.dart';
import 'package:imtihon_4_oy1/utils/helpers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmationController = TextEditingController();
  final nameController = TextEditingController();

  final firebaseAuthService = FirebaseAuthService();

  @override
  void initState() {
    super.initState();
    checkAuthState();
  }

  void checkAuthState() async {
    if (FirebaseAuth.instance.currentUser != null) {
      Future.microtask(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomePage();
        }));
      });
    }
  }

  void submit() async {
    if (emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordController.text == passwordConfirmationController.text &&
        nameController.text.isNotEmpty) {
      try {
        await firebaseAuthService.register(
          emailController.text,
          passwordController.text,
          nameController.text,
        );
        Future.microtask(() {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
        });
      } on FirebaseAuthException catch (error) {
        Helpers.showErrorDialog(context, error.message ?? "Xatolik");
      } catch (e) {
        Helpers.showErrorDialog(context, "Tizimda xatolik");
      }
    } else {
      Helpers.showErrorDialog(context,
          "Iltimos, to'liq ma'lumot kiriting va parollar bir xil ekanligini tekshiring");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/imtihon_logo_javohir.png",
                width: 300.0,
                height: 300.0,
                fit: BoxFit.contain,
              ),
              const Text(
                "Ro'yxatdan o'tish",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 2),
                child: TextField(
                  style: TextStyle(
                    fontFamily: GoogleFonts.aBeeZee().toString(),
                  ),
                  cursorColor: Colors.orange,
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Name",
                    // GoogleFonts.italianno dan foydalanish
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 2),
                child: TextField(
                  cursorColor: Colors.orange,
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Email",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 2),
                child: TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    focusColor: Colors.orange,
                    border: OutlineInputBorder(),
                    labelText: "Parol",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 2),
                child: TextField(
                  controller: passwordConfirmationController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Parolni tasdiqlang",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.orange,
                      ),
                    ),
                  ),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.fromLTRB(40, 0, 40, 2),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: submit,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                        side: BorderSide(
                            color: Color.fromARGB(255, 255, 115, 0),
                            width: 2.0), // Border rangi va kengligi
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor:
                          Color.fromARGB(255, 255, 221, 202), // Ichki rangi
                      foregroundColor: Colors.black, // Matnning rangi
                    ),
                    child: const Text(
                      "Kirish",
                      style: TextStyle(
                        color: Colors.black, // Matnning rangi (qo'shimcha)
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Login",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
