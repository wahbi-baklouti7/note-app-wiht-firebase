import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:note_app_fireb/screens/sign_in_screen.dart';

class SignUpScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  String? userName, userEmail, userPassword;

  void signIn(BuildContext context) async {
    var formState = _formKey.currentState;
    formState!.save();
    if (formState.validate()) {
      try {
        UserCredential user = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: userEmail!, password: userPassword!);

        FirebaseFirestore.instance
            .collection("users")
            .add({"username": userName, "email": userEmail});

        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false);
      } on FirebaseAuthException catch (e) {
        String message = "";
        if (e.code == "weak-password") {
          // const AlertDialog(
          //   content: Text("weak password"),
          // );
          message = "Weak password!";
        } else if (e.code == "email-already-in-use") {
          // const AlertDialog(
          //   content: Text("the account already exists"),
          // );
          message = "Email already exist";
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
                const Text("Sign Up ", style: TextStyle(fontSize: 30)),
                const SizedBox(height: 24),
                TextFormField(
                  onSaved: (value) {
                    userName= value;
                  },
                  decoration: InputDecoration(
                    label: const Text("User name"),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return "Please!, Enter your user name";
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 24,
                ),
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
                          const Text("Sign UP", style: TextStyle(fontSize: 24)),
                      onPressed: () async {
                        signIn(context);
                      },
                    ))
              ],
            )),
      ),
    );
  }
}
