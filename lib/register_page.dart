import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false; // To handle loading state

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Registration Failed';

        // Handling FirebaseAuth specific errors
        if (e.code == 'email-already-in-use') {
          errorMessage =
              'This email is already in use. Please try another one.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Password is too weak. Please choose a stronger one.';
        } else if (e.code == 'invalid-email') {
          errorMessage =
              'The email address is not valid. Please check and try again.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Registration Failed: ${e.toString()}")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text("Register"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.person_add_alt_1_outlined,
                  size: 100,
                  color: Colors.white,
                ),
                SizedBox(height: 20),
                Text(
                  "Create Account",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email TextField
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: 'Enter your email',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter an email';
                          }
                          if (!RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
                              .hasMatch(value.trim())) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      // Password TextField
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: Colors.white),
                          hintText: 'Enter your password',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.blueAccent),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      // Register Button
                      _isLoading
                          ? CircularProgressIndicator(
                              color: Colors.blueAccent,
                            )
                          : AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.blueAccent,
                              ),
                              child: ElevatedButton(
                                onPressed: _register,
                                style: ElevatedButton.styleFrom(
                                  iconColor: Colors.transparent,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                ),
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
