import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:note_app_fireb/screens/home_screen.dart';
import 'package:note_app_fireb/screens/sign_up_screen.dart';

class LoginScreen extends StatelessWidget {
  String? userEmail, userPassword;
  final _formKey = GlobalKey<FormState>();

  signIn(BuildContext context) async {
    var formState = _formKey.currentState;
    formState!.save();
    if (formState.validate()) {
      try {
        UserCredential userCrede = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: userEmail!, password: userPassword!);
        

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false);
      } on FirebaseAuthException catch (e) {
        String message = "";
        if (e.code == "user-not-found") {
          message = "No user found for that email";
        } else if (e.code == "wrong-password") {
          message = "Wrong Password";
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Container(
            padding: const EdgeInsets.fromLTRB(16, 150, 16, 0),
            margin: const EdgeInsets.all(10),
            child: ListView(
              children: [
                TextFormField(
                  onSaved: (value) {
                    userEmail = value;
                  },
                  decoration: InputDecoration(
                    label: const Text("Email"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please!, Enter your email address";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  onSaved: (value) {
                    userPassword = value;
                  },
                  decoration: InputDecoration(
                    label: const Text("Password"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please!, Enter your password";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  child: Row(
                    children: [
                      const Text("You don't have an account?",
                          style: TextStyle(fontSize: 14)),
                      const SizedBox(
                        width: 3,
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUpScreen()),
                                (route) => false);
                          },
                          child: const Text("Click Here",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800))),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    height: 59,
                    width: double.infinity,
                    child: ElevatedButton(
                      child:
                          const Text("Login", style: TextStyle(fontSize: 24)),
                      onPressed: () {
                        signIn(context);
                      },
                    ))
              ],
            )),
      ),
    );
  }
}
